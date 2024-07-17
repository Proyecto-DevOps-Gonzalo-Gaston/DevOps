
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
    protocol    = "tcp"
    self        = true
    from_port   = 0
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    self        = true
    from_port   = 0
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "task_definitions_creation" {
  count              = 3
  family             = var.tasks_definitions[count.index]
  execution_role_arn = data.aws_iam_role.LabRole.arn
  task_role_arn      = data.aws_iam_role.LabRole.arn
  network_mode       = "awsvpc"
  container_definitions = jsonencode([
    {
      name  = var.container_definitions[count.index]
      image = var.container_images[count.index]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      essential        = true
      environment      = []
      environmentFiles = []
      mountPoints      = []
      volumesFrom      = []
      ulimits          = []
    }
  ])
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  depends_on = [
    aws_lb.load_balancer
  ]
}

resource "aws_ecs_task_definition" "task_definitions_creation_orders" {
  family             = var.tasks_definitions[3]
  execution_role_arn = data.aws_iam_role.LabRole.arn
  task_role_arn      = data.aws_iam_role.LabRole.arn
  network_mode       = "awsvpc"
  container_definitions = jsonencode([
    {
      name  = var.container_definitions[3]
      image = var.container_images[3]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      essential = true
      environment = [
        {
          name  = "APP_ARGS"
          value = "http://${aws_lb.load_balancer[1].dns_name}:8080 http://${aws_lb.load_balancer[2].dns_name}:8080 http://${aws_lb.load_balancer[3].dns_name}:8080"
        }
      ]
      environmentFiles = []
      mountPoints      = []
      volumesFrom      = []
      ulimits          = []
    }
  ])
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  depends_on = [
    aws_lb.load_balancer
  ]
}

resource "aws_lb_listener" "front_end" {
  count             = 4
  load_balancer_arn = aws_lb.load_balancer[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group[count.index].arn
  }
}

resource "aws_ecs_service" "my_services" {
  count           = 3
  name            = var.services_name[count.index]
  cluster         = aws_ecs_cluster.fargate_cluster_creation.id
  task_definition = aws_ecs_task_definition.task_definitions_creation[count.index].arn
  launch_type     = "FARGATE"
  desired_count   = 1 # Número deseado de instancias del servicio
  network_configuration {
    subnets          = aws_subnet.public_subnet[*].id
    security_groups  = [aws_default_security_group.default.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group[count.index].arn
    container_name   = var.container_definitions[count.index]
    container_port   = 8080
  }
  # Configura detalles adicionales como el balanceador de carga, roles, etc.
}

resource "aws_ecs_service" "my_services_orders" {
  name            = var.services_name[3]
  cluster         = aws_ecs_cluster.fargate_cluster_creation.id
  task_definition = aws_ecs_task_definition.task_definitions_creation_orders.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    subnets          = aws_subnet.public_subnet[*].id
    security_groups  = [aws_default_security_group.default.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group[3].arn
    container_name   = var.container_definitions[3]
    container_port   = 8080
  }
}

resource "aws_ecr_repository" "ecr_creation" {
  count = 4
  name  = var.ecr_names[count.index]
}