#!/bin/bash

dir=$(dirname -- "$0")
project_root=$(dirname -- "$dir")/../..

# Load environment variables from .env file
set -a
source "$project_root/config/.env"
set +a

# Run terraform apply with the loaded environment variables
terraform apply \
  -var "aws_access_key=$AWS_ACCESS_KEY" \
  -var "aws_secret_token=$AWS_SECRET_TOKEN" \
  -var "snowflake_user_arn=$SNOWFLAKE_IAM_USER_ARN" \
  -var "snowflake_external_id=$SNOWFLAKE_AWS_EXTERNAL_ID"
