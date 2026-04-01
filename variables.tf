variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name used in resource tags"
  type        = string
  default     = "myproject"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to deploy subnets into. If empty, the first 3 AZs will be used."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets (one per AZ). If empty, no public subnets will be created."
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets (one per AZ). If empty, no private subnets will be created."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Set to true to provision NAT Gateway(s) for private subnets"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway shared across all AZs (cheaper, less HA). When false, one NAT Gateway is created per AZ."
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Additional tags to merge into every resource"
  type        = map(string)
  default     = {}
}
