resource "oci_objectstorage_bucket" "mds_bucket" {
    
    # do not delete depends_on
    
    depends_on = [oci_identity_compartment.MySqlOciCompartment]

    compartment_id = oci_identity_compartment.MySqlOciCompartment.id
    name = var.name_bucket
    namespace = var.bucket_namespace
    storage_tier = "Standard"
}

