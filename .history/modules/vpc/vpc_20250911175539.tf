resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = var.name })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  for_each                = { for idx, az in var.azs : idx => az }
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr, 4, each.key)
  map_public_ip_on_launch = true
  availability_zone       = each.value
  tags                    = merge(var.tags, { Name = "${var.name}-public-${each.key}" })
}

resource "aws_subnet" "private" {
  for_each          = { for idx, az in var.azs : idx => az }
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr, 4, each.key + 8)
  availability_zone = each.value
  tags              = merge(var.tags, { Name = "${var.name}-private-${each.key}" })
}

resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  domain   = "vpc"
  tags     = merge(var.tags, { Name = "${var.name}-nat-eip-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = merge(var.tags, { Name = "${var.name}-nat-${each.key}" })
  depends_on    = [aws_internet_gateway.this]
}


