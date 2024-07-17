resource "null_resource" "check_ecr_exists" {
  count = length(var.ecr_names)

  triggers = {
    ecr_name = var.ecr_names[count.index]
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecr describe-repositories --repository-names ${self.triggers.ecr_name} || echo "not found"
    EOT
    on_failure = continue
  }
}

resource "aws_ecr_repository" "ecr_creation" {
  count        = length(var.ecr_names)
  name         = var.ecr_names[count.index]

  depends_on = [null_resource.check_ecr_exists]

  provisioner "local-exec" {
    when    = create
    command = "echo ${var.ecr_names[count.index]} created"
  }
}