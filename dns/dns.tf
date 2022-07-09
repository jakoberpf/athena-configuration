module "dns" {
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/erpf/caddy-ingress" # "jakoberpf/gateway-ingress/erpf"

  providers = {
    cloudflare = cloudflare
    remote     = remote
  }

  for_each = toset(local.domains_http)

  domains = [
    each.key
  ]

  host = "10.110.180.110"
  port = 30080

  https_enabled = false

  cloudflare_email        = var.cloudflare_email
  cloudflare_zone_id      = var.cloudflare_zone_id
  cloudflare_token        = var.cloudflare_token
  cloudflare_record_value = "primary.gateway.dns.erpf.de"
}

module "dns_for_https" {
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/erpf/caddy-ingress" # "jakoberpf/gateway-ingress/erpf"

  providers = {
    cloudflare = cloudflare
    remote     = remote
  }

  for_each = toset(local.domains_https)

  domains = [
    each.key
  ]

  host = "10.110.180.110"
  port = 30443

  cloudflare_email        = var.cloudflare_email
  cloudflare_zone_id      = var.cloudflare_zone_id
  cloudflare_token        = var.cloudflare_token
  cloudflare_record_value = "primary.gateway.dns.erpf.de"
}

locals {
  domains_http = [
    "bashhub.erpf.de",
    "bashhub.dev.erpf.de",  
    "gitlab.dev.erpf.de",
    "gitpod.dev.erpf.de",
    "teleport.dev.erpf.de",
    "anonaddy.dev.erpf.de"
  ]
  domains_https = [  
    "bitwarden.erpf.de",
    "vaultwarden.erpf.de",
    "vaultwarden.dev.erpf.de",
    "bitwarden.dev.erpf.de",
    "iam.erpf.de",
    "iam.dev.erpf.de",
  ]
}
