variable "rabbitmq_addr" {
  default = "http://10.5.0.6"
}

variable "vault_addr" {
  default = "http://10.5.0.5"
}

variable "vault_token" {
  default = ""
}

variable "rabbitmq_guest_password" {
  default = "guest"
}

variable "rabbitmq_guest_login" {
  default = "guest"
}

variable "rabbitmq_admin_password" {
  default = ""
}

variable "rabbitmq_admin_login" {
  default = "admin"
}
