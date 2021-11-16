variable "region" {
  description = "Region"
  default     = "eu-west-1"
  #default = "eu-central-1"
}
variable "aws_moodle_bucket" {
    default = "moodle-tf-state"
}
variable "aws_networking_bucket" {
    default = "moodle-networking"
}
variable "aws_application_bucket" {
    default = "moodle-application"
}
variable "aws_dynamodb_table" {
    default = "moodle-tfstatelock"
}


provider "aws" {
  region = var.region
}
resource "aws_dynamodb_table" "moodle_statelock" {
  name           = var.aws_dynamodb_table
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "moodle_state" {  
  bucket = var.aws_moodle_bucket
  force_destroy = true
  #acl    = "private"
  
  server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
               sse_algorithm = "AES256"
            }
        }
    }

  #lifecycle {
  #    prevent_destroy = true
  #  }
  versioning {
    enabled = true
  }
  tags = {
      Name = "S3 Terraform Remote State moodle"
    }  
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.moodle_state.arn
  description = "The ARN of the S3 bucket"
}
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.moodle_statelock.name
  description = "The name of the DynamoDB table"
}
