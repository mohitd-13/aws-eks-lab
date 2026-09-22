resource "aws_iam_role" "payments_irsa" {
  name               = "payments-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.payments_irsa_trust.json
}

resource "aws_iam_policy" "payments_s3" {
  name   = "payments_s3"
  policy = data.aws_iam_policy_document.payments_s3.json
}

resource "aws_iam_role_policy_attachment" "payments_irsa_s3" {
  role       = aws_iam_role.payments_irsa.name
  policy_arn = aws_iam_policy.payments_s3.arn
}
