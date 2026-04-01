locals {
  # Use provided AZs or fallback to the first 3 available
  azs = length(var.availability_zones) > 0 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 3)

  common_tags = merge(
    {
      Environment = try(var.environment, "dev")
      Project     = try(var.project, "myproject")
    },
    var.additional_tags
  )

  # Normalize subnet configurations for the module
  public_subnets = {
    for idx, cidr in var.public_subnet_cidr_blocks : "public-${idx}" => {
      cidr_block = cidr
      az         = local.azs[idx % length(local.azs)]
      tier       = "public"
    }
  }

  private_subnets = {
    for idx, cidr in var.private_subnet_cidr_blocks : "private-${idx}" => {
      cidr_block = cidr
      az         = local.azs[idx % length(local.azs)]
      tier       = "private"
    }
  }
}
