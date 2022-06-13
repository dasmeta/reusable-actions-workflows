# GitHub Actions: Publish terraform plan result into PR and apply the changes
GitHub Action for adding terraform plan output as a PR comment.

## Usage

This action can be used as follows add latest version:

```yaml
    - name: Publish terraform plan result into PR
      uses: dasmeta/reusable-actions-workflows/terraform@0.0.4
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
    steps:
      - name: Publish terraform plan result into PR
        uses: dasmeta/reusable-actions-workflows/terraform@0.0.4
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
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
`Default: 100`

`path`
Optional. Relative path under repository.
`Default: terraform `

`aws-region`
Optional. 'AWS Region, e.g. us-east-2'
`Default: us-east-1`

`aws-access-key-id:` 
Optional. AWS Access Key ID. This input is required if running in the GitHub hosted environment.

`aws-secret-access-key`
Optional. AWS Secret Access Key. This input is required if running in the GitHub hosted environment.

`backend`
Optional. Disable or Enable Backend
`Default: false`

`backend-config`
Optional. Configuration to be merged with what is in the configuration file's 'backend' block.
`Default: "backend.hcl"`

`var-file`
Optional. Variable file
`Default: "env.tfvars"`


## EXAMPLE FOR Plan and publish/comment under PR for master:

```yaml
name: Plan and comment on PR
on:
  pull_request:
    types:
      - opened
      - reopened
      - edited
      - synchronize
    branches:
      - master
    paths:
      - 'terraform/sample-path-to-terraform-project-sources/**'
jobs:  
  plan:
    name: Plan and publish/comment under PR
    runs-on: ubuntu-20.04
    strategy:
      matrix:
        path:
          - sample-path-to-terraform-project-sources
    steps:
      - name: Publish terraform plan result into PR
        uses: dasmeta/reusable-actions-workflows/terraform@0.0.4
        with:
          fetch-depth: 100
          post-plan-to-github-pr: 'true'
          target_branch: "release"
          path: terraform/${{ matrix.path }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
          aws-region: ${{ secrets.AWS_DEFAULT_REGION }}
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          backend: true
          backend-config: backend.tfbackend 
          var-file: variables.tfvars
```

## EXAMPLE FOR Plan and apply after merge into master:

```yaml
name: Plan and Apply
on:
  pull_request:
    types: [closed]
    branches:
      - master
    paths:
      - 'terraform/sample-path-to-terraform-project-sources/**'
jobs:
  plan:
    name: Plan and apply stage
    if: github.event_name == 'pull_request' && github.event.pull_request.merged == true
    runs-on: ubuntu-20.04
    strategy:
      matrix:
        path:
          - sample-path-to-terraform-project-sources
    steps:
      - name: Plan stage ${{ matrix.path }}
        uses: dasmeta/reusable-actions-workflows/terraform@0.0.4
        with:
          post-plan-to-github-pr: 'false'
          do-apply: 'true'
          fetch-depth: 100
          path: terraform/${{ matrix.path }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
          aws-region: ${{ secrets.AWS_DEFAULT_REGION }}
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          backend: true
          backend-config: backend.tfbackend
          var-file: variables.tfvars

```
