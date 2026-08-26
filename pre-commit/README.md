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

| Input | Default | Purpose |
|---|---|---|
| `repo-token` | — | Token used to comment on the pull request. Usually `${{ secrets.GITHUB_TOKEN }}`. |
| `path` | `.` | Working directory the hooks run in. |
| `terraform-docs-version` | `0.20.0` | terraform-docs release to install, no leading `v`. |
| `terraform-version` | `1.9.8` | Terraform installed for hooks that shell out to it. |
| `scope` | `all` | `all` checks the whole repository, `changed` only files touched since `base-ref`. |
| `base-ref` | pull request base | Base ref used when `scope: changed`. |
| `comment` | `true` | Post the hook output as a pull request comment. |
| `fail-on-error` | `true` | Fail the step when a hook fails. |
| `aws-access-key-id` | — | Deprecated and unused, accepted so existing callers keep working. |
| `aws-secret-access-key` | — | Deprecated and unused, accepted so existing callers keep working. |

## Behaviour Notes

**This action fails when a hook fails.** Before 4.4.0 it could not: `continue-on-error`
sat on both the run step and the check step, and the check itself was
`grep -q "Failed"`, which *succeeds* when hooks fail. Any required status check
built on it was decorative. If you relied on the old advisory behaviour, set
`fail-on-error: false` explicitly.

**terraform-docs is pinned.** Generated documentation differs between
terraform-docs releases, so an unpinned install makes CI disagree with local
hooks and every README looks out of date on somebody's machine. Pin the same
version in your local setup as the one this action installs.

**Scoping to changed files.** `scope: changed` runs hooks only over files touched
since the base ref, which keeps a pull request from being judged on unrelated
parts of the repository. It falls back to a full run when no base ref can be
determined, so a `push` build still checks everything.
