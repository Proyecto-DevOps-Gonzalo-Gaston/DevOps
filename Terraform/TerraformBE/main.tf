
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
  count             = 2
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = element(["10.0.0.0/20", "10.0.16.0/20"], count.index)
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
  vpc_id            = aws_vpc.my_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "be-devops-gg-vpce-s3"
  }
}

resource "aws_lb_target_group" "target_group" {
  count    = 4
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

resource "aws_ecs_cluster" "fargate_cluster_creation" {
  name = var.cluster_name
}

resource "aws_lb" "load_balancer" {
  count              = 4
  name               = var.load_balancers[count.index]
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnet[*].id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecr_repository" "ecr_creation" {
  count    = 4
  name     = var.ecr_names[count.index]
}

resource "aws_ecs_task_definition" "task_definitions_creation" {
  count              = 4
  family             = var.tasks_definitions[count.index]
  execution_role_arn = data.aws_iam_role.LabRole.arn
  task_role_arn      = data.aws_iam_role.LabRole.arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  container_definitions = jsonencode([
    {
      name      = var.container_definitions[count.index]
      image     = var.container_images[count.index]
      memory    = 512
      cpu       = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

/* 
resource "aws_lb_target_group_attachment" "target_attachment" {
  count            = length(var.load_balancers)
  target_group_arn = aws_lb_target_group.target_group[count.index].arn
  target_id        = 
  port             = 80
}



resource "aws_ecs_service" "my_services" { 
    count           = 4
    name            = var.services_name[count.index]
    cluster         = aws_ecs_cluster.fargate_cluster_creation.id
    task_definition = aws_ecs_task_definition.task_definitions_creation[count.index].arn
    desired_count   = 1  # Número deseado de instancias del servicio

    # Configura detalles adicionales como el balanceador de carga, roles, etc.
}
*/