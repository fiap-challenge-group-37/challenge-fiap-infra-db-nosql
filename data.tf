# =============================================================================
# DATA SOURCES
# Consumo do estado remoto do Kubernetes para integracao com a infraestrutura
# =============================================================================

data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = "bucket-s3-g52-tc3"
    key    = "fiap/k8s/terraform.tfstate"
    region = "us-east-1"
  }
}
