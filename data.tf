## for MDS

data "oci_mysql_mysql_configurations" "mysql_shape" {

 compartment_id = oci_identity_compartment.MySqlOciCompartment.id
 display_name = "MySQL OCI Terraform"

 shape_name = var.mysql_shape_name
 type = ["DEFAULT"]

}

## for instance on which MySQL is installed

# get a list of vnic attachments

 data "oci_core_vnic_attachments" "MySqlOciVNICs" {

       compartment_id = oci_identity_compartment.MySqlOciCompartment.id
       availability_domain = var.mysql_db_system_availability_domain
       instance_id = oci_core_instance.MySqlOciInstance.id

  }

# get the primary VNIC ID

  data "oci_core_vnic" "MySqlOciVNICprimary" {
     vnic_id = lookup(data.oci_core_vnic_attachments.MySqlOciVNICs.vnic_attachments[0], "vnic_id")

  }


## for MDS channel

# data "oci_mysql_channel" "MySqlOciChannel" {
#    channel_id = oci_mysql_channel.MySqlOciChannel.id
#}

