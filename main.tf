 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "2.70.0"
    }
  }

  backend "s3" {
    bucket = "storage-iac-reto"
    key    = "dev/app-aws-terraform-reto.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region     = var.aws_region
}

/*
resource "aws_ecr_repository" "ecr_repo" {
  name = "ecr-repo"
}
*/


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
  name               = "ecsTaskExecutionRole-task-frontend-node"
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


/* */
resource "aws_lb_target_group" "target_group" {
  name        = "target-group-node-002"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  #depends_on = [aws_alb.application_load_balancer]  
}


resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.arn_load_balancer
  port              = "3000"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our tagrte group
  }
}

resource "aws_ecs_service" "my_first_service" {
  name            = var.name_service
  cluster         = "cluster-lab-ecs"
  task_definition = "${aws_ecs_task_definition.my_first_task.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 2 # Setting the number of containers to 3
  #depends_on = [aws_lb_listener.listener]

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" 
    container_name   = "${aws_ecs_task_definition.my_first_task.family}"
    container_port   = 3000 # Specifying the container port
  }

  network_configuration {
    subnets          = [ "subnet-08063edc21a996fb6","subnet-0470f753f16c4958a","subnet-0412b98279eccb694"]
    assign_public_ip = true   
    security_groups  = [var.security_group] 
  }
}
