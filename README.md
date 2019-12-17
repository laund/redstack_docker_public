## Build Stack Consul
```bash
# docker-compose up -d --build consul-server-1
```

## Create Bootstrap ACL

![Bootstrap](./termtosvg/acl_bootstrap.svg)

## Create Policy/Token Agent

![Policy_Agent](./termtosvg/acl_policy_agent.svg)

```bash
# consul acl policy create -name "agent-token" -description "Agent's Token Policy" -rules @agent-policy.hcl
# consul acl token create -description "Agent Token" -policy-name "agent-token"
# consul acl set-agent-token default "<SecretID>"
```

## Create Policy/Token Vault

![Policy_Vault](./termtosvg/acl_policy_vault.svg)

```bash
# consul acl policy create -name "vault-token" -description "Vault Token Policy" -rules @vault-policy.hcl
# consul acl token create -description "Vault Token" -policy-name "vault-token"
```

## Create Policy/Token Rabbitmq

![Policy_Rabbitmq](./termtosvg/acl_policy_rabbitmq.svg)

```bash
# consul acl policy create -name "rabbitmq-token" -description "Rabbitmq Token Policy" -rules @rabbitmq-policy.hcl
# consul acl token create -description "Rabbitmq Token" -policy-name "rabbitmq-token"
```

## Build Stack Rabbitmq
```bash
# docker-compose up -d --build rabbitmq-server-1
# docker-compose up -d --build rabbitmq-server-2
# docker-compose up -d --build rabbitmq-server-3
```

## Build Stack Vault
```bash
# docker-compose up -d --build vault
```

## Unsealed Vault Server

![Vault_Unseal](./termtosvg/vault_unseal.svg)

```bash
# docker exec -it redstack_vault_1 /bin/sh
# vault operator init
# vault operator unseal (repeat process 3x use 3 tokens # )
# vault login (Insert Root Token)
```

## Enable Dynamic Secrets Rabbitmq

![Vault_Policy_Rabbitmq.svg](./termtosvg/vault_policy_rabbitmq.svg)

```bash
# vault secrets enable rabbitmq
# vault write rabbitmq/config/connection connection_uri="http://10.5.0.6:15672" username="guest" password="guest"
# vault write rabbitmq/roles/dc1-rabbitmq vhosts='{"/":{"configure": ".*", "write": ".*", "read": ".*"}}'
```

## Test Dynamic Secrets Vault <-> Rabbitmq

![Vault_Policy_Rabbitmq.svg](./termtosvg/create_dynamics_secrets_vault_rabbitmq.svg)

```bash
# vault read rabbitmq/creds/dc1-rabbitmq
```

```bash
# cd validate-rabbitmq-go
```

## Configure Receive (Rabbitmq)

![Consumer_Rabbitmq.svg](./termtosvg/consumer_rabbitmq.svg)

```bash
# go run consumer/receive.go
```

## Configure Producer Send (Rabbitmq)

![Producer_Rabbitmq.svg](./termtosvg/producer_rabbitmq.svg)

```bash
# sh producer/loop.sh
```

## Build Stack Cassandra

```bash
# docker-compose up -d --build cassandra-server-1
# docker-compose up -d --build cassandra-server-2
# docker-compose up -d --build cassandra-server-3
```

## Enable Dynamic Secrets Cassandra

![Vault_Policy_Cassandra.svg](./termtosvg/vault_policy_cassandra.svg)

```bash
# vault secrets enable database

# vault write database/config/cassandra-database \
    plugin_name="cassandra-database-plugin" \
    hosts=10.5.0.9 \
    protocol_version=4 \
    username=cassandra \
    password=cassandra \
    allowed_roles=cassandra-access

# vault write database/roles/cassandra-access \
plugin_name="cassandra-database-plugin" \
db_name=cassandra-database \
creation_statements="CREATE USER '{{username}}' WITH PASSWORD '{{password}}' NOSUPERUSER; \
     GRANT SELECT ON ALL KEYSPACES TO {{username}};" \
default_ttl="1h" \
max_ttl="24h"
```

## Test Dynamics Secrets Vault/Cassandra
![Dynamic_Secrets_Cassandra.svg](./termtosvg/dynamic_secrets_cassandra.svg)

```bash
# vault read database/creds/cassandra-access
```

![Connect_Cassandra_Dynamic_Secrets.svg](./termtosvg/connect_cassandra_dynamic_secrets.svg)

```bash
# cqlsh 10.5.0.9 -u<vaultuserdynamic> -p<vaultpassworddynamic>
```

## Build Stack Wazuh

On the host that will build the stack build the following command:

```bash
# sysctl -w vm.max_map_count=262144
```

Next Steps:

```bash
# docker-compose up -d --build wazuh

# docker-compose up -d --build elasticsearch

# docker-compose up -d --build kibana

# docker-compose up -d --build nginx
```

Access:

https://10.5.0.15/

login: foo  
password: bar


## Terraform Under Construction

## Reference Links

[Consul Acl](https://www.consul.io/docs/acl/index.html)  
[Rabbitmq Cluster-Formation](https://www.rabbitmq.com/cluster-formation.html#peer-discovery-consul)  
[Vault RabbitMQ Secrets Engine](https://www.vaultproject.io/docs/secrets/rabbitmq/index.html)  
[Vault Cassandra Database](https://www.vaultproject.io/docs/secrets/databases/cassandra.html)
