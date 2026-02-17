 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
  #version = "2.70.0"
  backend "s3" {
    bucket = "storage-iac-reto"
    key    = "dev/service-crud-api.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region     = var.aws_region
}

resource "aws_ecs_task_definition" "my_first_task" {
  family                   = "task-frontend-node"
  container_definitions = file("./task-definitions/service.json")
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole-${var.name_service}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group-${var.name_service}"
  port        = var.port
  protocol    = "TCP"        # 🔥 NLB usa TCP
  target_type = "ip"         # 🔥 obligatorio para Fargate
  vpc_id      = var.vpc_id

}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.arn_load_balancer  # ARN de tu NLB
  port              = var.port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}


data "aws_ecs_cluster" "cluster" {
  cluster_name = "aws-reto-cluster"
}

resource "aws_ecs_service" "my_first_service" {
  name            = var.name_service
  cluster         = data.aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.my_first_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  depends_on = [aws_lb_listener.listener]

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    #container_name   = "service-name-dentro-del-task"  # ⚠️ importante
    container_name   = "${aws_ecs_task_definition.my_first_task.family}"
    container_port   = 3000
  }

  network_configuration {
    subnets          = ["subnet-076382280f9e7ea51","subnet-005671e664ea149fc"]
    assign_public_ip = true
    security_groups  = [var.security_group]
  }
}