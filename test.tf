provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami                     = "ami-005f9685cb30f234b"
    instance_type           = "t2.micro"
    key_name                = "secretKeyFile"

    security_groups  = [aws_security_group.http_access.name]


    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install docker -y
                sudo usermod -aG docker ec2-user
                sudo service docker start
                sudo yum install ruby -y
                sudo yum install wget
                wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
                chmod +x ./install
                sudo ./install auto
                sudo service codedeploy-agent status
                EOF

    
    user_data_replace_on_change = true
    tags = {
        Name = "env-stage"
    }
}

resource "aws_security_group" "http_access" {
    name        = "http_access"
    description = "Allow HTTP inbound traffic"
    egress  {
            cidr_blocks         = [ "0.0.0.0/0", ]
            description         = ""
            from_port           = 0
            ipv6_cidr_blocks    = []
            prefix_list_ids     = []
            protocol            = "-1"
            security_groups     = []
            self                = false
            to_port             = 0
        }
    
    ingress  {
        description = "HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]    
    }
    
    ingress {
            cidr_blocks         = [ "0.0.0.0/0", ]
            description         = "SSH access"
            from_port           = 22
            ipv6_cidr_blocks    = []
            prefix_list_ids     = []
            protocol            = "tcp"
            security_groups     = []
            self                = false
            to_port             = 22
        }
    
}

resource "null_resource" "check_docker_version" {
    depends_on = [aws_instance.example]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./secretKeyFile.pem")
        host        = aws_instance.example.public_ip
        timeout     = "3m"
    }

    provisioner "remote-exec" {
        inline = [
            "docker version"
        ]
    }
}



