# GitHub Actions: Publish terraform plan result into PR and apply the changes
GitHub Action for adding Pre-Commit output as a PR comment.

## Usage

This action can be used as follows add latest version:

```yaml
    - name: Pre-Commit Result to PR comment
      uses: dasmeta/reusable-actions-workflows/pre-commit@main
```

## For Default Configuration in .github/workflows/check.yml you must have:

```yaml
name: Infracost
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
    permissions: write-all
    steps:
    - uses: actions/checkout@v2
    - uses: actions/setup-python@v3
    - name: self test action
      uses: dasmeta/reusable-actions-workflows/pre-commit@main
      with:
        repo-token: ${{ secrets.GITHUB_TOKEN }}
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        path: modules/${{ matrix.path }}

```

## Run it manually 
```yaml
name: Infracost
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
    permissions: write-all
    steps:
      - name: Check out code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - run: python -m pip install pre-commit
        shell: bash
      - run: python -m pip freeze --local
        shell: bash
      - run: |
            curl -sSLo ./terraform-docs.tar.gz https://terraform-docs.io/dl/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
            tar -xzf terraform-docs.tar.gz
            chmod +x terraform-docs
            sudo mv terraform-docs /usr/bin/terraform-docs
        shell: bash
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-region: eu-central-1
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.2.1
      - name: Initialize Terraform
        run: |
            cd modules/${{ matrix.path }}
            terraform init
        shell: bash
      
      - uses: actions/cache@v3
        with:
          path: ~/.cache/pre-commit
          key: pre-commit-3|${{ env.pythonLocation }}|${{ hashFiles('.pre-commit-config.yaml') }}
      - run: |
          cd modules/${{ matrix.path }}
          touch results.txt
          pre-commit run -a | sed -E 's/^([[:space:]]+)([-+])/\2\1/g'  > results.txt
        shell: bash
        continue-on-error: true
      - name: Put Files in ENV Vars
        run: |
          cd modules/${{ matrix.path }}
          RESULT=$(cat results.txt)
          echo "RESULT<<EOF" >> $GITHUB_ENV
          echo "$RESULT" >> $GITHUB_ENV
          echo "EOF" >> $GITHUB_ENV
        shell: bash

      - name: Post to GitHub PR
        uses: mshick/add-pr-comment@v1
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          allow-repeats: true
          repo-token-user-login: 'github-actions[bot]'
          message: |
              ## Output
              ```diff
              ${{ env.RESULT }}
              ```

```
## Valid INPUTS

`repo-token`
Optional. Uses to comment on PRs. Example: `repo-token: ${{ secrets.GITHUB_TOKEN }}`

