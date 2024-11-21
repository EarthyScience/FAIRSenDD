terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

provider "openstack" {
  application_credential_id     = var.application_credential_id
  application_credential_secret = var.application_credential_secret
  auth_url                      = var.auth_url
  region                        = var.region
}

# Variables

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

variable "default_image_id" {
  type        = string
  description = "id of image debian-12-genericcloud-amd64-20241004-1890"
  default     = "0a9ce0a0-2c53-49aa-b73d-8aa6a042dd7a"
}

variable "external_network_id" {
  type    = string
  default = "652e477b-b96f-4ad6-8c10-ea4fb0e9030a" # public1
}

# Network

resource "openstack_networking_network_v2" "network" {
  name = "fairsendd"
}

resource "openstack_networking_subnet_v2" "subnet" {
  network_id = openstack_networking_network_v2.network.id
  cidr       = "10.10.29.0/24"
  ip_version = 4
  gateway_ip = "10.10.29.1"
}

resource "openstack_networking_router_v2" "router" {
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}


resource "openstack_compute_floatingip_associate_v2" "fip_assoc_1" {
  floating_ip = var.floating_ip
  instance_id = openstack_compute_instance_v2.gateway.id
}


# VM instances

resource "openstack_compute_instance_v2" "gateway" {
  name            = "gateway"
  image_id        = var.default_image_id
  flavor_id       = var.flavor_small
  key_pair        = var.key_pair
  security_groups = ["default"]

  network {
    uuid = openstack_networking_network_v2.network.id
  }
}
