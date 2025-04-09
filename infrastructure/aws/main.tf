locals {
  snowflake_user_arn    = "arn:aws:iam::831926600710:user/a9my0000-s"
  snowflake_external_id = "ZN18147_SFCRole=3_Ej1e54lxs5SHgsBcj0819DcV+Ss="
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_token
}

resource "aws_iam_role" "snowflake-reader" {
  name = "snowflake-reader-auto"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "",
        Effect = "Allow",
        Principal = {
          "AWS" : local.snowflake_user_arn
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = local.snowflake_external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "snowflake-reader-policy" {
  name = "snowflake-reader-policy"
  role = aws_iam_role.snowflake-reader.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::gmkr-test-bucket/sample_data/*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = "arn:aws:s3:::gmkr-test-bucket"
        Condition = {
          StringLike = {
            "s3:prefix" = ["sample_data/*"]
          }
        }
      }
    ]
  })
}

output "snowflake-reader-role-arn" {
  value = aws_iam_role.snowflake-reader.arn
}
