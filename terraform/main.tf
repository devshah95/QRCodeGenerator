provider "aws" {
  assume_role {
    role_arn = var.role
  }
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id 
  cidr_block = "10.0.0.0/24"
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
}