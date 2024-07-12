resource "aws_vpc" "vpc_creation"{
  cidr_block       = "10.0.0.0/16" 
  instance_tenancy = "default"    
  enable_dns_support = true        
  enable_dns_hostnames = true       
  tags = {
    Name = var.vpc_name 
  }
}



resource "aws_ecs_cluster" "fargate_cluster_creation" {
  name               = var.cluster_name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecr_repository" "ecr_creation" {
  for_each = toset(var.ecr_names)
  name     = each.value #Agregar imagenes a cada uno con CICD
}

/*
resource "aws_ecs_task_definition" "task_definitions_creation" {  
    for_each = aws_ecr_repository.4_ecr_creation

    family                   = toset(var.tasks_definitions)
    execution_role_arn       = aws_iam_role.labrole.arn
    task_role_arn            = aws_iam_role.labrole.arn
    network_mode             = "awsvpc"
    cpu                      = 256
    memory                   = 512
    container_definitions   = jsonencode([
    {
      name   = toset(each.value) #Terminar
      image  = "nginx:latest" #Terminar
      memory = 256
      cpu    = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "my_services" { 
    for_each = toset(var.services_name)
    name = each.key
    cluster         = aws_ecs_cluster.fargate_cluster_creation.id
    task_definition = aws_ecs_task_definition.4_task_definitions_creation.arn
    desired_count   = 1  # Número deseado de instancias del servicio

    # Configura detalles adicionales como el balanceador de carga, roles, etc.
}

*/