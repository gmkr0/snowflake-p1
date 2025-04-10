variable "environment" {
  type        = string
  description = "The environment to deploy to"
  default     = "Dev"
}

variable "aws_access_key" {
  type        = string
  description = "The AWS access key"
  sensitive   = true
}

variable "aws_secret_token" {
  type        = string
  description = "The AWS secret token"
  sensitive   = true
}

variable "snowflake_user_arn" {
  type        = string
  description = "The ARN of the Snowflake user"
}

variable "snowflake_external_id" {
  type        = string
  description = "The external ID of the Snowflake user"
}

variable "snowflake_queue_arn" {
  type        = string
  description = "The ARN of the Snowflake queue"
}


