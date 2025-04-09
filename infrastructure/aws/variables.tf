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



