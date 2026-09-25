# AWS EKS LAB

AWS-EKS-LAB showcase how create a working EKS cluster provisioned with Terraform, built as a hands-on lab for learning EKS and infrastructure-as-code workflows. It creates a VPC (public and private subnets across two AZs in ap-south-1), an EKS cluster with a single managed node group, and the core addons needed for a working cluster, with remote state and a GitHub Actions pipeline supporting it.

This is a learning environment, not a production setup. It uses a single NAT gateway and a single node to keep costs low, and it intentionally excludes ingress, monitoring, and autoscaling.  

[![Validate Plan](https://github.com/mohitd-13/aws-eks-lab/actions/workflows/validate.yml/badge.svg)](https://github.com/mohitd-13/aws-eks-lab/actions/workflows/validate.yml)
[![Speculative Plan](https://github.com/mohitd-13/aws-eks-lab/actions/workflows/plan.yml/badge.svg)](https://github.com/mohitd-13/aws-eks-lab/actions/workflows/plan.yml)
[![Apply Plan](https://github.com/mohitd-13/aws-eks-lab/actions/workflows/apply.yml/badge.svg)](https://github.com/mohitd-13/aws-eks-lab/actions/workflows/apply.yml)

## Architecture

The aws-eks-lab architecture has two main parts: a VPC and an EKS cluster.

The VPC spans two availability zones, each with one public and one private subnet. An Internet Gateway attached to the VPC handles inbound and outbound internet traffic for the public subnets. A single NAT Gateway, deployed in the AZ-1 public subnet, lets both private subnets initiate outbound connections while blocking unsolicited inbound traffic — this is a deliberate cost tradeoff for a lab environment rather than a highly available design, since AZ-2's private subnet depends on AZ-1's NAT gateway.

The EKS cluster consists of an AWS-managed control plane, running in an AWS-owned VPC outside this account, and a managed node group that provisions the worker nodes. Currently a single t3.medium worker node runs in the AZ-1 private subnet (AZ-2's private subnet is provisioned but unused, ready for scaling). The control plane and worker nodes communicate over EKS-managed ENIs placed in the private subnets. Core addons — vpc-cni, kube-proxy, coredns, and eks-pod-identity-agent — are installed for the cluster to function.

![ALT TEXT](./assets/aws-eks-lab-architecture.svg)

| Component | Value |
|---|---|
| Region | ap-south-1 |
| Kubernetes version | 1.33 |
| VPC CIDR | 10.0.0.0/16 |
| Availability Zones | ap-south-1a, ap-south-1b |
| Public subnets | 10.0.101.0/24 (AZ-1), 10.0.102.0/24 (AZ-2) |
| Private subnets | 10.0.1.0/24 (AZ-1), 10.0.2.0/24 (AZ-2) |
| NAT Gateways | 1 (AZ-1 only, shared across both AZs) |
| Node group | Managed node group "default" |
| Instance type | t3.medium |
| Node count | min = 1, max = 1, desired = 1 |
| Node placement | AZ-1 private subnet only |
| EKS addons | vpc-cni, kube-proxy, coredns, eks-pod-identity-agent |
| Cluster creator admin access | `enable_cluster_creator_admin_permissions = true` (access entries) |

## Getting Started

### Prerequisites

Before creating an eks cluster in your AWS account, you need to make sure that you have the following installed on your local machine:

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.10
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) >= 2.x, configured with credentials (`aws configure`)
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

> [!NOTE]
> This project uses a backend state for storing terraform statefiles for remote setup and CI/CD, but that is not needed for simply creating a working eks cluster on your local machine, that's why when initializing terraform in step 2 we are skipping the backend `terraform init -backend=false`. For more information on backend state check out [Contribution](./docs/CONTRIBUTION.md).

### Installation

To get started with creating your own cluster, follow these steps:

1. Clone the repository and change directory:

  ```bash
  git clone https://github.com/mohitd-13/aws-eks-lab.git
  cd aws-eks-lab
  ```

2. Initialize Terraform:

  ```bash
  terraform init -backend=false
  ```

3. View the resources that will be created:

  ```bash
  terraform plan
  ```

4. Apply the Terraform configuration:

  ```bash
  terraform apply -auto-approve
  ```

> [!NOTE]
> It can take 15-20 minutes for all resources to be fully created, so wait before moving on to the next step.

5. Update the kubeconfig to use your eks cluster

  ```bash
  aws eks update-kubeconfig --name $(terraform output --raw cluster_name) --region ap-south-1 
  ```
6. Verify the cluster is up:
 
  ```bash
  kubectl get nodes
  ```

## Cost & Teardown

Running this lab costs roughly $0.19/hour (~$4.50/day): about $0.10/hr for the EKS control plane, $0.045/hr for the NAT gateway, and $0.04/hr for the single t3.medium node. Other resources like VPC, subnets, IAM roles and backend resources(s3, kms) don't carry an hourly charge. Data transfer throught NAT Gateway is billed per GB and isn't included in the estimate above. Prices can vary depending on the region and current rates for more information visit [AWS Price](https://aws.amazon.com/pricing/).

Avoid heavy charge by destroying the cluster when you're done:

  ```bash
  terraform destroy -auto-approve
  ```
  
> [!WARNING]
> If `destroy` hangs or fails, check for resources created outside Terraform (e.g., a LoadBalancer provisioned by a Kubernetes Service), since these can hold onto the VPC and block deletion until removed manually.

## Contribution

We welcome contributions, for detail explanation on contribution checkout [Contribution](./docs/CONTRIBUTION.md).  

## License

This project is licensed under the MIT License.
