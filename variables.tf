variable "aws_region" {
    description = "the region where resources will get deployed."
    type = string
    default = "us-west-2"
    
}

variable "vpc_cidr" {
  description = "CIDR blocks for vpc"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnet_cidrs" {
  description = "cidr block for private subnet"
}