#!/bin/sh


 TENANCY=$(oci iam compartment list --access-level ACCESSIBLE |\
 grep -i tenancy | \
 awk 'NR==1{print $2}' | \
 sed -e 's/,//g' -e 's/"//g')

 sleep 3

 var_username=$(whoami)

 var_bucket=$( oci os ns get | \
 awk 'NR==2{print $2}' | \
 sed 's/"//g')

var_tenancy_ocid=$( oci iam compartment list --access-level ACCESSIBLE |\
grep -i tenancy | \
awk 'NR==1{print $2}' | \
sed -e 's/,//g' -e 's/"//g')

var_ad_mds=$(oci iam availability-domain list | \
jq .data[0].name | \
sed 's/"//g')

#var_image_os=$(oci compute image list --all --output table --compartment-id $TENANCY | grep "Canonical-Ubuntu-20.04-2021.01.25-0"  | awk {'print $16'})
var_image_os=$(oci compute image list --all --output table --compartment-id $TENANCY | grep "Canonical-Ubuntu-20.04-2021.03.25-0" | awk {'print $16'})


function message() {

echo "### variables added with generate_variables.sh script" 

}

function create_compartment_variable() {

 echo "
variable \"compartment_ocid\" {
     default = \"$var_tenancy_ocid\"
}
" 

}

function public_key_path(){

echo "
variable \"ssh_public_key_path\" {
   default = \"/home/$var_username/.ssh/id_rsa.pub\"
}
" 

}

function private_key_path() {

echo "
variable \"ssh_private_key_path\" {
   default = \"/home/$var_username/.ssh/id_rsa\"
}
" 

}

function bucket_namespace() {
echo "
variable \"bucket_namespace\" {
   default = \"$var_bucket\"
}
" 
}

function ad_mds() {

echo "
variable \"mysql_db_system_availability_domain\" {
   default = \"$var_ad_mds\"
}
"

}


function image_os() {
echo "
variable \"instance_image\" {
   default = \"$var_image_os\"
}
" 
}

message
create_compartment_variable
public_key_path
private_key_path
bucket_namespace
ad_mds
image_os
