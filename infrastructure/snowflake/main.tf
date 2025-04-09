terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

locals {
provider "snowflake" {
  organization_name = "rtnhgqg"
  account_name      = "no03980"
  user              = "tf-snow"
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file("C:\\Users\\egood\\.ssh\\snowflake_tf_snow_key.p8")
  role              = "ACCOUNTADMIN"
}

resource "snowflake_storage_integration" "snowflake_s3_integration" {
  name                      = "SNOWFLAKE_S3_INTEGRATION"
  type                      = "EXTERNAL_STAGE"
  enabled                   = true
  storage_provider          = "S3"
  storage_aws_role_arn      = var.snowflake_iam_role_arn
  storage_allowed_locations = [var.s3_stage_url]
}

resource "snowflake_database" "primary" {
  name = "${upper(var.environment)}_MAIN"
}

resource "snowflake_schema" "raw" {
  name     = "RAW"
  database = snowflake_database.primary.name
}

resource "snowflake_file_format" "s3_file_format" {
  name        = "S3_FILE_FORMAT"
  database    = snowflake_database.primary.name
  schema      = snowflake_schema.raw.name
  format_type = "CSV"
}

resource "snowflake_stage" "s3_stage3" {
  name                = "S3_STAGE"
  database            = snowflake_database.primary.name
  schema              = snowflake_schema.raw.name
  storage_integration = snowflake_storage_integration.snowflake_s3_integration.name
  file_format         = "FORMAT_NAME = ${snowflake_file_format.s3_file_format.fully_qualified_name}"
  url                 = var.s3_stage_url
  depends_on          = [snowflake_file_format.s3_file_format]
}

output "storage_aws_external_id" {
  value = snowflake_storage_integration.snowflake_s3_integration.storage_aws_external_id
}

output "storage_aws_iam_user_arn" {
  value = snowflake_storage_integration.snowflake_s3_integration.storage_aws_iam_user_arn
}
