terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "git::https://github.com/FT-ONI/VPC-ev2.git?ref=v1.0.0"
}

module "ec2" {
  source            = "git::https://github.com/FT-ONI/computing-ev2.git?ref=v1.0.0"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.subnet_public_1_id
  security_group_id = module.vpc.sg_web_id
}

module "load_balancer" {
  source           = "git::https://github.com/FT-ONI/LB-ev2.git?ref=v1.0.0"
  sg_alb_id        = module.vpc.sg_alb_id
  public_subnets   = [module.vpc.subnet_public_1_id, module.vpc.subnet_public_2_id]
  target_group_arn = module.ec2.target_group_arn
}

module "s3" {
  source = "git::https://github.com/FT-ONI/s3-ev2.git?ref=v1.0.0"
}