provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
    ami                     = "ami-005f9685cb30f234b"
    instance_type           = "t2.micro"
    key_name                = "secretKeyFile"

        
    user_data_replace_on_change = true
    tags = {
        Name = "env-stage"
    }
}