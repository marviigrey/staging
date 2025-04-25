variable "aws_region" {
  description = "the region where resources will get deployed."
  type        = string
  default     = "eu-west-2"

}

variable "vpc_cidr" {
  description = "CIDR blocks for vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "private_subnet_cidrs" {
  description = "cidr block for private subnet"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  type        = list(string)
}

variable "tags" {
  description = "a common tag to apply to all resources."
  type        = map(string)
  default = {
    "Environment" = "staging"
    "Name"        = "i-One-backend"
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ami" {
  default = "ami-0fbbcfb8985f9a341"
}

variable "ec2-bastion-public-key-path" {
  type = string
}

variable "ec2-bastion-private-key-path" {
  type = string
}

variable "frontend-public-key-path" {
  type = string
}

variable "frontend-private-key-path" {
  type = string
}