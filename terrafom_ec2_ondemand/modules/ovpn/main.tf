terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 6.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region 
}

# ---------------------------
# Data Sources
# ---------------------------

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

# ---------------------------
# Local Values
# ---------------------------

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  vpc_cidr     = data.aws_vpc.selected.cidr_block
  subnet_cidr  = var.subnet_cidr_block != null ? var.subnet_cidr_block : cidrsubnet(local.vpc_cidr, 8, 20)
}

# ---------------------------
# Networking Resources
# ---------------------------

resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = local.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${random_id.suffix.hex}"
  }

  lifecycle {
    ignore_changes = [cidr_block]
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "public-rt-${random_id.suffix.hex}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------
# EC2 Key Pair
# ---------------------------

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ec2-key-${random_id.suffix.hex}"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/ec2-key.pem"
  file_permission = "0400"
}

# ---------------------------
# Security Group
# ---------------------------


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow OpenVPN UDP"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = var.allowed_udp_cidr
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  } 

  ingress {
    description = "Allow Postgrey traffic (port 5324)"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_postgrey_cidr  # Define this as a variable or use ["0.0.0.0/0"]
}
  
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr  # Define this in variables.tf or use ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidr  # Define this too or use ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow_ssh_sg-${random_id.suffix.hex}"
    Environment = var.environment
  }
}

# ---------------------------
# on_demand EC2 Instance
# ---------------------------

resource "aws_instance" "ec2_on_demand" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "vpn-on_demand-instance"
  }
}

#------------------------------
# attach IAM policy
#------------------------------

resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
