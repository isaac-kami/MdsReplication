resource "oci_core_subnet" "MySqlInstanceSubnet"{

  cidr_block = var.cidrinstancesubnet
  compartment_id = oci_identity_compartment.MySqlOciCompartment.id
  vcn_id = oci_core_virtual_network.MySqlOciVCN.id

  display_name = "MySqlInstanceSubnet"
  

  security_list_ids = [oci_core_security_list.MySqlOciSecurityList.id]


  route_table_id = oci_core_route_table.MySqlOciRouteTable.id
  
  dhcp_options_id = oci_core_dhcp_options.MySqlOciDHCPOptions.id
  
  dns_label = "MySqlInstance"
}
