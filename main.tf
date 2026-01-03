# Data source para usar a LabRole (se necessario para outros recursos)
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Subnet Group para DocumentDB usando as subnets do EKS
resource "aws_docdb_subnet_group" "main" {
  name       = local.subnet_group_name
  subnet_ids = data.terraform_remote_state.k8s.outputs.subnet_ids

  tags = local.subnet_group_tags
}

# Security Group para DocumentDB
resource "aws_security_group" "docdb_sg" {
  name        = local.security_group_name
  description = "Allow MongoDB access from EKS cluster"
  vpc_id      = data.terraform_remote_state.k8s.outputs.vpc_id

  tags = local.security_group_tags

  # Permitir saida (padrao)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir acesso MongoDB apenas da VPC (mais seguro que 0.0.0.0/0)
  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.k8s.outputs.vpc_cidr]
  }
}

# DocumentDB Cluster Parameter Group
resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb5.0"
  name        = local.parameter_group_name
  description = "DocumentDB cluster parameter group"

  parameter {
    name  = "tls"
    value = var.db_tls_enabled ? "enabled" : "disabled"
  }

  tags = local.common_tags
}

# DocumentDB Cluster
resource "aws_docdb_cluster" "main" {
  cluster_identifier              = local.cluster_identifier
  engine                          = "docdb"
  master_username                 = var.db_username
  master_password                 = var.db_password
  port                            = var.db_port
  db_subnet_group_name            = aws_docdb_subnet_group.main.name
  vpc_security_group_ids          = [aws_security_group.docdb_sg.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name

  # Configuracoes de backup
  backup_retention_period = var.db_backup_retention_period
  preferred_backup_window = "03:00-04:00"

  # Configuracoes de manutencao
  preferred_maintenance_window = "sun:04:00-sun:05:00"

  # Configuracoes de seguranca
  storage_encrypted = false # AWS Academy pode nao suportar encryption

  # Configuracoes de deployment
  skip_final_snapshot = true
  deletion_protection = false # Para facilitar limpeza

  tags = local.cluster_tags
}

# DocumentDB Cluster Instance
resource "aws_docdb_cluster_instance" "main" {
  count              = var.db_instance_count
  identifier         = "${local.cluster_identifier}-${count.index}"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.db_instance_class

  tags = local.instance_tags
}
