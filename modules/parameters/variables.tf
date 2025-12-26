variable "github_token" {
  type      = string
  sensitive = true
}

variable "s3bucket" {
  type = string
}

variable "usg_cis_profile" {
  type = string
}
