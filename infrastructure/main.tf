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
  name = "router"
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

data "template_cloudinit_config" "init_script_gateway" {
  part {
    content_type = "text/cloud-config"
    content      = file("gateway/cloud-init.yml")
  }
}

data "template_cloudinit_config" "init_script_app" {
  part {
    content_type = "text/cloud-config"
    content      = file("app/cloud-init.yml")
  }
}

data "template_cloudinit_config" "init_script_node" {
  part {
    content_type = "text/cloud-config"
    content      = file("node/cloud-init.yml")
  }
}

data "template_cloudinit_config" "init_script_runner" {
  part {
    content_type = "text/cloud-config"
    content      = file("runner/cloud-init.yml")
  }
}

resource "openstack_compute_instance_v2" "gateway" {
  name            = "gateway"
  image_id        = var.default_image_id
  flavor_id       = var.flavor_small
  key_pair        = var.key_pair
  security_groups = ["default"]
  user_data       = data.template_cloudinit_config.init_script_gateway.rendered

  network {
    uuid        = openstack_networking_network_v2.network.id
    fixed_ip_v4 = "10.10.29.10"
  }
}

resource "openstack_compute_instance_v2" "app" {
  name            = "app"
  image_id        = var.default_image_id
  flavor_id       = var.flavor_small
  key_pair        = var.key_pair
  security_groups = ["default"]
  user_data       = data.template_cloudinit_config.init_script_app.rendered

  network {
    uuid        = openstack_networking_network_v2.network.id
    fixed_ip_v4 = "10.10.29.11"
  }
}

resource "openstack_compute_instance_v2" "runner" {
  name            = "runner"
  image_id        = var.default_image_id
  flavor_id       = var.flavor_bigger
  key_pair        = var.key_pair
  security_groups = ["default"]
  user_data       = data.template_cloudinit_config.init_script_runner.rendered

  network {
    uuid        = openstack_networking_network_v2.network.id
    fixed_ip_v4 = "10.10.29.12"
  }
}

resource "openstack_compute_instance_v2" "node1" {
  name            = "node1"
  image_id        = var.default_image_id
  flavor_id       = var.flavor_big
  key_pair        = var.key_pair
  security_groups = ["default"]
  user_data       = data.template_cloudinit_config.init_script_node.rendered

  network {
    uuid        = openstack_networking_network_v2.network.id
    fixed_ip_v4 = "10.10.29.21"
  }
}

# Volumes

resource "openstack_blockstorage_volume_v3" "data" {
  region      = "RegionOne"
  name        = "data"
  description = "data to store files generated by the workflow"
  size        = 550
}

resource "openstack_compute_volume_attach_v2" "data_node1" {
  instance_id = openstack_compute_instance_v2.node1.id
  volume_id   = openstack_blockstorage_volume_v3.data.id
  device      = "/dev/vdc"
}

resource "openstack_blockstorage_volume_v3" "runner" {
  region      = "RegionOne"
  name        = "runner"
  description = "working directory for github runner"
  size        = 128
}

resource "openstack_compute_volume_attach_v2" "runner_runner" {
  instance_id = openstack_compute_instance_v2.runner.id
  volume_id   = openstack_blockstorage_volume_v3.runner.id
  device      = "/dev/vdc"
}
