resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-vpc"
  })
}

# ── Subnets ──────────────────────────────────────────────────────────────────

resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnet_cidr_blocks : idx => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = length(var.availability_zones) > 0 ? var.availability_zones[each.key % length(var.availability_zones)] : null
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-public-${each.key + 1}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnet_cidr_blocks : idx => cidr }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = length(var.availability_zones) > 0 ? var.availability_zones[each.key % length(var.availability_zones)] : null

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-private-${each.key + 1}"
    Tier = "private"
  })
}

# ── Internet Gateway ──────────────────────────────────────────────────────────

resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnet_cidr_blocks) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-igw"
  })
}

# ── Public Route Table ────────────────────────────────────────────────────────

resource "aws_route_table" "public" {
  count  = length(var.public_subnet_cidr_blocks) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-public-rt"
  })
}

resource "aws_route" "public_internet" {
  count                  = length(var.public_subnet_cidr_blocks) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

# ── NAT Gateway ──────────────────────────────────────────────────────────────

locals {
  nat_gateway_count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.public_subnet_cidr_blocks)) : 0
}

resource "aws_eip" "nat" {
  count  = local.nat_gateway_count
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "this" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  # Place NAT GW in sequential public subnets
  subnet_id = values(aws_subnet.public)[count.index].id

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-nat-${count.index + 1}"
  })

  depends_on = [aws_internet_gateway.this]
}

# ── Private Route Tables ─────────────────────────────────────────────────────

resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${try(var.tags["Environment"], "dev")}-private-rt-${each.key + 1}"
  })
}

resource "aws_route" "private_nat" {
  for_each = var.enable_nat_gateway ? aws_subnet.private : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[each.key % local.nat_gateway_count].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
