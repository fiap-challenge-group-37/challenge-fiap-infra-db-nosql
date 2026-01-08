output "docdb_endpoint" {
  description = "Endpoint do cluster DocumentDB"
  value       = aws_docdb_cluster.main.endpoint
}

output "docdb_reader_endpoint" {
  description = "Endpoint de leitura do cluster DocumentDB"
  value       = aws_docdb_cluster.main.reader_endpoint
}

output "docdb_port" {
  description = "Porta do cluster DocumentDB"
  value       = aws_docdb_cluster.main.port
}

output "docdb_username" {
  description = "Username do cluster DocumentDB"
  value       = var.docdb_username
}

output "docdb_cluster_identifier" {
  description = "Identificador do cluster DocumentDB"
  value       = aws_docdb_cluster.main.cluster_identifier
}
