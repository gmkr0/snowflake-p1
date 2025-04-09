{{ config(
    materialized='ephemeral',
    depends_on=['integration.create_format']
) }}

{% set s3_url = env_var('S3_STAGE_URL') %}

{% do run_query(
    "CREATE OR REPLACE STAGE my_sample_stage 
     URL = '" ~ s3_url ~ "'
     STORAGE_INTEGRATION = my_sample_s3_integration
     FILE_FORMAT = my_csv_format"
) %}