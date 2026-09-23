provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=55d9916d3c8ae59e1f9d74be7825a1c355a54a5b"
  version = "5.10.0"

  name = "aws-eks-lab"
  cidr = "10.0.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b",
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
  ]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
}

module "eks" {
  source  = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=61eb7d050ecea5eff4a9d3453d3be2d6afed57a6"
  version = "20.10.0"

  name               = "aws-eks-lab"
  kubernetes_version = "1.33"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access                   = true
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

      subnet_ids = module.vpc.private_subnets
    }
  }
}
