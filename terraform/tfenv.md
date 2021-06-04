# Terraform version manager tfenv

* <span style="color:blue">Operation menu</span>

	```bash
	$  make -sf Makefile-tools
	
	 Choose a command run:
	
	tfenv                                    Check and install tfenv when no found
	tfenv-version                            Setup default version in your project folder
	tfenv-use                                List current and available versions and switch version
	tfenv-uninstall                          Un-install version from installed version list
	tfenv-install                            List all available versions and select to install through tfenv version manager
	
	```

* Install tfenv from github `https://github.com/tfutils/tfenv`' - [README](https://github.com/tfutils/tfenv/blob/master/README.md)

	```bash
	$  make -sf Makefile-tools tfenv
	
	No tfenv found in /home1/jso/.nvm/versions/node/v16.2.0/bin:/home1/jso/.pyenv/plugins/pyenv-virtualenv/shims:/home1/jso/.pyenv/shims:/home1/jso/.pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:.:/home1/jso:/usr/local/go/bin:/home1/jso/.local/bin, installing it into /usr/local/bin
	Cloning into '/home1/jso/.tfenv'...
	remote: Enumerating objects: 1259, done.
	remote: Counting objects: 100% (106/106), done.
	remote: Compressing objects: 100% (69/69), done.
	remote: Total 1259 (delta 50), reused 47 (delta 25), pack-reused 1153
	Receiving objects: 100% (1259/1259), 268.68 KiB | 777.00 KiB/s, done.
	Resolving deltas: 100% (789/789), done.
	
	$  ls -al ~/.tfenv/bin
	total 16
	drwxrwxr-x 2 jso jso 4096 Jun  4 18:14 .
	drwxrwxr-x 9 jso jso 4096 Jun  4 18:14 ..
	-rwxrwxr-x 1 jso jso 2300 Jun  4 18:14 terraform
	-rwxrwxr-x 1 jso jso 3143 Jun  4 18:14 tfenv
	
	$  which tfenv
	/usr/local/bin/tfenv
	
	$  tfenv list
	No versions available. Please install one with: tfenv install
	
	$  ~/.tfenv/bin/tfenv list
	No versions available. Please install one with: tfenv install
	```

* Install Terraform version through `tfenv` version manager utility

	```bash
	$  tfenv install latest
	Installing Terraform v0.15.5
	Downloading release tarball from https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip
	############################################################################################################################################################### 100.0%
	Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_SHA256SUMS
	No keybase install found, skipping OpenPGP signature verification
	Archive:  tfenv_download.NfGyBt/terraform_0.15.5_linux_amd64.zip
	  inflating: /home1/jso/.tfenv/versions/0.15.5/terraform
	Installation of terraform v0.15.5 successful. To make this your default version, run 'tfenv use 0.15.5'
	
	$  tfenv list
	  0.15.5
	No default set. Set with 'tfenv use <version>'
	
	$  ls -al ~/.tfenv
	total 80
	drwxrwxr-x  2 jso jso  4096 Jun  4 18:15 bin
	-rw-rw-r--  1 jso jso  4218 Jun  4 18:14 CHANGELOG.md
	drwxrwxr-x  8 jso jso  4096 Jun  4 18:14 .git
	drwxrwxr-x  3 jso jso  4096 Jun  4 18:14 .github
	-rw-rw-r--  1 jso jso    81 Jun  4 18:14 .gitignore
	drwxrwxr-x  2 jso jso  4096 Jun  4 18:14 lib
	drwxrwxr-x  2 jso jso  4096 Jun  4 18:14 libexec
	-rw-rw-r--  1 jso jso  1085 Jun  4 18:14 LICENSE
	-rw-rw-r--  1 jso jso 11130 Jun  4 18:14 README.md
	drwxrwxr-x  2 jso jso  4096 Jun  4 18:14 share
	drwxrwxr-x  2 jso jso  4096 Jun  4 18:14 test
	-rw-rw-r--  1 jso jso   458 Jun  4 18:14 .travis.yml
	drwxrwxr-x  3 jso jso  4096 Jun  4 18:18 versions
	
	$  ls -al ~/.tfenv/versions/
	total 12
	drwxrwxr-x  3 jso jso 4096 Jun  4 18:18 .
	drwxrwxr-x 10 jso jso 4096 Jun  4 18:18 ..
	drwxrwxr-x  2 jso jso 4096 Jun  4 18:18 0.15.5
	
	# Create .terraform-version token file to setup default version to "0.12.28"
	$  make -sf Makefile-tools tfenv-version
	
	Terraform versions installed through tfenv
	  0.15.5
	No default set. Set with 'tfenv use <version>'
	Hit enter to install version 0.12.28 or ctrl-C to quit:
	Installing Terraform v0.12.28
	Downloading release tarball from https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
	############################################################################################################################################################### 100.0%
	Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_SHA256SUMS
	No keybase install found, skipping OpenPGP signature verification
	Archive:  tfenv_download.YbGnKh/terraform_0.12.28_linux_amd64.zip
	  inflating: /home1/jso/.tfenv/versions/0.12.28/terraform
	Installation of terraform v0.12.28 successful. To make this your default version, run 'tfenv use 0.12.28'
	```

	<pre>
	$  tfenv list
	  0.15.5
	<span style="color:blue>* 0.12.28 (set by /home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/useful-resources/devops/makefile/.terraform-version)</span>
	</pre>

	```bash
	$  tfenv use 0.15.5
	Switching default version to v0.15.5
	Default version file overridden by /home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/useful-resources/devops/makefile/.terraform-version, changing the default version has no effect
	Switching completed
	
	# Away from project folder with .terraform-version
	$  cd ..
	$  tfenv list
	* 0.15.5 (set by /home1/jso/.tfenv/version)
	  0.12.28
	
	$  sudo ln -s ~/.tfenv/bin/terraform /usr/local/bin/terraform
	$  terraform -version
	Terraform v0.15.5
	on linux_amd64
	$  tfenv list
	* 0.15.5 (set by /home1/jso/.tfenv/version)
	  0.12.28
	```

