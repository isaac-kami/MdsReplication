# MySQL - MDS replication

<b> <i> Code adapted to be run from OCI Cloud-Shell </i> </b>

<i>This repository is for implementing and testing the possible steps for inbound replication in OCI with MySQL Service installed on an instance (the Source) and the MySQL Database System (the Target)</i>

<br>

Architecture that will be deployed with Terraform code:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/arch_channel1.jpg)

<br></br>
<b>Steps:</b>
<br></br>

## Part 1 
1. Generate ssh keys under your home directory. (these keys will be set as variables in variables.tf file )

Example:

```
zack@cloudshell:~ (eu-frankfurt-1)$ pwd 
/home/zack
zack@cloudshell:ExampleMySqlDbAndInstance (eu-frankfurt-1)$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/zack/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/zack/.ssh/id_rsa
Your public key has been saved in home/zack/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:
The key's randomart image is:
+---[RSA 3072]----+
|..oo..o o. .o    |
|oo o.  + ..o.E   |
|* . .   .o..  .  |
|o. . . . .o .    |
|. o o o S  .     |
|   o = . .       |
|  o . = . .      |
|.=.+o+.. o o .   |
|.+Oo.+o.. . o    |
+----[SHA256]-----+

zack@cloudshell:~ (eu-frankfurt-1)$ 
zack@cloudshell:~ (eu-frankfurt-1)$ $ ls /home/zack/.ssh/id*
id_rsa id_rsa.pub

```
<br></br>
2. Clone the repository:

```
zack@cloudshell:~ (eu-frankfurt-1)$ git clone  https://github.com/isaac-kami/MdsReplication.git
```
<br></br>
3. Change the corresponding variables from variables.tf file:

```
zack@cloudshell:~ (eu-frankfurt-1)$ cd MdsReplication
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ ls var*
variables.tf
```

<b> The following subpoints a), b) and c) are completely automated with the help of script generate_variables.sh </b>

```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ chmod +x generate_variables.sh
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ ./generate_variables.sh
```
Time of generating and adding to variables.tf file (give or take 1 or 2 seconds):
```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ time ./generate_variables.sh
 
 real    0m15.067s
 user    0m12.179s
 sys     0m1.519s
```

<b> After running the "generate_variables.sh" go to next step, Part2 - Step 4 </b>

a) Set up the generated ssh keys (private and public):

```
variable "ssh_public_key_path" {
  default = ""
}
```

```
variable "ssh_private_key_path" {
  default = ""
}
```

b) Add your OCID tenancy (this variable will be required for creation of child compartment, "MySqlOciCompartment"):

```
variable "compartment_ocid" {
  default = ""
}
```

You can find the OCID tenancy with the help of simple OCI command line:


```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$  oci iam compartment list --access-level ACCESSIBLE |\
grep -i tenancy | \
awk 'NR==1{print $2}' | \
sed -e 's/,//g' -e 's/"//g'
ocid1.tenancy.oc1..aaaaaaahereisyourtenancy
```


c) Provide namespace for the bucket:
```
variable "bucket_namespace" {
  default = ""
}
```

You can find the namespace of your bucket with oci command:

```
zack@cloudshell:~ (eu-frankfurt-1)$ oci os ns get
{
  "data": "s0meinf0h3re"
}
```

<br></br>
## Part 2

4. Perform the Terraform commands: 

```
terraform init
terraform plan
terraform apply
```
<br></br>
5. At this stage, the "terraform apply" will be:


- creating a VCN and compartment, with two subnets - private and public:
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/3vcn.png)  <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/4sub.png)

- creating an Internet Gateway
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/5ig.png)

- creating an Service Gateway
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/6sg.png)

- applying route rules for Service Gateway
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/7rules.png)

- deploying an OCI instance in a public subnet, with firewall rules for ports 22, 3306, 33060 and 3307
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/1ins.png) <br></br>
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/8ins_ingress.png)

- provisioning MySQL service and mysql-shell on OCI instance


- creating a MySQL DB System in a private subnet 
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/2db.png)

- creating an Object Storage
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/9object_storage.png)

<br></br>
## Part 3

6. As soon as the the environment is ready, setup OCI CLI Configuration on mysqlshellinstance.
 
More details at <a href="https://github.com/isaac-kami/MdsReplication/blob/main/OciCLI.md">OciCLI.md</a>

<i> Proceed with next steps as soon as Step 6 is properly implemented </i>
<br></br>

<br></br>


## Part 4

7. Channel creation:

[7.1]  Perform GTID purging

a) Dumping data from MySQL source into Bucket

Access MySQL client that is already configured on mysqlshellinstance:

