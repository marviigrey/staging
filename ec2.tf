  resource "aws_instance" "backend" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Backend Server</h1>" > /var/www/html/index.html
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
