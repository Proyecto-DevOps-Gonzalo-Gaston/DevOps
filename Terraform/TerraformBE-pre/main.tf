resource "aws_ecr_repository" "ecr_creation" {
  count = 4
  name  = var.ecr_names[count.index]
}