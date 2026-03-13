provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name = "web-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  instance_types = [
    "c7i-flex.large",
    "m7i-flex.large",
    "c7i-flex.large"
  ]

  root_volume_sizes = [
    40,
    50,
    40
  ]
}

resource "aws_instance" "server" {
  count         = 3
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = local.instance_types[count.index]
  key_name      = "terraform-key"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  root_block_device {
    volume_size = local.root_volume_sizes[count.index]
    volume_type = "gp3"
  }

  tags = {
    Name = "terraform-server-${count.index}"
  }
}

output "public_ips" {
  value = aws_instance.server[*].public_ip
}

output "private_ips" {
  value = aws_instance.server[*].private_ip
}
