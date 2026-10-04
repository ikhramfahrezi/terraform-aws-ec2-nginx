# ======================================================
# TERRAFORM AWS EC2 + NGINX AUTOMATION TEMPLATE
# ======================================================

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ------------------------------------------------------
# 1. VARIABEL (Bisa diubah sesuai kebutuhan)
# ------------------------------------------------------
variable "aws_region" {
  description = "Region AWS yang digunakan"
  type        = string
  default     = "ap-southeast-3"
}

variable "instance_type" {
  description = "Tipe hardware server EC2"
  type        = string
  default     = "t3.micro"
}

variable "server_name" {
  description = "Nama tag untuk server EC2"
  type        = string
  default     = "terraform-web-server"
}

# ------------------------------------------------------
# 2. PROVIDER
# ------------------------------------------------------
provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------
# 3. DYNAMIC DATA SOURCE (Mencari AMI Ubuntu 24.04 LTS Terbaru)
# ------------------------------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Official Canonical Owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ------------------------------------------------------
# 4. SECURITY GROUP (Firewall Rules)
# ------------------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "${var.server_name}-sg"
  description = "Security Group - Allow SSH (Port 22) and HTTP (Port 80)"

  # Buka Akses SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Buka Akses Web HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic (Akses keluar dari server)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.server_name}-sg"
  }
}

# ------------------------------------------------------
# 5. EC2 INSTANCE RESOURCE
# ------------------------------------------------------
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  user_data_replace_on_change = true

  # Script Otomatisasi Instalasi Nginx
  user_data = <<-EOF
              #!/bin/bash
              export DEBIAN_FRONTEND=noninteractive
              apt-get update -y
              apt-get install -y nginx
              echo "<h1>Web Server Deployed via Terraform Automation</h1>" > /var/www/html/index.nginx-debian.html
              systemctl enable nginx
              systemctl restart nginx
              EOF

  tags = {
    Name = var.server_name
  }
}

# ------------------------------------------------------
# 6. OUTPUTS (Info otomatis setelah deployment)
# ------------------------------------------------------
output "public_ip" {
  description = "IP Publik Server EC2"
  value       = aws_instance.web_server.public_ip
}

output "website_url" {
  description = "URL HTTP Website"
  value       = "http://${aws_instance.web_server.public_ip}"
}