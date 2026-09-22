data "aws_iam_policy_document" "payments_irsa_trust" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::656338545145:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/F864D19680EFC529AAD78C10C7E4585C"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.ap-south-1.amazonaws.com/id/F864D19680EFC529AAD78C10C7E4585C:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.ap-south-1.amazonaws.com/id/F864D19680EFC529AAD78C10C7E4585C:sub"
      values   = ["system:serviceaccount:payments:api"]
    }
  }
}

data "aws_iam_policy_document" "payments_s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::pastebin-content-656338545145/payments/*"]
  }
}
