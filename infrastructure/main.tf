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
