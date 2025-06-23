data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
  depends_on       = [module.eks_cluster]
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
  depends_on       = [module.eks_cluster]
}