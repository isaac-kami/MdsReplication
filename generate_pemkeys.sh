#!/bin/bash

function create_folder() {
  mkdir -p /root/.oci
}

function generate_private_api_key() {
   openssl genrsa -out /root/.oci/oci_api_private_key.pem 2048
 }

function generate_public_api_key() {
   openssl rsa -pubout -in /root/.oci/oci_api_private_key.pem -out /root/.oci/oci_api_key_public.pem
}

function generate_fingerprint() {
openssl rsa -in ~/.oci/oci_api_private_key.pem -pubout -outform DER | \
openssl md5 -c  | \
sed s/\(stdin\)=\\s//g >> /root/.oci/oci_api_key_fingerprint
}


create_folder
generate_private_api_key
generate_public_api_key
generate_fingerprint
