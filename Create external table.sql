CREATE MASTER KEY ENCRYPTION BY PASSWORD ='password'

-- 1. create credentials
CREATE DATABASE SCOPED CREDENTIAL cred_aw
WITH IDENTITY = 'Managed Identity'

-- 2. creating external data source
CREATE EXTERNAL DATA SOURCE source_silver
WITH
(
    LOCATION = 'https://sampleprojlamba1.dfs.core.windows.net/silver',
    CREDENTIAL = cred_aw
)

CREATE EXTERNAL DATA SOURCE source_gold
WITH
(
    LOCATION = 'https://sampleprojlamba1.dfs.core.windows.net/gold',
    CREDENTIAL = cred_aw
)

-- 3. create external file format
CREATE EXTERNAL FILE FORMAT format_parquet
WITH 
(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)

----------------------------------
-- create external table extSales
----------------------------------
CREATE EXTERNAL TABLE gold.extSales
WITH
(
    LOCATION = 'extSales',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT * FROM gold.sales
