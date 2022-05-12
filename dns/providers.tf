terraform {
  backend "s3" {}
  required_version = ">= 1.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.8.0"
    }
    remote = {
      source  = "tenstad/remote"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

provider "remote" {
  conn {
    user        = "ubuntu"
    private_key = file("../.ssh/automation")
    host        = "primary.gateway.dns.erpf.de"
    sudo        = true
  }
}
