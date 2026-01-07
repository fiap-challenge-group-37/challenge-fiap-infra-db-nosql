# Challenge FIAP - Infraestrutura NoSQL (DocumentDB)

Repositorio de infraestrutura Terraform para provisionamento de Amazon DocumentDB na AWS.

## Arquitetura

Este repositorio provisiona um cluster Amazon DocumentDB (compativel com MongoDB), seguindo a mesma proposta do [challenge-fiap-infra-db](https://github.com/fiap-challenge-group-52/challenge-fiap-infra-db):

- **Provisiona apenas a infraestrutura do banco** (cluster, instancias, security groups)
- **Nao cria collections/schemas** - isso fica a cargo das aplicacoes via ORM (Mongoose, Spring Data MongoDB, etc.)

### Recursos Provisionados

| Recurso | Descricao |
|---------|-----------|
| `aws_docdb_cluster` | Cluster DocumentDB |
| `aws_docdb_cluster_instance` | Instancia(s) do cluster |
| `aws_docdb_subnet_group` | Subnet group usando subnets do EKS |
| `aws_security_group` | Security group para acesso MongoDB (porta 27017) |
| `aws_docdb_cluster_parameter_group` | Parameter group com configuracoes do cluster |

## Pre-requisitos

- Terraform >= 1.5
- AWS CLI configurado
- Bucket S3 `bucket-s3-g52-tc3` existente (para backend)
- Infraestrutura Kubernetes provisionada ([challenge-fiap-infra-k8s](https://github.com/fiap-challenge-group-52/challenge-fiap-infra-k8s))

## Estrutura do Repositorio

```
.
├── .github/
│   └── workflows/
│       └── terraform-up.yaml   # Pipeline CI/CD
├── backend.tf                  # Backend remoto S3
├── data.tf                     # Data sources
├── locals.tf                   # Variaveis locais e tags
├── main.tf                     # Recursos DocumentDB
├── outputs.tf                  # Outputs exportados
├── provider.tf                 # Provider AWS
├── variables.tf                # Variaveis de entrada
├── terraform.tfvars            # Valores locais (nao versionado)
└── README.md                   # Documentacao
```

## Variaveis

| Variavel | Descricao | Padrao |
|----------|-----------|--------|
| `aws_region` | Regiao AWS | `us-east-1` |
| `resource_prefix` | Prefixo dos recursos | `fiap-g52-tc3` |
| `db_instance_class` | Classe da instancia | `db.t3.medium` |
| `db_instance_count` | Numero de instancias | `1` |
| `db_backup_retention_period` | Dias de retencao de backup | `7` |
| `db_port` | Porta do banco | `27017` |
| `db_username` | Usuario master | (obrigatorio) |
| `db_password` | Senha master | (obrigatorio) |
| `db_tls_enabled` | Habilitar TLS | `false` |

## Uso Local

```bash
# Inicializar Terraform
terraform init

# Validar configuracao
terraform validate

# Planejar alteracoes
terraform plan -var="db_username=admin" -var="db_password=sua_senha_segura"

# Aplicar alteracoes
terraform apply -var="db_username=admin" -var="db_password=sua_senha_segura"
```

## CI/CD

O pipeline GitHub Actions executa automaticamente em push para `main` ou manualmente via `workflow_dispatch`.

### Secrets Necessarios

| Secret | Descricao |
|--------|-----------|
| `AWS_ACCESS_KEY_ID` | Access Key AWS |
| `AWS_SECRET_ACCESS_KEY` | Secret Key AWS |
| `AWS_SESSION_TOKEN` | Token de sessao (opcional) |
| `AWS_DEFAULT_REGION` | Regiao padrao |
| `DOCDB_USERNAME` | Usuario master do DocumentDB |
| `DOCDB_PASSWORD` | Senha master do DocumentDB |

## Conexao da Aplicacao

### String de Conexao

```
mongodb://<username>:<password>@<endpoint>:27017/?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false
```

### Exemplo com Mongoose (Node.js)

```javascript
const mongoose = require('mongoose');

mongoose.connect(process.env.DOCDB_CONNECTION_STRING, {
  useNewUrlParser: true,
  useUnifiedTopology: true
});
```

### Exemplo com Spring Data MongoDB (Java)

```yaml
spring:
  data:
    mongodb:
      uri: ${DOCDB_CONNECTION_STRING}
```

## Outputs

| Output | Descricao |
|--------|-----------|
| `docdb_endpoint` | Endpoint do cluster (escrita) |
| `docdb_reader_endpoint` | Endpoint de leitura |
| `docdb_port` | Porta do cluster |
| `docdb_username` | Usuario master |
| `docdb_cluster_identifier` | Identificador do cluster |

## Relacionamento com Outros Repositorios

```
challenge-fiap-infra-k8s (EKS)
         │
         ├── challenge-fiap-infra-db (RDS MySQL)
         │
         └── challenge-fiap-infra-db-nosql (DocumentDB) ← Este repositorio
```

## Custos

DocumentDB com instancia `db.t3.medium`:
- **Instancia**: ~$0.076/hora = ~$55/mes
- **Storage**: $0.10/GB-mes
- **I/O**: $0.20 por milhao de solicitacoes
- **Total estimado (1 instancia)**: ~$60-70/mes

**Nota**: AWS Academy pode ter limitacoes. Verifique os servicos disponiveis na sua conta.

## Links Uteis

- [Documentacao DocumentDB](https://docs.aws.amazon.com/documentdb/)
- [Terraform AWS Provider - DocumentDB](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/docdb_cluster)
- [Compatibilidade MongoDB](https://docs.aws.amazon.com/documentdb/latest/developerguide/mongo-apis.html)
