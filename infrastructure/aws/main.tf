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

resource "aws_s3_bucket" "gmkr_test_bucket" {
  bucket = "gmkr-test-bucket"
  object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "gmkr_test_bucket_versioning" {
  bucket = aws_s3_bucket.gmkr_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "gmkr_test_bucket_ownership_controls" {
  bucket = aws_s3_bucket.gmkr_test_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "gmkr_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.gmkr_test_bucket.id
  block_public_acls       = false 
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "gmkr_test_bucket_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.gmkr_test_bucket_public_access_block,
    aws_s3_bucket_ownership_controls.gmkr_test_bucket_ownership_controls
  ]
  bucket = aws_s3_bucket.gmkr_test_bucket.id
  acl    = "public-read"
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
          "AWS" : var.snowflake_user_arn
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.snowflake_external_id
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "snowflake_folder" {
  depends_on = [
    aws_s3_bucket_acl.gmkr_test_bucket_acl
  ]
  bucket = aws_s3_bucket.gmkr_test_bucket.id
  key    = "snowflake/"
  acl    = "public-read"
  content = ""
}

resource "aws_iam_role_policy" "snowflake-reader-policy" {
  name = "snowflake-reader-policy"
  role = aws_iam_role.snowflake-reader.name
  depends_on = [
    aws_s3_object.snowflake_folder,
    aws_s3_bucket.gmkr_test_bucket
  ]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.gmkr_test_bucket.arn}/${aws_s3_object.snowflake_folder.key}*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = "${aws_s3_bucket.gmkr_test_bucket.arn}"
        Condition = {
          StringLike = {
            "s3:prefix" = ["${aws_s3_object.snowflake_folder.key}*"]
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "gmkr_test_bucket_notification" {
  bucket = aws_s3_bucket.gmkr_test_bucket.id

  queue {
    queue_arn     = var.snowflake_queue_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "${aws_s3_object.snowflake_folder.key}"
    filter_suffix = ".csv"
  }
}

output "snowflake-reader-role-arn" {
  value = aws_iam_role.snowflake-reader.arn
}

output "gmkr_test_bucket_s3_url" {
  value = "s3://${aws_s3_bucket.gmkr_test_bucket.bucket}/${aws_s3_object.snowflake_folder.key}"
}

