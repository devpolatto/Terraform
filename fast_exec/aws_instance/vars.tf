variable "common_tags" {
  type = map(any)
  default = {
    ENV           = ""
    LAB_ID        = ""
    ALIAS_PROJECT = ""
    MANAGED_BY    = "Terraform"
  }
}