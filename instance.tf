resource "oci_core_instance" "MySqlOciInstance" {

    availability_domain = var.mysql_db_system_availability_domain

    shape = var.instance_shape

    compartment_id = oci_identity_compartment.MySqlOciCompartment.id

    source_details {
        source_id = var.instance_image
        source_type = "image"
    }

    display_name = var.instance_name

    metadata = {
        ssh_authorized_keys = file(var.public_ssh)
    }
   
    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_subnet.MySqlInstanceSubnet.id
    }

}
