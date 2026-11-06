variable "domain" {
  type = string
}

variable "names" {
  type        = list(string)
  description = "Record names (without the domain) pointing at the given addresses"
}

variable "ipv4" {
  type = string
}

variable "ipv6" {
  type = string
}
