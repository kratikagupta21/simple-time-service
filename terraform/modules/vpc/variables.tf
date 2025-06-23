variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
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

variable "availability_zones" {
  description = "List of availability zones"
}

variable "public_subnet_ids" {
  type    = list(string)
  default = null
}

variable "private_subnet_ids" {
  type    = list(string)
  default = null
}