```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ terraform output
MySqlSourceIP = 129.159.196.152
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ ssh ubuntu@129.159.196.152
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1035-oracle x86_64)
[... snip ...]
ubuntu@mysqlshellinstance:~$ 
ubuntu@mysqlshellinstance:~$ sudo -i
root@mysqlshellinstance:~# 
root@mysqlshellinstance:/home# mysql -uroot -pabc123!
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 14
Server version: 8.0.23-0ubuntu0.20.04.1 (Ubuntu)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```
... and create a new database and tablespace:
```

mysql> create database testexample;
Query OK, 1 row affected (0.01 sec)

mysql> create table testexample.exampletable (name varchar(20), firstname varchar(20));
Query OK, 0 rows affected (0.03 sec)

mysql> insert into testexample.exampletable (name, firstname) values ('Foster', 'Zack');
Query OK, 1 row affected (0.01 sec)

mysql> select * from testexample.exampletable;
+--------+-----------+
| name   | firstname |
+--------+-----------+
| Foster | Zack      |
+--------+-----------+
1 row in set (0.00 sec)

mysql> 

```
Dump data into bucket from mysql-shell with dumpInstance() utility:
```
root@mysqlshellinstance:/home# mysqlsh -uroot -pabc123!
MySQL Shell 8.0.23

[.... snip ....]

MySQL  localhost:33060+ ssl  JS > 
MySQL  localhost:33060+ ssl  JS >  util.dumpInstance("mdsobject", {osBucketName: "mdsbucket", osNamespace: "add here namespace", threads: 4, ocimds: true, compatibility: ["strip_restricted_grants"]})

```
Possible output:
```
[.... snip ....]
Writing DDL for table `testexample`.`exampletable`
Writing DDL for schema `testexample`
Preparing data dump for table `testexample`.`exampletable`
NOTE: Could not select a column to be used as an index for table `testexample`.`exampletable`. Chunking has been disabled for this table, data will be dumped to a single file.
Data dump for table `testexample`.`exampletable` will be written to 1 file
Running data dump using 4 threads.
NOTE: Progress information uses estimated values and may not be accurate.
1 thds dumping - ?% (1 rows / ?), 0.00 rows/s, 11.00 B/s uncompressed, 0.00 B/s compressed
Duration: 00:00:01s                                                                       
Schemas dumped: 1                                                                         
Tables dumped: 1 
[.... snip ....]
```

Check mdsbucket from OCI UI, and there should the following content:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/12.png)


Save the content of @.json file under a preferred location on host mysqlshellinstance:
![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/13.png)
```
root@mysqlshellinstance:/home# cat > @.json << EOF
> {
>     "dumper": "mysqlsh Ver 8.0.23 for Linux on x86_64 - for MySQL 8.0.23 (MySQL Community Server (GPL))",
>     "version": "1.0.2",
>     "origin": "dumpInstance",
>     "schemas": [
>         "testexample"
>     ],
>     "basenames": {
>         "testexample": "testexample"
>     },
>     "users": [
>         "'debian-sys-maint'@'localhost'",
>         "'replicauser'@'%'",
>         "'root'@'localhost'"
>     ],
>     "defaultCharacterSet": "utf8mb4",
>     "tzUtc": true,
>     "bytesPerChunk": 64000000,
>     "user": "root",
>     "hostname": "mysqlshellinstance",
>     "server": "mysqlshellinstance",
>     "serverVersion": "8.0.23-0ubuntu0.20.04.1",
>     "gtidExecuted": "05a86185-989d-11eb-a948-020017064b8c:1-10",
>     "gtidExecutedInconsistent": false,
>     "consistent": true,
>     "mdsCompatibility": true,
>     "begin": "2021-04-08 21:01:58"
> }
> EOF


```
<br></br>
[7.2] Loading data from Bucket into MySQL DB system 

From same location where @.json file is saved, access the MySQL Database System (MDS) by using mysql-shell, 
and load the data from bucket into MDS with the help of loadDump() utility:

<i> Your MDS private IP may be different </i>

```
root@mysqlshellinstance:/home#  mysqlsh -uusermds -h10.0.1.48 -pABCabc123$%
MySQL Shell 8.0.23

[... snip ... ]

MySQL  10.0.1.48:33060+ ssl  JS > 
MySQL  10.0.1.48:33060+ ssl  JS > util.loadDump("mdsobject", {osBucketName: "mdsbucket", osNamespace: "replaceHere", threads: 4})
```
<br></br>
Possible output:

```
[... snip ... ]
Fetching dump data from remote location...
Fetching 1 table metadata files for schema `testexample`...
Checking for pre-existing objects...
Executing common preamble SQL
Executing DDL script for schema `testexample`
[Worker003] Executing DDL script for `testexample`.`exampletable`
[Worker002] testexample@exampletable.tsv.zst: Records: 1  Deleted: 0  Skipped: 0  Warnings: 0
Executing common postamble SQL                                       
                                                        
1 chunks (1 rows, 12 bytes) for 1 tables in 1 schemas were loaded in 1 sec (avg throughput 12.00 B/s)
0 warnings were reported during the load.
[... snip ... ]

```
<br></br>
Switch to SQL mode, and check if "testexample" database exists on MDS:

