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