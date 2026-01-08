variable "aws_region" {
  description = "Regiao AWS"
  default     = "us-east-1"
}

variable "resource_prefix" {
  description = "Prefixo dos recursos"
  default     = "fiap-g37-tc3"
}

# Removemos: db_instance_class, db_port, docdb_username, docdb_password
# O DynamoDB não precisa de nada disso.