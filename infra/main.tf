####
# NOTE: Prerequisites/resources not defined in this project:
# - the likewise.org hosted zone in route53
# - a valid SSL cert in ACM for blog-dev.likewise.org
#
# These will be pulled in with data sources below.
#
# See https://www.youtube.com/watch?v=U9n6N56neuo for a good overview of the setup.
####

locals {
  s3_bucket_name     = "blog-dev.likewise.org"
  domain             = "blog-dev.likewise.org"
  domain_for_prod    = "blog.likewise.org"
  route53_zone_name  = "likewise.org."
}

##
#### DATA SOURCES
##

data "aws_route53_zone" "main" {
  name         = local.route53_zone_name
  private_zone = false
}

data "aws_acm_certificate" "main" {
  domain   = local.domain
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "cert_for_prod" {
  domain   = local.domain_for_prod
  statuses = ["ISSUED"]
}

##
#### S3 CONFIGURATION
##

resource "aws_s3_bucket" "main" {
  bucket = local.s3_bucket_name

  tags = {
    Name        = "${local.domain} static site bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}

##
#### CLOUDFRONT CONFIGURATION
##

resource aws_cloudfront_distribution "main" {
  enabled = true
  aliases = [local.domain, local.domain_for_prod]
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  wait_for_deployment = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    # CachingOptimized managed policy ID from
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id = aws_s3_bucket.main.bucket
    viewer_protocol_policy = "redirect-to-https"

    /*
    forwarded_values {
      query_string = false
    
      cookies {
        forward = "none"
      }
    }
    */
    function_association {
      event_type = "viewer-request"  # Attach the function at the viewer-request stage
      function_arn = aws_cloudfront_function.main.arn
    }
  }

  origin {
    domain_name = aws_s3_bucket.main.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    origin_id   = aws_s3_bucket.main.bucket # Same value as .id
  }

  comment             = local.s3_bucket_name

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cert_for_prod.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }

  tags = {
    Environment = "Dev"
  }
}

resource aws_cloudfront_origin_access_control "main" {
  name = "${local.s3_bucket_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "s3:GetObject",
    ]
    resources = ["${aws_s3_bucket.main.arn}/*"]

    condition {
      test = "StringEquals"
      values = [aws_cloudfront_distribution.main.arn]
      variable = "AWS:SourceArn"
    }
  }
}

# Cloudfront function to make sure URLs ending in / are redirected to /index.html
# See https://stackoverflow.com/a/76581267/267263
resource "aws_cloudfront_function" "main" {
  name    = "my-cloudfront-function"
  runtime = "cloudfront-js-1.0"

  code = <<EOF
function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Check whether the URI is missing a file name.
    if (uri.endsWith('/')) {
        request.uri += 'index.html';
    } 
    // Check whether the URI is missing a file extension.
    else if (!uri.includes('.')) {
        request.uri += '/index.html';
    }

    return request;
}
EOF

  comment = "Function to append index.html to missing URIs"
}

#### ROUTE53 CONFIGURATION
resource "aws_route53_record" "main" {
  name    = local.domain
  type    = "A"
  zone_id = data.aws_route53_zone.main.zone_id

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "production-fqdn" {
  name    = local.domain_for_prod
  type    = "A"
  zone_id = data.aws_route53_zone.main.zone_id

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}

