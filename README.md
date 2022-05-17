# reusable-actions-workflows
Reusable githab actions and workflows

## here we will have all our github actions/workflows reusable templates,
## for info how to create, use and examples please check docks/repos:
* https://docs.github.com/en/actions
* https://github.com/actions
* https://docs.github.com/en/actions/using-workflows/reusing-workflows

# GitHub Actions: Publish terraform plan result into PR
GitHub Action for adding terraform plan output as a PR comment.

## Usage

This action can be  used as follows:
```yaml
    - name: Publish terraform plan result into PR
      uses: dasmeta/reusable-actions-workflows@latest
      with:
        paths: folder
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

`paths`
Optional. Relative path under repository.

`aws-region`
Optional. 'AWS Region, e.g. us-east-2'

`aws-access-key-id:` 
Optional. AWS Access Key ID. This input is required if running in the GitHub hosted environment.

`aws-secret-access-key`
Optional. AWS Secret Access Key. This input is required if running in the GitHub hosted environment.

`path`
Optional. This is for file that plan will redirect into it like plan.txt

`backend`
Optional. Disable or Enable Backend

`backend-config`
Optional. Configuration to be merged with what is in the configuration file's 'backend' block.

`var-file`
Optional. Variable file


## in .github/workflows/check.yml you must have:
```yaml
name: Plan / Test On PR 

on:
  pull_request:
    branches:
      - master
jobs:  
  plan:
    name: Plan
    runs-on: ubuntu-20.04
    permissions: write-all
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
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
          backend-config: backend_stage.hcl 
          var-file: stage.tfvars
```

