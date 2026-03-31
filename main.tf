module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet_cidr_blocks  = local.public_subnets
  private_subnet_cidr_blocks = local.private_subnets
  availability_zones         = local.azs
  enable_nat_gateway         = true
  tags                       = local.common_tags
}
