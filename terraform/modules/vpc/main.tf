resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                                   = "${var.name}-vpc-${var.environment}"
    Product                                                = var.name
    Environment                                            = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-igw-${var.environment}"
    Product     = var.name
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.name}-nat-${var.environment}-${format("%03d", count.index+1)}"
    Product     = var.name
    Environment = var.environment
  }
}

resource "aws_eip" "nat" {
  count = length(var.private_subnets)

  tags = {
    Name        = "${var.name}-nat-eip-${var.environment}-${format("%03d", count.index+1)}"
    Product     = var.name
    Environment = var.environment
  }
}

/*output "eip_allocation_ids" {
  value = aws_eip.nat[*].id
}*/

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)
  map_public_ip_on_launch = false

  tags = {
    Name                                                   = "${var.name}-private-subnet-${var.environment}-${format("%03d", count.index+1)}",
    Product                                                = var.name
    Environment                                            = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = false

  tags = {
    Name                                                   = "${var.name}-public-subnet-${var.environment}-${format("%03d", count.index+1)}",
    Product                                                = var.name
    Environment                                            = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-routing-table-public-${var.environment}"
    Product     = var.name
    Environment = var.environment
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.name}-routing-table-private-${var.environment}-${format("%03d", count.index+1)}"
    Product     = var.name
    Environment = var.environment
  }
}

resource "aws_route" "private" {
  count                  = length(compact(var.public_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

