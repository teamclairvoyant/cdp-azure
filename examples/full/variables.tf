variable "deployment_name_prefix" {
  default = "CDP1_"
}

variable "location" {
  description = "Azure Region for the resource group"
  default = "East US"
}

variable "vnet_cidr" {
  default = "10.0.0.0/16"
}

variable subnets {
  default = [
    {
      name           = "subnet1"
      address_prefix = "10.0.1.0/24"
      security_group = false
    }
  ]
}

variable "bucket_name" {
  default = "sre-cdp-test"
}

