# Feature Specification: Native Terraform Test Support In terraform-test Action

**Feature Branch**: `agent/dmvp-9656-terraform-test-native-support`
**Created**: 2026-08-12
**Status**: Draft
**Jira**: DMVP-9656
**Input**: The shared `terraform-test` action could not run Terraform's native test framework. Discovered while migrating `terraform-github-repository` to `.tftest.hcl` tests under the module repository baseline defined in the constitution repository.

## Problem

The `terraform-test` action claims to "init, test terraform code" but has three defects that together mean native tests either fail or silently pass without testing anything.

1. **No init step.** The action never runs `terraform init`. Verified empirically: a module with no providers passes without init, but any module declaring `required_providers` fails with `Missing required provider`. Every real module repository hits this.
2. **Terraform default predates native tests.** `terraform_version` defaults to `1.3.6`. The native test framework and `.tftest.hcl` parsing arrived in 1.6. The experimental `terraform test` that existed in 1.3 was removed in 1.6, so the default cannot run either generation of tests correctly.
3. **Existence-only test check.** The action verifies that `tests/` exists but not that it contains a discoverable test file. `terraform test` discovers `*.tftest.hcl` in the test directory only and does not recurse, so a repository with files at `tests/<case>/main.tftest.hcl` passes the check, runs zero tests, and reports success.

A fourth, smaller defect: `path` defaults to `/`, so the default configuration would `cd /` to the filesystem root.

## Evidence

Verified with Terraform 1.14.7:

- `tests/top.tftest.hcl` is discovered and executed.
- `tests/nested/main.tftest.hcl` is not discovered by default and only runs when pointed at with `-test-directory`.
- `terraform test` without `terraform init` succeeds for a provider-less module and fails with `Missing required provider` for a module requiring `hashicorp/null`.

`terraform-github-repository` was consuming this action at `@4.3.0` with four test files nested at `tests/<case>/main.tftest.hcl`, so its test job was reporting success while executing nothing.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Native Tests Actually Execute (Priority: P1)

As a module maintainer, I want the shared action to run my `.tftest.hcl` tests, so CI reflects real verification.

**Acceptance Scenarios**:

1. **Given** a module repository with `tests/*.tftest.hcl` and providers, **When** the action runs, **Then** Terraform is initialized and the tests execute.
2. **Given** a repository whose module declares `required_providers`, **When** the action runs, **Then** it does not fail with `Missing required provider`.
3. **Given** the action's default configuration, **When** it runs, **Then** the Terraform version supports `.tftest.hcl`.

---

### User Story 2 - Undiscoverable Tests Fail Loudly (Priority: P1)

As a maintainer, I want CI to fail when my test files are placed where Terraform cannot find them, so a green check never means zero tests.

**Acceptance Scenarios**:

1. **Given** `tests/` containing only nested test files, **When** the action runs, **Then** the job fails and names the nested files with instructions to move them.
2. **Given** `tests/` containing no test files at all, **When** the action runs, **Then** the job fails.
3. **Given** `tests/` containing both discoverable and nested files, **When** the action runs, **Then** the job proceeds and emits a warning naming the nested files.

## Success Criteria *(mandatory)*

- **SC-001**: The action initializes Terraform before testing, with the backend disabled by default.
- **SC-002**: The default Terraform version supports the native test framework.
- **SC-003**: The action fails when `tests/` holds no discoverable `*.tftest.hcl` file.
- **SC-004**: Nested test files are reported by path rather than silently ignored.
- **SC-005**: The default `path` resolves to the repository root rather than the filesystem root.
- **SC-006**: The action README documents the required test layout and the discovery constraint.

## Out Of Scope

- Bumping `actions/checkout@v3`, `aws-actions/configure-aws-credentials@v1`, or `hashicorp/setup-terraform@v2` to current major versions. These are stale but unrelated to native test support and warrant their own change.
- Changing the sibling `terraform` action, which has the same `1.3.6` default for plan/apply flows where it is not a defect.

## Compatibility Notes

Raising the default Terraform version is a behavior change for existing consumers. It is judged safe because the previous default could not run either the removed experimental test command or the current native framework. Consumers needing the old behavior can pin `terraform_version` explicitly.