* Switch to use various installed Terraform version registered in `tfenv` version manager

	```bash
	$  tfenv use 0.12.28
	Switching default version to v0.12.28
	Switching completed
	$  terraform -version
	Terraform v0.12.28
	
	Your version of Terraform is out of date! The latest version
	is 0.15.5. You can update by downloading from https://www.terraform.io/downloads.html
	```

* Install Terraform `latest version of prefix 0.13`

	```bash
	$  tfenv install latest:^0.13
	Installing Terraform v0.13.7
	Downloading release tarball from https://releases.hashicorp.com/terraform/0.13.7/terraform_0.13.7_linux_amd64.zip
	############################################################################################################################################################### 100.0%
	Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.13.7/terraform_0.13.7_SHA256SUMS
	No keybase install found, skipping OpenPGP signature verification
	Archive:  tfenv_download.ktWr6x/terraform_0.13.7_linux_amd64.zip
	  inflating: /home1/jso/.tfenv/versions/0.13.7/terraform
	Installation of terraform v0.13.7 successful. To make this your default version, run 'tfenv use 0.13.7'
	
	$  tfenv list
	  0.15.5
	  0.13.7
	* 0.12.28 (set by /home1/jso/.tfenv/version)
	
	$  tfenv use 0.13.7
	Switching default version to v0.13.7
	Switching completed
	
	$  terraform -version
	Terraform v0.13.7
	
	Your version of Terraform is out of date! The latest version
	is 0.15.5. You can update by downloading from https://www.terraform.io/downloads.html
	```

