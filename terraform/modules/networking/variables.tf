variable "vpc_name" {
  description = "Internet Gateway name"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
}

variable "instance_tenancy" {
  description = "Instance tenancy for the VPC"
}

variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    cidr_block           = string
    availability_zone    = string
    map_public_ip_on_launch = bool
  }))
}

variable "igw_name" {
  description = "Internet Gateway name"
}

variable "route_table_name" {
  description = "Route table name"
}

variable "routes" {
  description = "Map of route configurations"
  type = map(object({
    cidr_block = string
    gateway_id = string
  }))
}

variable "route_table_associations" {
  description = "Map of route table associations"
  type = map(object({
    subnet_id      = string
    route_table_id = string
  }))
}