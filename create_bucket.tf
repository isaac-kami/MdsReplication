resource "oci_objectstorage_bucket" "mds_bucket" {

    compartment_id = oci_identity_compartment.MySqlOciCompartment.id
    name = var.name_bucket
    namespace = var.bucket_namespace
    storage_tier = "Standard"
}

