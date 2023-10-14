variable "workload" {
  type = string
}

variable "aurora_username" {
  type = string
}

variable "aurora_password" {
  type      = string
  sensitive = true
}

variable "aurora_endpoint" {
  type = string
}
