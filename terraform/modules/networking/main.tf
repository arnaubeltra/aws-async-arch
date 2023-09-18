resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  instance_tenancy = var.instance_tenancy
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnets" {
  vpc_id = aws_vpc.vpc.id
  for_each = var.subnets
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch 
  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  dynamic "route" {
    for_each = var.routes
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }
  tags = {
    Name = var.route_table_name
  }
}

resource "aws_route_table_association" "route_table_association" {
  depends_on = [ aws_route_table.route_table ]
  for_each = var.route_table_associations
  subnet_id = each.value.subnet_id
  route_table_id = each.value.route_table_id
}
