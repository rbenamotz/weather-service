resource "aws_s3_bucket" "api_bucket" {
  bucket = "${local.function_name}-bucket"
}


data "aws_s3_bucket" "bucket" {
  bucket     = aws_s3_bucket.api_bucket.id
  depends_on = [aws_s3_bucket.api_bucket]
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = data.aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


data "aws_iam_policy_document" "data_store_access" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      data.aws_s3_bucket.bucket.arn,
      "${data.aws_s3_bucket.bucket.arn}/*"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "data_store_access" {
  name   = "${local.resource_name_prefix}.data_store_access-policy"
  policy = data.aws_iam_policy_document.data_store_access.json
}