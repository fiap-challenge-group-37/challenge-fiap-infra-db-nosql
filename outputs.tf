output "dynamodb_table_name" {
  description = "Nome da tabela criada no DynamoDB"
  value       = aws_dynamodb_table.pedidos.name
}

output "dynamodb_table_arn" {
  description = "ARN da tabela (Identificador único na AWS)"
  value       = aws_dynamodb_table.pedidos.arn
}

output "aws_region" {
  description = "Região onde a tabela foi criada"
  value       = var.aws_region
}