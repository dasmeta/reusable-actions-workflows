# Implementation Plan: Native Terraform Test Support In terraform-test Action

**Spec**: [spec.md](spec.md)
**Jira**: DMVP-9656
**Branch**: `agent/dmvp-9656-terraform-test-native-support`

## Technical Context

**Artifact types**: GitHub composite action YAML and Markdown documentation.

**Primary artifacts**:

- `terraform-test/action.yml`
- `terraform-test/README.md`

**Related work**: The module repository baseline in `dasmeta/constitution`
(`specs/046-tf-module-repo-baseline`) defines the test layout this action must
support. `terraform-github-repository` is the first adopter.

## Design Decisions

### Init with the backend disabled by default

Module test repositories have no remote state. `terraform init -backend=false`
avoids requiring backend credentials while still installing providers and child
modules. A `backend` input is exposed for the rare consumer that needs it,
matching the sibling `terraform` action's input naming.

### Fail closed on undiscoverable tests

The existence-only check is the reason a broken layout went unnoticed. The
replacement counts discoverable files at depth 1 and nested files below that,
and fails when the discoverable count is zero. When both exist, the job proceeds
with a warning rather than failing, because the discoverable tests are real
coverage and blocking them would punish partial migration.

### Default version rather than a required input

Making `terraform_version` required would break every existing consumer.
Changing the default fixes the common case while leaving the input available for
pinning.

## Phased Approach

1. Add the `backend` input and raise the `terraform_version` default.
2. Correct the `path` default from `/` to `.`.
3. Replace the tests-folder check with the discovery-aware guard.
4. Insert the init step before the test step.
5. Document the layout requirement, inputs, and behavior in the action README.

## Verification

- The guard logic is exercised against three fixtures — discoverable, nested-only, and empty — confirming pass, fail-with-names, and fail respectively.
- Terraform test discovery depth and the init requirement are verified empirically rather than assumed from documentation.
- `terraform-github-repository` serves as the end-to-end adopter, where `terraform test` runs four cases successfully after migration.

## Risks

- **Behavior change for consumers**: the Terraform default moves from 1.3.6 to 1.9.8. Mitigated by the fact that the old default could not run tests correctly in either generation, and by leaving the input pinnable.
- **Newly failing jobs**: repositories whose tests were silently not executing will now fail if their layout is wrong. This is the intended effect; the failure message names the offending paths.
