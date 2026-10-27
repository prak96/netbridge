
locals {
  my_tags = {
    "project" = "netBridge"
    "usedBy"  = "tf"
  }
}

variable "vnet-cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Enter the CIDR for VNET"
}
