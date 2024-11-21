# Infrastructure

This directory descibes the infrastructure including VM instances, storage volume, and other resources as Code.
Terraform is used to describe the infrastructure.

## Deploy

1. Get OpenStack credentials
2. Adapt the terraform variables to your OpenStack instance. This project uses cloud.eodc.eu
3. Go to this directory and run the following shell commands:

```sh
export TF_VAR_application_credential_id=123
export TF_VAR_application_credential_secret=123456789
terraform init
terraform apply
```

## Access nodes

1. Import the ssh key pair from openstack to your local system
2. Run `ssh -J debian@fairsendd.eodchosting.eu debian@node1`
```

## Features

- gateway
    - NFS eo-storage01.eodc mounted at /data
    - nginx web server, default debian package
- node
    ⁻ NFS eo-storage01.eodc mounted at /data