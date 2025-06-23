############################TO Deploy VPC#######################################

module "vpc" {
   source             = "../../modules/vpc"
   name               = var.vpc_name
   environment        = var.environment
   cidr               = var.cidr
   private_subnets    = var.private_subnets
   public_subnets     = var.public_subnets
   availability_zones = var.availability_zones
}


############################TO Deploy eks#######################################

module "eks_cluster" {
  source                                  = "../../modules/eks" 
  eks_cluster_role_name                   = var.eks_cluster_role_name
  eks_cluster_name                        = var.eks_cluster_name
  eks_cluster_version                     = var.eks_cluster_version
  vpc_subnet_ids                          = module.vpc.private_subnet_ids
  eks_cluster_endpoint_private_access     = var.eks_cluster_endpoint_private_access
  eks_cluster_endpoint_public_access      = var.eks_cluster_endpoint_public_access
  eks_cluster_desired_size                = var.eks_cluster_desired_size
  eks_cluster_max_size                    = var.eks_cluster_max_size
  eks_cluster_min_size                    = var.eks_cluster_min_size
  eks_cluster_max_unavailable             = var.eks_cluster_max_unavailable
  eks_instance_types                      = var.eks_instance_types
  eks_disk_size                           = var.eks_disk_size
  eks_vpc_id                              = module.vpc.vpc_id
  eks_node_group_sg                       = var.eks_node_group_sg
  eks_key_pair_name                       = var.eks_key_pair_name

  depends_on = [module.vpc]

}


############################TO Deploy simple-time-service#######################################


module "name" {
  source = "../../modules/simple-time-service-deployment"
  deployment_name             = var.deployment_name
  deployment_namespace        = var.deployment_namespace
  deployment_label            = var.deployment_label
  deployment_replicas         = var.deployment_replicas
  deployment_container_name   = var.deployment_container_name
  deployment_image_name       = var.deployment_image_name
  deployment_container_port   = var.deployment_container_port
  deployment_cpu_limit        = var.deployment_cpu_limit
  deployment_memory_limit     = var.deployment_memory_limit
  deployment_cpu_request      = var.deployment_cpu_request
  deployment_memory_request   = var.deployment_memory_request
  service_name                = var.service_name
  service_type                = var.service_type
  service_port                = var.service_port
  service_target_port         = var.service_target_port
  eks_cluster_name            = var.eks_cluster_name

  depends_on = [module.eks_cluster]

}