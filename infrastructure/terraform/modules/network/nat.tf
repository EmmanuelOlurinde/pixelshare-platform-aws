resource "aws_eip" "nat_eip" {
  vpc  = true
  tags = { Name = "${var.project_name}-nat-eip" }
}

resource "aws_nat_gateway" "natgw" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat_eip.id
  tags = { Name = "${var.project_name}-natgw" }
}
