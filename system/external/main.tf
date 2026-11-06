module "transip" {
  source  = "./modules/transip"
  transip = var.transip
  namespaces = [
    "cert-manager",
    "external-dns",
  ]
}

# Records for the VPS (metal/vps.yml); records of cluster apps are managed
# by external-dns
locals {
  vps = yamldecode(file("${path.module}/../../metal/inventories/prod.yml")).vps.hosts.vps1
}

module "vps_dns" {
  source = "./modules/dns"
  domain = "jonaskoperdraat.nl"
  names  = ["headscale"]
  ipv4   = local.vps.ansible_host
  ipv6   = local.vps.ipv6
}
