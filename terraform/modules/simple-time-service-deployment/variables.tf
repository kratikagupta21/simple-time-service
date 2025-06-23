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
  description = "service_target_port"
  default     = 5000
  type        = number
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}