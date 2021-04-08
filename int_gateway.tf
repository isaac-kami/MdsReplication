resource "oci_core_internet_gateway" "MySqlOciInternetGateway" {
  compartment_id = oci_identity_compartment.MySqlOciCompartment.id
  display_name = "MySqlOciInternetGateway"
  vcn_id = oci_core_virtual_network.MySqlOciVCN.id
}

