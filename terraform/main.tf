module "vpc" {
  source  = "./modules/networking"

  vpc_name = "async-arch-vpc"
  cidr_block         = "10.0.0.0/16"
  instance_tenancy   = "default"

  subnets = {
    "async-arch-public-subnet-1" = {
      cidr_block           = "10.0.1.0/24"
      availability_zone    = "us-east-1a"
      map_public_ip_on_launch = true
    },
    "async-arch-public-subnet-2" = {
      cidr_block           = "10.0.2.0/24"
      availability_zone    = "us-east-1b"
      map_public_ip_on_launch = true
    },
    "async-arch-frontend-subnet-1" = {
      cidr_block           = "10.0.3.0/24"
      availability_zone    = "us-east-1a"
      map_public_ip_on_launch = false
    },
    "async-arch-frontend-subnet-2" = {
      cidr_block           = "10.0.4.0/24"
      availability_zone    = "us-east-1b"
      map_public_ip_on_launch = false
    },
    "async-arch-worker-subnet-1" = {
      cidr_block           = "10.0.5.0/24"
      availability_zone    = "us-east-1a"
      map_public_ip_on_launch = false
    },
    "async-arch-worker-subnet-2" = {
      cidr_block           = "10.0.6.0/24"
      availability_zone    = "us-east-1b"
      map_public_ip_on_launch = false
    }
  }

  igw_name = "async-arch-igw"
  
  routes = {
    internet_route = {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.vpc.internet_gateway.id
    }
  }

  route_table_name = "async-arch-custom-route-table"

  route_table_associations = {
    public_subnet1_association = {
      subnet_id      = module.vpc.public_subnet_1
      route_table_id = module.vpc.route_table
    },
    public_subnet2_association = {
      subnet_id      = module.vpc.public_subnet_2
      route_table_id = module.vpc.route_table
    }
  }

}
