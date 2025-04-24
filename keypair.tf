
resource "tls_private_key" "ec2-bastion-host-key-pair" {
  algorithm = "RSA"
  rsa_bits = 4096
}

## Create the file for Public Key
resource "local_file" "ec2-bastion-host-public-key" {
  depends_on = [ tls_private_key.ec2-bastion-host-key-pair ]
  content = tls_private_key.ec2-bastion-host-key-pair.public_key_openssh
  filename = var.ec2-bastion-public-key-path
}

#create file for private key
resource "local_sensitive_file" "ec2-bastion-host-private-key" {
    depends_on = [ tls_private_key.ec2-bastion-host-key-pair ]
    content = tls_private_key.ec2-bastion-host-key-pair.private_key_pem
    file_permission = "0600"
    filename = var.ec2-bastion-private-key-path

}
resource "aws_key_pair" "ec2-bastion-host-key" {
  depends_on = [local_file.ec2-bastion-host-public-key]
  key_name = "ec2-bastion-key-pair"
  public_key = tls_private_key.ec2-bastion-host-key-pair.public_key_openssh
}