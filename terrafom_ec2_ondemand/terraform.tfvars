region              = "us-east-1"
vpc_name            = "prod-vpc"
vpc_cidr            = "10.0.0.0/16"
azs                 = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
allowed_ssh_cidr    = ["0.0.0.0/0"]
allowed_udp_cidr    = ["0.0.0.0/0"]
#eks values
cluster_name        = "testingondemand-cluster"
cluster_version     = "1.31"
min_size            = 2
max_size            = 5
desired_size        = 5
on_demand_instance_types = ["m5.large"]
# terraform.tfvars
db_name           = "mydatabase"
db_password       = "ChangeMe123!"  # Replace with a secure password
environment       = "dev"
instance_class    = "db.t3.micro"
allocated_storage = 20
db_username       = "dbadmin"
allowed_cidr_blocks = [ "10.0.0.0/16" ]
#ovpn
instance_type = "t3.medium"