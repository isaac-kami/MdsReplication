[ For step 6 ]

<br>

You will need to configure OCI CLI (along with .pem keys) on mysqlshellinstance host in order to perform data transfer to Object Storage

The following steps are based on the Official Documentation <a href="https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#Required_Keys_and_OCIDs">Required Keys and OCIDs</a>

<b> Prerequisites: </b>

From Cloud-Shell, run the following commands for finding out:

a) Tenancy OCID (saved as an environment variable):
```
zack@cloudshell:~ (eu-frankfurt-1)$ TENANCY=$(oci iam compartment list --access-level ACCESSIBLE | grep -i tenancy | awk 'NR==1{print $2}' | sed -e 's/,//g' -e 's/"//g')
zack@cloudshell:~ (eu-frankfurt-1)$ 
zack@cloudshell:~ (eu-frankfurt-1)$ echo $TENANCY
ocid1.tenancy.oc1..aaaaaaaahereisyourtenancyOCID
```
b) User OCID

```
zack@cloudshell:~ (eu-frankfurt-1)$  oci iam user list --compartment-id $TENANCY --query "data[?contains(\"id\",'user')].id | [0]" | sed 's/"//g'
ocid1.user.oc1..aaaaaaaahereisyouruserOCID
```

<i> These details details (tenancy OCID and User OCID) will be required when performing the OCI CLI configuration. </i>


6.1. Log in to mysqlshellinstance:

```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ terraform output
MySqlSourceIP = 129.159.196.152
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ ssh ubuntu@129.159.196.152
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)
[... snip ...]
ubuntu@mysqlshellinstance:~$ 
ubuntu@mysqlshellinstance:~$ sudo -i
root@mysqlshellinstance:~# 
```
... and download & install.sh script: 

```
root@mysqlshellinstance:~# bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

```

<b> Steps 6.2, 6.3, 6.4, 6.5 are automated with the help of script generate_pemkeys.sh. This script must be run from mysqlshellinstance. </b>
    
 ```
root@mysqlshellinstance:~# cd /home
root@mysqlshellinstance:/home# wget https://raw.githubusercontent.com/isaac-kami/MdsReplication/main/generate_pemkeys.sh
```
```
root@mysqlshellinstance:/home# chmod +x generate_pemkeys.sh 
root@mysqlshellinstance:/home# ./generate_pemkeys.sh 
```
```
root@mysqlshellinstance:/home# ls -ltr /root/.oci/
total 12
-rw------- 1 root root 1675 Apr 17 10:02 oci_api_private_key.pem
-rw-r--r-- 1 root root  451 Apr 17 10:02 oci_api_key_public.pem
-rw-r--r-- 1 root root   48 Apr 17 10:02 oci_api_key_fingerprint
 ```
 
 <b> From here, go to Step 6.7 </b>

6.2. Create folder /root/.oci, where the OCI configuration will be added:

```
root@mysqlshellinstance:~# mkdir -p /root/.oci/
root@mysqlshellinstance:~# cd ~/.oci
root@mysqlshellinstance:~/.oci#
```

6.3. Generate API private key:
```
root@mysqlshellinstance:~/.oci# openssl genrsa -out ~/.oci/oci_api_private_key.pem 2048
```
6.4. Generate API public key
```
root@mysqlshellinstance:~/.oci#  openssl rsa -pubout -in /root/.oci/oci_api_private_key.pem -out /root/.oci/oci_api_key_public.pem 

```
6.5. Generate Fingerprint

```
root@mysqlshellinstance:~/.oci# openssl rsa -in ~/.oci/oci_api_private_key.pem -pubout -outform DER | \
openssl md5 -c  | \
sed s/\(stdin\)=\\s//g > oci_api_key_fingerprint 

```
6.6. Check if files were successfully created:

```
root@mysqlshellinstance:~/.oci# ls -ltr
total 12
-rw------- 1 root root 1679 Apr  8 15:20 oci_api_private_key.pem
-rw-r--r-- 1 root root  451 Apr  8 15:21 oci_api_key_public.pem
-rw-r--r-- 1 root root   48 Apr  8 15:22 oci_api_key_fingerprint
root@mysqlshellinstance:~/.oci# 
```
6.7.  Add API RSA public key to OCI User

```
root@mysqlshellinstance:~/.oci#  more oci_api_key_public.pem
-----BEGIN PUBLIC KEY-----
MII=============================================================
=============================================================Vm6
gfl=============================================================
=============================================================S7u
SQX=============================================================
=============================================================zIX
yQ=====
-----END PUBLIC KEY-----

```

a) Copy the content, and go to OCI UI > Menu > Identity > Users:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/10.png)

b) Select your User, and go down the page. Select API Keys > Add API Keys, and then paste the content:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/11.png)


6.8. Setup configuration file for OCI:

```
root@mysqlshellinstance:~/.oci# /root/bin/oci setup config
```

You will have to provide here the Tenancy OCID and User OCID we have mentioned earler.

Possible output:
```
    This command provides a walkthrough of creating a valid CLI config file.

    The following links explain where to find the information required by this
    script:

    User API Signing Key, OCID and Tenancy OCID:

        https://docs.cloud.oracle.com/Content/API/Concepts/apisigningkey.htm#Other

    Region:

        https://docs.cloud.oracle.com/Content/General/Concepts/regions.htm

    General config documentation:

        https://docs.cloud.oracle.com/Content/API/Concepts/sdkconfig.htm


Enter a location for your config [/root/.oci/config]: 
Enter a user OCID: <you add here USER OCID>
Enter a tenancy OCID: <you add here TENANCY OCID>
Enter a region by index or name(e.g.
1: ap-chiyoda-1, 2: ap-chuncheon-1, 3: ap-hyderabad-1, 4: ap-melbourne-1, 5: ap-mumbai-1,
6: ap-osaka-1, 7: ap-seoul-1, 8: ap-sydney-1, 9: ap-tokyo-1, 10: ca-montreal-1,
11: ca-toronto-1, 12: eu-amsterdam-1, 13: eu-frankfurt-1, 14: eu-zurich-1, 15: me-dubai-1,
16: me-jeddah-1, 17: sa-santiago-1, 18: sa-saopaulo-1, 19: uk-cardiff-1, 20: uk-gov-cardiff-1,
21: uk-gov-london-1, 22: uk-london-1, 23: us-ashburn-1, 24: us-gov-ashburn-1, 25: us-gov-chicago-1,
26: us-gov-phoenix-1, 27: us-langley-1, 28: us-luke-1, 29: us-phoenix-1, 30: us-sanjose-1): 13
Do you want to generate a new API Signing RSA key pair? (If you decline you will be asked to supply the path to an existing key.) [Y/n]: n
Enter the location of your API Signing private key file: /root/.oci/oci_api_private_key.pem

Config written to /root/.oci/config
[ ... snip ... ]

```

6.9. Check if config file was created under /root/.oci/ folder:
```
root@mysqlshellinstance:~/.oci# ls -ltr /root/.oci/config
-rw------- 1 root root 306 Apr  8 15:26 /root/.oci/config
```
6.10. Call OCI CLI tool without full path:
```
root@mysqlshellinstance:~/.oci# echo 'export PATH="$PATH:/root/.oci/"' >> ~/.bashrc 
root@mysqlshellinstance:~/.oci# source ~/.bashrc
root@mysqlshellinstance:~/.oci#  oci -v
2.22.2
```

6.11. Perform a small test:
```
root@mysqlshellinstance:~/.oci# oci os ns get
{
  "data": "s0meDatahere"
}

```
