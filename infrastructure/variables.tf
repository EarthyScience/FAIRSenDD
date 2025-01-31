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

variable "flavor_middle" {
  description = "openstack flavor ID using less ressources"
  default     = "1b9963ec-b541-4532-964c-7668b3dee679" # 	8vCPUs_8GB_RAM @ cloud.eodc.eu
}

variable "flavor_bigger" {
  description = "openstack flavor ID using less ressources"
  default     = "f416deda-3fc8-47f6-886f-49b4824384c2" # 	16vCPUs_32GB_RAM @ cloud.eodc.eu
}


variable "flavor_big" {
  description = "openstack flavor ID using most ressorces"
  default     = "f2b75eb6-af92-4cf0-86e4-873e097597a0" # 32vCPUs_96GB_RAM @ cloud.eodc.eu
}

variable "default_image_id" {
  type        = string
  description = "id of default instance image"
  default     = "0a9ce0a0-2c53-49aa-b73d-8aa6a042dd7a" # debian-12-genericcloud-amd64-20241004-1890 @ cloud.eodc.eu
}
