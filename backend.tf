terraform {
  backend "s3" {
    bucket       = "terraform-statefile-bucket-656338545145"
    key          = "aws-eks-lab/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
    kms_key_id   = "arn:aws:kms:ap-south-1:656338545145:key/707c388a-3a53-4bac-b1db-78028e63a6d6"
  }
}
