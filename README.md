# Terraform AWS VPC Module

This module provisions a production-ready AWS Virtual Private Cloud (VPC) with public and private subnets.
It includes essential networking components such as an Internet Gateway, NAT Gateway, route tables, and subnet associations.

## Features

* Creates a VPC with customizable CIDR block
* Supports public and private subnets
* Configures Internet Gateway for public access
* Configures NAT Gateway for private subnet outbound access
* Sets up route tables and associations
* Implements environment-based naming and tagging

##usage

```hcl
module "vpc" {
  source = "aaditya-2905/vpc/aws"

  vpc_cidr_block        = "10.0.0.0/16"
  pub_subnet_cidr_block = "10.0.1.0/24"
  priv_subnet_cidr_block = "10.0.2.0/24"
  environment           = "dev"
}
```

## Inputs

| Name                   | Description                 | Type   |
| ---------------------- | --------------------------- | ------ |
| vpc_cidr_block         | CIDR block for VPC          | string |
| pub_subnet_cidr_block  | CIDR for public subnet      | string |
| priv_subnet_cidr_block | CIDR for private subnet     | string |
| environment            | Environment name (dev/prod) | string |

## Outputs

| Name           | Description       |
| -------------- | ----------------- |
| vpc_id         | ID of the VPC     |
| pub_subnet_id  | Public subnet ID  |
| priv_subnet_id | Private subnet ID |

## Notes

* NAT Gateway requires an Elastic IP which is Expenisve
* Public subnet is internet-accessible via IGW
* Private subnet routes traffic through NAT Gateway
