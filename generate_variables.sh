#!/bin/sh


 TENANCY=$(oci iam compartment list --access-level ACCESSIBLE |\
 grep -i tenancy | \
 awk 'NR==1{print $2}' | \
 sed -e 's/,//g' -e 's/"//g')


 var_username=$(whoami)

 var_bucket=$( oci os ns get | \
 awk 'NR==2{print $2}' | \
 sed 's/"//g')

var_tenancy_ocid=$( oci iam compartment list --access-level ACCESSIBLE |\
grep -i tenancy | \
awk 'NR==1{print $2}' | \
sed -e 's/,//g' -e 's/"//g')

var_ad_mds=$(oci iam availability-domain list | \
jq .data[1].name | \
sed 's/"//g')

var_image_os=$(oci compute image list --all --output table --compartment-id $TENANCY | \
grep "Canonical-Ubuntu-20.04-2021.01.25-0" | \
awk {'print $16'})


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
variable \"ssh_public_key_path\" {
   default = \"/home/$var_username/.ssh/id_rsa.pub\"
}
" >> variables.tf

}

function private_key_path() {

echo "
variable \"ssh_private_key_path\" {
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

function ad_mds() {

echo "
variable \"mysql_db_system_availability_domain\" {
   default = \"$var_ad_mds\"
}
" >> variables.tf

}


function image_os() {
echo "
variable \"instance_image\" {
   default = \"$var_image_os\"
}
" >> variables.tf
}

message
create_compartment_variable
public_key_path
private_key_path
bucket_namespace
ad_mds
image_os
