# GitHub Actions: Run Trivy
GitHub Action for running Trivy security scanning in a general-purpose way.

## Usage

```yaml
- name: Trivy
  uses: dasmeta/reusable-actions-workflows/trivy@main
```

## Example workflow

```yaml
name: TRIVY
on:
  pull_request:
  push:
    branches: [main, master]

jobs:
  trivy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      security-events: write
    steps:
      - uses: dasmeta/reusable-actions-workflows/trivy@main
        with:
          fetch-depth: 0
          scan-type: config
          path: .
          sarif-file: trivy.sarif
          scanners: misconfig,secret
          severity: HIGH,CRITICAL
          exit-code: "0"
```

For other targets you can switch `scan-type` (for example `fs`, `repo`, or `image`) and keep the rest of the action unchanged.

## Valid INPUTS

`fetch-depth`  
Optional. Number of commits to fetch.  
Default: `0`

`path`  
Optional. Path/reference to scan.  
Default: `.`

`scan-type`  
Optional. Trivy scan type (for example `fs`, `repo`, `config`, `image`).  
Default: `config`

`format`  
Optional. Trivy output format.  
Default: `sarif`

`sarif-file`  
Optional. Output file name.  
Default: `trivy.sarif`

`scanners`  
Optional. Comma-separated scanners to run.  
Default: `misconfig,secret`

`severity`  
Optional. Comma-separated severities to report.  
Default: `HIGH,CRITICAL`

`exit-code`  
Optional. Exit code when findings are detected.  
Default: `0`
