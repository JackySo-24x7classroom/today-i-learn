# AWS unified CloudWatch Agent manual installation

`Table of Content`


<!-- vim-markdown-toc GFM -->

- [Manual Unified Agent Installation](#manual-unified-agent-installation)

<!-- vim-markdown-toc -->

## Manual Unified Agent Installation

1. Create an IAM role called CWUnifiedAgentRole and attach it to the EC2 instance (follow the steps as demonstrated in Chapter 3, CloudWatch Logs, Metrics, and Dashboard).
	* Instead of creating a fresh policy, select CloudWatchAgentAdminPolicy, which is an AWS managed policy, and attach it to the created role.
	```json
	{
	    "Version": "2012-10-17",
	    "Statement": [
	        {
	            "Effect": "Allow",
	            "Action": [
	                "cloudwatch:PutMetricData",
	                "ec2:DescribeTags",
	                "logs:PutLogEvents",
	                "logs:DescribeLogStreams",
	                "logs:DescribeLogGroups",
	                "logs:CreateLogStream",
	                "logs:CreateLogGroup"
	            ],
	            "Resource": "*"
	        },
	        {
	            "Effect": "Allow",
	            "Action": [
	                "ssm:GetParameter",
	                "ssm:PutParameter"
	            ],
	            "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
	        }
	    ]
	}
	```
2. The next step is to download and install the agent using the command line. In the Linux terminal, type the following command to download the agent:
	* `wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip`
	* When the file is successfully downloaded, unzip the file called AmazonCloudWatchAgent.zip using the unzip command in the Linux terminal.

	```bash
	$ wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
	--2021-06-16 06:53:14--  https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
	Resolving s3.amazonaws.com (s3.amazonaws.com)... 54.231.40.10
	Connecting to s3.amazonaws.com (s3.amazonaws.com)|54.231.40.10|:443... connected.
	HTTP request sent, awaiting response... 200 OK
	Length: 96920693 (92M) [application/zip]
	Saving to: ‘AmazonCloudWatchAgent.zip’
	
	AmazonCloudWatchAgent.zip          100%[==============================================================>]  92.43M  7.72MB/s    in 13s     
	
	2021-06-16 06:53:28 (7.01 MB/s) - ‘AmazonCloudWatchAgent.zip’ saved [96920693/96920693]
	
	ec2-user@ip-10-92-1-48:~$ zip -sf AmazonCloudWatchAgent.zip 
	Archive contains:
	  amazon-cloudwatch-agent.rpm
	  amazon-cloudwatch-agent.deb
	  manifest.json
	  install.sh
	  uninstall.sh
	  detect-system.sh
	Total 6 entries (97269379 bytes)
	ec2-user@ip-10-92-1-48:~$ mkdir cw-agent
	ec2-user@ip-10-92-1-48:~$ cd cw-agent/
	ec2-user@ip-10-92-1-48:~/cw-agent$ unzip ../AmazonCloudWatchAgent.zip 
	Archive:  ../AmazonCloudWatchAgent.zip
	  inflating: amazon-cloudwatch-agent.rpm  
	  inflating: amazon-cloudwatch-agent.deb  
	  inflating: manifest.json           
	  inflating: install.sh              
	  inflating: uninstall.sh            
	  inflating: detect-system.sh        
	ec2-user@ip-10-92-1-48:~/cw-agent$ tree .
	.
	├── amazon-cloudwatch-agent.deb
	├── amazon-cloudwatch-agent.rpm
	├── detect-system.sh
	├── install.sh
	├── manifest.json
	└── uninstall.sh
	
	0 directories, 6 files
	```


3. The next step is to install the agent by running the install.sh script.

	```bash
	$ ./install.sh
	dpkg: error: requested operation requires superuser privilege
	ec2-user@ip-10-92-1-48:~/cw-agent$ sudo ./install.sh
	Selecting previously unselected package amazon-cloudwatch-agent.
	(Reading database ... 188614 files and directories currently installed.)
	Preparing to unpack ./amazon-cloudwatch-agent.deb ...
	create group cwagent, result: 0
	create user cwagent, result: 0
	Unpacking amazon-cloudwatch-agent (1.247347.6b250880-1) ...
	Setting up amazon-cloudwatch-agent (1.247347.6b250880-1) ...
	ec2-user@ip-10-92-1-48:~/cw-agent$
	```

4. Next, we create a configuration file that the CloudWatch agent will use. This file will be created using the CloudWatch agent wizard. A couple of questions will be asked by the wizard, and the answers will form the configuration file that will be created. The file to trigger the wizard is located at /opt/aws/amazon-cloudwatch-agent/bin. Change the directory to the location using the cd command. Then, run the wizard file, which is the amazon-cloudwatch-agent-config-wizard file, using the same command as for the install.sh file:

This will start the CloudWatch agent wizard

```bash

ec2-user@ip-10-92-1-48:~/cw-agent$ /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
Make sure that you have write permission to /opt/aws/amazon-cloudwatch-agent/bin/config.json
ec2-user@ip-10-92-1-48:~/cw-agent$ sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
=============================================================
= Welcome to the AWS CloudWatch Agent Configuration Manager =
=============================================================
On which OS are you planning to use the agent?
1. linux
2. windows
3. darwin
default choice: [1]:
1
Trying to fetch the default region based on ec2 metadata...
Are you using EC2 or On-Premises hosts?
1. EC2
2. On-Premises
default choice: [1]:
1
Which user are you planning to run the agent?
1. root
2. cwagent
3. others
default choice: [1]:
1
Do you want to turn on StatsD daemon?
1. yes
2. no
default choice: [1]:
1
Which port do you want StatsD daemon to listen to?
default choice: [8125]

What is the collect interval for StatsD daemon?
1. 10s
2. 30s
3. 60s
default choice: [1]:
3
What is the aggregation interval for metrics collected by StatsD daemon?
1. Do not aggregate
2. 10s
3. 30s
4. 60s
default choice: [4]:
4
Do you want to monitor metrics from CollectD?
1. yes
2. no
default choice: [1]:
1
Do you want to monitor any host metrics? e.g. CPU, memory, etc.
1. yes
2. no
default choice: [1]:
1
Do you want to monitor cpu metrics per core? Additional CloudWatch charges may apply.
1. yes
2. no
default choice: [1]:
1
Do you want to add ec2 dimensions (ImageId, InstanceId, InstanceType, AutoScalingGroupName) into all of your metrics if the info is available?
1. yes
2. no
default choice: [1]:
1
Would you like to collect your metrics at high resolution (sub-minute resolution)? This enables sub-minute resolution for all metrics, but you can customize for specific metrics in the output json file.
1. 1s
2. 10s
3. 30s
4. 60s
default choice: [4]:
4
Which default metrics config do you want?
1. Basic
2. Standard
3. Advanced
4. None
default choice: [1]:
2
Current config as follows:
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"metrics": {
		"append_dimensions": {
			"AutoScalingGroupName": "${aws:AutoScalingGroupName}",
			"ImageId": "${aws:ImageId}",
			"InstanceId": "${aws:InstanceId}",
			"InstanceType": "${aws:InstanceType}"
		},
		"metrics_collected": {
			"collectd": {
				"metrics_aggregation_interval": 60
			},
			"cpu": {
				"measurement": [
					"cpu_usage_idle",
					"cpu_usage_iowait",
					"cpu_usage_user",
					"cpu_usage_system"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				],
				"totalcpu": false
			},
			"disk": {
				"measurement": [
					"used_percent",
					"inodes_free"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"diskio": {
				"measurement": [
					"io_time"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"mem": {
				"measurement": [
					"mem_used_percent"
				],
				"metrics_collection_interval": 60
			},
			"statsd": {
				"metrics_aggregation_interval": 60,
				"metrics_collection_interval": 60,
				"service_address": ":8125"
			},
			"swap": {
				"measurement": [
					"swap_used_percent"
				],
				"metrics_collection_interval": 60
			}
		}
	}
}
Are you satisfied with the above config? Note: it can be manually customized after the wizard completes to add additional items.
1. yes
2. no
default choice: [1]:
1
Do you have any existing CloudWatch Log Agent (http://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AgentReference.html) configuration file to import for migration?
1. yes
2. no
default choice: [2]:
2
Do you want to monitor any log files?
1. yes
2. no
default choice: [1]:
2
Saved config file to /opt/aws/amazon-cloudwatch-agent/bin/config.json successfully.
Current config as follows:
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"metrics": {
		"append_dimensions": {
			"AutoScalingGroupName": "${aws:AutoScalingGroupName}",
			"ImageId": "${aws:ImageId}",
			"InstanceId": "${aws:InstanceId}",
			"InstanceType": "${aws:InstanceType}"
		},
		"metrics_collected": {
			"collectd": {
				"metrics_aggregation_interval": 60
			},
			"cpu": {
				"measurement": [
					"cpu_usage_idle",
					"cpu_usage_iowait",
					"cpu_usage_user",
					"cpu_usage_system"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				],
				"totalcpu": false
			},
			"disk": {
				"measurement": [
					"used_percent",
					"inodes_free"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"diskio": {
				"measurement": [
					"io_time"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"mem": {
				"measurement": [
					"mem_used_percent"
				],
				"metrics_collection_interval": 60
			},
			"statsd": {
				"metrics_aggregation_interval": 60,
				"metrics_collection_interval": 60,
				"service_address": ":8125"
			},
			"swap": {
				"measurement": [
					"swap_used_percent"
				],
				"metrics_collection_interval": 60
			}
		}
	}
}
Please check the above content of the config.
The config file is also located at /opt/aws/amazon-cloudwatch-agent/bin/config.json.
Edit it manually if needed.
Do you want to store the config in the SSM parameter store?
1. yes
2. no
default choice: [1]:
2
Program exits now.
```

`Note:` There are three types of metrics used for EC2 instances: Basic, Standard, and Advanced.
* The Basic metric configuration only collects the memory and disk space used,
* Standard metric configuration collects all the metrics from the basic configuration along with other metrics such as disk I/O time, CPU usage idle, CPU usage I/O wait, CPU usage user, and CPU usage system.
* Advanced configuration of metrics is able to collect the same metrics as the Standard configuration and more besides.

> The wizard will now generate the configuration file based on all the input values that have been given and prompt to accept or reject the configuration.

```json
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"metrics": {
		"append_dimensions": {
			"AutoScalingGroupName": "${aws:AutoScalingGroupName}",
			"ImageId": "${aws:ImageId}",
			"InstanceId": "${aws:InstanceId}",
			"InstanceType": "${aws:InstanceType}"
		},
		"metrics_collected": {
			"collectd": {
				"metrics_aggregation_interval": 60
			},
			"cpu": {
				"measurement": [
					"cpu_usage_idle",
					"cpu_usage_iowait",
					"cpu_usage_user",
					"cpu_usage_system"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				],
				"totalcpu": false
			},
			"disk": {
				"measurement": [
					"used_percent",
					"inodes_free"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"diskio": {
				"measurement": [
					"io_time"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"mem": {
				"measurement": [
					"mem_used_percent"
				],
				"metrics_collection_interval": 60
			},
			"statsd": {
				"metrics_aggregation_interval": 60,
				"metrics_collection_interval": 60,
				"service_address": ":8125"
			},
			"swap": {
				"measurement": [
					"swap_used_percent"
				],
				"metrics_collection_interval": 60
			}
		}
	}
}
```

> Since this is a unified agent, the wizard will ask whether we have a log file to monitor, meaning whether we have a path that we would like to configure. For the moment, we will select option 2, which is no. Then, press Enter to continue.

> The wizard will ask for confirmation a second time. This time, it will specify the path where the configuration file is. For our setup, it is in the /opt/aws/amazon-cloudwatch-agent/bin/config.json path. It will also ask whether we want to store the config file in the SSM parameter store. Storing it in the SSM parameter store means that we will have a backup in the AWS SSM parameter store in case this configuration is missing. This is also good when working with an EC2 fleet or virtual machine fleet, so that they all have a single source of truth in the AWS SSM parameter store for their CloudWatch agent configuration file. This makes it easier to apply across the instance from a single centralized location. For our setup, we will say no, which is option 2. Then, press the Enter key.

<pre>
$ tree /opt/aws/amazon-cloudwatch-agent
/opt/aws/amazon-cloudwatch-agent
├── LICENSE
├── NOTICE
├── RELEASE_NOTES
├── THIRD-PARTY-LICENSES
├── bin
│   ├── CWAGENT_VERSION
│   ├── amazon-cloudwatch-agent
│   ├── amazon-cloudwatch-agent-config-wizard
│   ├── amazon-cloudwatch-agent-ctl
│   ├── config-downloader
│   ├── config-translator
│   ├── config.json
│   ├── cwagent-otel-collector
│   └── start-amazon-cloudwatch-agent
├── cwagent-otel-collector
│   ├── etc
│   │   └── cwagent-otel-collector.d
│   ├── logs
│   └── var
├── doc
│   └── amazon-cloudwatch-agent-schema.json
├── etc
│   ├── amazon-cloudwatch-agent.d
│   └── common-config.toml
├── logs
└── var
</pre>

5. Next step is to start CloudWatch and start sending metrics to CloudWatch metrics. Use the following command to start the agent:
	* `./amazon-cloudwatch-agent-ctl -a fetch-config -c file:config.json -s`

```bash
ec2-user@ip-10-92-1-48:/opt/aws/amazon-cloudwatch-agent/bin$ sudo ./amazon-cloudwatch-agent-ctl -a fetch-config -c file:config.json -s
****** processing amazon-cloudwatch-agent ******
/opt/aws/amazon-cloudwatch-agent/bin/config-downloader --output-dir /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d --download-source file:config.json --mode ec2 --config /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml --multi-config default
Successfully fetched the config and saved in /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/file_config.json.tmp
Start configuration validation...
/opt/aws/amazon-cloudwatch-agent/bin/config-translator --input /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json --input-dir /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d --output /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml --mode ec2 --config /opt/aws/amazon-cloudwatch-agent/etc/common-config.toml --multi-config default
2021/06/16 07:27:10 Reading json config file path: /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/file_config.json.tmp ...
Valid Json input schema.
I! Detecting run_as_user...
No csm configuration found.
No log configuration found.
Configuration validation first phase succeeded
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent -schematest -config /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml
Configuration validation second phase succeeded
Configuration validation succeeded
amazon-cloudwatch-agent has already been stopped
Created symlink /etc/systemd/system/multi-user.target.wants/amazon-cloudwatch-agent.service → /etc/systemd/system/amazon-cloudwatch-agent.service.
```

`Note:` You need to validate `collectd` has been installed in this Linux system as you configuring to use collectd in wizard

```bash
ec2-user@ip-10-92-1-48:/opt/aws/amazon-cloudwatch-agent/bin$ ls -al /usr/share/collectd/types.db
-rw-r--r-- 1 root root 13187 Apr 17  2020 /usr/share/collectd/types.db
```

> This will start the CloudWatch agent as a daemon process, using the config.json file, which is the file that has the configuration that we have created. It also has the option of using the SSM option, that is, if the config file is stored in the AWS SSM parameter store.

```bash
$ sudo systemctl status amazon-cloudwatch-agent
● amazon-cloudwatch-agent.service - Amazon CloudWatch Agent
     Loaded: loaded (/etc/systemd/system/amazon-cloudwatch-agent.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-06-16 07:27:11 UTC; 2min 37s ago
   Main PID: 25434 (amazon-cloudwat)
      Tasks: 9 (limit: 18983)
     Memory: 18.7M
     CGroup: /system.slice/amazon-cloudwatch-agent.service
             └─25434 /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent -config /opt/aws/amazon-cloudwatch-agent/etc/amazon-clo>

Jun 16 07:27:11 ip-10-92-1-48 systemd[1]: Started Amazon CloudWatch Agent.
Jun 16 07:27:11 ip-10-92-1-48 start-amazon-cloudwatch-agent[25434]: /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json doe>
Jun 16 07:27:11 ip-10-92-1-48 start-amazon-cloudwatch-agent[25434]: Valid Json input schema.
Jun 16 07:27:11 ip-10-92-1-48 start-amazon-cloudwatch-agent[25434]: I! Detecting run_as_user...
ec2-user@ip-10-92-1-48:/opt/aws/amazon-cloudwatch-agent/bin$ ps -ef | grep amazon-cloudwatch-agent
root       25434       1  0 07:27 ?        00:00:01 /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent -config /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.toml -envconfig /opt/aws/amazon-cloudwatch-agent/etc/env-config.json -pidfile /opt/aws/amazon-cloudwatch-agent/var/amazon-cloudwatch-agent.pid
ec2-user   26212    6402  0 07:30 pts/0    00:00:00 grep --color=auto amazon-cloudwatch-agent
```

