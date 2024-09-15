terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = ">= 1.8.0"
    }
  }

}

provider "lxd" { 
}

