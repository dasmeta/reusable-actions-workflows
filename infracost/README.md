# GitHub Actions: Run Infracost
GitHub Action for Infracost it generates cloud cost estimation for Terraform in pull requests comment.

## Usage
## For Default Configuration in .github/workflows/xxx.yml you must have:
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
      - name: Setup Infracost
        uses: infracost/actions/setup@v2
        with:
          api-key: ${{ secrets.INFRACOST_API_KEY }}

      - name: Checkout base branch
        uses: actions/checkout@v3
        with:
          ref: '${{ github.event.pull_request.base.ref }}'

      - name: Generate Infracost cost estimate baseline
        run: |
          infracost breakdown --path=modules/${{ matrix.path }} \
                              --format=json \
                              --out-file=/tmp/infracost-base.json

      - name: Checkout PR branch
        uses: actions/checkout@v3

      - name: Generate Infracost diff
        run: |
          infracost diff --path=modules/${{ matrix.path }}\
                          --format=json \
                          --compare-to=/tmp/infracost-base.json \
                          --out-file=/tmp/infracost.json

      - name: Post Infracost comment
        run: |
            infracost comment github --path=/tmp/infracost.json \
                                     --repo=$GITHUB_REPOSITORY \
                                     --github-token=${{github.token}} \
                                     --pull-request=${{github.event.pull_request.number}} \
                                     --behavior=update

```
