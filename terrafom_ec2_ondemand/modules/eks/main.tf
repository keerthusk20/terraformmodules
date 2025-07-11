resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
  ]
}

#############################
# EKS Node Group (ON_DEMAND)
############################# 

resource "aws_eks_node_group" "on_demand_nodes" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "on_demand-node-group"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_ids

  # In modules/eks/main.tf
  #capacity_type   = "ON_DEMAND"  # Change back to ON_DEMAND after quota increase
  #instance_types  = ["t3.medium"]  # Use single instance type

  capacity_type   = "ON_DEMAND"
  instance_types  = var.on_demand_instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow worker nodes to communicate with EKS API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with VPC CIDR if needed
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}


