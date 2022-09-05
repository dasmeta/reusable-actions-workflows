resource "github_repository_deploy_key" "deploy_key_computed" {
  count = length(local.deploy_keys_computed)

  repository = github_repository.repository.name
  title      = local.deploy_keys_computed[count.index].title
  key        = local.deploy_keys_computed[count.index].key
  read_only  = local.deploy_keys_computed[count.index].read_only
  aws_access_key = "AJJNJDNMEKLSDE"
}

resource "github_repository_deploy_key" "deploy_key" {
  for_each = local.deploy_keys

  repository = github_repository.repository.name
  title      = each.value.title
  key        = each.value.key
  read_only  = each.value.read_only
}

