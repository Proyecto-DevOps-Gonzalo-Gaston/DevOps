
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the cluster."
  type        = string
}

variable "services_name" {
  description = "Name of the services"
  type        = list(string)
}

variable "tasks_definitions" {
  description = "Name of tasks definitions"
  type        = list(string)
}

variable "ecr_names" {
  description = "Name of Ecrs"
  type        = list(string)
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "target_group"{
  description = "Name of targets groups"
  type        = list(string)
}

variable "load_balancers"{
  description = "Name of loads balancers"
  type        = list(string)
}