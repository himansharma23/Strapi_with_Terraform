provider "aws" {
  region = "ap-south-1"
}

# =========================
# Generate NEW PEM key
# =========================
resource "tls_private_key" "strapi_key_v3" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# =========================
# Create NEW AWS Key Pair
# =========================
resource "aws_key_pair" "strapi_keypair_v3" {
  key_name   = "strapi-key-v3"
  public_key = tls_private_key.strapi_key_v3.public_key_openssh
}

# =========================
# NEW Security Group
# =========================
resource "aws_security_group" "strapi_sg_v3" {
  name        = "strapi-sg-v3"
  description = "Allow SSH and Strapi access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
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

# =========================
# NEW EC2 Instance (t3.micro)
# =========================
resource "aws_instance" "strapi_ec2_v3" {
  ami                    = "ami-0ff5003538b60d5ec"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.strapi_keypair_v3.key_name
  vpc_security_group_ids = [aws_security_group.strapi_sg_v3.id]

  tags = {
    Name = "Strapi-EC2-T3"
  }
}

# =========================
# Outputs
# =========================
output "public_ip_v3" {
  value = aws_instance.strapi_ec2_v3.public_ip
}

output "private_key_pem_v3" {
  value     = tls_private_key.strapi_key_v3.private_key_pem
  sensitive = true
}
