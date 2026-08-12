# Tasks: Native Terraform Test Support In terraform-test Action

**Input**: Design documents from `/specs/001-terraform-test-native-support/`
**Prerequisites**: spec.md, plan.md
**Jira**: DMVP-9656

## Phase 1: Investigation

- [X] T001 Verify `terraform test` discovery depth empirically with a top-level and a nested test file
- [X] T002 Verify whether `terraform test` requires `terraform init`, for a provider-less module and for one declaring `required_providers`
- [X] T003 Review the sibling `terraform/action.yml` for house init and input conventions

## Phase 2: Action Changes

- [X] T004 [US1] Add the `backend` input, defaulting to `false`, in `terraform-test/action.yml`
- [X] T005 [US1] Raise the `terraform_version` default from `1.3.6` to `1.9.8` and document the >= 1.6 requirement
- [X] T006 [US1] Correct the `path` default from `/` to `.`
- [X] T007 [US2] Replace the existence-only tests check with a discovery-aware guard that counts depth-1 and nested `*.tftest.hcl` files
- [X] T008 [US2] Fail when no discoverable test file exists, naming nested files when present
- [X] T009 [US2] Warn without failing when discoverable and nested files coexist
- [X] T010 [US1] Insert a `terraform init -backend=<backend>` step before the test step

## Phase 3: Documentation

- [X] T011 Document the required test layout and the non-recursive discovery constraint in `terraform-test/README.md`
- [X] T012 Document the `path`, `backend`, and `terraform_version` inputs
- [X] T013 Document the action's step-by-step behavior
- [X] T014 State that the >= 1.6 requirement applies to the runner, not to a module's consumer `required_version` floor

## Phase 4: Verification

- [X] T015 Exercise the guard against discoverable, nested-only, and empty fixtures
- [X] T016 Confirm end-to-end via `terraform-github-repository`, where four migrated cases pass

## Deferred

- [ ] T017 Bump `actions/checkout@v3`, `aws-actions/configure-aws-credentials@v1`, and `hashicorp/setup-terraform@v2` to current majors
- [ ] T018 Cut a new release tag so consumers can move off `@4.3.0`
- [ ] T019 Review the sibling `terraform` action's `1.3.6` default separately
