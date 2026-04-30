data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_a.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y docker git
    systemctl enable --now docker
    usermod -aG docker ec2-user

    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    mkdir -p /opt/pixelshare
    cd /opt/pixelshare

    cat << 'EOC' > docker-compose.yml
    services:
      api:
        image: 933196964255.dkr.ecr.us-east-1.amazonaws.com/pixelshare-app:latest
        container_name: pixelshare-app
        ports:
          - "80:5000"
        restart: always
        healthcheck:
          test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
          interval: 30s
          timeout: 10s
          retries: 3
          start_period: 40s
    EOC

    docker-compose up -d
  EOF

  tags = { Name = "${var.project_name}-web" }
}

resource "aws_lb_target_group_attachment" "web_attach" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}
