provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../../"

  environment = var.environment
  project     = var.project

  vpc_cidr_block             = var.vpc_cidr_block
  availability_zones         = var.availability_zones
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  additional_tags = {
    ManagedBy = "terraform"
  }
}

# ── Outputs ───────────────────────────────────────────────────────────────────

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "nat_gateway_ids" {
  value = module.vpc.nat_gateway_ids
}
