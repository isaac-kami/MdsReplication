output "MySqlSourceIP" {
  value = data.oci_core_vnic.MySqlOciVNICprimary.public_ip_address
}

