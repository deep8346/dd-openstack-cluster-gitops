terraform {
  required_version = ">= 1.6.0"

  backend "local" {
    path = ".opentofu-local-dd-openstack-cluster/terraform.tfstate"
  }
}