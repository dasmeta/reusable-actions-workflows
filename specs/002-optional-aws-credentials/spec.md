# Feature Specification: Skip AWS Credential Configuration When Unused

**Feature Branch**: `agent/dmvp-9656-optional-aws-credentials`
**Created**: 2026-08-12
**Status**: Draft
**Jira**: DMVP-9656
**Input**: PR review on `terraform-github-repository#35` found that its Terraform Test job fails before Terraform runs, because the action always configures AWS credentials even for a module that uses no AWS provider.

## Problem

The `terraform-test` action runs `Configure AWS Credentials` unconditionally. A
module repository using a non-AWS provider has no reason to configure AWS, but
the step still executes with whatever inputs it receives.

Observed on `terraform-github-repository#35`, a module using only the
`integrations/github` provider:

```
##[error]The security token included in the request is invalid.
```

The job stops there. `terraform init` and `terraform test` never run, so the
repository has no CI coverage of its tests while the check merely reports a
credentials failure.

This compounds the defects fixed in `specs/001-terraform-test-native-support`:
even after the action gained an init step and a working Terraform default, an
unrelated AWS credential requirement still blocks execution.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Non-AWS Modules Can Run Tests (Priority: P1)

As a maintainer of a module using a non-AWS provider, I want the action to skip
AWS setup, so my tests actually execute.

**Acceptance Scenarios**:

1. **Given** a workflow that passes no AWS inputs, **When** the action runs, **Then** the AWS credential step is skipped and Terraform runs.
2. **Given** a workflow that passes both AWS key inputs, **When** the action runs, **Then** AWS credentials are configured as before.
3. **Given** a workflow that passes only one of the two key inputs, **When** the action runs, **Then** the step is skipped rather than failing on a partial credential set.

## Success Criteria *(mandatory)*

- **SC-001**: The AWS credential step runs only when both key inputs are non-empty.
- **SC-002**: AWS-using modules keep their existing behavior with no workflow change.
- **SC-003**: The README states that AWS inputs are optional and that omitting them skips the step.

## Compatibility Notes

Purely additive. Workflows already supplying valid credentials are unaffected.
Workflows supplying empty or invalid credentials move from a hard failure to a
skipped step, which is the intended correction.

## Out Of Scope

- OIDC-based AWS authentication as an alternative to static keys.
- Bumping `aws-actions/configure-aws-credentials@v1`, which still targets a deprecated Node runtime. Tracked separately.
