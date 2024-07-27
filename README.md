Overview
The project involves deploying a QR code generator application using AWS ECS with Fargate, Terraform, Docker, and GitHub Actions. The application consists of a frontend built with React and a backend built with FastAPI. The deployment leverages AWS infrastructure, including VPCs, subnets, security groups, and an Application Load Balancer (ALB).
Components
Frontend

- **Framework**: React
- **Docker Image**: devshah95/aws-infrastructure-project-frontend:latest
- **Port**: 3000
- **Environment Variable**: REACT_APP_BACKEND_URL

Backend

- **Framework**: FastAPI
- **Docker Image**: devshah95/aws-infrastructure-project-backend:latest
- **Port**: 8000
- **Endpoint**: /generate_qr/

Infrastructure
VPC and Subnets

- A VPC with a CIDR block of 10.0.0.0/16.
- Two public subnets in different availability zones.

Internet Gateway and Route Tables

- An internet gateway attached to the VPC.
- Route tables configured to route internet traffic to the internet gateway.

Security Groups

- **ALB Security Group**: Allows inbound HTTP (80) and HTTPS (443) traffic.
- **ECS Security Group**: Allows all inbound and outbound traffic within the VPC.

Application Load Balancer
An ALB that distributes traffic to the frontend and backend target groups.
Target Groups

- **Frontend Target Group**: Listens on port 3000.
- **Backend Target Group**: Listens on port 8000.

IAM Roles

- **Task Execution Role**: Allows ECS tasks to make AWS API calls.
- **Task Role**: Allows ECS tasks to interact with AWS services for execute command functionality.

CloudWatch Log Groups

- Log groups for both frontend and backend to capture application logs.

ECS Configuration
ECS Cluster
An ECS cluster named QRCode-Cluster.
Task Definition

- **Task Family**: qr-code-task
- **Network Mode**: awsvpc
- **CPU and Memory**: 512 CPU units and 1024 MiB of memory.
- **Containers**:
  - **Frontend**: Configured to communicate with the backend using an environment variable.
  - **Backend**: Exposes the /generate_qr/ endpoint.

ECS Service

- Deploys the task definition with a desired count of 1.
- Configured with load balancers to distribute traffic to the frontend and backend containers.

Deployment
Terraform
Infrastructure is defined using Terraform scripts and deployed using the terraform apply command.
GitHub Actions

A CI/CD pipeline defined in deploy.yaml automates the deployment process.

- Workflow steps:
  - Checkout the code.
  - Configure AWS credentials.
  - Initialize and apply Terraform configuration.

Frontend Code (React)

- Allows users to input text or URLs to generate QR codes.
- Sends requests to the backend endpoint /generate_qr/ to create QR codes.

Backend Code (FastAPI)

- Defines a FastAPI application to handle QR code generation requests.
- Accepts POST requests at /generate_qr/ and returns a PNG image of the generated QR code.

Key Points

- **AWS Fargate** is used to run containers without managing EC2 instances.
- **Application Load Balancer (ALB)** is used to distribute incoming traffic to the appropriate containers.
- **Terraform** is used for Infrastructure as Code (IaC) to define and provision the necessary AWS resources.
- **GitHub Actions** automates the deployment process, ensuring continuous integration and continuous deployment (CI/CD).

Challenges Addressed

- Ensuring that the frontend can communicate with the backend within the ECS cluster.
- Proper configuration of security groups to allow necessary communication between services.
- Using environment variables to dynamically configure the frontend with the backend URL.
