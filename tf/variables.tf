variable region {
  default = "us-west1"
}

variable azs {
  type    = "list"
  default = ["us-west1-a", "us-west1-b", "us-west1-c"]
}

provider google {
  region = "${var.region}"
}

variable network {
  default = "default"
}

variable master_prefix {
  default = "kube-master"
}

variable master_count {
  default = "1"
}

variable ssh_ip_ranges {
  type = "list"
}

variable ssh_user {
}

variable ssh_private_key {
}

variable metadata {
  description = "Metadata to be attached to the NAT gateway instance"
  type        = "map"
}
