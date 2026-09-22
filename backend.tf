terraform {
  backend "s3" {
    bucket       = "terraform-statefile-bucket-656338545145"
    key          = "aws-eks-lab/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
    kms_key_id   = "alias/terraform-statefile-bucket-656338545145-key"
  }
}
