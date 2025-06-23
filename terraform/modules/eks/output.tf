output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_name" {
  value = aws_iam_role.eks_node_group_role.name
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "eks_cluster_node_group_name" {
  value = aws_eks_node_group.eks_cluster_node_group.node_group_name
}
