USE emea_supply_chain;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 26.7/Uploads/raw_shipments.csv'
INTO TABLE raw_shipments
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;