variable "ecr_names" {
  description = "Name of Ecrs"
  type        = list(string)
}

variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}