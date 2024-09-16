# starters-2024-terraform-cloud
Repo will contain code to manage TF Cloud projects and workspaces

## Requirements

- Terraform
- Azure CLI
- At least the "blob storage contributor"-role on the storage account where the remote state lives

## Usage instruction

- clone code from repo, `main` branch
- navigate to the folder where the code is located in the terminal
- run `az login` in terminal and select the correct Azure subscription
- if you have the correct RBAC-roles, you can run `teraform init` in terminal and Terraform will initialise successfully
- edit the existing projects/workspaces structure in main.auto.tfvars to your liking
- run `terraform apply` in terminal and enter `yes` to apply the new desired projects/workspaces structure
- navigate to your Terraform Cloud organisation in browser to check the newly applied structure