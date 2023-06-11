# Terraform AWS EC2 CodeDeploy agent and Docker install

Terraform script to create Ec2 instance, create IAM policy and role and attach to Ec2. Script also installs Docker and CodeDeploy on EC2 instance and should display Docker version and CodeDeploy status that were installed on the EC2 instance

# Terraform AWS EC2 install Single Web Server
Creates an EC2 instance with a single busybox server

# Terraform AWS EC2
Creates an auto scaling group which ensures a number of EC2 are running and depending on the load this number increases

## Commands to run
`terraform init`
`terraform apply`
`terraform destroy`

# Terraform AWS CICD
- Creates AWS CI/CD pipeline using AWS CodeBuild, AWS CodeDeploy, AWS CodePipeline
## SecretKey
You need a SecretFile.pem to SSH into Ec2 instance. You can generate one in AWS. 
