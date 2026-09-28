variable "aws_region" {
  description = "Name of the AWS region where the resources will be deployed"
  type        = string
  default     = "ap-south-1"
}

variable "cloud_name" {
  description = "Name of the VPC for AWS EKS LAB"
  type        = string
  default     = "aws-eks-vpc"
}

variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
  default     = "aws-eks-cluster"
}

variable "eks_role_name" {
  description = "Name of the IAM Role for our EKS Cluster"
  type        = string
  default     = "TerraformEKSLABRole"
}

variable "workload_namespace" {
  description = "Namespace for our Kubernetes workloads"
  type        = string
  default     = "payments"
}

variable "workload_sa" {
  description = "Service Account for our Kubernetes workloads"
  type        = string
  default     = "payments-sa"
}
