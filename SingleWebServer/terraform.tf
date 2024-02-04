resource "aws_instance" "example" {
  ami                    = "ami-005f9685cb30f234b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]


  user_data                   = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF
  user_data_replace_on_change = true
  # Above line - set to true because if you change the user_data and run "apply"
  # terraform will terminate the previous instanceand create a new one
  # terraform default behaviour will try to update the original instance when "apply" is
  # entered, while the user_data only runs on the very first boot which your instance
  # already went through so if you hit apply the updates to user_data wont run
  # You need to force the creation of a new instance in order to run your new user_Data script
  tags = {
    Name = "SingleWebServer"
  }

}

resource "aws_security_group" "instance" {
  name = "terraform-WebServer-security-group"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks      = ["0.0.0.0/0", ]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }


  ingress {
    cidr_blocks      = ["0.0.0.0/0", ]
    description      = "SSH access"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }
}

variable "server_port" {
  default     = 8080
  type        = number
  description = "The port the server will use for HTTP requests"
}
output "public_ip" {
  value       = aws_instance.example.public_ip
  description = "Web Server Public IP "
}
