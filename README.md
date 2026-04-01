# AWS VPC Wrapper Module

A fully dynamic and reusable Terraform wrapper for provisioning a production-ready AWS VPC. This module uses `try()` logic for robust defaults and `for_each` for flexible subnet management, ensuring zero-error deployment even with minimal inputs.

## Features

- **Fully Dynamic**: Supports any number of public and private subnets across multiple AZs.
- **Fail-Safe Defaults**: Uses `try()` and `coalesce()` to handle missing inputs without throwing errors.
- **Automatic AZ Selection**: Automatically picks the first 3 Available AZs if none are provided.
- **Flexible NAT Configuration**: Toggle between single NAT Gateway (cost-optimized) or one per AZ (high availability).
- **Consolidated Tagging**: Automatically merges project, environment, and custom tags across all resources.

### Basic Usage (Minimal Inputs)
The module will use defaults (10.0.0.0/16 VPC, no subnets unless specified).

```hcl
module "vpc" {
  source  = "aaditya-2905/vpc/aws"
  version = "1.1.0"

  environment = "dev"
  project     = "my-awesome-app"
}
```

### Advanced Usage (Fully Configured)
```hcl
module "vpc" {
  source  = "aaditya-2905/vpc/aws"
  version = "1.1.0"

  vpc_cidr_block             = "10.0.0.0/16"
  availability_zones         = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false # High Availability: NAT GW per AZ

  additional_tags = {
    Owner     = "DevOps-Team"
    ManagedBy = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default |
| :--- | :--- | :--- | :--- |
| `vpc_cidr_block` | CIDR block for the VPC | `string` | `"10.0.0.0/16"` |
| `environment` | Deployment environment name | `string` | `"dev"` |
| `project` | Project name used in resource tags | `string` | `"myproject"` |
| `availability_zones` | AZs to deploy into (falls back to first 3 available) | `list(string)` | `[]` |
| `public_subnet_cidr_blocks` | List of CIDR blocks for public subnets | `list(string)` | `[]` |
| `private_subnet_cidr_blocks`| List of CIDR blocks for private subnets | `list(string)` | `[]` |
| `enable_nat_gateway` | Provision NAT Gateway(s) for private subnets | `bool` | `false` |
| `single_nat_gateway` | Use a single shared NAT Gateway (cheaper) | `bool` | `true` |
| `additional_tags` | Extra tags for every resource | `map(string)` | `{}` |

## Outputs

| Name | Description |
| :--- | :--- |
| `vpc_id` | The ID of the VPC |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids`| List of private subnet IDs |
| `igw_id` | ID of the Internet Gateway |
| `nat_gateway_ids` | List of NAT Gateway IDs |
| `public_route_table_id` | ID of the shared public route table |
| `private_route_table_ids`| List of private route table IDs |

## Notes

- **Dynamic Tagging**: Resources are automatically named based on `environment` and `project` tags.
- **NAT Gateway**: Placing a NAT Gateway requires at least one public subnet. If `enable_nat_gateway` is true but no public subnets are defined, the NAT Gateway won't be created.
- **Cost Warning**: NAT Gateways and Elastic IPs incur hourly costs. Use `single_nat_gateway = true` for dev environments.
