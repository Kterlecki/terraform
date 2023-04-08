# Terraform AWS EC2

Terraform script to create Ec2 instance, create IAM policy and role and attach to Ec2. Script also installs Docker and CodeDeploy on EC2 instance and should display Docker version and CodeDeploy status that were installed on the EC2 instance

## Commands to run
`terraform init`
`terraform apply`
`terraform destroy`


## You need a SecretFile.pem to SSH into Ec2 instance
### You can generate one in AWS