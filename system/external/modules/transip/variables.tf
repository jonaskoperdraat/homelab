variable "transip" {
  type = object({
    account_name = string
    private_key  = string
  })

  sensitive = true
}

variable "namespaces" {
  type        = list(string)
  description = "Namespaces that need the TransIP API credentials"
}
