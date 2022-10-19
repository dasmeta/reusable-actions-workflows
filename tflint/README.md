# GitHub Actions: Run Tflint
GitHub Action for running tflint.

## Usage

This action can be used as follows add latest version:

```yaml
    - name: Tflint
      uses: dasmeta/reusable-actions-workflows/tflint@main
```

## For Default Configuration in .github/workflows/xxx.yml you must have:
```yaml
name: Tflint
on:
  pull_request:
  push:
    branches: [main, master]

jobs:
  terraform-validate:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        path:
          - dashboard
          - billing
    permissions: write-all
    steps:
    - uses: dasmeta/reusable-actions-workflows/tflint@main
      with:
        aws-region: ${{ secrets.AWS_REGION}}
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        path: modules/${{ matrix.path }}  
        repo-token: ${{ secrets.GITHUB_TOKEN }}

```

## Valid INPUTS


`aws-region`
Optional. 'AWS Region, e.g. us-east-2'
`Default: eu-central-1`

`aws-access-key-id:` 
Optional. AWS Access Key ID. This input is required if running in the GitHub hosted environment.

`aws-secret-access-key`
Optional. AWS Secret Access Key. This input is required if running in the GitHub hosted environment.

`path`
Optional. Add path where will run job.
