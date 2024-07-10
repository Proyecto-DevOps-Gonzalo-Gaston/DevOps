# Create S3 Bucket Resource
resource "aws_s3_bucket" "s3_bucket" {
  for_each = toset(var.bucket_name)

  bucket = each.key
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket" {
  for_each = aws_s3_bucket.s3_bucket
  bucket   = each.value.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  for_each = aws_s3_bucket.s3_bucket
  bucket   = each.value.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_bucket" {
  for_each = aws_s3_bucket.s3_bucket
  bucket   = each.value.id
  acl      = "public-read"
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  for_each = aws_s3_bucket.s3_bucket

  bucket = each.value.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${each.value.id}/*"
            ]
        }
    ]
  }  
  EOF
}
