provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../../"

  environment = var.environment
}
