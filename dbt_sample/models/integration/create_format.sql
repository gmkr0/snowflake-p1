{% do run_query(
    "CREATE OR REPLACE FILE FORMAT my_csv_format
     TYPE = 'CSV'
     FIELD_OPTIONALLY_ENCLOSED_BY = '\"'
     SKIP_HEADER = 1"
) %}