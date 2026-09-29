output "cluster_name" {
  description = "Name of the eks cluster where the Kubernetes cluster is deployed"
  value       = module.eks.cluster_name
}

output "vpc_name" {
  description = "Name of the VPC where the cluster is deployed"
  value       = module.vpc.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by the EKS cluster"
  value       = aws_iam_role.eks_role.arn
}

output "kubernetes_namespace" {
  description = "Namespace of the Kubernetes service account used by the EKS cluster"
  value       = aws_eks_pod_identity_association.pod_identity_assoc.namespace
}

output "kubernetes_service_account" {
  description = "Name of the Kubernetes service account used by the EKS cluster"
  value       = aws_eks_pod_identity_association.pod_identity_assoc.service_account
}
