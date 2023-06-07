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

resource "aws_iam_policy" "artifact_bucket_iam_policy" {
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
          "${aws_s3_bucket.codepipeline-bucket-84543422.arn}"
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
          "${aws_s3_bucket.codepipeline-bucket-84543422.arn}/*"
        ]
      },
      {
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Effect = "Allow",
        Resource = "${aws_s3_bucket.artifact-bucket-84543422.arn}/*"
        
      }
    ]
  })
}

# Artifact Bucket ##
resource "aws_s3_bucket" "artifact-bucket-84543422" {
  bucket = "artifact-bucket-84543422"
}

resource "aws_s3_bucket_policy" "artifact_bucket_policy" {
  bucket = aws_s3_bucket.artifact-bucket-84543422.id
  policy = data.aws_iam_policy_document.artifact_bucket_policy_doc.json
}

resource "aws_s3_bucket_public_access_block" "artifact_bucket_access" {
  provider = aws.cloud
  bucket = aws_s3_bucket.artifact-bucket-84543422.id
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
      identifiers = [var.codepipeline_role_arn]
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
      aws_s3_bucket.artifact-bucket-84543422.arn,
      "${aws_s3_bucket.artifact-bucket-84543422.arn}/*",
      ]
  }
}

resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  provider = aws.cloud
  bucket = aws_s3_bucket.artifact-bucket-84543422.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "artifact_bucket_versioning" {
  provider = aws.cloud
  bucket = aws_s3_bucket.artifact-bucket-84543422.id
  versioning_configuration {
    status = "Enabled"
  }
}

### CICD bucket

resource "aws_s3_bucket" "codepipeline-bucket-84543422" {
  bucket =  "cicd-artifact-bucket-84543422"
  force_destroy = true
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_access" {
  bucket = aws_s3_bucket.codepipeline-bucket-84543422.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "codepipeline_bucket_policy" {
  bucket = aws_s3_bucket.codepipeline-bucket-84543422.id
  policy = data.aws_iam_policy_document.codepipeline_bucket_policy_doc.json
}
  
data "aws_iam_policy_document" "codepipeline_bucket_policy_doc"{
  statement {
    principals {
      type = "AWS"
      identifiers = [var.codepipeline_role_arn]
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
      aws_s3_bucket.codepipeline-bucket-84543422.arn,
      "${aws_s3_bucket.codepipeline-bucket-84543422.arn}/*",
      ]
  }
}

resource "aws_s3_bucket_acl" "codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.codepipeline-bucket-84543422.id
  acl = "private"
}

resource "aws_s3_bucket_versioning" "codepipeline_bucket_versioning" {
  bucket = aws_s3_bucket.codepipeline-bucket-84543422.id
  versioning_configuration {
    status = "Enabled"
  }
}