resource "oci_core_dhcp_options" "MySqlOciDHCPOptions" {

  compartment_id = oci_identity_compartment.MySqlOciCompartment.id
  vcn_id = oci_core_virtual_network.MySqlOciVCN.id
  display_name = "MySqlDHCPOptions"

  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  options {
    type = "SearchDomain"
    search_domain_names = ["mysqldboci.com"]
  }

 }

