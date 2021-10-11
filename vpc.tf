#Main VPC detail
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_code}-${var.environment}-vpc"
  }
}

#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_code}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project_code
    Manager     = var.project_mgr
  }
}

#Route table for public subnets
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_code}-${var.environment}-public-rt"
    Environment = var.environment
    Project     = var.project_code
    Manager     = var.project_mgr
  }
}

#Set main route table
resource "aws_main_route_table_association" "main_rt" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.pub_route_table.id
}


#Create a public subnet a
resource "aws_subnet" "pub_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "${var.project_code}-${var.environment}-public-subnet-a"
  }
}

# Create public subnet c
resource "aws_subnet" "pub_subnet_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_subnet_c_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}c"

  tags = {
    Name = "${var.project_code}-${var.environment}-public-subnet-c"
  }
}

#Route table subnet associations public subnet a
resource "aws_route_table_association" "pub_a" {
  subnet_id      = aws_subnet.pub_subnet_a.id
  route_table_id = aws_route_table.pub_route_table.id
}

#Route table subnet associations public subnet c
resource "aws_route_table_association" "pub_c" {
  subnet_id      = aws_subnet.pub_subnet_c.id
  route_table_id = aws_route_table.pub_route_table.id
}

#Route Tables for private subnets
resource "aws_route_table" "pvt_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_code}-${var.environment}-private-rt"
    Environment = var.environment
    Project     = var.project_code
    Manager     = var.project_mgr
  }
}

#Create a private subnet in a
resource "aws_subnet" "pvt_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.priv_subnet_a_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project_code}-${var.environment}-private-subnet-a"
  }
}

# Create private subnet in c
resource "aws_subnet" "pvt_subnet_c" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.priv_subnet_c_cidr
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "${var.project_code}-${var.environment}-private-subnet-c"
  }
}

#Route table subnet associations private a
resource "aws_route_table_association" "pvt_a" {
  subnet_id      = aws_subnet.pvt_subnet_a.id
  route_table_id = aws_route_table.pvt_route_table.id
}

#Route table subnet associations private c
resource "aws_route_table_association" "pvt_c" {
  subnet_id      = aws_subnet.pvt_subnet_c.id
  route_table_id = aws_route_table.pvt_route_table.id
}