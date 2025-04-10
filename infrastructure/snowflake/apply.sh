#!/bin/bash

dir=$(dirname -- "$0")
project_root=$(dirname -- "$dir")/../..

# Load environment variables from .env file
set -a
source "$project_root/config/.env"
set +a

# Run terraform apply with the loaded environment variables
terraform apply \
  -var "s3_stage_url=$S3_STAGE_URL" \
  -var "snowflake_iam_role_arn=$SNOWFLAKE_IAM_ROLE_ARN" \
  -var "snowflake_private_key=$SNOWFLAKE_PRIVATE_KEY"
