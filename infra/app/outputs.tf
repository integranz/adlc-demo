output "image_tag" { value = var.image_tag }
output "environment_default_domain" { value = azurerm_container_app_environment.this.default_domain }

output "api_name" { value = azurerm_container_app.api.name }
output "api_latest_revision" { value = azurerm_container_app.api.latest_revision_name }
output "api_fqdn" { value = azurerm_container_app.api.ingress[0].fqdn }
output "api_url" { value = "https://${azurerm_container_app.api.ingress[0].fqdn}" }
output "api_health_url" { value = "https://${azurerm_container_app.api.ingress[0].fqdn}/health" }

output "web_name" { value = azurerm_container_app.web.name }
output "web_latest_revision" { value = azurerm_container_app.web.latest_revision_name }
output "web_fqdn" { value = azurerm_container_app.web.ingress[0].fqdn }
output "web_url" { value = "https://${azurerm_container_app.web.ingress[0].fqdn}" }
output "web_health_url" { value = "https://${azurerm_container_app.web.ingress[0].fqdn}/" }

