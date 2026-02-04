# **AWS EC2 Provisioning Using Terraform**

# **Step 1**

**Initialize and apply Terraform.**

```bash
terraform init
terraform apply
```


---

# Step 2

**Generate the private key.**
```bash
terraform output -raw private_key_pem > key.pem
```

# **Terraform Code**
```bash
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

```

# <img width="783" height="416" alt="image" src="https://github.com/user-attachments/assets/55e2aa2c-c664-4696-b170-a2a68694d77d" />


# <img width="1113" height="701" alt="image" src="https://github.com/user-attachments/assets/e8a8474a-504f-4d13-8b70-d983b1bfdd07" />


# <img width="943" height="874" alt="image" src="https://github.com/user-attachments/assets/e69b8cca-6c26-420b-adcd-7761c7b6fc65" />


---

# **Step 3**

**Connect to the EC2 instance.**
```bash
ssh -i key.pem ec2-user@<PUBLIC_IP>
```

# <img width="1151" height="241" alt="image" src="https://github.com/user-attachments/assets/4ed65499-18bd-4347-a7e0-d9f2fbb79c36" />


# <img width="1898" height="298" alt="image" src="https://github.com/user-attachments/assets/d81748df-c756-4116-b0a2-105637c09fd8" />


# <img width="1918" height="512" alt="image" src="https://github.com/user-attachments/assets/60fa0295-dc14-4d78-b0d5-0d00f8f3639a" />



---

# Step 4

**Install required packages.**
```bash
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo yum install -y nodejs git
```

# <img width="1909" height="420" alt="image" src="https://github.com/user-attachments/assets/a7aa62fc-548d-47fa-a2eb-78ae44e8b757" />


---

# **Step 5**

**Run Strapi.**
```bash
git clone https://github.com/strapi/strapi.git
cd strapi
npm install
npm run develop
```


# <img width="1919" height="673" alt="image" src="https://github.com/user-attachments/assets/4ebde724-de63-475f-8878-090433b13658" />


# <img width="1593" height="517" alt="image" src="https://github.com/user-attachments/assets/71df9992-eaf1-49d3-907c-5cc08bdc9141" />


# **Access to the Application**
**http://<PUBLIC_IP>:1337**


# <img width="743" height="494" alt="image" src="https://github.com/user-attachments/assets/6551b18b-09f0-44b0-89f4-d0dbc92cea59" />


<img width="997" height="536" alt="image" src="https://github.com/user-attachments/assets/501adefd-c89d-4aae-9afa-e0b91090a9c3" />


