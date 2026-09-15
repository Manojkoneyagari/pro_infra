resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

resource "aws_subnet" "public_sub" {
  count                   = length(var.public_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = var.aznames[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-pubsubnet-${var.aznames[count.index]}"
  }
}

resource "aws_subnet" "private_sub" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.aznames[count.index]


  tags = {
    Name = "${var.project}-privsubnet-${var.aznames[count.index]}"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-${var.environment}-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_sub[0].id

  tags = {
    Name = "${var.project}-${var.environment}-ngw"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "${var.project}-${var.environment}-publicroute"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }


  tags = {
    Name = "${var.project}-${var.environment}-privateroute"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public_sub[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.private_sub[count.index].id
  route_table_id = aws_route_table.private_route.id
}