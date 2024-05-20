# 3-tier-app-with-terraform

In this repository, we have the Terraform code which creates an innfrastructure on AWS that support a Three-Tier application.

## Problem Statement

Infrastructure setup using Terraform - Use Terraform to provision the following resources:

1) Virtual Machines (EC2 instances on AWS) for the front-end and back-end tiers.
2) A managed database service (RDS on AWS) for the database tier.
3) Configure appropriate security groups and network settings to allow communication between tiers.
4) Create any necessary networking components such as a Virtual Private Cloud (VPC) using Terraform.
5) Utilize the respective cloud platform's Key Vault service to securely store any sensitive information such as database passwords.

### Pre requisites

1) Please make sure to do the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configuration on your system
2) Active AWS account.

### Folder Structure

![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/51a76f12-e4ae-4eaf-9636-573eb31dd9a4)

# Code Walkthrough

In this section, we will explain the usage of each and every Terraform file that we have used.

## Root folder

The root folder consists of 3 files

![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/b9fef510-d039-4d79-915f-41cc9376cce5)

### main.tf

This Terraform configuration defines an AWS infrastructure using modules to create a Virtual Private Cloud (VPC), EC2 instances for frontend and backend services, an RDS database instance, and manages a secret in AWS Secrets Manager. Let's break down the main components:

**Provider Configuration:**

It specifies that Terraform should use the AWS provider and sets the region to us-west-2.

**VPC Module:**

It uses a custom module located in ./modules/vpc to create a VPC. No specific configurations are provided in this snippet.

**Frontend EC2 Module:**

It uses a custom module located in ./modules/ec2 to create an EC2 instance for the frontend service.
It specifies the instance type as t2.micro, the Amazon Machine Image (AMI) to use, the subnet ID from the VPC module for the public subnet, and the security group ID for the frontend service.

**Backend EC2 Module:**

Similar to the frontend module but creates an EC2 instance for the backend service using a different subnet and security group.

**RDS Module:**

It uses a custom module located in ./modules/rds to create an RDS database instance.
It specifies the subnet IDs from the VPC module for the private subnets, the security group ID for the database, the database username, and the database password.

**AWS Secrets Manager:**

It creates a secret named rds_db_password in AWS Secrets Manager.
It defines a secret version for the password using aws_secretsmanager_secret_version.
The secret's password is set to "my-secure-password".
This configuration creates a basic AWS infrastructure with networking, compute instances, a database, and manages a secret for the database password

### variables.tf

This Terraform configuration defines a variable named region with a default value of "us-west-2". This variable can be used throughout the Terraform configuration to reference the AWS region where the resources will be provisioned.

### outputs.tf

This Terraform configuration defines outputs for various resources created in the infrastructure. These outputs allow you to retrieve important information about these resources after they have been created. Here's a breakdown of each output:

1. **VPC ID Output**:
   - It defines an output named `vpc_id` that retrieves the VPC ID from the VPC module (`module.vpc.vpc_id`).
   - This output can be used to access the VPC ID from other parts of the Terraform configuration or to display it after the infrastructure has been created.

2. **Frontend EC2 ID Output**:
   - It defines an output named `frontend_ec2_id` that retrieves the EC2 instance ID for the frontend service from the frontend EC2 module (`module.frontend_ec2.instance_id`).
   - This output can be used to access the frontend EC2 instance ID from other parts of the Terraform configuration or to display it after the infrastructure has been created.

3. **Backend EC2 ID Output**:
   - Similar to the frontend output, this defines an output named `backend_ec2_id` that retrieves the EC2 instance ID for the backend service from the backend EC2 module (`module.backend_ec2.instance_id`).

4. **RDS Endpoint Output**:
   - It defines an output named `rds_endpoint` that retrieves the endpoint (connection string) for the RDS database from the RDS module (`module.rds.endpoint`).
   - This output can be used to access the RDS database endpoint from other parts of the Terraform configuration or to display it after the infrastructure has been created.

These outputs provide a way to easily retrieve important information about the infrastructure, such as VPC ID, EC2 instance IDs, and database endpoints, which can be useful for further configuration or troubleshooting.

## modules/ec2 folder

![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/883dd594-b908-4c2c-92d8-a80a018ba773)

### main.tf

This Terraform configuration defines an AWS EC2 instance resource named `ec2_instance`. It uses several variables to customize the instance's configuration:

1. **`ami`** (`var.ami`):
   - The AMI (Amazon Machine Image) to use for the EC2 instance. This is the base image for the instance.
   - This value is expected to be provided through a variable (`var.ami`).

2. **`instance_type`** (`var.instance_type`):
   - The EC2 instance type, which defines the virtual hardware of the instance (e.g., CPU, memory, storage).
   - This value is expected to be provided through a variable (`var.instance_type`).

