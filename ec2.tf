  resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.ec2-bastion-host-key.key_name
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              snap install amazon-ssm-agent --classic
              systemctl enable --now snap.amazon-ssm-agent.amazon-ssm-agent
              EOF

  tags = {
    Name = "backend-server"
  }
}
resource "aws_security_group" "backend_sg" {
  name = "backend-sg"
  vpc_id = aws_vpc.main.id
  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "backend-sg" {
  ip_protocol = "tcp"
  from_port = 8080
  to_port = 8080
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4 = var.vpc_cidr

}
resource "aws_vpc_security_group_ingress_rule" "backend_sg_ssh" {
  ip_protocol        = "tcp"
  from_port          = 22
  to_port            = 22
  security_group_id  = aws_security_group.backend_sg.id
  cidr_ipv4          = "${aws_instance.backend.private_ip}/32"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}
