
# for mysql  mds

variable "private_IP"{
  default="10.0.1.5"
}

variable "mysql_db_system_admin_password" {
  default="ABCabc123$%"
}

variable "mysql_db_system_admin_username" {
  default = "usermds"
}

variable "mysql_shape_name" {
  default = "MySQL.VM.Standard.E3.1.8GB"
}

variable "mysql_storage" {
  default = 50
}

#for vcn block

variable "cidrblockz" {
  type = list(string)
  default = ["10.0.0.0/16"]
}

#for subnet

variable "cidrsubnet" {
  default = "10.0.1.0/24"
}

variable "cidrinstancesubnet" {
  default = "10.0.2.0/24"
}

# for ingress


variable "cidr_ingress" {
  default = "10.0.0.0/16"
}

# for security list

variable "portz" {
 default = [22,3306,3307,33060]
}

## for instance

variable "instance_name" {
  default = "MySqlShellInstance"
}

variable "instance_shape" {
  default = "VM.Standard.E2.1"
}




### for channel

variable "instance_passwd" {
  default = "Str0nkPa$$wd"
}


variable "instance_user" {
  default = "replicauser"
}
variable "source_port" {
  default = "3307"
}


variable "ssl_status" {
  default = "DISABLED"
}

# for fqdn 
# gather data as:
# hostname + mysql dns label + mysql oci vcn + oraclevcn.com

variable "fqdn" {
  default = "mysqlshellinstance.mysqlinstance.mysqlocivcn.oraclevcn.com"
}

## for bucket
variable  "name_bucket"{
  default = "mdsbucket"
} 


