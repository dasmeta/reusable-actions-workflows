# GitHub Actions: Run Terraform Test
GitHub Action for running the `terraform test` command.

## Test layout requirements

This action runs Terraform's native test framework. Test files must be
`*.tftest.hcl` placed **directly inside** the `tests/` directory of the target
path:

```text
tests/
  basic-create.tftest.hcl
  full-enabled.tftest.hcl
```

`terraform test` discovers test files in the test directory only — it does not
recurse. A file at `tests/basic-create/main.tftest.hcl` is silently never
executed, so the run reports success while testing nothing. This action fails
the job when `tests/` contains no discoverable test file, and names any nested
files it found so the layout can be corrected.

Native tests require Terraform >= 1.6. This is a requirement on the version the
action runs, not on the module's `required_version`; do not raise a module's
consumer version floor to satisfy the test runner.

## Usage

This action can be used as follows add latest version:

```yaml
    - name: Terraform Test
      uses: dasmeta/reusable-actions-workflows/terraform-test@main
```

## For Default Configuration in .github/workflows/xxx.yml you must have:
```yaml
name: Terraform Test
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
    - uses: dasmeta/reusable-actions-workflows/terraform-test@main
      with:
        aws-region: ${{ secrets.AWS_REGION}}
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        path: modules/${{ matrix.path }}

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
Optional. Path where to run terraform test, relative to the repository root.
`Default: .`

`backend`
Optional. Enable or disable the backend during `terraform init`. Module test
repositories normally keep this disabled.
`Default: "false"`

`terraform_version`
Optional. Terraform version used by this action. Must be >= 1.6 for the native
test framework.
`Default: 1.9.8`

## Behavior

1. Checks out the repository and configures AWS credentials.
2. Installs the requested Terraform version.
3. Verifies `<path>/tests` exists and contains at least one discoverable
   `*.tftest.hcl` file, failing with guidance when test files are nested.
4. Runs `terraform init` in `<path>`, with the backend disabled by default.
5. Runs `terraform test` in `<path>`.
