variable "vpc_cidr_block" {
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []
}

variable "availability_zones" {
  description = "List of availability zones to deploy subnets into"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Set to true to create NAT Gateway(s) so private subnets can reach the internet"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "When true, a single NAT Gateway is shared by all private subnets (less HA, lower cost). When false, one NAT Gateway is created per AZ."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
