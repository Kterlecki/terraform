resource "aws_iam_role" "artifact_s3_role" {
  name = "artifact_bucket_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name        = "artifact_s3_policy"
  description = "CICD S3 policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        Effect   = "Allow"
        Resource = [
          "${aws_s3_bucket.codePipeline.arn}"
        ]
      },
      {
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ],
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Effect = "Allow",
        Resource =  [
          "${aws_s3_bucket.artifact_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = cicd-artifact-bucket
  name = "artifact_bucket"
}

resource "aws_s3_bucket_policy" "artifact_bucket" {
  bucket = aws_s3_bucket.artifact_bucket.id
  policy = data.aws_iam_policy_document.artifact_bucket_policy_doc.json
}

resource "aws_s3_bucket_public_access_block" "artifact_bucket_access" {
  provider = aws.cloud
  bucket = aws_s3_bucket.artifact_bucket.id
  ignore_public_acls = true
  restrict_public_buckets = true
  block_public_acls = true
  block_public_policy = true
}

data "aws_iam_policy_document" "artifact_bucket_policy_doc"{
  provider = aws.cloud
  statement {
    principals {
      type = "AWS"
      identifiers = [var.var.codepipeline_role_arn]
    }

    actions = [ 
      "s3:Get*",
      "s3:List*",
      "s3:ReplicateObject",
      "s3:PutObject",
      "s3:RestoreObject",
      "s3:PutObjectVersionTagging",
      "s3:PutObjectTagging",
      "s3:PutObjectAcl"
     ]
     resources = [ 
      aws_s3_bucket.artifact_bucket.arn,
      "${aws_s3_bucket.artifact_bucket.arn}/*",
      ]
  }
}

resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  provider = aws.cloud
  bucket = aws_s3_bucket.artifact_bucket.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "artifact_bucket_versioning" {
  provider = aws.cloud
  bucket = aws_s3_bucket.artifact_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}