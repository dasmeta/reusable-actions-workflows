# GitHub Actions: Run TFSEC
GitHub Action for running terraform tfsec security scanning.  It is static analysis security scanner for your Terraform code

## Usage

This action can be used as follows add latest version:

```yaml
    - name: TFSEC
      uses: dasmeta/reusable-actions-workflows/tfsec@4.0.0
```

## For Default Configuration in .github/workflows/tfsec.yml you must have:

```yaml
name: TFSEC
on:
  pull_request:
  push:
    branches: [main, master]

jobs:
  terraform-tfsec:
    runs-on: ubuntu-latest
    permissions: write-all
    steps:
    - uses: dasmeta/reusable-actions-workflows/tfsec@4.0.0
      with:
        fetch-depth: 0

```

## Valid INPUTS

`fetch-depth`
Optional. 'fetch-depth'
`Default: 0`
