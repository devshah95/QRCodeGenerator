provider "aws" {
  assume_role {
    role_arn = var.role
  }
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
