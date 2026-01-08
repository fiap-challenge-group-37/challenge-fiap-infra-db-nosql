# =============================================================================
# DATA SOURCES
# Consumo do estado remoto do Kubernetes para integracao com a infraestrutura
# =============================================================================

data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = "bucket-s3-g37-tc4"
    key    = "fiap/k8s/terraform.tfstate"
    region = "us-east-1"
  }
}
