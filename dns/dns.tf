module "dns" {
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/erpf/caddy-ingress" # "jakoberpf/gateway-ingress/erpf"

  providers = {
    cloudflare = cloudflare
    remote     = remote
  }

  for_each = toset(local.domains)

  domains = [
    each.key
  ]
  host = "10.110.180.110"
  port = 30080

  cloudflare_email        = var.cloudflare_email
  cloudflare_zone_id      = var.cloudflare_zone_id
  cloudflare_token        = var.cloudflare_token
  cloudflare_record_value = "primary.gateway.dns.erpf.de"
}

locals {
  domains = [
    "bashhub.dev.erpf.de",
    "vaultwarden.dev.erpf.de",
    "gitlab.dev.erpf.de",
    "registry.dev.erpf.de",
    "minio.dev.erpf.de",
    "gitpod.dev.erpf.de",
  ]
}
