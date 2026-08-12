# Implementation Plan: Skip AWS Credential Configuration When Unused

**Spec**: [spec.md](spec.md)
**Jira**: DMVP-9656
**Branch**: `agent/dmvp-9656-optional-aws-credentials`

## Technical Context

**Artifact types**: GitHub composite action YAML and Markdown documentation.

**Primary artifacts**:

- `terraform-test/action.yml`
- `terraform-test/README.md`

**Predecessor**: `specs/001-terraform-test-native-support`, released as `4.3.1`.

## Design Decisions

### Gate on both key inputs, not the region

`aws-region` has a default, so it is always non-empty and cannot signal intent.
The access key and secret are the real indicators. Requiring both to be
non-empty also avoids attempting authentication with a half-supplied credential
pair, which would fail in a more confusing way than skipping.

### Skip rather than warn

A non-AWS module supplying no credentials is a normal, correct configuration,
not a degraded one. Emitting a warning would train maintainers to ignore
warnings.

## Steps

1. Add an `if` condition to the `Configure AWS Credentials` step requiring both key inputs.
2. Document that AWS inputs are optional and that omitting them skips the step.
3. Update the documented behavior list.

## Verification

- Action YAML parses.
- `terraform-github-repository#35`, which supplies no AWS inputs, is the end-to-end case: its Terraform Test job should reach `terraform init` and run four test cases.

## Risks

- **Silent skip hides a real misconfiguration**: an AWS module that forgets to pass credentials will now fail later, at Terraform, rather than at the credential step. The Terraform error is specific enough to diagnose, and the alternative blocks legitimate non-AWS modules.
