variable "transip" {
  type = object({
    account_name = string
    private_key  = string
  })

  sensitive = true
}
