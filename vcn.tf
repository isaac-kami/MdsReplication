resource "oci_core_virtual_network" "MySqlOciVCN" {
  cidr_blocks = var.cidrblockz
  compartment_id = oci_identity_compartment.MySqlOciCompartment.id
  display_name = "MySqlOciVCN"

  # for dns
 
  dns_label = "MySqlOciVCN"
}
