#!/bin/sh


var_username=$(whoami)

var_bucket=$( oci os ns get | \
 awk 'NR==2{print $2}' | \
 sed 's/"//g')

var_tenancy_ocid=$( oci iam compartment list --access-level ACCESSIBLE |\
grep -i tenancy | \
awk 'NR==1{print $2}' | \
sed -e 's/,//g' -e 's/"//g')



function message() {

echo "### variables added with generate_variables.sh script" >> variables.tf

}

function create_compartment_variable() {

 echo "
variable \"compartment_ocid\" {
     default = \"$var_tenancy_ocid\"
}
" >> variables.tf

}

function public_key_path(){

echo "
variable \"public_ssh\" {
   default = \"/home/$var_username/.ssh/id_rsa.pub\"
}
" >> variables.tf

}

function private_key_path() {

echo "
variable \"private_key_path\" {
   default = \"/home/$var_username/.ssh/id_rsa\"
}
" >> variables.tf

}

function bucket_namespace() {
echo "
variable \"bucket_namespace\" {
   default = \"$var_bucket\"
}
" >> variables.tf
}

message
create_compartment_variable
public_key_path
private_key_path
bucket_namespace

