# AWS DocumentDB

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Subnet group](#subnet-group)
- [Security group](#security-group)
- [Deploy DocumentDB](#deploy-documentdb)
- [Connect EC2 instance through SSM session](#connect-ec2-instance-through-ssm-session)
- [Some DocumentDB work](#some-documentdb-work)

<!-- vim-markdown-toc -->

> In a world where data is growing rapidly and is considered the new gold, you must be able to work with it and provide the most appropriate solutions based on the data you are working with. Nowadays there are a lot of data sources to work with, and corresponding formats. One of the most efficient ways to handle data is by structuring them and then using an RDBMS to handle them; but, because of the variety of data sources and application types, it's not always appropriate to structure data. Sometimes you should work with semi-structured and/or unstructured data.

> In these cases, you can have a non-strict schema (free-form data) or you don't have a schema (schema-less data), so you need to implement a solution that could work with that type of data. Amazon DocumentDB is a fully managed, fast, and scalable DBMS that allows you to deploy a MongoDB compatible cluster, so you can store, retrieve and work with data represented as JSON documents.

## Subnet group

`Introduction`

> Amazon DocumentDB makes it easy to set up, operate, and scale a MongoDB compatible database in the cloud. Before launching DocumentDB clusters, you need to configure a DB Subnet Group.

> Subnets are segments of a VPC's IP address range that allow you to group your resources based on security and operational needs. A DB Subnet Group is a collection of subnets (typically private) that you create in a VPC and designate for your DB instances. Each DB subnet group should have subnets in at least two Availability Zones in a given region.

> When creating a DB in a VPC, you must select a DB subnet group. Amazon DocumentDB uses that DB subnet group and your preferred Availability Zone to select a subnet and an IP address within that subnet to associate with your DB instance. When Amazon DocumentDB creates a DB in a VPC, it assigns a network interface to your DB instance by using an IP address selected from your DB Subnet Group. If the primary DB instance of a Multi-AZ deployment fails, Amazon DocumentDB can promote the corresponding standby and subsequently create a new standby using an IP address from an assigned subnet in one of the other Availability Zones.

> You can create a DocumentDB Subnet Group using the RDS launch wizard.

***Instructions***

1. In the AWS Management Console search bar, enter RDS, and click the RDS result under Services:

2. From the RDS dashboard, click Subnet Groups from the left-hand menu:

3. Click Create DB Subnet Group to open the creation wizard:

4. Fill out the form using the following data:

* Name: documentdb-subnet-group
* Description: documentdb-subnet-group-description
* VPC ID: Select the available one

5. Select all the subnets available from the dropdown menu and then click Create:

> Note: It could take a few seconds for the AZs to appear. If not, just manually select the correct VPC.

> Warning: Be sure to be in the right region and be sure to have selected the correct VPC.

> After a few seconds, your DB Subnet Group will be available and ready for use:

***Summary:*** In this Lab Step, you used the AWS Management Console to create a DB Subnet Group.

## Security group

`Introduction`

> You will use an EC2 instance to run queries against the DocumentDB database in upcoming lab steps. In order to allow incoming traffic from EC2 instances to the DocumentDB cluster inside the same VPC.

> The rules of a Security Group control the inbound traffic that's allowed to reach the instances that are associated with the security group and the outbound traffic that's allowed to leave them. By default, security groups allow all outbound traffic and deny all inbound traffic.

> You can add new rules to a VPC Security Group using the AWS Management Console.

***Instructions***

1. In the AWS Management Console search bar, enter VPC, and click the VPC result under Services:

2. In the navigation pane to the left, click Security Groups. The Security Groups list will load:

3. Click on Create security group.

4. Fill the creation form as described below:

* Security group name: documentdb-sg
* Description: Allow MongoDB Connections from within the VPC
* Inbound rules: click on Add rule
* Type: Custom TCP
* Protocol: TCP
* Port: 27017
* Source: (Custom) - 172.31.0.0/16

5. Scroll to the bottom and click Create security group. You will be ready to connect to your DocumentDB cluster inside the VPC.

***Summary*** In this Lab Step, you used the AWS Management Console to configure Security Group rules for your DocumentDB cluster.

## Deploy DocumentDB

`Introduction`

> Amazon DocumentDB allows you to deploy a fast and easily scalable DocumentDB Cluster that lets you build and work on a MongoDB compatible database. You can easily scale it by increasing the number of instances of the cluster.

> In this lab, you will create an Amazon DocumentDB cluster with a single instance.

***Instructions***

1. Look at the upper part of the AWS console to reach the search bar. Enter documentdb and click on Amazon DocumentDB:

> The Amazon DocumentDB dashboard will be displayed:

2. Click on Launch Amazon DocumentDB.

3. Fill the creation form as displayed below (leave unmentioned fields at their default value):

* Cluster identifier: ca-lab-document-db-cluster
* Instance class: db.t3.medium
* Number of instances: 1 (make sure to select this one, otherwise you will be banned)
* Master username: cloudacademylabs
* Master password/Confirm Master password: CloudAcademyLabs_1!

4. Check the Show advanced settings and enter the followings (leave unmentioned fields at their default value):

* Subnet group: documentdb-subnet-group
* VPC Security groups: documentdb-sg

5. Uncheck the Enable deletion protection checkbox:

6. Click on Create cluster to start the cluster creation.

7. Wait until the deployment of the cluster completes:

> Because you deployed a cluster with a single instance, you can see there is only one replica instance in the DocumentDB cluster.

> Note: The cluster could take up to 12 minutes to complete the deployment.

***Summary*** In this lab step, you created an Amazon DocumentDB cluster with a single node.

## Connect EC2 instance through SSM session

`Introduction`

> You will use SSM to connect to an instance to run queries against DocumentDB.

> Session Manager is part of AWS Systems Manager suite of tools for gaining operational insights and taking action on AWS resources. Session Manager gives you browser-based shell access to EC2 instances running the Systems Manager agent. Both Windows and Linux instances are supported. Session manager provides secure access to instances without the need to distribute passwords or SSH keys. Session Manager also allows you to connect to instances without having to open any inbound ports. All communication is encrypted and IAM policies can restrict access to sessions running in Session Manager.

> You will use Session Manager to start a session on an EC2 instance running in your Cloud Academy Lab environment in this Lab Step.

## Some DocumentDB work

> You will create a collection, and manage JSON documents inside it. A MongoDB collection is a kind of directory where JSON documents reside.

***Instructions***

1. Move to the DocumentDB clusters section, and click on the cluster you previously created.

2. Scroll down to the Connect section:

3. Copy the Connect to this cluster with the mongo shell URL so you can use it later.

4. Enter the following command to download the AWS digital certificate needed to establish the connection:

`wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem`

5. Go back to the EC2 browser session you opened before, and prompt the URL you just copied replacing the <insertYourPassword> with CloudAcademyLabs_1!

6. Enter the following command to create a new document related to a user in the users collection:

`db.users.insert({"name": "John", "surname": "Doe", "cars": ["Ferrari 488", "Ford Mustang Shelby"]})`

> You don't need to manually create the collection because when a collection doesn't exist, MongoDB automatically creates it.

7. Enter the following command to retrieve the document you just inserted:

`db.users.findOne()`

> MongoDB automatically sets the `_id` field. That's because every JSON document needs to be identified by a unique key that acts as an index.

8. Enter the following command to insert other documents:

```
db.users.insert({"name": "Michael", "surname": "Doe", "cars": ["Alfa Romeo Giulia"]})
db.users.insert({"name": "Katie", "surname": "Prost", "cars": ["Maserati MC20", "Honda Civic Type-R"]})
db.users.insert({"name": "Andy", "surname": "McKane"})
```

9. Execute the following command to query all the documents you inserted:

`db.users.find()`

> The four documents don't have the same structure. You didn't define any schema but you had the possibility to work with data. In this situation, you are working schema-less. MongoDB supports schema definition, so you could also work with semi-structured data (there is a schema that is not as rigid as the relational model one).

10. Execute the following command to retrieve users that have only a single car:

`db.users.find({cars: {$size: 1}})`

***Summary*** In this lab step, you connected to the DocumentDB cluster and performed some basic operations using the MongoDB shell.

<details><summary><i>Click here to see work and output</i></summary><br>

```bash
sh-4.2$ id
uid=1001(ssm-user) gid=1001(ssm-user) groups=1001(ssm-user)
sh-4.2$ cd
sh-4.2$ ls
sh-4.2$ wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
--2021-05-28 06:51:08--  https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
Resolving s3.amazonaws.com (s3.amazonaws.com)... 52.217.85.46
Connecting to s3.amazonaws.com (s3.amazonaws.com)|52.217.85.46|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 43888 (43K) [binary/octet-stream]
Saving to: 'rds-combined-ca-bundle.pem'

100%[=======================================================================================================>] 43,888      --.-K/s   in 0.07s

2021-05-28 06:51:08 (611 KB/s) - 'rds-combined-ca-bundle.pem' saved [43888/43888]

sh-4.2$ pwd
/home/ssm-user

sh-4.2$ mongo --ssl --host ca-lab-document-db-cluster.cluster-cwxnbirzzqgo.us-west-2.docdb.amazonaws.com:27017 --sslCAFile rds-combined-ca-bundle.pem --username cloudacademylabs --password CloudAcademyLabs_1!

MongoDB shell version v3.6.23
connecting to: mongodb://ca-lab-document-db-cluster.cluster-cwxnbirzzqgo.us-west-2.docdb.amazonaws.com:27017/?gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("22a037f4-519c-4458-a927-84d768b609ac") }
MongoDB server version: 4.0.0
WARNING: shell and server versions do not match
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
        http://docs.mongodb.org/
Questions? Try the support group
        http://groups.google.com/group/mongodb-user

Warning: Non-Genuine MongoDB Detected

This server or service appears to be an emulation of MongoDB rather than an official MongoDB product.

Some documented MongoDB features may work differently, be entirely missing or incomplete, or have unexpected performance characteristics.

To learn more please visit: https://dochub.mongodb.org/core/non-genuine-mongodb-server-warning.

rs0:PRIMARY> db.users.insert({"name": "John", "surname": "Doe", "cars": ["Ferrari 488", "Ford Mustang Shelby"]})
WriteResult({ "nInserted" : 1 })

rs0:PRIMARY> db.users.findOne()
{
        "_id" : ObjectId("60b09352c3c1f1f9a8b10784"),
        "name" : "John",
        "surname" : "Doe",
        "cars" : [
                "Ferrari 488",
                "Ford Mustang Shelby"
        ]
}

rs0:PRIMARY> db.users.insert({"name": "Michael", "surname": "Doe", "cars": ["Alfa Romeo Giulia"]})
WriteResult({ "nInserted" : 1 })

rs0:PRIMARY> db.users.insert({"name": "Katie", "surname": "Prost", "cars": ["Maserati MC20", "Honda Civic Type-R"]})
WriteResult({ "nInserted" : 1 })

rs0:PRIMARY> db.users.insert({"name": "Andy", "surname": "McKane"})
WriteResult({ "nInserted" : 1 })

rs0:PRIMARY> db.users.find()
{ "_id" : ObjectId("60b09352c3c1f1f9a8b10784"), "name" : "John", "surname" : "Doe", "cars" : [ "Ferrari 488", "Ford Mustang Shelby" ] }
{ "_id" : ObjectId("60b0936ac3c1f1f9a8b10785"), "name" : "Michael", "surname" : "Doe", "cars" : [ "Alfa Romeo Giulia" ] }
{ "_id" : ObjectId("60b0936ac3c1f1f9a8b10786"), "name" : "Katie", "surname" : "Prost", "cars" : [ "Maserati MC20", "Honda Civic Type-R" ] }
{ "_id" : ObjectId("60b0936bc3c1f1f9a8b10787"), "name" : "Andy", "surname" : "McKane" }
rs0:PRIMARY> db.users.find({cars: {$size: 1}})
{ "_id" : ObjectId("60b0936ac3c1f1f9a8b10785"), "name" : "Michael", "surname" : "Doe", "cars" : [ "Alfa Romeo Giulia" ] }
rs0:PRIMARY>
```
</details><br>
