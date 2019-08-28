# mediawiki

This repository consist of files to deploy Mediawiki on K8S cluster running on top of GCE instance. Repo contains two directories 'tf' and 'mediawiki'.
1) 'tf' dir contains terraform files to launch GCE instances / firewall rules and configure k8s cluster.
2) 'mediawiki' dir contains necessary files to deploy Mediawiki app over K8S.
3) Dockerfile: to create docker image of Mediawiki.

Contents of 'mediawiki' are being copied while launching infrastructure using Terraform. In order to create and deploy Mediawiki, follow steps below:

1) Set up workstation
- Install Terraform /gcloud utilities. These are required to create infra over GCP.
- Create SSH keypair using below commands. SSH keypair is required as input in Terraform to copy files and allow SSH access to launched GCE instance.

2) Clone the repository

3) Prepare input file to Terraform. Refer tf/myinfra.tfvars file and replace with your values.

- ssh_user : This is SSH user name.
- ssh_private_key: This is SSH private key file path. This file gets used to authenticate while coping files.
- ssh_ip_ranges: This is to restrict SSH access to set of IPs. If not sure, set it as: 0.0.0.0/0
- metadata: This is added as metadata to GCE instance. Format should be like:    
`{ ssh-keys = "<SSH-USERNAME>": <CONTENTS OF SSH PUBLIC KEY FILE> <SSH-USERNAME>@<SOME DOMAIN>`

4) Login to GCP and set google project name.
- `$ gcloud auth application-default login`
- `$ export GOOGLE_PROJECT=$(gcloud config get-value project)`

5) Launch stack
- `$ terraform init`
- `$ terraform plan --var-file="myinfra.tfvars"`
- `$ terraform apply --var-file="myinfra.tfvars"`

6) Note down public ip from output of above command. SSH to this instance using specified private key. Execute below commands after login.
- `$ tar -xzf /tmp/mediawiki-0.1.0.tar.gz`
- `$ bash appdeploy.sh`

7) Access Mediawiki application over mentioned URL in output.