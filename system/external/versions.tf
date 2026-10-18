terraform {
  required_version = "~> 1.7"

  cloud {
    hostname     = "app.terraform.io"
    organization = "jnskt"

    workspaces {
      name = "homelab-system-external"
    }
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.26.0"
    }
  }
}

provider "kubernetes" {
  # Use KUBE_CONFIG_PATH environment variables
  # Or in cluster service account
}
