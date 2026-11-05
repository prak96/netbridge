
locals {
  my_tags = {
    "project" = "netBridge"
    "usedBy"  = "tf"
  }

   my_locations = [
    "eastus",
    "westus",
    "eastasia",
    "centralus"
  ]
}

variable "rg_location" {
  type = string
  description = "Enter the LOCATION of Resource Group"

  validation {
    condition = contains(local.my_locations, lower(trimspace(var.rg_location)))
                                              ### " east asia " --> Input will NOT BE TAKEN as valid AZURE LOCATION since 'replace()' function is not used to remove [" "] as depicted below 
    
    error_message = "Enter only these LOCATIONS from list"
  }
}

variable "vpn_location" {
  type = string
  description = "Enter the LOCATION of Resource Group"

  validation {
    condition = contains(local.my_locations, lower(replace(trimspace(var.vpn_location), " ", "")))
    error_message = "Enter only these LOCATIONS from list"
  }
}



variable "vnet1-cidr" {
  type        = string
  description = "Enter the CIDR for VNET"
}

variable "vnet2-cidr" {
  type        = string
  description = "Enter the CIDR for VNET"
}

variable "gateway-cidr" {
  type = string
  description = "Enter the CIDR for local Gateway"
}





variable "env_names" {
  type        = list(string)
  description = "Enter the environment names"
}


# variable "win-username" {
#   type = string
#   description = "Enter VM Username"
# }

variable "win-password" {
  type = string
  description = "Enter VM Password"
}

variable "osDisk" {
  type = number
  description = "Enter Disk Size"
  validation {
    condition = var.osDisk >= 127
    error_message = "OS Disk size must be GREATER THAN or EQUAL to 127GB"
  }
}


