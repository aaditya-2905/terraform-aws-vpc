output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}

output "igw_id" {
  description = "ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs (empty when enable_nat_gateway = false)"
  value       = try(aws_nat_gateway.this[*].id, [])
}

output "public_route_table_id" {
  description = "ID of the shared public route table"
  value       = try(aws_route_table.public[0].id, null)
}

output "private_route_table_ids" {
  description = "List of private route table IDs (one per AZ)"
  value       = [for rt in aws_route_table.private : rt.id]
}
