-- This query aggregates the total amount of money the company is losing to carrier overbilling.
USE emea_supply_chain;
SELECT 
    Carrier_3PL,
    ROUND(SUM(Freight_Spend_EUR), 2) AS Total_Expected_Spend_EUR,
    ROUND(SUM(Invoice_Billed_EUR), 2) AS Total_Actual_Billed_EUR,
    ROUND(SUM(Invoice_Discrepancy), 2) AS Total_Lost_To_Overbilling_EUR
FROM clean_shipments
GROUP BY Carrier_3PL
ORDER BY Total_Lost_To_Overbilling_EUR DESC;