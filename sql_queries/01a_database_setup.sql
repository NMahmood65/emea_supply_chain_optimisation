CREATE DATABASE emea_supply_chain;
USE emea_supply_chain;

CREATE TABLE raw_shipments (
    Shipment_ID VARCHAR(20),
    Order_Date VARCHAR(255),
    Origin_Location VARCHAR(255),
    Destination VARCHAR(255),
    Channel VARCHAR(255),
    Carrier_3PL VARCHAR(255),
    Distance_km INT,
    Weight_kg DECIMAL(10,2),
    Expected_Transit_Days INT,
    Actual_Transit_Days INT,
    Delivery_Status VARCHAR(255),
    Freight_Spend_EUR DECIMAL(10,2),
    Invoice_Billed_EUR DECIMAL(10,2),
    EDI_Compliance_Status VARCHAR(255),
    Claim_Status VARCHAR(255),
    Invoice_Discrepancy DECIMAL(10,2)
);