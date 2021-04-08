

resource "oci_mysql_channel" "MySqlOciChannel" {

    source {
        hostname = var.fqdn
        password = var.instance_passwd
        source_type = "MYSQL"
        ssl_mode = var.ssl_status
        username = var.instance_user

        port = var.source_port
    }

    target {

        db_system_id = oci_mysql_mysql_db_system.mysql_create.id
        target_type = "DBSYSTEM"

    }

    compartment_id = oci_identity_compartment.MySqlOciCompartment.id
    is_enabled = "true"
}
