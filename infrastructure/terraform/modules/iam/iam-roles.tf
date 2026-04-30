data "aws_iam_policy_document" "ec2_app_policy_doc" {
  statement {
    sid    = "AllowReadDbSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      aws_secretsmanager_secret.db_credentials.arn
    ]
  }

  statement {
    sid    = "AllowS3ImageAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.images.arn,
      "${aws_s3_bucket.images.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "ec2_app_policy" {
  name   = "${var.project_name}-ec2-app-policy"
  policy = data.aws_iam_policy_document.ec2_app_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "ec2_app_policy_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ec2_app_policy.arn
}
