resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.eks_key_pair_name}"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "aws_secretsmanager_secret" "key_pair" {
  name        = "${var.eks_key_pair_name}"
  description = "EC2 instance key"
}

resource "aws_secretsmanager_secret_version" "key_pair" {
  secret_id     = aws_secretsmanager_secret.key_pair.id
  secret_string = tls_private_key.key_pair.private_key_pem
}

resource "aws_security_group" "eks_node_group_sg" {
  name        = var.eks_node_group_sg
  description = "Security group for EKS node group"
  vpc_id      = var.eks_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }



  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"  
    cidr_blocks     = ["0.0.0.0/0"]  
  }

}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = var.eks_cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.eks_cluster_role.name
}

/*resource "aws_iam_role_policy_attachment" "AccessKubernetesApi" {
  policy_arn = "arn:aws:iam::263418058632:policy/AccessKubernetesApi" #"arn:aws:iam::730335448473:policy/AccessKubernetesApi" #"arn:aws:iam::471112792555:policy/AccessKubernetesApi" 
  role       = aws_iam_role.eks_cluster_role.name
}*/

resource "aws_iam_role_policy_attachment" "AutoScalingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.eks_cluster_role.name
}
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_cluster_version
  vpc_config {
    subnet_ids = var.vpc_subnet_ids #["subnet-0760535658bb51ded", "subnet-06afff705221c26d7", "subnet-0a27abca521462fdf", "subnet-00ef8ecacad4aa2d9", "subnet-0e9d264cc0fc96810"] #var.vpc_subnet_ids
    endpoint_private_access = var.eks_cluster_endpoint_private_access
    endpoint_public_access  = var.eks_cluster_endpoint_public_access
    security_group_ids      = [aws_security_group.eks_node_group_sg.id]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.CloudWatchFullAccess,
    aws_iam_role_policy_attachment.AutoScalingFullAccess
  ]
  tags      = {
    eks-node-group-env      = "prod"
    Name                    = var.eks_cluster_name
  }
}




resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
  addon_version = "v1.19.0-eksbuild.1"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}


resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role-12"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_eks_node_group" "eks_cluster_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-cluster-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.vpc_subnet_ids  #["subnet-0760535658bb51ded", "subnet-06afff705221c26d7", "subnet-0a27abca521462fdf", "subnet-00ef8ecacad4aa2d9", "subnet-0e9d264cc0fc96810"] #var.vpc_subnet_ids
  version         = aws_eks_cluster.eks_cluster.version
  instance_types  = var.eks_instance_types
  disk_size       = var.eks_disk_size
  tags            = {
    eks-node-group-env      = "prod"
    Name          = aws_eks_cluster.eks_cluster.name
  }  

  scaling_config {
    desired_size = var.eks_cluster_desired_size
    max_size     = var.eks_cluster_max_size
    min_size     = var.eks_cluster_min_size
  }

  update_config {
    max_unavailable = var.eks_cluster_max_unavailable
  }

  /*lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }*/

  remote_access {
    ec2_ssh_key = aws_key_pair.key_pair.key_name
    source_security_group_ids = [aws_security_group.eks_node_group_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
  resolve_conflicts_on_update = "OVERWRITE"
  addon_version               = "v1.11.3-eksbuild.1"

  configuration_values = jsonencode({
    replicaCount = 3
    /*resources = {
      limits = {
        cpu    = "100m"
        memory = "150Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "150Mi"
      }
    }*/
  })
  depends_on = [aws_eks_cluster.eks_cluster, aws_eks_node_group.eks_cluster_node_group]
}

/*resource "aws_eks_addon" "csi_snapshot" {
  cluster_name                  = aws_eks_cluster.eks_cluster.name
  addon_name                    = "snapshot-controller"
  addon_version                 = "v7.0.1-eksbuild.1"
  depends_on                    = [aws_eks_cluster.eks_cluster, aws_eks_node_group.eks_cluster_node_group]
}*/

resource "aws_eks_addon" "efs" {
  cluster_name                  = aws_eks_cluster.eks_cluster.name
  addon_name                    = "aws-efs-csi-driver"
  addon_version                 = "v2.1.4-eksbuild.1"
  depends_on                    = [aws_eks_cluster.eks_cluster, aws_eks_node_group.eks_cluster_node_group]
}