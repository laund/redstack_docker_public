# Vault provider
provider "vault" {
  address = "${var.vault_addr}:8200"
  token   = "${var.vault_token}"
}

# Configure the RabbitMQ provider
provider "rabbitmq" {
  endpoint = "${var.rabbitmq_addr}:15672"
  username = "${var.rabbitmq_guest_login}"
  password = "${var.rabbitmq_guest_password}"
}