* Run terraform commands with tfenv switched/used version

	```bash
	$  ls
	0-aws.tf  2-etcd.tf     4-controllers.tf  6-elb.tf      etcd.sh    service-l7.yaml  variables.tf
	1-vpc.tf  3-workers.tf  5-iam.tf          7-kubeadm.tf  master.sh  tf-kube          worker.sh
	
	$  terraform init
	
	Initializing the backend...
	
	Initializing provider plugins...
	- Finding latest version of hashicorp/template...
	- Finding latest version of hashicorp/aws...
	- Installing hashicorp/template v2.2.0...
	- Installed hashicorp/template v2.2.0 (signed by HashiCorp)
	- Installing hashicorp/aws v3.44.0...
	- Installed hashicorp/aws v3.44.0 (signed by HashiCorp)
	
	The following providers do not have any version constraints in configuration,
	so the latest version was installed.
	
	To prevent automatic upgrades to new major versions that may contain breaking
	changes, we recommend adding version constraints in a required_providers block
	in your configuration, with the constraint strings suggested below.
	
	* hashicorp/aws: version = "~> 3.44.0"
	* hashicorp/template: version = "~> 2.2.0"
	
	
	Warning: Interpolation-only expressions are deprecated
	
	  on 0-aws.tf line 2, in provider "aws":
	   2:   region = "${var.region}"
	
	Terraform 0.11 and earlier required all non-constant expressions to be
	provided via interpolation syntax, but this pattern is now deprecated. To
	silence this warning, remove the "${ sequence from the start and the }"
	sequence from the end of this expression, leaving just the inner expression.
	
	Template interpolation syntax is still used to construct strings from
	expressions when the template includes multiple interpolation sequences or a
	mixture of literal strings and interpolations. This deprecation applies only
	to templates that consist entirely of a single interpolation sequence.
	
	(and 83 more similar warnings elsewhere)
	
	
	Warning: Quoted type constraints are deprecated
	
	  on variables.tf line 89, in variable "amis":
	  89:   type = "map"
	
	Terraform 0.11 and earlier required type constraints to be given in quotes,
	but that form is now deprecated and will be removed in a future version of
	Terraform. To silence this warning, remove the quotes around "map" and write
	map(string) instead to explicitly indicate that the map elements are strings.
	
	Terraform has been successfully initialized!
	
	You may now begin working with Terraform. Try running "terraform plan" to see
	any changes that are required for your infrastructure. All Terraform commands
	should now work.
	
	If you ever set or change modules or backend configuration for Terraform,
	rerun this command to reinitialize your working directory. If you forget, other
	commands will detect it and remind you to do so if necessary.
	 jso  ubunu2004  ~  myob-work  …  projects-kubernetes  vanilla-k8s  aws-kubeadm-terraform  main  2?  $  tfenv list
	  0.15.5
	* 0.13.7 (set by /home1/jso/.tfenv/version)
	  0.12.28
	$  tfenv use 0.12.28
	Switching default version to v0.12.28
	Switching completed
	$  terraform init
	
	Initializing the backend...
	
	Initializing provider plugins...
	- Checking for available provider plugins...
	- Downloading plugin for provider "aws" (hashicorp/aws) 3.37.0...
	- Downloading plugin for provider "template" (hashicorp/template) 2.2.0...
	
	The following providers do not have any version constraints in configuration,
	so the latest version was installed.
	
	To prevent automatic upgrades to new major versions that may contain breaking
	changes, it is recommended to add version = "..." constraints to the
	corresponding provider blocks in configuration, with the constraint strings
	suggested below.
	
	* provider.aws: version = "~> 3.37"
	* provider.template: version = "~> 2.2"
	
	
	Warning: registry.terraform.io: This version of Terraform has an outdated GPG key and is unable to verify new provider releases. Please upgrade Terraform to at least 0.12.31 to receive new provider updates. For details see: https://discuss.hashicorp.com/t/hcsec-2021-12-codecov-security-event-and-hashicorp-gpg-key-exposure/23512
	
	
	
	Warning: registry.terraform.io: This version of Terraform has an outdated GPG key and is unable to verify new provider releases. Please upgrade Terraform to at least 0.12.31 to receive new provider updates. For details see: https://discuss.hashicorp.com/t/hcsec-2021-12-codecov-security-event-and-hashicorp-gpg-key-exposure/23512
	
	
	
	Warning: Interpolation-only expressions are deprecated
	
	  on 0-aws.tf line 2, in provider "aws":
	   2:   region = "${var.region}"
	
	Terraform 0.11 and earlier required all non-constant expressions to be
	provided via interpolation syntax, but this pattern is now deprecated. To
	silence this warning, remove the "${ sequence from the start and the }"
	sequence from the end of this expression, leaving just the inner expression.
	
	Template interpolation syntax is still used to construct strings from
	expressions when the template includes multiple interpolation sequences or a
	mixture of literal strings and interpolations. This deprecation applies only
	to templates that consist entirely of a single interpolation sequence.
	
	(and 50 more similar warnings elsewhere)
	
	
	Warning: Quoted type constraints are deprecated
	
	  on variables.tf line 89, in variable "amis":
	  89:   type = "map"
	
	Terraform 0.11 and earlier required type constraints to be given in quotes,
	but that form is now deprecated and will be removed in a future version of
	Terraform. To silence this warning, remove the quotes around "map" and write
	map(string) instead to explicitly indicate that the map elements are strings.
	
	Terraform has been successfully initialized!
	
	You may now begin working with Terraform. Try running "terraform plan" to see
	any changes that are required for your infrastructure. All Terraform commands
	should now work.
	
	If you ever set or change modules or backend configuration for Terraform,
	rerun this command to reinitialize your working directory. If you forget, other
	commands will detect it and remind you to do so if necessary.
	 jso  ubunu2004  ~  myob-work  …  projects-kubernetes  vanilla-k8s  aws-kubeadm-terraform  main  2?  $  tfenv use default
	No installed versions of terraform matched 'default'
	 jso  ubunu2004  ~  myob-work  …  projects-kubernetes  vanilla-k8s  aws-kubeadm-terraform  main  2?  $  tfenv use latest
	Switching default version to v0.15.5
	Switching completed
	 jso  ubunu2004  ~  myob-work  …  projects-kubernetes  vanilla-k8s  aws-kubeadm-terraform  main  2?  $  terraform init
	There are some problems with the configuration, described below.
	
	The Terraform configuration must be valid before initialization so that
	Terraform can determine which modules and providers need to be installed.
	╷
	│ Error: Invalid quoted type constraints
	│
	│   on variables.tf line 89, in variable "amis":
	│   89:   type = "map"
	│
	│ Terraform 0.11 and earlier required type constraints to be given in quotes, but that form is now deprecated and will be removed in a future version of Terraform.
	│ Remove the quotes around "map" and write map(string) instead to explicitly indicate that the map elements are strings.
	╵
	
	$  tfenv list
	* 0.15.5 (set by /home1/jso/.tfenv/version)
	  0.13.7
	  0.12.28
	
	$  tfenv use 0.13.7
	Switching default version to v0.13.7
	Switching completed
	 jso  ubunu2004  ~  myob-work  …  projects-kubernetes  vanilla-k8s  aws-kubeadm-terraform  main  2?  $  terraform init
	
	Initializing the backend...
	
	Initializing provider plugins...
	- Using previously-installed hashicorp/aws v3.44.0
	- Using previously-installed hashicorp/template v2.2.0
	
	The following providers do not have any version constraints in configuration,
	so the latest version was installed.
	
	To prevent automatic upgrades to new major versions that may contain breaking
	changes, we recommend adding version constraints in a required_providers block
	in your configuration, with the constraint strings suggested below.
	
	* hashicorp/aws: version = "~> 3.44.0"
	* hashicorp/template: version = "~> 2.2.0"
	
	
	Warning: Interpolation-only expressions are deprecated
	
	  on 0-aws.tf line 2, in provider "aws":
	   2:   region = "${var.region}"
	
	Terraform 0.11 and earlier required all non-constant expressions to be
	provided via interpolation syntax, but this pattern is now deprecated. To
	silence this warning, remove the "${ sequence from the start and the }"
	sequence from the end of this expression, leaving just the inner expression.
	
	Template interpolation syntax is still used to construct strings from
	expressions when the template includes multiple interpolation sequences or a
	mixture of literal strings and interpolations. This deprecation applies only
	to templates that consist entirely of a single interpolation sequence.
	
	(and 83 more similar warnings elsewhere)
	
	
	Warning: Quoted type constraints are deprecated
	
	  on variables.tf line 89, in variable "amis":
	  89:   type = "map"
	
	Terraform 0.11 and earlier required type constraints to be given in quotes,
	but that form is now deprecated and will be removed in a future version of
	Terraform. To silence this warning, remove the quotes around "map" and write
	map(string) instead to explicitly indicate that the map elements are strings.
	
	Terraform has been successfully initialized!
	
	You may now begin working with Terraform. Try running "terraform plan" to see
	any changes that are required for your infrastructure. All Terraform commands
	should now work.
	
	If you ever set or change modules or backend configuration for Terraform,
	rerun this command to reinitialize your working directory. If you forget, other
	commands will detect it and remind you to do so if necessary.
	```

