
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(["10.0.0.0/20", "10.0.16.0/20"], count.index)
  availability_zone = element(["us-east-1a", "us-east-1b"], count.index)
  tags = {
    Name = "be-devops-gg-subnet-public${count.index + 1}-us-east-1${element(["a", "b"], count.index)}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "be-devops-gg-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "be-devops-gg-rtb-public"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.my_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "be-devops-gg-vpce-s3"
  }
}

resource "aws_lb_target_group" "target_group" {
  count = 4
  name     = var.target_group[count.index]
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  target_type = "ip"

  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

//esta parte esta bien
resource "aws_ecs_cluster" "fargate_cluster_creation" {
  name               = var.cluster_name
}
/* 

resource "aws_lb" "load_balancer" {
  count             = 4
  name              = var.load_balancers[count.index]
  internal          = false
//load_balancer_type = "application"  no se si es application o otro
//security_groups = Crear un security o especificar que onda
  subnets           = aws_subnet.public_subnet[*].id
  vpc_id          = aws_vpc.my_vpc.id  
}

//Cuando lo de arriba este hecho, esto es para juntar los load balancers con los target groups (no se si esta bien, falta revision)
resource "aws_lb_target_group_attachment" "target_attachment" {
  count             = length(var.target_group) * length(var.load_balancers)
  target_group_arn  = aws_lb_target_group.target_group[count.index / length(var.load_balancers)].arn
  target_id         = aws_lb.load_balancer[count.index % length(var.load_balancers)].arn
}




//falta revisar aqui.

resource "aws_ecr_repository" "ecr_creation" {
  for_each = toset(var.ecr_names)
  name     = each.value #Agregar imagenes a cada uno con CICD  Aqui pide ya la imagen url de un container. lo cual necesito entender del DEVOPS procesop ara esto:D
}

resource "aws_ecs_task_definition" "task_definitions_creation" {  
    count = 4
    family                   = var.tasks_definitions[count.index]
    execution_role_arn       = aws_iam_role.labrole.arn
    task_role_arn            = aws_iam_role.labrole.arn
    network_mode             = "awsvpc"
    cpu                      = 256
    memory                   = 512
    container_definitions   = jsonencode([
    {
      name   = toset(each.value) #Terminar ,
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