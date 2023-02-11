resource "aws_vpc" "eks_network" {
  cidr_block           = var.cidr_block
  
  enable_dns_hostnames = true
  tags = {
    Name = var.cluster_name
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# Internet gatewaycode vpc_v  
resource "aws_internet_gateway" "eks_network_gateway" {
  vpc_id = aws_vpc.eks_network.id
  
  tags = {
    Name = var.cluster_name
  }
  
}

# NAT gateway
resource "aws_eip" "eks_network_nat_gateway_a" {
  vpc        = true
  for_each   = var.vpc_private_prefix
  tags = {
    Name = "${var.cluster_name}-nat-gateway_a"
  }
}

resource "aws_route_table" "eks_network_public" {
  vpc_id = aws_vpc.eks_network.id
  
  tags = {
    Name = "${var.cluster_name}-public"
  }
}

resource "aws_route" "internet-gateway" {
  route_table_id         = aws_route_table.eks_network_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_network_gateway.id
}

resource "aws_default_route_table" "eks_network_private" {
  default_route_table_id = aws_vpc.eks_network.default_route_table_id

  tags = {
    Name = "${var.cluster_name}-private"
  }
}