* List out all available versions to be installed. Then, of course, try some versions installation through `tfenv` version manager

	```bash
	$  tfenv list-remote
	0.15.5
	0.15.4
	0.15.3
	0.15.2
	0.15.1
	0.15.0
	0.15.0-rc2
	0.15.0-rc1
	0.15.0-beta2
	0.15.0-beta1
	0.15.0-alpha20210210
	0.15.0-alpha20210127
	0.15.0-alpha20210107
	0.14.11
	0.14.10
	0.14.9
	0.14.8
	0.14.7
	0.14.6
	0.14.5
	0.14.4
	0.14.3
	0.14.2
	0.14.1
	0.14.0
	0.14.0-rc1
	0.14.0-beta2
	0.14.0-beta1
	0.14.0-alpha20201007
	0.14.0-alpha20200923
	0.14.0-alpha20200910
	0.13.7
	0.13.6
	0.13.5
	0.13.4
	0.13.3
	0.13.2
	0.13.1
	0.13.0
	0.13.0-rc1
	0.13.0-beta3
	0.13.0-beta2
	0.13.0-beta1
	0.12.31
	0.12.30
	0.12.29
	0.12.28
	0.12.27
	0.12.26
	0.12.25
	0.12.24
	0.12.23
	0.12.22
	0.12.21
	0.12.20
	0.12.19
	0.12.18
	0.12.17
	0.12.16
	0.12.15
	0.12.14
	0.12.13
	0.12.12
	0.12.11
	0.12.10
	0.12.9
	0.12.8
	0.12.7
	0.12.6
	0.12.5
	0.12.4
	0.12.3
	0.12.2
	0.12.1
	0.12.0
	0.12.0-rc1
	0.12.0-beta2
	0.12.0-beta1
	0.12.0-alpha4
	0.12.0-alpha3
	0.12.0-alpha2
	0.12.0-alpha1
	0.11.15
	0.11.15-oci
	0.11.14
	0.11.13
	0.11.12
	0.11.12-beta1
	0.11.11
	0.11.10
	0.11.9
	0.11.9-beta1
	0.11.8
	0.11.7
	0.11.6
	0.11.5
	0.11.4
	0.11.3
	0.11.2
	0.11.1
	0.11.0
	0.11.0-rc1
	0.11.0-beta1
	0.10.8
	0.10.7
	0.10.6
	0.10.5
	0.10.4
	0.10.3
	0.10.2
	0.10.1
	0.10.0
	0.10.0-rc1
	0.10.0-beta2
	0.10.0-beta1
	0.9.11
	0.9.10
	0.9.9
	0.9.8
	0.9.7
	0.9.6
	0.9.5
	0.9.4
	0.9.3
	0.9.2
	0.9.1
	0.9.0
	0.8.8
	0.8.7
	0.8.6
	0.8.5
	0.8.4
	0.8.3
	0.8.2
	0.8.1
	0.8.0
	0.7.13
	0.7.12
	0.7.11
	0.7.10
	0.7.9
	0.7.8
	0.7.7
	0.7.6
	0.7.5
	0.7.4
	0.7.3
	0.7.2
	0.7.1
	0.7.0
	0.6.16
	0.6.15
	0.6.14
	0.6.13
	0.6.12
	0.6.11
	0.6.10
	0.6.9
	0.6.8
	0.6.7
	0.6.6
	0.6.5
	0.6.4
	0.6.3
	0.6.2
	0.6.1
	0.6.0
	0.5.3
	0.5.1
	0.5.0
	0.4.2
	0.4.1
	0.4.0
	0.3.7
	0.3.6
	0.3.5
	0.3.1
	0.3.0
	0.2.2
	0.2.1
	0.2.0
	0.1.1
	0.1.0
	
	$  tfenv install latest:^0.14
	Installing Terraform v0.14.11
	Downloading release tarball from https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_linux_amd64.zip
	############################################################################################################################################################### 100.0%
	Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_SHA256SUMS
	No keybase install found, skipping OpenPGP signature verification
	Archive:  tfenv_download.bvIzkb/terraform_0.14.11_linux_amd64.zip
	  inflating: /home1/jso/.tfenv/versions/0.14.11/terraform
	Installation of terraform v0.14.11 successful. To make this your default version, run 'tfenv use 0.14.11'
	
	$  tfenv list
	  0.15.5
	  0.14.11
	* 0.13.7 (set by /home1/jso/.tfenv/version)
	  0.12.28
	```

