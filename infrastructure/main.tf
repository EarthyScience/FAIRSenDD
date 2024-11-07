terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

variable "application_credential_id" {
  type = string
}

variable "application_credential_secret" {
  type = string
}

variable "auth_url" {
  type    = string
  default = "https://cloud.eodc.eu:5000"
}

variable "region" {
  type    = string
  default = "RegionOne"
}

variable "floating_ip" {
  type        = string
  description = "Public gateway IP"
  default     = "193.171.117.119"
}

variable "key_pair" {
  type        = string
  default     = "id_ecdsa_key1_fairsendd_eodc"
  description = "name of SSH key pair to log in to the VMs"
}

variable "flavor_small" {
  description = "openstack flavor ID using less ressources"
  default     = "b3164b6a-0bc7-4a62-b586-438cdb05a0b2" # 4vCPUs_8GB_RAM @ cloud.eodc.eu
}

variable "flavor_big" {
  description = "openstack flavor ID using most ressorces"
  default     = "f2b75eb6-af92-4cf0-86e4-873e097597a0" # 32vCPUs_96GB_RAM @ cloud.eodc.eu
}

variable "internal_network" {
  type    = string
  default = "fairsendd-network-ca568b8"
}

data "template_cloudinit_config" "init_script" {
  part {
    content_type = "text/cloud-config"
    content      = file("cloudinit.yml")
  }
}

provider "openstack" {
  application_credential_id     = var.application_credential_id
  application_credential_secret = var.application_credential_secret
  auth_url                      = var.auth_url
  region                        = var.region
}

resource "openstack_compute_instance_v2" "gateway" {
  name            = "gateway"
  image_id        = "7c2a5f8f-e563-41f8-b09d-e187bdffff3a" # EODC_Debian11_RC_v2.0.15
  flavor_id       = var.flavor_small
  key_pair        = var.key_pair
  security_groups = ["default"]

  network {
    name = var.internal_network
  }
}

resource "openstack_compute_instance_v2" "node1" {
  name            = "node1"
  image_id        = "7c2a5f8f-e563-41f8-b09d-e187bdffff3a" # EODC_Debian11_RC_v2.0.15
  flavor_id       = var.flavor_big
  key_pair        = var.key_pair
  user_data       = data.template_cloudinit_config.init_script.rendered
  security_groups = ["default"]

  network {
    name = var.internal_network
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc_1" {
  floating_ip = var.floating_ip
  instance_id = openstack_compute_instance_v2.gateway.id
}
