
data "oci_objectstorage_bucket" "bucketstuff" {
   name = var.name_bucket
   namespace = var.bucket_namespace
} 

data "oci_core_services" "mysql_services" {
}



resource "oci_core_service_gateway" "bucket_SVG" {
    compartment_id = oci_identity_compartment.MySqlOciCompartment.id
    services {
        service_id = data.oci_core_services.mysql_services.services.1.id
    }
    vcn_id = oci_core_virtual_network.MySqlOciVCN.id

    display_name = "mysql service gateway"
}

#resource "oci_core_route_table" "examplebucket_route" {

    #compartment_id = oci_identity_compartment.MySqlOciCompartment.id
   # vcn_id = oci_core_virtual_network.MySqlOciVCN.id
    
    
 #  route_rules {
 #        cidr_block        = "0.0.0.0/0"
 #        network_entity_id = oci_core_internet_gateway.MySqlOciInternetGateway.id
 #    }

 #  route_rules    {
 #       destination =  lookup(data.oci_core_services.mysql_services.services[1],"cidr_block")
 #       destination_type = "SERVICE_CIDR_BLOCK"
 #       network_entity_id = oci_core_service_gateway.bucket_SVG.id
 #      }

#}
