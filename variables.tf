variable "aws_region" {
  type        = string
  description = "AWS region where resources will be created"
  default     = "us-east-1"

  validation {
    condition     = can(regex("^([a-z]{2})-([a-z]+)-\\d$", var.aws_region))
    error_message = "Provide a valid AWS region (e.g. us-east-1)."
  }
}

variable "resource_prefix" {
  type        = string
  description = "Prefix applied to resource names and tags"
  default     = "fiap-g52-tc3"

  validation {
    condition     = length(trimspace(var.resource_prefix)) > 0
    error_message = "Resource prefix cannot be empty."
  }
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for the DocumentDB instance"
  default     = "db.t3.medium"

  validation {
    condition     = can(regex("^db\\.", var.db_instance_class))
    error_message = "DB instance class must start with db."
  }
}

variable "db_instance_count" {
  type        = number
  description = "Number of instances in the DocumentDB cluster"
  default     = 1

  validation {
    condition     = var.db_instance_count >= 1 && var.db_instance_count <= 16
    error_message = "Instance count must be between 1 and 16."
  }
}

variable "db_backup_retention_period" {
  type        = number
  description = "Number of days to retain automatic backups"
  default     = 7

  validation {
    condition     = var.db_backup_retention_period >= 1 && var.db_backup_retention_period <= 35
    error_message = "Backup retention must be between 1 and 35 days."
  }
}

variable "db_port" {
  type        = number
  description = "Port where the database will listen"
  default     = 27017

  validation {
    condition     = var.db_port >= 1024 && var.db_port <= 65535
    error_message = "Port must be between 1024 and 65535."
  }
}

variable "docdb_username" {
  type        = string
  description = "Master username for the DocumentDB cluster"
}

variable "docdb_password" {
  type        = string
  description = "Master password for the DocumentDB cluster"
  sensitive   = true
}

variable "db_tls_enabled" {
  type        = bool
  description = "Enable TLS for DocumentDB connections"
  default     = false
}
