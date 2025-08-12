provider "aws" {
    region = "sa-east-1"
}

variable "bucket_name" {
    type = string
}

resource "aws_s3_bucket" "site-estatico_bucket" {
    bucket = "site-estatico-one-${var.bucket_name}"


    website {
        index_document = "index.html"
        error_document = "error.html"
    }

    tags = {
        Name = "site estatico bucket"
        Environment = "Production"
    }
}

resource "aws_s3_bucket_public_access_block" "site-estatico_bucket" {
    bucket = aws_s3_bucket.site-estatico_bucket.id

    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "site-estatico_bucket" {
    bucket = aws_s3_bucket.site-estatico_bucket.id

    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl"  "site-estatico_bucket" {
    depends_on = [aws_s3_bucket_public_access_block.site-estatico_bucket,
    aws_s3_bucket_ownership_controls.site-estatico_bucket,
    ]

    bucket = aws_s3_bucket.site-estatico_bucket.id
    acl = "public-read"
}