3. **`subnet_id`** (`var.subnet_id`):
   - The ID of the subnet in which to launch the EC2 instance.
   - This value is expected to be provided through a variable (`var.subnet_id`).

4. **`security_groups`** (`var.security_group_ids`):
   - A list of security group IDs to associate with the EC2 instance. Security groups control inbound and outbound traffic for the instance.
   - This value is expected to be provided through a variable (`var.security_group_ids`).

This resource configuration allows you to launch an EC2 instance with a specified AMI, instance type, subnet, and security groups, making it flexible and customizable based on your needs.

### outputs.tf

This Terraform configuration defines an output named `instance_id` that retrieves the ID of the AWS EC2 instance created earlier in the Terraform configuration (`aws_instance.ec2_instance.id`). The `aws_instance.ec2_instance.id` refers to the ID attribute of the `aws_instance` resource with the identifier `ec2_instance`.

This output allows you to retrieve the instance ID after the EC2 instance has been created. The instance ID can be used to reference or manage the EC2 instance in other parts of your infrastructure or configuration.

### variables.tf

This Terraform configuration defines several variables that can be used to customize the configuration of an AWS EC2 instance:

1. **`ami`**: 
   - This variable does not have a specified type, so it can accept any value.
   - It is intended to store the ID of the Amazon Machine Image (AMI) to use for the EC2 instance.

2. **`instance_type`**: 
   - This variable does not have a specified type, so it can accept any value.
   - It is intended to store the type of EC2 instance to launch, which specifies the virtual hardware characteristics of the instance (e.g., CPU, memory, storage).

3. **`subnet_id`**: 
   - This variable does not have a specified type, so it can accept any value.
   - It is intended to store the ID of the subnet in which to launch the EC2 instance.

4. **`security_group_ids`**: 
   - This variable is of type `list(string)`, meaning it expects a list of string values.
   - It is intended to store a list of security group IDs to associate with the EC2 instance. Security groups control inbound and outbound traffic for the instance.

These variables provide a way to parameterize the EC2 instance configuration, allowing you to easily customize the AMI, instance type, subnet, and security groups used for the instance without modifying the main Terraform configuration.

## modules/rds folder

![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/d0efd3fb-753c-4715-bce8-2d37e8b53d79)

### main.tf

This Terraform configuration defines two AWS resources: an RDS subnet group (`aws_db_subnet_group`) and an RDS database instance (`aws_db_instance`).

1. **RDS Subnet Group Resource** (`aws_db_subnet_group.main`):
   - Creates an RDS subnet group named "main-subnet-group" with the specified subnet IDs (`var.subnet_ids`).
   - This subnet group is used to define the subnets where the RDS instances will be deployed. It ensures that the RDS instances are deployed in these specific subnets.

2. **RDS Instance Resource** (`aws_db_instance.main`):
   - Creates an RDS database instance with the identifier "main-db".
   - The database engine is MySQL (`engine = "mysql"`).
   - The instance class is `db.t3.micro`, which specifies the compute and memory capacity of the instance.
   - The allocated storage for the database is 20 GB (`allocated_storage = 20`).
   - It is associated with the RDS subnet group created earlier (`db_subnet_group_name = aws_db_subnet_group.main.name`).
   - The security group IDs (`vpc_security_group_ids`) that control inbound and outbound traffic to the RDS instance are specified in the `var.security_group_id` variable.
   - The database is configured with a username (`var.db_username`) and password (`var.db_password`) for authentication.
   - `skip_final_snapshot` is set to true, which means that no final DB snapshot is created when the RDS instance is deleted.

### outputs.tf

This Terraform configuration defines an output named `endpoint` that retrieves the endpoint (connection string) of the RDS database instance created earlier (`aws_db_instance.main.endpoint`). The `aws_db_instance.main.endpoint` refers to the endpoint attribute of the `aws_db_instance` resource with the identifier `main`.

This output allows you to retrieve the database endpoint after the RDS instance has been created. The endpoint can be used to connect to the database from other applications or services.

### variables.tf

This Terraform configuration defines several variables that can be used to parameterize the AWS resources created in the Terraform configuration:

1. **`subnet_ids`**:
   - This variable is of type `list(string)`, meaning it expects a list of string values.
   - It is intended to store the IDs of the subnets where the RDS instance will be deployed.
   - Example usage: `subnet_ids = ["subnet-12345", "subnet-67890"]`

2. **`security_group_id`**:
   - This variable does not have a specified type, so it can accept any value.
   - It is intended to store the ID of the security group that controls inbound and outbound traffic to the RDS instance.
   - Example usage: `security_group_id = "sg-123456"`

3. **`db_username`**:
   - This variable does not have a specified type, so it can accept any value.
   - It is intended to store the username for accessing the RDS database.
   - Example usage: `db_username = "myusername"`

4. **`db_password`**:
   - This variable does not have a specified type, so it can accept any value.
   - It is intended to store the password for accessing the RDS database.
   - Example usage: `db_password = "mypassword"`

