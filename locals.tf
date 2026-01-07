locals {
  component   = "db-nosql"
  name_prefix = "${var.resource_prefix}-${local.component}"

  subnet_group_name    = "${local.name_prefix}-subnet"
  security_group_name  = "${local.name_prefix}-sg"
  parameter_group_name = "${local.name_prefix}-params"
  cluster_identifier   = "${local.name_prefix}-docdb"

  common_tags = {
    Project   = var.resource_prefix
    Component = local.component
    ManagedBy = "terraform"
  }

  subnet_group_tags = merge(local.common_tags, {
    Name = local.subnet_group_name
  })

  security_group_tags = merge(local.common_tags, {
    Name = local.security_group_name
  })

  cluster_tags = merge(local.common_tags, {
    Name = local.cluster_identifier
  })

  instance_tags = merge(local.common_tags, {
    Name = "${local.cluster_identifier}-instance"
  })
}
