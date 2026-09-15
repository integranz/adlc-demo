# Values rendered from .adlc/config.yaml. Change them with /adlc:bootstrap, then re-scaffold.
locals {
  project     = "adlc-demo"
  environment = "dev"

  resource_group_name = "rg-adlc-demo-dev"
  acr_name            = "acradlcdemo"
  key_vault_name      = "kv-adlc-demo-dev"
  identity_name       = "id-adlc-demo-dev"
  log_analytics_name  = "log-adlc-demo-dev"
  cae_name            = "cae-adlc-demo-dev"

  tags = {
    project     = local.project
    environment = local.environment
    managed_by  = "terraform"
    layer       = "app"
    generator   = "adlc 0.8.2"
  }
}
