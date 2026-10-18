resource "kubernetes_secret" "transip_credentials" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "transip-credentials"
    namespace = each.value

    annotations = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  data = {
    "account-name" = var.transip.account_name
    "private-key"  = var.transip.private_key
  }
}
