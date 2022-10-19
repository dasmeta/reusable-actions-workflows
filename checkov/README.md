# GitHub Actions: Run Checkov
GitHub Action for running checkov It is static code analysis tool for scanning infrastructure.

## Usage

This action can be used as follows:

```yaml
    - name: Checkov
      uses: dasmeta/reusable-actions-workflows/checkov@main
```

## For Default Configuration in .github/workflows/xxx.yml you must have:
```yaml
name: Checkov
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
          - folder1
          - folder2
    permissions: write-all
    steps:
    - uses: dasmeta/reusable-actions-workflows/checkov@main
      with:
        fetch-depth: 0
        directory: modules/${{ matrix.directory }}
        

```

## Valid INPUTS

`aws-region`
Optional. 'AWS Region, e.g. us-east-2'
`Default: eu-central-1`

`aws-access-key-id:` 
Optional. AWS Access Key ID. This input is required if running in the GitHub hosted environment.

`aws-secret-access-key`
Optional. AWS Secret Access Key. This input is required if running in the GitHub hosted environment.

`directory`
Optional. A directory where will run Checkov
