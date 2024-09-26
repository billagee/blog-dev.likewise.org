provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "blogdev_likewise_org" {
  bucket = "blogdev.likewise.org"

  tags = {
    Name        = "blogdev.likewise.org static site bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership-controls" {
  bucket = aws_s3_bucket.blogdev_likewise_org.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public-access-block" {
  bucket = aws_s3_bucket.blogdev_likewise_org.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership-controls,
    aws_s3_bucket_public_access_block.public-access-block,
  ]

  bucket = aws_s3_bucket.blogdev_likewise_org.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "blogdev_likewise_org_website_config" {
  bucket = aws_s3_bucket.blogdev_likewise_org.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Data source to fetch the hosted zone details not defined in TF
data "aws_route53_zone" "likewise_zone" {
  name         = "likewise.org."
  private_zone = false
}

resource "aws_route53_record" "blogdev-a-record" {
  zone_id = data.aws_route53_zone.likewise_zone.zone_id
  name    = "blogdev.likewise.org"
  type    = "A"

  alias {
    # Has a trailing dot which breaks the DNS record:
    #name                   = aws_s3_bucket_website_confguration.blogdev_likewise_org_website_config.website_endpoint
    name                   = "s3-website-us-east-1.amazonaws.com"
    zone_id                = aws_s3_bucket.blogdev_likewise_org.hosted_zone_id
    evaluate_target_health = true
  }
}

output "s3_bucket_website_url" {
  #value = aws_s3_bucket.mysitebucket.website_endpoint
  value = aws_s3_bucket_website_configuration.blogdev_likewise_org_website_config.website_endpoint
}
