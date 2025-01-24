terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = ">= 3.7.0"
    }
  }
}

provider "grafana" {
  url  = "<>"
  auth = "${var.grafana_username}:${var.grafana_password}"
}

variable "grafana_username" {
  type        = string
  description = "Grafana Username"
  sensitive   = true
}

variable "grafana_password" {
  type        = string
  description = "Grafana Password"
  sensitive   = true
}
