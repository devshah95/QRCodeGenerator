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
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Temporarily allow from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "frontend_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "frontend_to_backend" {
  type = "egress"
  from_port = 8000
  to_port = 8000
  protocol = "tcp"
  security_group_id = aws_security_group.frontend_sg.id
  source_security_group_id = aws_security_group.backend_sg.id

  depends_on = [aws_security_group.backend_sg]
}

resource "aws_security_group_rule" "backend_from_frontend" {
  type = "ingress"
  from_port = 8000
  to_port = 8000
  protocol = "tcp"
  security_group_id = aws_security_group.backend_sg.id
  source_security_group_id = aws_security_group.frontend_sg.id

  depends_on = [aws_security_group.frontend_sg]
}

resource "aws_alb" "main_alb" {
  name = "my-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.frontend_sg.id]
  subnets = [aws_subnet.public.id]
}

resource "aws_alb_target_group" "frontend" {
  name = "frontend-targets"
  port = 3000
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}

resource "aws_alb_listener" "frontend" {
  load_balancer_arn = aws_alb.main_alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.frontend.arn
  }
}