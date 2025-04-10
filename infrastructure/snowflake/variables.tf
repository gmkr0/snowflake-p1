variable "environment" {
  type        = string
  description = "The environment to deploy to"
  default     = "Dev"
}

variable "s3_stage_url" {
  type        = string
  description = "The URL of the S3 stage"
}

variable "snowflake_iam_role_arn" {
  type        = string
  description = "The ARN of the IAM role to use for the Snowflake connection"
}

variable "snowflake_private_key" {
  type        = string
  description = "The private key for the Snowflake connection"
}
