# cdp-azure

This repo contains various bits to make it easier to bring up Cloudera Data Platform (CDP) Public Cloud up in Azure.

I've placed 3 modules each in its own directory as they're designed to be include-able from a common main.tf file.
We currently have:
- ADLS/  - Create the ADLS storage and logs filesystems
- VNET/ - Create the VNET structure that is needed for the CCM/Private IPs feature to work
- IAM/ - Create IAM Managed Identities as per [CDP documentation](https://docs.cloudera.com/management-console/cloud/environments-azure/topics/mc-az-minimal-setup-for-cloud-storage.html)

How to use

1. Install & Configure Terraform for your Azure account (via Azure CLI)
2. Change into the appropriate example directory (examples/full, examples/iam_only)
3. Authenticate to Azure.  For details on all your options, please visit the [official Authenticating using the Azure CLI documentation](https://www.terraform.io/docs/providers/azurerm/guides/azure_cli.html)
4. Adjust your variables.tf so that match your deployment expectation
4. Run `terraform init`
5. Run `terraform plan` to do a dry run and `terraform apply` to do the real thing

Video Instructions for module configuration
- IAM: https://youtu.be/CStOiWKmb28
- S3:  https://youtu.be/pu_Y_EpYvps
- VPC: https://youtu.be/93-qsSTSXX0

 PS: Don't forget to set up a ssh tunnel or a proxy in a bastion host so that you can access the CDP endpoints from your network.
