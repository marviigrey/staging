resource "aws_route_table" "public" {
  vpc_id =aws_vpc.main.id
   
  tags  = merge(
    var.tags,
    {
        Name = "i-one-route"
    }
  )
}
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags  = merge(
    var.tags,
    {
        Name = "i-one-route"
    }
  )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
data "aws_availability_zones" "available" {}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
