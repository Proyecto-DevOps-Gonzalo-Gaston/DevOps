
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the cluster. Must be Unique across AWS"
  type        = string
}

variable "services_name" {
  description = "Name of the services. Must be Unique across AWS"
  type        = list(string)
}

variable "tasks_definitions" {
  description = "Name of the tasks definitions. Must be Unique across AWS"
  type        = list(string)
}

variable "ecr_names" {
  description = "Region in which AWS Resources to be created"
  type        = list(string)
}

variable "vpc_name" {
  description = "Region in which AWS Resources to be created"
  type        = string
}
