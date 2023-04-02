provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami                     = "ami-005f9685cb30f234b"
    instance_type           = "t2.micro"
    key_name                = "secretKeyFile"
    iam_instance_profile    = aws_iam_instance_profile.ec2-cd-role.name
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

data "aws_iam_policy_document" "codedeploy-policy" {
    statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.us-east-1.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "code-deploy-role" {
    name = "code-deploy-role"
    assume_role_policy = data.aws_iam_policy_document.codedeploy-policy.json
}

resource "aws_iam_policy_attachment" "AmazonEC2RoleforAWSCodeDeploy" {
    name        = "AmazonEC2RoleforAWSCodeDeploy"
    policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
    roles       = [aws_iam_role.code-deploy-role.name]
}

resource "aws_iam_instance_profile" "ec2-cd-role" {
    name = "ec2-cd-role"
    role = aws_iam_role.code-deploy-role.name
}


resource "aws_codedeploy_app" "example" {
  name = "example-app"
}

resource "aws_sns_topic" "example" {
  name = "example-topic"
}

resource "aws_codedeploy_deployment_group" "example" {
  app_name              = aws_codedeploy_app.example.name
  deployment_group_name = "example-group"
  service_role_arn      = aws_iam_role.code-deploy-role.arn
  }
