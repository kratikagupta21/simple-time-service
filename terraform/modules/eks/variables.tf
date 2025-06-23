variable "eks_cluster_role_name" {
  description = "eks cluster role name"
  default = "eks-cluster-role"
  type = string
}

variable "eks_vpc_id" {
  description = "eks vpc id"
  default = ""
  type = string
}

variable "eks_node_group_sg" {
  description = "eks node group sg"
  default = ""
  type = string
}


variable "eks_key_pair_name" {
  description = "eks key pair name"
  default = ""
  type = string
}

variable "eks_cluster_name" {
  description = "eks cluster name"
  default = "eks-cluster"
  type = string
}

variable "eks_cluster_version" {
  description = "eks cluster version"
  default = "1.29"
  type = string
}

variable "vpc_subnet_ids" {
  description = "vpc subnet ids"
  default = []
  type = list(string)
}

variable "eks_cluster_endpoint_private_access" {
  description = "eks cluster endpoint private access"
  default = true
  type = bool
}

variable "eks_cluster_endpoint_public_access" {
  description = "eks cluster endpoint public access"
  default = false
  type = bool
}

variable "eks_cluster_desired_size" {
  description = "eks cluster max unavailable"
  default = "28"
  type = string
}

variable "eks_cluster_max_size" {
  description = "eks cluster max size"
  default = "35"
  type = string
}

variable "eks_cluster_min_size" {
  description = "eks cluster min size"
  default = "28"
  type = string
}

variable "eks_cluster_max_unavailable" {
  description = "eks cluster max unavailable"
  default = "1"
  type = string
}

variable "eks_instance_types" {
  description = "eks disk size"
  default = []
  type = list(string)
}

variable "eks_disk_size" {
  description = ""
  default = ""
  type = string
}







