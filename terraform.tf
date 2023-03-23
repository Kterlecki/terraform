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