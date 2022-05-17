# GitHub Actions: Publish terraform plan result into PR
GitHub Action for adding terraform plan output as a PR comment.

## Usage

This action can be used as follows add latest version:

```yaml
    - name: Publish terraform plan result into PR
      uses: dasmeta/reusable-actions-workflows@latest
```

## For Default Configuration in .github/workflows/check.yml you must have:
```yaml
on:
  pull_request:
    branches:
      - master
jobs:  
  plan:
    name: Plan
    runs-on: ubuntu-20.04
    permissions: write-all
    steps:
      - name: Publish terraform plan result into PR
        uses: dasmeta/reusable-actions-workflows@latest
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          aws-access-key-id: ${{ secrets.AWS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRETE_ID }}
```

## Note

If you had one or more folders add it in matrix path.

```yaml
strategy:
      matrix:
        path: 
          - Folder1
          - Folder2
```

## Valid INPUTS

`github-token`
Optional. Uses to comment on PRs.

`fetch-depth`
Optional. Number of commits to fetch. 0 indicates all history for all branches and tags.
Default: 100

`paths`
Optional. Relative path under repository.
Default: terraform 

`aws-region`
Optional. 'AWS Region, e.g. us-east-2'
Default: us-east-1

`aws-access-key-id:` 
Optional. AWS Access Key ID. This input is required if running in the GitHub hosted environment.

`aws-secret-access-key`
Optional. AWS Secret Access Key. This input is required if running in the GitHub hosted environment.

`path`
Optional. This is for file that plan will redirect into it like plan.txt
Default: folder1

`backend`
Optional. Disable or Enable Backend
Default: false

`backend-config`
Optional. Configuration to be merged with what is in the configuration file's 'backend' block.
Default: "backend.hcl"

`var-file`
Optional. Variable file
Default: "env.tfvars"


## EXAMPLE FOR NOT Default configuration:

```yaml
jobs:  
  plan:
    name: Plan
    runs-on: ubuntu-20.04
    permissions: write-all
    steps:
      - name: Publish terraform plan result into PR
        uses: dasmeta/reusable-actions-workflows@latest
        with:
          fetch-depth: 2
          paths: terraform/folder1
          path: folder1
          github-token: ${{ secrets.GITHUB_TOKEN }}
          aws-access-key-id: ${{ secrets.AWS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRETE_ID }}
          backend: true
          backend-config: backend_prod.hcl 
          var-file: prod.tfvars
```

## FOR 2 or More project and NOT Default configuration:

```yaml
jobs:  
  plan:
    name: Plan
    runs-on: ubuntu-20.04
    permissions: write-all
    strategy:
      matrix:
        path: 
          - pushmetrics.io
          - query.me
    steps:
      - name: Publish terraform plan result into PR
        uses: dasmeta/reusable-actions-workflows@latest
        with:
          fetch-depth: 100
          paths: terraform/${{ matrix.path }}
          path: ${{ matrix.path }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
          aws-access-key-id: ${{ secrets.AWS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRETE_ID }}
          backend: true
          backend-config: backend_prod.hcl 
          var-file: prod.tfvars
```
