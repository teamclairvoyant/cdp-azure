##   Terraform to set up a VNET for CDP w/ CCM (Private IPs) enabled
##   michael.arnold@clairvoyantsoft.com

## This TF will create the following artifacts
## 1x VNET (with the CIDR specified in the variable VNET_CIDR)

# if you want the generated artifacts to have a prefix to their name, then
# specify it here or use the -var argument on the command line

####
#### VARIABLES GO HERE
####
variable "PREFIX" {
  description = "Prefix for names of created objects (e.g. CDPPOC_)"
  default = ""
}

variable "RG" {}
variable "LOCATION" {
  description = "Azure Region for the resource group"
}

# You can change the default VNET CIDR here - its 10.0.0.0/16 by default
# We will be dividing this CIDR into 6 equal size subnets
variable "VNET_CIDR" {
  description = "The CIDR block for the VNET, e.g: 10.0.0.0/16"
  type = string
  default = "10.0.0.0/16"
}

variable subnets {
  type = list(object({
    name           = string,
    address_prefix = string,
    security_group = bool
  }))
  description = "(Optional) Creates the given subnets in the VNET"
  default     = []
}

## The VNET has an internet gateway and DNS options enabled
resource "azurerm_virtual_network" "the_vnet" {
  name                = "${var.PREFIX}cdp-vnet"
  location            = var.LOCATION
  resource_group_name = var.RG
  address_space       = [var.VNET_CIDR]

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = "${var.PREFIX}${subnet.value.name}"
      address_prefix = subnet.value.address_prefix
    }
  }

  tags = {
    Name = "${var.PREFIX}cdp-vnet"
  }
}

