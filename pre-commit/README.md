# GitHub Actions: Publish terraform plan result into PR and apply the changes
GitHub Action for adding Pre-Commit output as a PR comment.

## Usage

This action can be used as follows add latest version:

```yaml
    - name: Pre-Commit Result to PR comment
      uses: dasmeta/reusable-actions-workflows/pre-commit@0.0.6
```

## For Default Configuration in .github/workflows/check.yml you must have:

```yaml
on:
  pull_request:
  push:
    branches: [main, test-me-*]

jobs:
  main:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: actions/setup-python@v3
    - name: self test action
      uses: dasmeta/reusable-actions-workflows/pre-commit@0.0.6
      with:
        repo-token: ${{ secrets.GITHUB_TOKEN }}

```
## Valid INPUTS

`repo-token`
Optional. Uses to comment on PRs. Example: `repo-token: ${{ secrets.GITHUB_TOKEN }}`

