resource "aws_security_group" "vpce_sg" {
  name        = "vpc-sg"
  description = "security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

}
resource "aws_vpc_security_group_ingress_rule" "vpce_sg_ingress" {
  security_group_id = aws_security_group.vpce_sg.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4         = aws_vpc.main.cidr_block
}

resource "aws_vpc_security_group_egress_rule" "vpce_sg_rule" {
  security_group_id = aws_security_group.vpce_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  tags = merge(
    var.tags,
    {
      Name = "vpce_sg_ipv4_egress"
    }
  )
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.vpce_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags = merge(
    var.tags,
    {
      Name = "vpce_sg_ipv6_egress"
    }
  )
}
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.public[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]

  tags = merge(
    var.tags,
    {
      Name = "ssm-endpoint"
    }
  )
}
resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.public[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]

  tags = merge(
    var.tags,
    {
      Name = "ec2messages-endpoint"
    }
  )
}