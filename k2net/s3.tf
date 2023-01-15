##
# S3 Buckets
##
resource "aws_s3_bucket" "cdn" {
  bucket = var.cdn_domain

  tags = merge(local.tags, {
    Name = var.cdn_domain
  })
}

# Bucket options
resource "aws_s3_bucket_acl" "cdn_acl" {
  bucket = aws_s3_bucket.cdn.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "cdn_access_block" {
  bucket = aws_s3_bucket.cdn.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cdn_sse" {
  bucket = aws_s3_bucket.cdn.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # SSE-S3
    }
  }
}

##
# S3 Bucket Policies
##
resource "aws_s3_bucket_policy" "cdn_cloudfront" {
  bucket     = aws_s3_bucket.cdn.id
  policy     = data.template_file.cloudfront_s3_policy.rendered
  depends_on = [aws_cloudfront_distribution.cdn]
}
