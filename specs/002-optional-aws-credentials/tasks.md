# Tasks: Skip AWS Credential Configuration When Unused

**Input**: Design documents from `/specs/002-optional-aws-credentials/`
**Prerequisites**: spec.md, plan.md
**Jira**: DMVP-9656

## Phase 1: Investigation

- [X] T001 Reproduce the failure from the `terraform-github-repository#35` run log
- [X] T002 Confirm the job stops at `Configure AWS Credentials` before `terraform init`
- [X] T003 Confirm `aws-region` cannot gate the step because it has a default

## Phase 2: Action Change

- [X] T004 [US1] Gate `Configure AWS Credentials` on both AWS key inputs being non-empty
- [X] T005 [US1] Document the skip behavior in the input reference
- [X] T006 [US1] Update the documented step-by-step behavior

## Phase 3: Verification

- [X] T007 Confirm the action YAML parses
- [ ] T008 Confirm `terraform-github-repository#35` reaches `terraform init` and runs four cases once a release including this change is consumed

## Deferred

- [ ] T009 Cut a release tag including this change
- [ ] T010 Support OIDC-based AWS authentication as an alternative to static keys
- [ ] T011 Bump `aws-actions/configure-aws-credentials@v1`, which targets a deprecated Node runtime
