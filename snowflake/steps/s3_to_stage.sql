COPY INTO SAMPLE_SCHEMA_RAW.NEIGHBORHOODS
    FROM @my_sample_stage
    PATTERN='.*/.*/.*/neighborhoods.csv'
    ON_ERROR=ABORT_STATEMENT;