key_prefix "rabbitmq/" {
  policy = "write"
}

session "" {
  policy = "write"
}

session_prefix "" {
  policy = "write"
}

service "rabbitmq" {
  policy = "write"
}

service_prefix "" {
   policy = "read"
}

node_prefix "" {
  policy = "read"
}

node "" {
  policy = "write"
}

agent "" {
  policy = "write"
}
