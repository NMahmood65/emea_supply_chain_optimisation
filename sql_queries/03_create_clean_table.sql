USE emea_supply_chain;
-- Create a new, clean table to serve as our single source of truth for Tableau
CREATE TABLE clean_shipments AS
WITH deduplicated_raw AS (
    -- Tip 22 & 23: Using CTEs and Window Functions for efficient deduplication
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY Shipment_ID ORDER BY Order_Date DESC) as row_num
    FROM raw_shipments
)
SELECT 
    Shipment_ID,
    
    -- 1. Date Normalization (Strict-Mode Safe): 
    -- Check the string pattern before attempting conversion
    CASE 
        WHEN Order_Date LIKE '20__-__-__' THEN STR_TO_DATE(Order_Date, '%Y-%m-%d') -- ISO format (e.g., 2023-12-31)
        WHEN Order_Date LIKE '%/%/%' THEN STR_TO_DATE(Order_Date, '%d/%m/%Y')      -- EU format (e.g., 31/12/2023)
        WHEN Order_Date LIKE '__-__-20__' THEN STR_TO_DATE(Order_Date, '%m-%d-%Y') -- US format (e.g., 12-31-2023)
        ELSE NULL 
    END AS Order_Date,
    
    -- 2. Standardizing Location Typos
    CASE 
        WHEN Origin_Location = 'London DC' THEN 'DC_London_UK'
        WHEN Origin_Location = 'Frankfurt_Warehouse' THEN 'DC_Frankfurt_DE'
        ELSE Origin_Location 
    END AS Origin_Location,
    
    Destination,
    Channel,
    
    -- 3. Handling Nulls and Cleaning Carrier Strings
    CASE 
        WHEN TRIM(Carrier_3PL) = 'dhl express' THEN 'DHL_Express'
        WHEN TRIM(Carrier_3PL) = 'DPD-Local' THEN 'DPD_Local'
        WHEN Carrier_3PL IS NULL OR Carrier_3PL = '' THEN 'Unknown_Carrier'
        ELSE TRIM(Carrier_3PL)
    END AS Carrier_3PL,
    
    -- 4. Correcting Impossible Values: Taking the absolute value of negative distances
    ABS(Distance_km) AS Distance_km,
    
    -- 5. Handling Missing Data: Imputing a default baseline weight for missing text values
    ROUND(COALESCE(NULLIF(Weight_kg, ''), 150.00), 2) AS Weight_kg, 
    
    Expected_Transit_Days,
    Actual_Transit_Days,
    Delivery_Status,
    
    -- 6. Financial Corrections: Fixing negative freight spends
    ABS(Freight_Spend_EUR) AS Freight_Spend_EUR,
    ABS(Invoice_Billed_EUR) AS Invoice_Billed_EUR,
    
    EDI_Compliance_Status,
    Claim_Status,
    
    -- 7. Recalculating the discrepancy mathematically to ensure accuracy
    ROUND((ABS(Invoice_Billed_EUR) - ABS(Freight_Spend_EUR)), 2) AS Invoice_Discrepancy

FROM deduplicated_raw
WHERE row_num = 1; -- Filter out the duplicate rows identified by the Window Function