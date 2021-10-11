provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_code
      Manager     = var.project_mgr
    }
  }
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_code" {
  type    = string
  default = "ecs-demo"
}

variable "project_mgr" {
  type    = string
  default = "Dinesh Kishor"
}

################

variable "vpc_cidr" {
  type    = string
  default = "192.168.100.0/24"
}

variable "pub_subnet_a_cidr" {
  type    = string
  default = "192.168.100.0/26"
}

variable "pub_subnet_c_cidr" {
  type    = string
  default = "192.168.100.64/26"
}

variable "priv_subnet_a_cidr" {
  type    = string
  default = "192.168.100.128/26"
}

variable "priv_subnet_c_cidr" {
  type    = string
  default = "192.168.100.192/26"
}

variable "aws_key_pair_name" {
  type    = string
  default = "dev-test"
}

variable "instance_types" {
  description = "instance types"

  default = {
    ec2 = "t2.micro"
  }
}

variable "ec2_amis" {
  description = "ec2 ami ids"

  default = {
    ecs = "ami-002eb9d0092f20557"
  }
}

variable "ec2_vol_size" {
  default = "8"
}