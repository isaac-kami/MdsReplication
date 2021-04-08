resource "oci_identity_compartment" "MySqlOciCompartment" {
    compartment_id = var.compartment_ocid
    description = "Compartment MySQL for VCN"
    name = "MySqlOciCompartment"
}
