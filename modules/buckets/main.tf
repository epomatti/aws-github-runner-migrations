locals {
  random_affix                 = random_string.random_suffix.result
  minimal_ubuntu_pro_usg       = "scripts/minimal_ubuntu_pro_usg.sh"
  minimal_ubuntu_github_runner = "scripts/minimal_ubuntu_github_runner.sh"
}

resource "random_string" "random_suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "aws_s3_bucket" "main" {
  bucket        = "bucket-github-runner-${local.random_affix}"
  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# resource "aws_s3_object" "minimal_ubuntu_pro_usg" {
#   bucket = aws_s3_bucket.main.id
#   key    = local.minimal_ubuntu_pro_usg
#   source = local.minimal_ubuntu_pro_usg
#   etag   = filemd5(local.minimal_ubuntu_pro_usg)
# }

# resource "aws_s3_object" "minimal_ubuntu_github_runner" {
#   bucket = aws_s3_bucket.main.id
#   key    = local.minimal_ubuntu_github_runner
#   source = local.minimal_ubuntu_github_runner
#   etag   = filemd5(local.minimal_ubuntu_github_runner)
# }
