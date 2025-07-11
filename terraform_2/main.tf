provider "aws" {
  region = "us-east-1"  # Path to your kubeconfig file
}
provider "kubernetes" {
  config_path = "~/.kube/config"  # Path to your kubeconfig file
}

data "aws_caller_identity" "current" {}
terraform {
  backend "s3" {
    bucket         = "my-tf-state-file-100000"
    key            = "envs/test/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"   
  }
}

# ... keep your existing module calls ...
module "vpc" {
  source = "./modules/vpc"

  vpc_name          = var.vpc_name
  vpc_cidr          = var.vpc_cidr
  azs               = var.azs
  private_subnets   = var.private_subnets
  public_subnets    = var.public_subnets
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  allowed_udp_cidr  = var.allowed_udp_cidr
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  spot_instance_types = var.spot_instance_types
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::453004142036:user/KeerthanaSankar"
      username = "KeerthanaSankar"
      groups   = ["system:masters"]
    }
  ]
}


# Configure Kubernetes provider AFTER EKS module


module "iam" {
  source = "./modules/iam"  # Path to your IAM module
  environment = var.environment
  aws_region  = var.aws_region
}


module "rds" {
  source = "./modules/rds"

  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.security_group_id]
  monitoring_role_arn = module.iam.rds_monitoring_role_arn

  db_name            = var.db_name
  db_password        = var.db_password
  environment        = var.environment
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  db_username        = var.db_username
}

##########################

resource "random_id" "suffix" {
  byte_length = 4
}
############################

module "spot_instance" {
  source         = "./modules/ovpn"
  #ami_id         = data.aws_ami.ubuntu.id
  instance_type  = var.instance_type
  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
}


####################nls
# main.tf (Updated)


module "cloudmasa_dns" {
  source = "./modules/private_hosted_zone"

  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnets
  enable_deletion_protection = false
  tags = {
    Environment = "production"
    Team       = "platform"
  }
}
