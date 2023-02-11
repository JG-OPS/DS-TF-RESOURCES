data "aws_availability_zones" "azs" {
  state = "available"
}
locals {
  az_names = data.aws_availability_zones.azs.names
  vpc_tags = {
    Name                                        = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/role/alb-ingress"            = "1"
    "subnet-type"                               = "public"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value["id"]
  route_table_id = aws_route_table.eks_network_public.id
}

resource "aws_subnet" "public" {
  for_each                = var.vpc_public_prefix
  availability_zone_id    = each.value["az"]
  cidr_block              = each.value["cidr"]
  vpc_id                  = aws_vpc.eks_network.id
  map_public_ip_on_launch = true

  tags = local.vpc_tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

# Private subnets

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value["id"]
  route_table_id = aws_default_route_table.eks_network_private.id
}

resource "aws_subnet" "private" {
  for_each                = var.vpc_private_prefix
  availability_zone_id    = each.value["az"]
  cidr_block              = each.value["cidr"]
  vpc_id                  = aws_vpc.eks_network.id
  map_public_ip_on_launch = false

  tags = local.vpc_tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "aws_nat_gateway" "eks_network_nat_gateway" {
  for_each      = aws_subnet.private
  allocation_id = aws_eip.eks_network_nat_gateway_a.id
  subnet_id     = "${each.value["id"]}"
  tags = {
    Name = var.cluster_name
  }
}

resource "aws_route" "nat-gateway" {
  for_each               = aws_nat_gateway.eks_network_nat_gateway
  route_table_id         = aws_default_route_table.eks_network_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value["id"]
}
