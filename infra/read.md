# FlowMatrix Infrastructure (Terraform)

Provisions the AWS data lake foundation for FlowMatrix.

## What it creates
- S3 bucket `flowmatrix-lake-<account-id>`: private, versioned, encrypted (AES256)
- Medallion layers as prefixes: `bronze/` (raw), `silver/` (cleaned), `gold/` (modeled)

## Region
ap-southeast-2

## Usage
terraform init
terraform plan
terraform apply

## Notes
- No credentials or state files are committed (see .gitignore)
- Public access is fully blocked on the bucket