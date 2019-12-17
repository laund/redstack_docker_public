agent_prefix "" {
  policy = "read"
}

agent "consul-server-01" {
  policy = "write"
}

service_prefix "" {
  policy = "write"
}

node_prefix "" {
  policy = "write"
}
