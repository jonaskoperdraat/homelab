resource "transip_dns_record" "a" {
  for_each = toset(var.names)

  domain  = var.domain
  name    = each.value
  type    = "A"
  expire  = 300
  content = [var.ipv4]
}

resource "transip_dns_record" "aaaa" {
  for_each = toset(var.names)

  domain  = var.domain
  name    = each.value
  type    = "AAAA"
  expire  = 300
  content = [var.ipv6]
}
