resource "oci_core_security_list" "MySqlOciSecurityList" {

  compartment_id = oci_identity_compartment.MySqlOciCompartment.id

  display_name = "MySqlOciSecurityList"

  vcn_id = oci_core_virtual_network.MySqlOciVCN.id

  egress_security_rules {
    stateless = false
    protocol = "6"
    destination = "0.0.0.0/0"
 }

   # apply ingress tcp rules for each port
   # of variable portz

   dynamic "ingress_security_rules" {
    for_each = toset(var.portz)
      content {
        protocol = "6"
        source = "0.0.0.0/0"
        tcp_options {
           max = ingress_security_rules.value
           min = ingress_security_rules.value
       }
    }
  }


}

