
locals {
  my_tags = {
    "project" = "netBridge"
    "usedBy"  = "tf"
  }
}

variable "vnet-cidr" {
  type        = string
  description = "Enter the CIDR for VNET"
}

variable "env_names" {
  type        = list(string)
  description = "Enter the environment names"
}