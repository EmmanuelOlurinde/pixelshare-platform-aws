variable "project_name" {
  type = string
}

resource "aws_s3_bucket" "images" {
  bucket = "${var.project_name}-images"
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.images.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.images.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
