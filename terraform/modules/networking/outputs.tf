output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}

output "public_subnet_1" {
  value = aws_subnet.subnets["async-arch-public-subnet-1"].id
}

output "public_subnet_2" {
  value = aws_subnet.subnets["async-arch-public-subnet-2"].id
}


output "route_table" {
  value = aws_route_table.route_table.id
}
