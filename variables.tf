variable AWS_REGION {
    type = string
    default = "eu-north-1"
}

variable AWS_ACCESS_KEY {
  type = string
}

variable AWS_SECRET_KEY {
  type = string
}

variable BASE_NAME {
  type = string
  default = "2im-Demo"
}

variable VPC_CIDR {
  type = string
  default = "10.0.0.0/16"
}

variable PUBLIC_SUBNET_CIDR {
  type = string
  default = "10.0.10.0/24"
}


variable PRIVATE_SUBNET_CIDR {
  type = string
  default = "10.0.20.0/24"
}