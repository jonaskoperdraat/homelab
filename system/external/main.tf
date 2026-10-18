module "transip" {
  source  = "./modules/transip"
  transip = var.transip
  namespaces = [
    "cert-manager",
    "external-dns",
  ]
}
