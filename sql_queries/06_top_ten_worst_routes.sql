-- This query identifies the top 10 worst-performing routes in the EMEA network by calculating the average days delayed.
USE emea_supply_chain;
SELECT 
    Origin_Location,
    Destination,
    COUNT(Shipment_ID) AS Route_Volume,
    ROUND(AVG(Actual_Transit_Days - Expected_Transit_Days), 2) AS Avg_Days_Delayed
FROM clean_shipments
GROUP BY Origin_Location, Destination
HAVING Route_Volume > 500 -- Filtering out low-volume outlier routes
ORDER BY Avg_Days_Delayed DESC
LIMIT 10;