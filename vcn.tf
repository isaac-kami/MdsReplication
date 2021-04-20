resource "oci_core_virtual_network" "MySqlOciVCN" {
  
  depends_on = [oci_identity_compartment.MySqlOciCompartment]
  
  cidr_blocks = var.cidrblockz
  compartment_id = oci_identity_compartment.MySqlOciCompartment.id
  display_name = "MySqlOciVCN"

  dns_label = "MySqlOciVCN"
}