* Use menu to select version to use in `tfenv` version manager

	```
	$  make -sf Makefile-tools tfenv-use
	
	1) 0.15.5
	2) 0.14.11
	3) 0.13.7
	4) 0.12.28
	Input your Terraform version choice to use or cltr-C to quit: 4
	Switching default version to v0.12.28
	Switching completed
	Terraform v0.12.28
	
	Your version of Terraform is out of date! The latest version
	is 0.15.5. You can update by downloading from https://www.terraform.io/downloads.html
	
	$  make -sf Makefile-tools tfenv-use
	
	1) 0.15.5
	2) 0.14.11
	3) 0.13.7
	4) 0.12.28
	Input your Terraform version choice to use or cltr-C to quit: 1
	Switching default version to v0.15.5
	Switching completed
	Terraform v0.15.5
	on linux_amd64
	```

* Menu to install version selecting from all available through `tfenv` version manager

	```bash
	$  tfenv -h
	Usage: tfenv <command> [<options>]
	
	Commands:
	   install       Install a specific version of Terraform
	   use           Switch a version to use
	   uninstall     Uninstall a specific version of Terraform
	   list          List all installed versions
	   list-remote   List all installable versions
	   version-name  Print current version
	   init          Update environment to use tfenv correctly.
	
	# Show current used version
	$  tfenv version-name
	0.15.5
	
	# Pick version and install through tfenv version manager
	$  make -f Makefile-tools tfenv-install
	
	 1) 0.15.5		    32) 0.13.7		       63) 0.12.12		  94) 0.11.7		    125) 0.9.2		       156) 0.6.11
	 2) 0.15.4		    33) 0.13.6		       64) 0.12.11		  95) 0.11.6		    126) 0.9.1		       157) 0.6.10
	 3) 0.15.3		    34) 0.13.5		       65) 0.12.10		  96) 0.11.5		    127) 0.9.0		       158) 0.6.9
	 4) 0.15.2		    35) 0.13.4		       66) 0.12.9		  97) 0.11.4		    128) 0.8.8		       159) 0.6.8
	 5) 0.15.1		    36) 0.13.3		       67) 0.12.8		  98) 0.11.3		    129) 0.8.7		       160) 0.6.7
	 6) 0.15.0		    37) 0.13.2		       68) 0.12.7		  99) 0.11.2		    130) 0.8.6		       161) 0.6.6
	 7) 0.15.0-rc2		    38) 0.13.1		       69) 0.12.6		 100) 0.11.1		    131) 0.8.5		       162) 0.6.5
	 8) 0.15.0-rc1		    39) 0.13.0		       70) 0.12.5		 101) 0.11.0		    132) 0.8.4		       163) 0.6.4
	 9) 0.15.0-beta2	    40) 0.13.0-rc1	       71) 0.12.4		 102) 0.11.0-rc1	    133) 0.8.3		       164) 0.6.3
	10) 0.15.0-beta1	    41) 0.13.0-beta3	       72) 0.12.3		 103) 0.11.0-beta1	    134) 0.8.2		       165) 0.6.2
	11) 0.15.0-alpha20210210    42) 0.13.0-beta2	       73) 0.12.2		 104) 0.10.8		    135) 0.8.1		       166) 0.6.1
	12) 0.15.0-alpha20210127    43) 0.13.0-beta1	       74) 0.12.1		 105) 0.10.7		    136) 0.8.0		       167) 0.6.0
	13) 0.15.0-alpha20210107    44) 0.12.31		       75) 0.12.0		 106) 0.10.6		    137) 0.7.13		       168) 0.5.3
	14) 0.14.11		    45) 0.12.30		       76) 0.12.0-rc1		 107) 0.10.5		    138) 0.7.12		       169) 0.5.1
	15) 0.14.10		    46) 0.12.29		       77) 0.12.0-beta2		 108) 0.10.4		    139) 0.7.11		       170) 0.5.0
	16) 0.14.9		    47) 0.12.28		       78) 0.12.0-beta1		 109) 0.10.3		    140) 0.7.10		       171) 0.4.2
	17) 0.14.8		    48) 0.12.27		       79) 0.12.0-alpha4	 110) 0.10.2		    141) 0.7.9		       172) 0.4.1
	18) 0.14.7		    49) 0.12.26		       80) 0.12.0-alpha3	 111) 0.10.1		    142) 0.7.8		       173) 0.4.0
	19) 0.14.6		    50) 0.12.25		       81) 0.12.0-alpha2	 112) 0.10.0		    143) 0.7.7		       174) 0.3.7
	20) 0.14.5		    51) 0.12.24		       82) 0.12.0-alpha1	 113) 0.10.0-rc1	    144) 0.7.6		       175) 0.3.6
	21) 0.14.4		    52) 0.12.23		       83) 0.11.15		 114) 0.10.0-beta2	    145) 0.7.5		       176) 0.3.5
	22) 0.14.3		    53) 0.12.22		       84) 0.11.15-oci		 115) 0.10.0-beta1	    146) 0.7.4		       177) 0.3.1
	23) 0.14.2		    54) 0.12.21		       85) 0.11.14		 116) 0.9.11		    147) 0.7.3		       178) 0.3.0
	24) 0.14.1		    55) 0.12.20		       86) 0.11.13		 117) 0.9.10		    148) 0.7.2		       179) 0.2.2
	25) 0.14.0		    56) 0.12.19		       87) 0.11.12		 118) 0.9.9		    149) 0.7.1		       180) 0.2.1
	26) 0.14.0-rc1		    57) 0.12.18		       88) 0.11.12-beta1	 119) 0.9.8		    150) 0.7.0		       181) 0.2.0
	27) 0.14.0-beta2	    58) 0.12.17		       89) 0.11.11		 120) 0.9.7		    151) 0.6.16		       182) 0.1.1
	28) 0.14.0-beta1	    59) 0.12.16		       90) 0.11.10		 121) 0.9.6		    152) 0.6.15		       183) 0.1.0
	29) 0.14.0-alpha20201007    60) 0.12.15		       91) 0.11.9		 122) 0.9.5		    153) 0.6.14
	30) 0.14.0-alpha20200923    61) 0.12.14		       92) 0.11.9-beta1		 123) 0.9.4		    154) 0.6.13
	31) 0.14.0-alpha20200910    62) 0.12.13		       93) 0.11.8		 124) 0.9.3		    155) 0.6.12
	Input your Terraform version choice to use or cltr-C to quit: 44
	Hit enter to install version 0.12.31 or ctrl-C to quit:
	Installing Terraform v0.12.31
	Downloading release tarball from https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip
	############################################################################################################################################################### 100.0%
	Downloading SHA hash file from https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_SHA256SUMS
	No keybase install found, skipping OpenPGP signature verification
	Archive:  tfenv_download.LoTG9A/terraform_0.12.31_linux_amd64.zip
	  inflating: /home1/jso/.tfenv/versions/0.12.31/terraform
	Installation of terraform v0.12.31 successful. To make this your default version, run 'tfenv use 0.12.31'
	
	$  tfenv list
	* 0.15.5 (set by /home1/jso/.tfenv/version)
	  0.14.11
	  0.13.7
	  0.12.31
	  0.12.28
	
	```

* Un-install version in `tfenv` version manager

	```bash
	$  tfenv uninstall 0.12.31
	Uninstall Terraform v0.12.31
	Terraform v0.12.31 is successfully uninstalled
	
	$  tfenv list
	* 0.15.5 (set by /home1/jso/.tfenv/version)
	  0.14.11
	  0.13.7
	  0.12.28
	
	$  make -f Makefile-tools tfenv-uninstall
	
	An error occurred (ExpiredToken) when calling the GetCallerIdentity operation: The security token included in the request is expired
	1) 0.15.5
	2) 0.14.11
	3) 0.13.7
	4) 0.12.28
	Input your Terraform version choice to use or cltr-C to quit: 2
	Uninstall Terraform v0.14.11
	Terraform v0.14.11 is successfully uninstalled
	* 0.15.5 (set by /home1/jso/.tfenv/version)
	  0.13.7
	  0.12.28
	```
