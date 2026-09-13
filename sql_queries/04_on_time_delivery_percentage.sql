-- This query calculates the exact On-Time Delivery percentage for each 3PL partner so we know who is 
-- failing their Service Level Agreements (SLAs).
USE emea_supply_chain;
SELECT 
    Carrier_3PL,
    COUNT(Shipment_ID) AS Total_Shipments,
    SUM(CASE WHEN Delivery_Status = 'On_Time' THEN 1 ELSE 0 END) AS On_Time_Deliveries,
    ROUND((SUM(CASE WHEN Delivery_Status = 'On_Time' THEN 1 ELSE 0 END) / COUNT(Shipment_ID)) * 100, 2) AS On_Time_Percentage
FROM clean_shipments
GROUP BY Carrier_3PL
ORDER BY On_Time_Percentage ASC;