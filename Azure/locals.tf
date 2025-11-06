locals {
    
    # Hub Local Variables
  prefix-hub         = "hub"
  hub-location="eastus"
  hub-resource-group="hub-rg-test"
  hub-address="10.0.0.0/16"
  hub-gateway-subnet-address="10.0.255.224/27"
  hub-mgmt-address="10.0.0.64/27"
  hub-dmz-address="10.0.0.32/27"

# NVA  Local Variables
  prefix-hub-nva         = "hub-nva"
  hub-nva-location       = "eastus"
  hub-nva-resource-group = "hub-nva-rg"
  hub-nva-nic-private_ip_address="10.0.0.36"

    # Spoke1 Local Variables
  prefix-spoke1         = "spoke1"
    spoke1-location       = "eastus"
  spoke1-resource-group = "spoke1-vnet-rg"
    spoke1-address="10.1.0.0/16"
  spoke1-mgmt-address="10.1.0.64/27"
  spoke1-workload-address="10.1.1.0/24"


    # Spoke2 Local Variables
  prefix-spoke2         = "spoke2"
    spoke2-location       = "eastus"
  spoke2-resource-group = "spoke2-vnet-rg"
    spoke2-address="10.2.0.0/16"
  spoke2-mgmt-address="10.2.0.64/27"
  spoke2-workload-address="10.2.1.0/24"
}