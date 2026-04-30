resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  iam_instance_profile = var.instance_profile

  tags = {
    Name = "${var.project_name}-app"
  }
}

