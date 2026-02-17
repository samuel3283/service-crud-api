# variables.tf | Auth and Application variables

#variable "aws_access_key" {
#  type        = string
#  description = "AWS Access Key"
#}

#variable "aws_secret_key" {
#  type        = string
#  description = "AWS Secret Key"
#}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "name_task" {
  type = string
  description = "Name Task of ECS"
}
variable "name_service" {
  type = string
  description = "Name Service of ECS"
}

variable "arn_load_balancer" {
  type        = string
  description = "Arn Load Balancer"
}


variable "security_group" {
  type = string
  description = "security_group"
}

variable "name_load_balancer" {
  type        = string
  description = "Name Load Balancer"
}

variable "port" {
  type        = string
  description = "Puerto Load Balancer"
}

variable "type_load_balancer" {
  type        = string
  description = "Type Load Balancer"
}
variable "target_group" {
  type        = string
  description = "Target Group"
}