```
0 warnings were reported during the load.
MySQL  10.0.1.48:33060+ ssl  JS > 
MySQL  10.0.1.48:33060+ ssl  JS > \sql
Switching to SQL mode... Commands end with ;
MySQL  10.0.1.48:33060+ ssl  SQL > show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| testexample        |
+--------------------+
5 rows in set (0.0009 sec)

MySQL  10.0.1.48:33060+ ssl  SQL > select * from testexample.exampletable ;
+--------+-----------+
| name   | firstname |
+--------+-----------+
| Foster | Zack      |
+--------+-----------+
1 row in set (0.0009 sec)
```

If load dumping was successful, perform GTID purging. The GTID can be found in the @.json file (gtidExecuted):

```
MySQL  10.0.1.48:33060+ ssl  SQL >  call sys.set_gtid_purged("05a86185-989d-11eb-a948-020017064b8c:1-10");
Query OK, 0 rows affected (0.0223 sec)
MySQL  10.0.1.48:33060+ ssl  SQL > show global variables like 'GTID%';
+----------------------------------+-------------------------------------------------------------------------------------+
| Variable_name                    | Value                                                                               |
+----------------------------------+-------------------------------------------------------------------------------------+
| gtid_executed                    | 05a86185-989d-11eb-a948-020017064b8c:1-10,
9f291431-989d-11eb-9012-020017069ace:1-3 |
| gtid_executed_compression_period | 0                                                                                   |
| gtid_mode                        | ON                                                                                  |
| gtid_owned                       |                                                                                     |
| gtid_purged                      | 05a86185-989d-11eb-a948-020017064b8c:1-10                                           |
+----------------------------------+-------------------------------------------------------------------------------------+
5 rows in set (0.0022 sec)
```

<br></br>

## Part 5
8. Deploying the Channel:

Go back to Cloud Shell:

```
MySQL  10.0.1.48:33060+ ssl  SQL > \q
Bye!
root@mysqlshellinstance:/home# exit
logout
ubuntu@mysqlshellinstance:~$ exit
logout
Connection to 129.159.196.152 closed.
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ 
```
... and create the Channel, by applying resource targetting:

```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ cp channel/create_channel.tf .
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ terraform apply -target oci_mysql_channel.MySqlOciChannel
```
If no errors, the Channel will appear as active:

![alt text](https://raw.githubusercontent.com/MuchTest/pix/main/b4/14.png)

<br></br>
9. Testing the replication


Create a new database by using the MySQL client on the mysqlshellinstance: <br>
<i> Quick and dirty... </i>
```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ ssh ubuntu@129.159.196.152 'mysql -uroot -pabc123! -e " create database testing;  create table testing.test(fruit varchar(20), veggie varchar(20));"'
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ ssh ubuntu@129.159.196.152 'mysql -uroot -pabc123! -e "insert into testing.test (fruit, veggie) values (\"apple\", \"salad\");"'

```
Check on MDS if the new database is present:

```
root@mysqlshellinstance:~# mysqlsh -uusermds -h10.0.1.48 -pABCabc123$%
MySQL Shell 8.0.23

[.... snip ....]

No default schema selected; type \use <schema> to set one.
 MySQL  10.0.1.48:33060+ ssl  JS > \sql
Switching to SQL mode... Commands end with ;
 MySQL  10.0.1.48:33060+ ssl  SQL > show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| testexample        |
| testing            |
+--------------------+
6 rows in set (0.0016 sec)

 MySQL  10.0.1.48:33060+ ssl  SQL > select * from testing.test;
+-------+--------+
| fruit | veggie |
+-------+--------+
| apple | salad  |
+-------+--------+
1 row in set (0.0009 sec)
```
<br></br>

<b> Destroying resources </b>

Before applying "terraform destroy", you will need to:

a) delete all preauthenticated requests from the Object storage (run command either from Cloud-Shell or mysqlshellinstance host):

```
for idz in `oci os preauth-request list -bn mdsbucket | grep id | awk '{print $2}' | sed 's/",//g' | sed 's/"//g'`; \
do echo y | oci os preauth-request delete  -bn mdsbucket --par-id $idz  ; \
done

```

b) delete all objects that are stored in the bucket (run command either from Cloud-Shell or mysqlshellinstance host):

```
zack@cloudshell:~ (eu-frankfurt-1)$ oci os object bulk-delete -bn mdsbucket
WARNING: This command will delete 13 objects. Are you sure you wish to continue? [y/N]: y
```

Apply command "terraform destroy":

```
zack@cloudshell:MdsReplication (eu-frankfurt-1)$ terraform destroy
```
