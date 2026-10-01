data "aws_iam_policy_document" "eks_trust" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "eks_role" {
  name                 = var.eks_role_name
  assume_role_policy   = data.aws_iam_policy_document.eks_trust.json
  permissions_boundary = var.eks_permissions_boundary_arn
}

resource "aws_eks_pod_identity_association" "pod_identity_assoc" {
  cluster_name    = module.eks.cluster_name
  namespace       = var.workload_namespace
  service_account = var.workload_sa
  role_arn        = aws_iam_role.eks_role.arn
}
