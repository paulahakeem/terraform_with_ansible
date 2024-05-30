# Terraform with Ansible
Create two EC2 machines using Terraform, set up a load balancer for them, and run the Ansible playbook that installs MySQL and WordPress on both of them at the same time.

# Prerequisites
- Terraform
- Ansible
- AWS account

- The file `/ansible/variables.yaml` should define the following variables:
    ```yaml
    region: <AWS-REGION>
    access_key: <AWS-ACCESS-KEY-ID>
    secret_key: <AWS-SECRET-ACCESS-KEY>

    mysql_root_password: <MYSQL-ROOT-PASSWORD>
    mysql_db: <MYSQL-DB-NAME>
    mysql_user: <MYSQL-DB-USER>
    mysql_password: <MYSQL-DB-PASSWORD>
    db_host: <db_ip>
    github_token: <github_token>
    github_repo_url: <github_url>
    ```

# Usage
1. Clone the repository
    ```bash
    git clone https://github.com/paulahakeem/terraform_with_ansible
    cd terraform_with_ansible
    ```
2. Run the following commands to create the EC2 instances and install MySQL and WordPress on them:
    ```bash
    cd terraform
    terraform init
    terraform apply
    ```

# Terraform Configuration
The `terraform/main.tf` file is configured to manage the entire infrastructure for this project. It uses Terraform modules to ensure a modular and reusable approach. This means you can configure and manage various aspects of the project, such as creating EC2 instances, setting up networking, and other AWS resources, all within the `main.tf` file. Additionally, a load balancer is set up to distribute traffic between the two EC2 machines, ensuring high availability and reliability for the deployed applications. The use of modules allows for a clean and organized structure, making it easier to extend and maintain the infrastructure as needed.
