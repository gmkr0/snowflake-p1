variable "environment" {
  type        = string
  description = "The environment to deploy to"
  default     = "Dev"
}

variable "s3_stage_url" {
  type        = string
  description = "The URL of the S3 stage"
  default     = "s3://gmkr-test-bucket/sample_data/"
}

variable "snowflake_iam_role_arn" {
  type        = string
  description = "The ARN of the IAM role to use for the Snowflake connection"
  default     = "arn:aws:iam::265980493481:role/snowflake-reader-auto"
}
