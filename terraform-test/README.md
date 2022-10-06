# GitHub Actions: Run Terraform Test
GitHub Action for running terraform test command.

## Usage

This action can be used as follows add latest version:

```yaml
    - name: Terraform Test
      uses: dasmeta/reusable-actions-workflows/terraform-test@0.0.8
```

## For Default Configuration in .github/workflows/check.yml you must have:
```yaml
name: Terraform Test
on:
  pull_request:
  push:
    branches: [main, master]

jobs:
  terraform-validate:
    runs-on: ubuntu-latest
    steps:
    - uses: dasmeta/reusable-actions-workflows/terraform-test@0.0.8
      with:
        aws-region: ${{ secrets.AWS_REGION}}
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

```

## Valid INPUTS


`aws-region`
Optional. 'AWS Region, e.g. us-east-2'
`Default: eu-central-1`

`aws-access-key-id:` 
Optional. AWS Access Key ID. This input is required if running in the GitHub hosted environment.

`aws-secret-access-key`
Optional. AWS Secret Access Key. This input is required if running in the GitHub hosted environment.
