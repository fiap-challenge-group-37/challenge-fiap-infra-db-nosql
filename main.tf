# Data source para usar a LabRole (necessário para permissões)
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# Criação da Tabela DynamoDB
resource "aws_dynamodb_table" "pedidos" {
  # Nome da tabela (ex: fiap-g52-tc3-pedidos)
  name           = "${var.resource_prefix}-pedidos"

  # Cobrança sob demanda (Perfeito para Lab/Testes - Grátis se não usar muito)
  billing_mode   = "PAY_PER_REQUEST"

  # Chave Primária (ID do Pedido)
  hash_key       = "id"

  # Definição do atributo da chave
  attribute {
    name = "id"
    type = "S" # S = String, N = Number
  }

  # Configuração de TTL (Opcional - limpa itens antigos automaticamente)
  # ttl {
  #   attribute_name = "TimeToExist"
  #   enabled        = true
  # }

  tags = local.common_tags
}

# Criação da Tabela DynamoDB para Pagamentos
resource "aws_dynamodb_table" "pagamentos" {
  # Nome da tabela (ex: fiap-g52-tc3-pagamentos)
  name           = "${var.resource_prefix}-pagamentos"

  # Cobrança sob demanda (Perfeito para Lab/Testes - Grátis se não usar muito)
  billing_mode   = "PAY_PER_REQUEST"

  # Chave Primária (ID do Pagamento)
  hash_key       = "id"

  # Definição do atributo da chave
  attribute {
    name = "id"
    type = "S" # S = String, N = Number
  }

  tags = local.common_tags
}