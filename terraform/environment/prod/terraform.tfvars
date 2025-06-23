environment                                     = "prod"
region                                          = "ap-south-1"
cidr                                            = "10.102.0.0/16"
availability_zones                              = ["ap-south-1a", "ap-south-1b"]
private_subnets                                 = ["10.102.0.0/24", "10.102.32.0/24"]
public_subnets                                  = ["10.102.16.0/24", "10.102.48.0/24"]


##########################variable for VPC######################
vpc_name                                        = "eks-vpc"

##########################variable for EKS######################
eks_cluster_role_name                           = "eks-cluster-role"
eks_cluster_name                                = "eks-cluster"
eks_cluster_version                             = "1.31"
eks_cluster_endpoint_private_access             = false
eks_cluster_endpoint_public_access              = true
eks_instance_types                              = ["t3.medium"]
eks_disk_size                                   = "100"
eks_cluster_desired_size                        = 2
eks_cluster_max_size                            = 2
eks_cluster_min_size                            = 2
eks_cluster_max_unavailable                     = 1
eks_node_group_sg                               = "eks-node-group-sg"
eks_key_pair_name                               = "eks-node-group-keypair2"

##########################variable for simple-time-service######################

deployment_name                                 = "simple-time-service"
deployment_namespace                            = "default"
deployment_label                                = "time-service"
deployment_replicas                             = 1
deployment_container_name                       = "time-service"
deployment_image_name                           = "kratikagupta/simpletimeservice"
deployment_container_port                       = 5000
deployment_cpu_limit                            = "250m"
deployment_memory_limit                         = "256Mi"
deployment_cpu_request                          = "100m"
deployment_memory_request                       = "128Mi"
service_name                                    = "time-service"
service_type                                    = "LoadBalancer"
service_port                                    = 5000
service_target_port                             = 5000

