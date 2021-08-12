  terraform {
  backend "s3" {
    bucket  = "ebebe150-2617-45f2-8a0a-6c7ad412c17e-dev"
    key     = "service/terraform.tfstate"
    region  = "us-east-1"
    profile = "ebebe150-2617-45f2-8a0a-6c7ad412c17e_root"
  }
}

