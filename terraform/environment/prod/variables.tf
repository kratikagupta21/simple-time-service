############################Common variabless############

variable "environment" {
  description = "Provide environment name"
}

variable "region" {
  description = "Provide region"
}

variable "availability_zones" {
  description = "provide availability zones"
}

###############################variable for VPC######################

variable "vpc_name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "public_subnets" {
  description = "List of public subnets"
  type    = list(string)
  default = null
}

variable "private_subnets" {
  description = "List of private subnets"
  type    = list(string)
  default = null
}


variable "public_subnet_ids" {
  type    = list(string)
  default = null
}

variable "private_subnet_ids" {
  type    = list(string)
  default = null
}

##############################variable for EKS######################

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
  default = "2"
  type = string
}

variable "eks_cluster_max_size" {
  description = "eks cluster max size"
  default = "3"
  type = string
}

variable "eks_cluster_min_size" {
  description = "eks cluster min size"
  default = "2"
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


##############################variable for simple-time-service######################

variable "deployment_name" {
  description = "deployment_name"
  default     = "simple-time-service"
  type        = string
}

variable "deployment_namespace" {
  description = "deployment_namespace"
  default     = "default"
  type        = string
}


variable "deployment_label" {
  description = "deployment_label"
  default     = "time-service"
  type        = string
}

variable "deployment_replicas" {
  description = "deployment_replicas"
  default     = 1
  type        = number
}

variable "deployment_container_name" {
  description = "deployment_container_name"
  default     = "time-service"
  type        = string
}

variable "deployment_image_name" {
  description = "deployment_image_name"
  default     = "kratikagupta/simple-time-service"
  type        = string
}

variable "deployment_container_port" {
  description = "deployment_container_port"
  default     = 5000
  type        = number
}

variable "deployment_cpu_limit" {
  description = "deployment_cpu_limit"
  default     = "250m"
  type        = string
}

variable "deployment_memory_limit" {
  description = "deployment_memory_limit"
  default     = "256Mi"
  type        = string
}

variable "deployment_cpu_request" {
  description = "deployment_cpu_request"
  default     = "100m"
  type        = string
}


variable "deployment_memory_request" {
  description = "deployment_memory_request"
  default     = "128Mi"
  type        = string
}

variable "service_name" {
  description = "service_name"
  default     = "time-service"
  type        = string
}

variable "service_type" {
  description = "service_type"
  default     = "LoadBalancer"
  type        = string
}

variable "service_port" {
  description = "service_port"
  default     = 5000
  type        = number
}

variable "service_target_port" {
  description = "service_terget_port"
  default     = 5000
  type        = number
}