These variables allow you to customize the configuration of the AWS resources, such as specifying different subnets, security groups, and authentication credentials, without modifying the main Terraform configuration.

## modules/vpc folder

![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/a635109c-4ec8-47b3-b107-422d3fe959a1)

### main.tf

This Terraform configuration defines several AWS resources for setting up a VPC (Virtual Private Cloud) with public and private subnets, along with corresponding security groups for a hypothetical application with frontend, backend, and database components. Let's break down each resource:

1. **VPC Resource** (`aws_vpc.main`):
   - Creates a VPC with the CIDR block `10.0.0.0/16`.

2. **Public Subnet Resources** (`aws_subnet.public`):
   - Creates two public subnets (`count = 2`) within the VPC.
   - Each subnet has a CIDR block in the range `10.0.0.0/24` and `10.0.1.0/24`.
   - Each subnet allows instances to have public IP addresses (`map_public_ip_on_launch = true`).
   - Subnets are spread across two availability zones (`us-west-2a` and `us-west-2b`).

3. **Private Subnet Resources** (`aws_subnet.private`):
   - Similar to public subnets, but creates two private subnets (`count = 2`) with CIDR blocks `10.0.2.0/24` and `10.0.3.0/24`.

4. **Security Group for Frontend** (`aws_security_group.frontend_sg`):
   - Creates a security group for the frontend instances within the VPC.
   - Allows inbound traffic on port 80 (HTTP) from anywhere (`0.0.0.0/0`).
   - Allows all outbound traffic.

5. **Security Group for Backend** (`aws_security_group.backend_sg`):
   - Creates a security group for the backend instances within the VPC.
   - Allows inbound traffic on port 8080 from the VPC CIDR block (`10.0.0.0/16`).
   - Allows all outbound traffic.

6. **Security Group for Database** (`aws_security_group.database_sg`):
   - Creates a security group for the database instances within the VPC.
   - Allows inbound traffic on port 3306 (MySQL) from the VPC CIDR block (`10.0.0.0/16`).
   - Allows all outbound traffic.

This configuration sets up a basic networking environment for a multi-tier application, with public subnets for frontend components, private subnets for backend components, and appropriate security groups to control traffic flow.

### outputs.tf

This Terraform configuration defines outputs for various AWS resources, allowing you to retrieve important information about these resources after they have been created. Here's an explanation of each output:

1. **VPC ID Output**:
   - It defines an output named `vpc_id` that retrieves the ID of the main VPC (`aws_vpc.main.id`).
   - This output can be used to access the VPC ID from other parts of the Terraform configuration or to display it after the VPC has been created.

2. **Public Subnet IDs Output**:
   - It defines an output named `public_subnet_ids` that retrieves the IDs of all the public subnets (`aws_subnet.public[*].id`).
   - This output uses the splat operator `[*]` to retrieve all the IDs as a list.
   - This output can be used to access the public subnet IDs from other parts of the Terraform configuration or to display them after the subnets have been created.

3. **Private Subnet IDs Output**:
   - Similar to the public subnet output, this defines an output named `private_subnet_ids` that retrieves the IDs of all the private subnets (`aws_subnet.private[*].id`).

4. **Frontend Security Group ID Output**:
   - It defines an output named `frontend_sg_id` that retrieves the ID of the security group for the frontend service (`aws_security_group.frontend_sg.id`).

5. **Backend Security Group ID Output**:
   - Similar to the frontend security group output, this defines an output named `backend_sg_id` that retrieves the ID of the security group for the backend service (`aws_security_group.backend_sg.id`).

6. **Database Security Group ID Output**:
   - It defines an output named `database_sg_id` that retrieves the ID of the security group for the database (`aws_security_group.database_sg.id`).

These outputs provide a way to easily retrieve important information about the AWS resources, such as VPC ID, subnet IDs, and security group IDs, which can be useful for further configuration or troubleshooting.

### variables.tf

This Terraform configuration defines a variable named region with a default value of "us-west-2". 

# Resulting infra on AWS

## AWS Secrets Manager
![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/e3a91ff4-4d08-4aa2-b807-16fd4c87dad8)

## EC2 Instances
![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/30c3956b-be7d-4470-8839-1fb6d79d362e)

## RDS
![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/bb0e9d81-7f04-41a0-8d4b-96a7fb8d747e)

## VPC
![image](https://github.com/logicopslab/3-tier-app-with-terraform/assets/82759985/4ffcad45-fa78-4cea-af8f-fab766ea2431)


# aws folder

It contains a file called as buildspec.yml

This build specification sets up a CodeBuild project to:

Install Terraform.
Verify AWS credentials.
Initialize and apply a Terraform configuration.
Package all files in the build directory as build artifacts.
This process is automated through the build phases, ensuring that the necessary steps are performed in sequence to provision the desired infrastructure using Terraform.
