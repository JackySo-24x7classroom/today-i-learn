# Create an AWS Lambda Layer for Python Runtime
> This tutorial is howto add python packages, for example Pandas and its required packages to make it work in AWS Lambda function

![lambda](lambda.png)

<!-- vim-markdown-toc GFM -->

- [Build lambda layer in Amazon linux](#build-lambda-layer-in-amazon-linux)
- [Create Lambda function to use home-made python layer](#create-lambda-function-to-use-home-made-python-layer)

<!-- vim-markdown-toc -->

**Scope-of-work**
- [x] Launch Amazon EC2 Instance using Amazone Linux 2 AMI
  - [x] SSH or SSM session into running EC2 instance
- [x] Build python packages layer in EC2 instance
  - [x] Install python packages
    - [x] python3-pip
    - [x] python3
    - [x] python3-setuptools
  - [x] Build python package layer in python virtual environment
    - [x] Activiate virtual environment
    - [x] Install pandas and packages through pip manager
       - [x] pandas
       - [x] numpy
       - [x] six
       - [x] python-dateutil
       - [x] pytz
    - [x] Make zip archive of python layer
- [x] Download layer archive from EC2 instance to your workstation
    - [x] Validate zip archive
- [x] Create AWS python based lambda with home-made python layer
    - [x] Create lambda layer
       - [x] Upload home-made zip to S3 bucket
       - [x] Publish zip file to make lambda layer
    - [x] Create lambda
       - [x] optionally create lambda role
       - [x] make function zip
       - [x] create function
       - [x] update function and adding layer arn 

## Build lambda layer in Amazon linux

<details><summary><i>Click HERE to view work and command output</i></summary><br>


```bash
[root@ip-172-24-121-11 bin]# uname -a
Linux ip-172-24-121-11 4.14.177-139.254.amzn2.x86_64 #1 SMP Thu May 7 18:48:23 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
[root@ip-172-24-121-11 bin]# su - ec2-user
[ec2-user@ip-172-24-121-11 ~]$ pwd
/home/ec2-user
[ec2-user@ip-172-24-121-11 ~]$ ls

[ec2-user@ip-172-24-121-11 ~]$ sudo yum install -y python3-pip python3 python3-setuptools
Loaded plugins: extras_suggestions, langpacks, priorities, update-motd
amzn2-core                                                                                                                                     | 3.7 kB  00:00:00
amzn2extra-ansible2                                                                                                                            | 3.0 kB  00:00:00
amzn2extra-docker                                                                                                                              | 3.0 kB  00:00:00
amzn2extra-epel                                                                                                                                | 3.0 kB  00:00:00
epel/x86_64/metalink                                                                                                                           |  36 kB  00:00:00
235 packages excluded due to repository priority protections
Package python3-pip-9.0.3-1.amzn2.0.2.noarch already installed and latest version
Package python3-setuptools-38.4.0-3.amzn2.0.6.noarch already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package python3.x86_64 0:3.7.6-1.amzn2.0.1 will be updated
--> Processing Dependency: python3(x86-64) = 3.7.6-1.amzn2.0.1 for package: python3-libs-3.7.6-1.amzn2.0.1.x86_64
---> Package python3.x86_64 0:3.7.9-1.amzn2.0.2 will be an update
--> Running transaction check
---> Package python3-libs.x86_64 0:3.7.6-1.amzn2.0.1 will be updated
---> Package python3-libs.x86_64 0:3.7.9-1.amzn2.0.2 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

======================================================================================================================================================================
 Package                                 Arch                              Version                                        Repository                             Size
======================================================================================================================================================================
Updating:
 python3                                 x86_64                            3.7.9-1.amzn2.0.2                              amzn2-core                             72 k
Updating for dependencies:
 python3-libs                            x86_64                            3.7.9-1.amzn2.0.2                              amzn2-core                            9.2 M

Transaction Summary
======================================================================================================================================================================
Upgrade  1 Package (+1 Dependent package)

Total download size: 9.2 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/2): python3-3.7.9-1.amzn2.0.2.x86_64.rpm                                                                                                    |  72 kB  00:00:00
(2/2): python3-libs-3.7.9-1.amzn2.0.2.x86_64.rpm                                                                                               | 9.2 MB  00:00:00
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                  45 MB/s | 9.2 MB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
Warning: RPMDB altered outside of yum.
  Updating   : python3-3.7.9-1.amzn2.0.2.x86_64                                                                                                                   1/4
  Updating   : python3-libs-3.7.9-1.amzn2.0.2.x86_64                                                                                                              2/4
  Cleanup    : python3-3.7.6-1.amzn2.0.1.x86_64                                                                                                                   3/4
  Cleanup    : python3-libs-3.7.6-1.amzn2.0.1.x86_64                                                                                                              4/4
  Verifying  : python3-libs-3.7.9-1.amzn2.0.2.x86_64                                                                                                              1/4
  Verifying  : python3-3.7.9-1.amzn2.0.2.x86_64                                                                                                                   2/4
  Verifying  : python3-libs-3.7.6-1.amzn2.0.1.x86_64                                                                                                              3/4
  Verifying  : python3-3.7.6-1.amzn2.0.1.x86_64                                                                                                                   4/4

Updated:
  python3.x86_64 0:3.7.9-1.amzn2.0.2

Dependency Updated:
  python3-libs.x86_64 0:3.7.9-1.amzn2.0.2

Complete!

[ec2-user@ip-172-24-121-11 ~]$ id
uid=1000(ec2-user) gid=1000(ec2-user) groups=1000(ec2-user),4(adm),10(wheel),190(systemd-journal)

[ec2-user@ip-172-24-121-11 ~]$ python3 -m venv lambda/env
[ec2-user@ip-172-24-121-11 ~]$ source ~/lambda/env/bin/activate
(env) [ec2-user@ip-172-24-121-11 ~]$ cd lambda/env
(env) [ec2-user@ip-172-24-121-11 env]$ mkdir python
(env) [ec2-user@ip-172-24-121-11 env]$ ls
bin  include  lib  lib64  python  pyvenv.cfg
(env) [ec2-user@ip-172-24-121-11 env]$ tree -L 2
.
├── bin
│   ├── activate
│   ├── activate.csh
│   ├── activate.fish
│   ├── easy_install
│   ├── easy_install-3.7
│   ├── pip
│   ├── pip3
│   ├── pip3.7
│   ├── python -> python3
│   └── python3 -> /usr/bin/python3
├── include
├── lib
│   └── python3.7
├── lib64 -> lib
├── python
└── pyvenv.cfg

6 directories, 11 files

(env) [ec2-user@ip-172-24-121-11 env]$ cd python/
(env) [ec2-user@ip-172-24-121-11 python]$ ls
(env) [ec2-user@ip-172-24-121-11 python]$ pip3 install -t . pandas
Collecting pandas
  Using cached pandas-1.2.4-cp37-cp37m-manylinux1_x86_64.whl (9.9 MB)
Collecting python-dateutil>=2.7.3
  Using cached python_dateutil-2.8.1-py2.py3-none-any.whl (227 kB)
Collecting pytz>=2017.3
  Using cached pytz-2021.1-py2.py3-none-any.whl (510 kB)
Collecting numpy>=1.16.5
  Using cached numpy-1.20.2-cp37-cp37m-manylinux2010_x86_64.whl (15.3 MB)
Collecting six>=1.5
  Using cached six-1.15.0-py2.py3-none-any.whl (10 kB)
Installing collected packages: six, python-dateutil, pytz, numpy, pandas
Successfully installed numpy-1.20.2 pandas-1.2.4 python-dateutil-2.8.1 pytz-2021.1 six-1.15.0
(env) [ec2-user@ip-172-24-121-11 python]$ rm -r *dist-info __pycache__ # remove unused files


(env) [ec2-user@ip-172-24-121-11 env]$ tree -L 2
.
├── bin
│   ├── activate
│   ├── activate.csh
│   ├── activate.fish
│   ├── easy_install
│   ├── easy_install-3.7
│   ├── pip
│   ├── pip3
│   ├── pip3.7
│   ├── python -> python3
│   └── python3 -> /usr/bin/python3
├── include
├── lib
│   └── python3.7
├── lib64 -> lib
├── python
│   ├── bin
│   ├── dateutil
│   ├── numpy
│   ├── numpy.libs
│   ├── pandas
│   ├── pytz
│   └── six.py
└── pyvenv.cfg

12 directories, 12 files


(env) [ec2-user@ip-172-24-121-11 lambda]$ tree -L 2
.
└── python
    ├── bin
    ├── dateutil
    ├── numpy
    ├── numpy.libs
    ├── pandas
    ├── pytz
    └── six.py

7 directories, 1 file
(env) [ec2-user@ip-172-24-121-11 lambda]$ zip -r layer.zip python
  adding: python/ (stored 0%)
  adding: python/six.py (deflated 75%)
  adding: python/dateutil/ (stored 0%)
  adding: python/dateutil/__init__.py (deflated 32%)
  adding: python/dateutil/_common.py (deflated 61%)
  adding: python/dateutil/_version.py (deflated 13%)
  adding: python/dateutil/easter.py (deflated 53%)
  adding: python/dateutil/relativedelta.py (deflated 77%)
  adding: python/dateutil/rrule.py (deflated 77%)
  adding: python/dateutil/tzwin.py (deflated 8%)
  adding: python/dateutil/utils.py (deflated 58%)
  adding: python/dateutil/parser/ (stored 0%)
  adding: python/dateutil/parser/__init__.py (deflated 66%)
  adding: python/dateutil/parser/_parser.py (deflated 76%)
  adding: python/dateutil/parser/isoparser.py (deflated 71%)
  adding: python/dateutil/parser/__pycache__/ (stored 0%)
  adding: python/dateutil/parser/__pycache__/__init__.cpython-37.pyc (deflated 46%)
  adding: python/dateutil/parser/__pycache__/_parser.cpython-37.pyc (deflated 59%)
  adding: python/dateutil/parser/__pycache__/isoparser.cpython-37.pyc (deflated 55%)
  adding: python/dateutil/tz/ (stored 0%)
  adding: python/dateutil/tz/__init__.py (deflated 46%)
  adding: python/dateutil/tz/_common.py (deflated 74%)
  adding: python/dateutil/tz/_factories.py (deflated 76%)
  adding: python/dateutil/tz/tz.py (deflated 75%)
  adding: python/dateutil/tz/win.py (deflated 69%)
  adding: python/dateutil/tz/__pycache__/ (stored 0%)
  adding: python/dateutil/tz/__pycache__/__init__.cpython-37.pyc (deflated 30%)
  adding: python/dateutil/tz/__pycache__/_common.cpython-37.pyc (deflated 62%)
  adding: python/dateutil/tz/__pycache__/_factories.cpython-37.pyc (deflated 55%)
  adding: python/dateutil/tz/__pycache__/tz.cpython-37.pyc (deflated 60%)
  adding: python/dateutil/tz/__pycache__/win.cpython-37.pyc (deflated 53%)
  adding: python/dateutil/zoneinfo/ (stored 0%)
  adding: python/dateutil/zoneinfo/__init__.py (deflated 65%)
  adding: python/dateutil/zoneinfo/dateutil-zoneinfo.tar.gz (deflated 3%)
  adding: python/dateutil/zoneinfo/rebuild.py (deflated 56%)
  adding: python/dateutil/zoneinfo/__pycache__/ (stored 0%)
  adding: python/dateutil/zoneinfo/__pycache__/__init__.cpython-37.pyc (deflated 54%)
  adding: python/dateutil/zoneinfo/__pycache__/rebuild.cpython-37.pyc (deflated 34%)
  adding: python/dateutil/__pycache__/ (stored 0%)
  adding: python/dateutil/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/dateutil/__pycache__/_common.cpython-37.pyc (deflated 46%)
  adding: python/dateutil/__pycache__/_version.cpython-37.pyc (deflated 17%)
  adding: python/dateutil/__pycache__/easter.cpython-37.pyc (deflated 41%)
  adding: python/dateutil/__pycache__/relativedelta.cpython-37.pyc (deflated 58%)
  adding: python/dateutil/__pycache__/rrule.cpython-37.pyc (deflated 57%)
  adding: python/dateutil/__pycache__/tzwin.cpython-37.pyc (deflated 15%)
  adding: python/dateutil/__pycache__/utils.cpython-37.pyc (deflated 49%)
  adding: python/pytz/ (stored 0%)
  adding: python/pytz/__init__.py (deflated 76%)
  adding: python/pytz/exceptions.py (deflated 60%)
  adding: python/pytz/lazy.py (deflated 78%)
  adding: python/pytz/reference.py (deflated 64%)
  adding: python/pytz/tzfile.py (deflated 64%)
  adding: python/pytz/tzinfo.py (deflated 75%)
  adding: python/pytz/zoneinfo/ (stored 0%)
  adding: python/pytz/zoneinfo/CET (deflated 54%)
  adding: python/pytz/zoneinfo/CST6CDT (deflated 52%)
  adding: python/pytz/zoneinfo/Cuba (deflated 53%)
  adding: python/pytz/zoneinfo/EET (deflated 54%)
  adding: python/pytz/zoneinfo/EST (deflated 73%)
  adding: python/pytz/zoneinfo/EST5EDT (deflated 53%)
  adding: python/pytz/zoneinfo/Egypt (deflated 51%)
  adding: python/pytz/zoneinfo/Eire (deflated 53%)
  adding: python/pytz/zoneinfo/Factory (deflated 75%)
  adding: python/pytz/zoneinfo/GB (deflated 53%)
  adding: python/pytz/zoneinfo/GB-Eire (deflated 53%)
  adding: python/pytz/zoneinfo/GMT (deflated 76%)
  adding: python/pytz/zoneinfo/GMT+0 (deflated 76%)
  adding: python/pytz/zoneinfo/GMT-0 (deflated 76%)
  adding: python/pytz/zoneinfo/GMT0 (deflated 76%)
  adding: python/pytz/zoneinfo/Greenwich (deflated 76%)
  adding: python/pytz/zoneinfo/HST (deflated 72%)
  adding: python/pytz/zoneinfo/Hongkong (deflated 52%)
  adding: python/pytz/zoneinfo/Iceland (deflated 52%)
  adding: python/pytz/zoneinfo/Iran (deflated 50%)
  adding: python/pytz/zoneinfo/Israel (deflated 52%)
  adding: python/pytz/zoneinfo/Jamaica (deflated 49%)
  adding: python/pytz/zoneinfo/Japan (deflated 56%)
  adding: python/pytz/zoneinfo/Kwajalein (deflated 53%)
  adding: python/pytz/zoneinfo/Libya (deflated 48%)
  adding: python/pytz/zoneinfo/MET (deflated 54%)
  adding: python/pytz/zoneinfo/MST (deflated 73%)
  adding: python/pytz/zoneinfo/MST7MDT (deflated 53%)
  adding: python/pytz/zoneinfo/NZ (deflated 54%)
  adding: python/pytz/zoneinfo/NZ-CHAT (deflated 53%)
  adding: python/pytz/zoneinfo/Navajo (deflated 53%)
  adding: python/pytz/zoneinfo/PRC (deflated 50%)
  adding: python/pytz/zoneinfo/PST8PDT (deflated 53%)
  adding: python/pytz/zoneinfo/Poland (deflated 53%)
  adding: python/pytz/zoneinfo/Portugal (deflated 53%)
  adding: python/pytz/zoneinfo/ROC (deflated 52%)
  adding: python/pytz/zoneinfo/ROK (deflated 49%)
  adding: python/pytz/zoneinfo/Singapore (deflated 55%)
  adding: python/pytz/zoneinfo/Turkey (deflated 53%)
  adding: python/pytz/zoneinfo/UCT (deflated 76%)
  adding: python/pytz/zoneinfo/UTC (deflated 76%)
  adding: python/pytz/zoneinfo/Universal (deflated 76%)
  adding: python/pytz/zoneinfo/W-SU (deflated 53%)
  adding: python/pytz/zoneinfo/WET (deflated 54%)
  adding: python/pytz/zoneinfo/Zulu (deflated 76%)
  adding: python/pytz/zoneinfo/iso3166.tab (deflated 41%)
  adding: python/pytz/zoneinfo/leapseconds (deflated 58%)
  adding: python/pytz/zoneinfo/tzdata.zi (deflated 76%)
  adding: python/pytz/zoneinfo/zone.tab (deflated 52%)
  adding: python/pytz/zoneinfo/zone1970.tab (deflated 51%)
  adding: python/pytz/zoneinfo/Africa/ (stored 0%)
  adding: python/pytz/zoneinfo/Africa/Abidjan (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Accra (deflated 50%)
  adding: python/pytz/zoneinfo/Africa/Addis_Ababa (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Algiers (deflated 51%)
  adding: python/pytz/zoneinfo/Africa/Asmara (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Asmera (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Bamako (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Bangui (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Banjul (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Bissau (deflated 62%)
  adding: python/pytz/zoneinfo/Africa/Blantyre (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Brazzaville (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Bujumbura (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Cairo (deflated 51%)
  adding: python/pytz/zoneinfo/Africa/Casablanca (deflated 50%)
  adding: python/pytz/zoneinfo/Africa/Ceuta (deflated 53%)
  adding: python/pytz/zoneinfo/Africa/Conakry (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Dakar (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Dar_es_Salaam (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Djibouti (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Douala (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/El_Aaiun (deflated 51%)
  adding: python/pytz/zoneinfo/Africa/Freetown (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Gaborone (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Harare (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Johannesburg (deflated 57%)
  adding: python/pytz/zoneinfo/Africa/Juba (deflated 52%)
  adding: python/pytz/zoneinfo/Africa/Kampala (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Khartoum (deflated 52%)
  adding: python/pytz/zoneinfo/Africa/Kigali (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Kinshasa (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Lagos (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Libreville (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Lome (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Luanda (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Lubumbashi (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Lusaka (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Malabo (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Maputo (deflated 66%)
  adding: python/pytz/zoneinfo/Africa/Maseru (deflated 57%)
  adding: python/pytz/zoneinfo/Africa/Mbabane (deflated 57%)
  adding: python/pytz/zoneinfo/Africa/Mogadishu (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Monrovia (deflated 63%)
  adding: python/pytz/zoneinfo/Africa/Nairobi (deflated 58%)
  adding: python/pytz/zoneinfo/Africa/Ndjamena (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Niamey (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Nouakchott (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Ouagadougou (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Porto-Novo (deflated 61%)
  adding: python/pytz/zoneinfo/Africa/Sao_Tome (deflated 63%)
  adding: python/pytz/zoneinfo/Africa/Timbuktu (deflated 68%)
  adding: python/pytz/zoneinfo/Africa/Tripoli (deflated 48%)
  adding: python/pytz/zoneinfo/Africa/Tunis (deflated 50%)
  adding: python/pytz/zoneinfo/Africa/Windhoek (deflated 50%)
  adding: python/pytz/zoneinfo/America/ (stored 0%)
  adding: python/pytz/zoneinfo/America/Adak (deflated 51%)
  adding: python/pytz/zoneinfo/America/Anchorage (deflated 52%)
  adding: python/pytz/zoneinfo/America/Anguilla (deflated 63%)
  adding: python/pytz/zoneinfo/America/Antigua (deflated 63%)
  adding: python/pytz/zoneinfo/America/Araguaina (deflated 51%)
  adding: python/pytz/zoneinfo/America/Aruba (deflated 59%)
  adding: python/pytz/zoneinfo/America/Asuncion (deflated 52%)
  adding: python/pytz/zoneinfo/America/Atikokan (deflated 58%)
  adding: python/pytz/zoneinfo/America/Atka (deflated 51%)
  adding: python/pytz/zoneinfo/America/Bahia (deflated 51%)
  adding: python/pytz/zoneinfo/America/Bahia_Banderas (deflated 52%)
  adding: python/pytz/zoneinfo/America/Barbados (deflated 54%)
  adding: python/pytz/zoneinfo/America/Belem (deflated 49%)
  adding: python/pytz/zoneinfo/America/Belize (deflated 52%)
  adding: python/pytz/zoneinfo/America/Blanc-Sablon (deflated 58%)
  adding: python/pytz/zoneinfo/America/Boa_Vista (deflated 50%)
  adding: python/pytz/zoneinfo/America/Bogota (deflated 56%)
  adding: python/pytz/zoneinfo/America/Boise (deflated 53%)
  adding: python/pytz/zoneinfo/America/Buenos_Aires (deflated 50%)
  adding: python/pytz/zoneinfo/America/Cambridge_Bay (deflated 53%)
  adding: python/pytz/zoneinfo/America/Campo_Grande (deflated 52%)
  adding: python/pytz/zoneinfo/America/Cancun (deflated 52%)
  adding: python/pytz/zoneinfo/America/Caracas (deflated 54%)
  adding: python/pytz/zoneinfo/America/Catamarca (deflated 50%)
  adding: python/pytz/zoneinfo/America/Cayenne (deflated 58%)
  adding: python/pytz/zoneinfo/America/Cayman (deflated 61%)
  adding: python/pytz/zoneinfo/America/Chicago (deflated 53%)
  adding: python/pytz/zoneinfo/America/Chihuahua (deflated 52%)
  adding: python/pytz/zoneinfo/America/Coral_Harbour (deflated 58%)
  adding: python/pytz/zoneinfo/America/Cordoba (deflated 50%)
  adding: python/pytz/zoneinfo/America/Costa_Rica (deflated 53%)
  adding: python/pytz/zoneinfo/America/Creston (deflated 60%)
  adding: python/pytz/zoneinfo/America/Cuiaba (deflated 52%)
  adding: python/pytz/zoneinfo/America/Curacao (deflated 59%)
  adding: python/pytz/zoneinfo/America/Danmarkshavn (deflated 52%)
  adding: python/pytz/zoneinfo/America/Dawson (deflated 53%)
  adding: python/pytz/zoneinfo/America/Dawson_Creek (deflated 52%)
  adding: python/pytz/zoneinfo/America/Denver (deflated 53%)
  adding: python/pytz/zoneinfo/America/Detroit (deflated 52%)
  adding: python/pytz/zoneinfo/America/Dominica (deflated 63%)
  adding: python/pytz/zoneinfo/America/Edmonton (deflated 52%)
  adding: python/pytz/zoneinfo/America/Eirunepe (deflated 51%)
  adding: python/pytz/zoneinfo/America/El_Salvador (deflated 56%)
  adding: python/pytz/zoneinfo/America/Ensenada (deflated 53%)
  adding: python/pytz/zoneinfo/America/Fort_Nelson (deflated 53%)
  adding: python/pytz/zoneinfo/America/Fort_Wayne (deflated 52%)
  adding: python/pytz/zoneinfo/America/Fortaleza (deflated 50%)
  adding: python/pytz/zoneinfo/America/Glace_Bay (deflated 52%)
  adding: python/pytz/zoneinfo/America/Godthab (deflated 53%)
  adding: python/pytz/zoneinfo/America/Goose_Bay (deflated 52%)
  adding: python/pytz/zoneinfo/America/Grand_Turk (deflated 52%)
  adding: python/pytz/zoneinfo/America/Grenada (deflated 63%)
  adding: python/pytz/zoneinfo/America/Guadeloupe (deflated 63%)
  adding: python/pytz/zoneinfo/America/Guatemala (deflated 54%)
  adding: python/pytz/zoneinfo/America/Guayaquil (deflated 54%)
  adding: python/pytz/zoneinfo/America/Guyana (deflated 57%)
  adding: python/pytz/zoneinfo/America/Halifax (deflated 52%)
  adding: python/pytz/zoneinfo/America/Havana (deflated 53%)
  adding: python/pytz/zoneinfo/America/Hermosillo (deflated 51%)
  adding: python/pytz/zoneinfo/America/Indianapolis (deflated 52%)
  adding: python/pytz/zoneinfo/America/Inuvik (deflated 52%)
  adding: python/pytz/zoneinfo/America/Iqaluit (deflated 52%)
  adding: python/pytz/zoneinfo/America/Jamaica (deflated 49%)
  adding: python/pytz/zoneinfo/America/Jujuy (deflated 50%)
  adding: python/pytz/zoneinfo/America/Juneau (deflated 52%)
  adding: python/pytz/zoneinfo/America/Knox_IN (deflated 52%)
  adding: python/pytz/zoneinfo/America/Kralendijk (deflated 59%)
  adding: python/pytz/zoneinfo/America/La_Paz (deflated 57%)
  adding: python/pytz/zoneinfo/America/Lima (deflated 50%)
  adding: python/pytz/zoneinfo/America/Los_Angeles (deflated 53%)
  adding: python/pytz/zoneinfo/America/Louisville (deflated 53%)
  adding: python/pytz/zoneinfo/America/Lower_Princes (deflated 59%)
  adding: python/pytz/zoneinfo/America/Maceio (deflated 51%)
  adding: python/pytz/zoneinfo/America/Managua (deflated 51%)
  adding: python/pytz/zoneinfo/America/Manaus (deflated 49%)
  adding: python/pytz/zoneinfo/America/Marigot (deflated 63%)
  adding: python/pytz/zoneinfo/America/Martinique (deflated 59%)
  adding: python/pytz/zoneinfo/America/Matamoros (deflated 51%)
  adding: python/pytz/zoneinfo/America/Mazatlan (deflated 52%)
  adding: python/pytz/zoneinfo/America/Mendoza (deflated 50%)
  adding: python/pytz/zoneinfo/America/Menominee (deflated 52%)
  adding: python/pytz/zoneinfo/America/Merida (deflated 52%)
  adding: python/pytz/zoneinfo/America/Metlakatla (deflated 50%)
  adding: python/pytz/zoneinfo/America/Mexico_City (deflated 52%)
  adding: python/pytz/zoneinfo/America/Miquelon (deflated 52%)
  adding: python/pytz/zoneinfo/America/Moncton (deflated 53%)
  adding: python/pytz/zoneinfo/America/Monterrey (deflated 51%)
  adding: python/pytz/zoneinfo/America/Montevideo (deflated 51%)
  adding: python/pytz/zoneinfo/America/Montreal (deflated 53%)
  adding: python/pytz/zoneinfo/America/Montserrat (deflated 63%)
  adding: python/pytz/zoneinfo/America/Nassau (deflated 53%)
  adding: python/pytz/zoneinfo/America/New_York (deflated 53%)
  adding: python/pytz/zoneinfo/America/Nipigon (deflated 52%)
  adding: python/pytz/zoneinfo/America/Nome (deflated 51%)
  adding: python/pytz/zoneinfo/America/Noronha (deflated 51%)
  adding: python/pytz/zoneinfo/America/Nuuk (deflated 53%)
  adding: python/pytz/zoneinfo/America/Ojinaga (deflated 51%)
  adding: python/pytz/zoneinfo/America/Panama (deflated 61%)
  adding: python/pytz/zoneinfo/America/Pangnirtung (deflated 53%)
  adding: python/pytz/zoneinfo/America/Paramaribo (deflated 58%)
  adding: python/pytz/zoneinfo/America/Phoenix (deflated 52%)
  adding: python/pytz/zoneinfo/America/Port-au-Prince (deflated 51%)
  adding: python/pytz/zoneinfo/America/Port_of_Spain (deflated 63%)
  adding: python/pytz/zoneinfo/America/Porto_Acre (deflated 50%)
  adding: python/pytz/zoneinfo/America/Porto_Velho (deflated 49%)
  adding: python/pytz/zoneinfo/America/Puerto_Rico (deflated 59%)
  adding: python/pytz/zoneinfo/America/Punta_Arenas (deflated 52%)
  adding: python/pytz/zoneinfo/America/Rainy_River (deflated 52%)
  adding: python/pytz/zoneinfo/America/Rankin_Inlet (deflated 51%)
  adding: python/pytz/zoneinfo/America/Recife (deflated 50%)
  adding: python/pytz/zoneinfo/America/Regina (deflated 51%)
  adding: python/pytz/zoneinfo/America/Resolute (deflated 51%)
  adding: python/pytz/zoneinfo/America/Rio_Branco (deflated 50%)
  adding: python/pytz/zoneinfo/America/Rosario (deflated 50%)
  adding: python/pytz/zoneinfo/America/Santa_Isabel (deflated 53%)
  adding: python/pytz/zoneinfo/America/Santarem (deflated 49%)
  adding: python/pytz/zoneinfo/America/Santiago (deflated 53%)
  adding: python/pytz/zoneinfo/America/Santo_Domingo (deflated 50%)
  adding: python/pytz/zoneinfo/America/Sao_Paulo (deflated 52%)
  adding: python/pytz/zoneinfo/America/Scoresbysund (deflated 54%)
  adding: python/pytz/zoneinfo/America/Shiprock (deflated 53%)
  adding: python/pytz/zoneinfo/America/Sitka (deflated 52%)
  adding: python/pytz/zoneinfo/America/St_Barthelemy (deflated 63%)
  adding: python/pytz/zoneinfo/America/St_Johns (deflated 52%)
  adding: python/pytz/zoneinfo/America/St_Kitts (deflated 63%)
  adding: python/pytz/zoneinfo/America/St_Lucia (deflated 63%)
  adding: python/pytz/zoneinfo/America/St_Thomas (deflated 63%)
  adding: python/pytz/zoneinfo/America/St_Vincent (deflated 63%)
  adding: python/pytz/zoneinfo/America/Swift_Current (deflated 52%)
  adding: python/pytz/zoneinfo/America/Tegucigalpa (deflated 54%)
  adding: python/pytz/zoneinfo/America/Thule (deflated 52%)
  adding: python/pytz/zoneinfo/America/Thunder_Bay (deflated 53%)
  adding: python/pytz/zoneinfo/America/Tijuana (deflated 53%)
  adding: python/pytz/zoneinfo/America/Toronto (deflated 53%)
  adding: python/pytz/zoneinfo/America/Tortola (deflated 63%)
  adding: python/pytz/zoneinfo/America/Vancouver (deflated 53%)
  adding: python/pytz/zoneinfo/America/Virgin (deflated 63%)
  adding: python/pytz/zoneinfo/America/Whitehorse (deflated 54%)
  adding: python/pytz/zoneinfo/America/Winnipeg (deflated 52%)
  adding: python/pytz/zoneinfo/America/Yakutat (deflated 52%)
  adding: python/pytz/zoneinfo/America/Yellowknife (deflated 52%)
  adding: python/pytz/zoneinfo/America/Argentina/ (stored 0%)
  adding: python/pytz/zoneinfo/America/Argentina/Buenos_Aires (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/Catamarca (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/ComodRivadavia (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/Cordoba (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/Jujuy (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/La_Rioja (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/Mendoza (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/Rio_Gallegos (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/Salta (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/San_Juan (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/San_Luis (deflated 51%)
  adding: python/pytz/zoneinfo/America/Argentina/Tucuman (deflated 50%)
  adding: python/pytz/zoneinfo/America/Argentina/Ushuaia (deflated 50%)
  adding: python/pytz/zoneinfo/America/Indiana/ (stored 0%)
  adding: python/pytz/zoneinfo/America/Indiana/Indianapolis (deflated 52%)
  adding: python/pytz/zoneinfo/America/Indiana/Knox (deflated 52%)
  adding: python/pytz/zoneinfo/America/Indiana/Marengo (deflated 52%)
  adding: python/pytz/zoneinfo/America/Indiana/Petersburg (deflated 51%)
  adding: python/pytz/zoneinfo/America/Indiana/Tell_City (deflated 52%)
  adding: python/pytz/zoneinfo/America/Indiana/Vevay (deflated 52%)
  adding: python/pytz/zoneinfo/America/Indiana/Vincennes (deflated 52%)
  adding: python/pytz/zoneinfo/America/Indiana/Winamac (deflated 52%)
  adding: python/pytz/zoneinfo/America/Kentucky/ (stored 0%)
  adding: python/pytz/zoneinfo/America/Kentucky/Louisville (deflated 53%)
  adding: python/pytz/zoneinfo/America/Kentucky/Monticello (deflated 52%)
  adding: python/pytz/zoneinfo/America/North_Dakota/ (stored 0%)
  adding: python/pytz/zoneinfo/America/North_Dakota/Beulah (deflated 52%)
  adding: python/pytz/zoneinfo/America/North_Dakota/Center (deflated 52%)
  adding: python/pytz/zoneinfo/America/North_Dakota/New_Salem (deflated 52%)
  adding: python/pytz/zoneinfo/Antarctica/ (stored 0%)
  adding: python/pytz/zoneinfo/Antarctica/Casey (deflated 54%)
  adding: python/pytz/zoneinfo/Antarctica/Davis (deflated 57%)
  adding: python/pytz/zoneinfo/Antarctica/DumontDUrville (deflated 59%)
  adding: python/pytz/zoneinfo/Antarctica/Macquarie (deflated 54%)
  adding: python/pytz/zoneinfo/Antarctica/Mawson (deflated 62%)
  adding: python/pytz/zoneinfo/Antarctica/McMurdo (deflated 54%)
  adding: python/pytz/zoneinfo/Antarctica/Palmer (deflated 53%)
  adding: python/pytz/zoneinfo/Antarctica/Rothera (deflated 65%)
  adding: python/pytz/zoneinfo/Antarctica/South_Pole (deflated 54%)
  adding: python/pytz/zoneinfo/Antarctica/Syowa (deflated 65%)
  adding: python/pytz/zoneinfo/Antarctica/Troll (deflated 52%)
  adding: python/pytz/zoneinfo/Antarctica/Vostok (deflated 65%)
  adding: python/pytz/zoneinfo/Arctic/ (stored 0%)
  adding: python/pytz/zoneinfo/Arctic/Longyearbyen (deflated 54%)
  adding: python/pytz/zoneinfo/Asia/ (stored 0%)
  adding: python/pytz/zoneinfo/Asia/Aden (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Almaty (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Amman (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Anadyr (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Aqtau (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Aqtobe (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Ashgabat (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Ashkhabad (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Atyrau (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Baghdad (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Bahrain (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Baku (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Bangkok (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Barnaul (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Beirut (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Bishkek (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Brunei (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Calcutta (deflated 46%)
  adding: python/pytz/zoneinfo/Asia/Chita (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Choibalsan (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Chongqing (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Chungking (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Colombo (deflated 55%)
  adding: python/pytz/zoneinfo/Asia/Dacca (deflated 55%)
  adding: python/pytz/zoneinfo/Asia/Damascus (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Dhaka (deflated 55%)
  adding: python/pytz/zoneinfo/Asia/Dili (deflated 56%)
  adding: python/pytz/zoneinfo/Asia/Dubai (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Dushanbe (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Famagusta (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Gaza (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Harbin (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Hebron (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Ho_Chi_Minh (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Hong_Kong (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Hovd (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Irkutsk (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Istanbul (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Jakarta (deflated 55%)
  adding: python/pytz/zoneinfo/Asia/Jayapura (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Jerusalem (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Kabul (deflated 59%)
  adding: python/pytz/zoneinfo/Asia/Kamchatka (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Karachi (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Kashgar (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Kathmandu (deflated 59%)
  adding: python/pytz/zoneinfo/Asia/Katmandu (deflated 59%)
  adding: python/pytz/zoneinfo/Asia/Khandyga (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Kolkata (deflated 46%)
  adding: python/pytz/zoneinfo/Asia/Krasnoyarsk (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Kuala_Lumpur (deflated 55%)
  adding: python/pytz/zoneinfo/Asia/Kuching (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Kuwait (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Macao (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Macau (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Magadan (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Makassar (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Manila (deflated 49%)
  adding: python/pytz/zoneinfo/Asia/Muscat (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Nicosia (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Novokuznetsk (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Novosibirsk (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Omsk (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Oral (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Phnom_Penh (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Pontianak (deflated 55%)
  adding: python/pytz/zoneinfo/Asia/Pyongyang (deflated 58%)
  adding: python/pytz/zoneinfo/Asia/Qatar (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Qostanay (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Qyzylorda (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Rangoon (deflated 58%)
  adding: python/pytz/zoneinfo/Asia/Riyadh (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Saigon (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Sakhalin (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Samarkand (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Seoul (deflated 49%)
  adding: python/pytz/zoneinfo/Asia/Shanghai (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Singapore (deflated 55%)
  adding: python/pytz/zoneinfo/Asia/Srednekolymsk (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Taipei (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Tashkent (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Tbilisi (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Tehran (deflated 50%)
  adding: python/pytz/zoneinfo/Asia/Tel_Aviv (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Thimbu (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Thimphu (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Tokyo (deflated 56%)
  adding: python/pytz/zoneinfo/Asia/Tomsk (deflated 51%)
  adding: python/pytz/zoneinfo/Asia/Ujung_Pandang (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Ulaanbaatar (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Ulan_Bator (deflated 52%)
  adding: python/pytz/zoneinfo/Asia/Urumqi (deflated 62%)
  adding: python/pytz/zoneinfo/Asia/Ust-Nera (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Vientiane (deflated 60%)
  adding: python/pytz/zoneinfo/Asia/Vladivostok (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Yakutsk (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Yangon (deflated 58%)
  adding: python/pytz/zoneinfo/Asia/Yekaterinburg (deflated 53%)
  adding: python/pytz/zoneinfo/Asia/Yerevan (deflated 52%)
  adding: python/pytz/zoneinfo/Atlantic/ (stored 0%)
  adding: python/pytz/zoneinfo/Atlantic/Azores (deflated 53%)
  adding: python/pytz/zoneinfo/Atlantic/Bermuda (deflated 53%)
  adding: python/pytz/zoneinfo/Atlantic/Canary (deflated 53%)
  adding: python/pytz/zoneinfo/Atlantic/Cape_Verde (deflated 59%)
  adding: python/pytz/zoneinfo/Atlantic/Faeroe (deflated 54%)
  adding: python/pytz/zoneinfo/Atlantic/Faroe (deflated 54%)
  adding: python/pytz/zoneinfo/Atlantic/Jan_Mayen (deflated 54%)
  adding: python/pytz/zoneinfo/Atlantic/Madeira (deflated 53%)
  adding: python/pytz/zoneinfo/Atlantic/Reykjavik (deflated 52%)
  adding: python/pytz/zoneinfo/Atlantic/South_Georgia (deflated 61%)
  adding: python/pytz/zoneinfo/Atlantic/St_Helena (deflated 68%)
  adding: python/pytz/zoneinfo/Atlantic/Stanley (deflated 51%)
  adding: python/pytz/zoneinfo/Australia/ (stored 0%)
  adding: python/pytz/zoneinfo/Australia/ACT (deflated 53%)
  adding: python/pytz/zoneinfo/Australia/Adelaide (deflated 51%)
  adding: python/pytz/zoneinfo/Australia/Brisbane (deflated 52%)
  adding: python/pytz/zoneinfo/Australia/Broken_Hill (deflated 52%)
  adding: python/pytz/zoneinfo/Australia/Canberra (deflated 53%)
  adding: python/pytz/zoneinfo/Australia/Currie (deflated 54%)
  adding: python/pytz/zoneinfo/Australia/Darwin (deflated 45%)
  adding: python/pytz/zoneinfo/Australia/Eucla (deflated 50%)
  adding: python/pytz/zoneinfo/Australia/Hobart (deflated 54%)
  adding: python/pytz/zoneinfo/Australia/LHI (deflated 52%)
  adding: python/pytz/zoneinfo/Australia/Lindeman (deflated 50%)
  adding: python/pytz/zoneinfo/Australia/Lord_Howe (deflated 52%)
  adding: python/pytz/zoneinfo/Australia/Melbourne (deflated 53%)
  adding: python/pytz/zoneinfo/Australia/NSW (deflated 53%)
  adding: python/pytz/zoneinfo/Australia/North (deflated 45%)
  adding: python/pytz/zoneinfo/Australia/Perth (deflated 51%)
  adding: python/pytz/zoneinfo/Australia/Queensland (deflated 52%)
  adding: python/pytz/zoneinfo/Australia/South (deflated 51%)
  adding: python/pytz/zoneinfo/Australia/Sydney (deflated 53%)
  adding: python/pytz/zoneinfo/Australia/Tasmania (deflated 54%)
  adding: python/pytz/zoneinfo/Australia/Victoria (deflated 53%)
  adding: python/pytz/zoneinfo/Australia/West (deflated 51%)
  adding: python/pytz/zoneinfo/Australia/Yancowinna (deflated 52%)
  adding: python/pytz/zoneinfo/Brazil/ (stored 0%)
  adding: python/pytz/zoneinfo/Brazil/Acre (deflated 50%)
  adding: python/pytz/zoneinfo/Brazil/DeNoronha (deflated 51%)
  adding: python/pytz/zoneinfo/Brazil/East (deflated 52%)
  adding: python/pytz/zoneinfo/Brazil/West (deflated 49%)
  adding: python/pytz/zoneinfo/Canada/ (stored 0%)
  adding: python/pytz/zoneinfo/Canada/Atlantic (deflated 52%)
  adding: python/pytz/zoneinfo/Canada/Central (deflated 52%)
  adding: python/pytz/zoneinfo/Canada/Eastern (deflated 53%)
  adding: python/pytz/zoneinfo/Canada/Mountain (deflated 52%)
  adding: python/pytz/zoneinfo/Canada/Newfoundland (deflated 52%)
  adding: python/pytz/zoneinfo/Canada/Pacific (deflated 53%)
  adding: python/pytz/zoneinfo/Canada/Saskatchewan (deflated 51%)
  adding: python/pytz/zoneinfo/Canada/Yukon (deflated 54%)
  adding: python/pytz/zoneinfo/Chile/ (stored 0%)
  adding: python/pytz/zoneinfo/Chile/Continental (deflated 53%)
  adding: python/pytz/zoneinfo/Chile/EasterIsland (deflated 53%)
  adding: python/pytz/zoneinfo/Etc/ (stored 0%)
  adding: python/pytz/zoneinfo/Etc/GMT (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/GMT+0 (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/GMT+1 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+10 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT+11 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT+12 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT+2 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+3 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+4 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+5 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+6 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+7 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+8 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT+9 (deflated 72%)
  adding: python/pytz/zoneinfo/Etc/GMT-0 (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/GMT-1 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-10 (deflated 70%)
  adding: python/pytz/zoneinfo/Etc/GMT-11 (deflated 70%)
  adding: python/pytz/zoneinfo/Etc/GMT-12 (deflated 70%)
  adding: python/pytz/zoneinfo/Etc/GMT-13 (deflated 70%)
  adding: python/pytz/zoneinfo/Etc/GMT-14 (deflated 70%)
  adding: python/pytz/zoneinfo/Etc/GMT-2 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-3 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-4 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-5 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-6 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-7 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-8 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT-9 (deflated 71%)
  adding: python/pytz/zoneinfo/Etc/GMT0 (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/Greenwich (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/UCT (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/UTC (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/Universal (deflated 76%)
  adding: python/pytz/zoneinfo/Etc/Zulu (deflated 76%)
  adding: python/pytz/zoneinfo/Europe/ (stored 0%)
  adding: python/pytz/zoneinfo/Europe/Amsterdam (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Andorra (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Astrakhan (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Athens (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Belfast (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Belgrade (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Berlin (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Bratislava (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Brussels (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Bucharest (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Budapest (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Busingen (deflated 51%)
  adding: python/pytz/zoneinfo/Europe/Chisinau (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Copenhagen (deflated 51%)
  adding: python/pytz/zoneinfo/Europe/Dublin (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Gibraltar (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Guernsey (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Helsinki (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Isle_of_Man (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Istanbul (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Jersey (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Kaliningrad (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Kiev (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Kirov (deflated 51%)
  adding: python/pytz/zoneinfo/Europe/Lisbon (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Ljubljana (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/London (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Luxembourg (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Madrid (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Malta (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Mariehamn (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Minsk (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Monaco (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Moscow (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Nicosia (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Oslo (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Paris (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Podgorica (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Prague (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Riga (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Rome (deflated 51%)
  adding: python/pytz/zoneinfo/Europe/Samara (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/San_Marino (deflated 51%)
  adding: python/pytz/zoneinfo/Europe/Sarajevo (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Saratov (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Simferopol (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Skopje (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Sofia (deflated 50%)
  adding: python/pytz/zoneinfo/Europe/Stockholm (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Tallinn (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Tirane (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Tiraspol (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Ulyanovsk (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Uzhgorod (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Vaduz (deflated 51%)
  adding: python/pytz/zoneinfo/Europe/Vatican (deflated 51%)
  adding: python/pytz/zoneinfo/Europe/Vienna (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Vilnius (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Volgograd (deflated 52%)
  adding: python/pytz/zoneinfo/Europe/Warsaw (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Zagreb (deflated 54%)
  adding: python/pytz/zoneinfo/Europe/Zaporozhye (deflated 53%)
  adding: python/pytz/zoneinfo/Europe/Zurich (deflated 51%)
  adding: python/pytz/zoneinfo/Indian/ (stored 0%)
  adding: python/pytz/zoneinfo/Indian/Antananarivo (deflated 58%)
  adding: python/pytz/zoneinfo/Indian/Chagos (deflated 60%)
  adding: python/pytz/zoneinfo/Indian/Christmas (deflated 62%)
  adding: python/pytz/zoneinfo/Indian/Cocos (deflated 61%)
  adding: python/pytz/zoneinfo/Indian/Comoro (deflated 58%)
  adding: python/pytz/zoneinfo/Indian/Kerguelen (deflated 65%)
  adding: python/pytz/zoneinfo/Indian/Mahe (deflated 62%)
  adding: python/pytz/zoneinfo/Indian/Maldives (deflated 60%)
  adding: python/pytz/zoneinfo/Indian/Mauritius (deflated 55%)
  adding: python/pytz/zoneinfo/Indian/Mayotte (deflated 58%)
  adding: python/pytz/zoneinfo/Indian/Reunion (deflated 63%)
  adding: python/pytz/zoneinfo/Mexico/ (stored 0%)
  adding: python/pytz/zoneinfo/Mexico/BajaNorte (deflated 53%)
  adding: python/pytz/zoneinfo/Mexico/BajaSur (deflated 52%)
  adding: python/pytz/zoneinfo/Mexico/General (deflated 52%)
  adding: python/pytz/zoneinfo/Pacific/ (stored 0%)
  adding: python/pytz/zoneinfo/Pacific/Apia (deflated 51%)
  adding: python/pytz/zoneinfo/Pacific/Auckland (deflated 54%)
  adding: python/pytz/zoneinfo/Pacific/Bougainville (deflated 45%)
  adding: python/pytz/zoneinfo/Pacific/Chatham (deflated 53%)
  adding: python/pytz/zoneinfo/Pacific/Chuuk (deflated 51%)
  adding: python/pytz/zoneinfo/Pacific/Easter (deflated 53%)
  adding: python/pytz/zoneinfo/Pacific/Efate (deflated 50%)
  adding: python/pytz/zoneinfo/Pacific/Enderbury (deflated 56%)
  adding: python/pytz/zoneinfo/Pacific/Fakaofo (deflated 58%)
  adding: python/pytz/zoneinfo/Pacific/Fiji (deflated 51%)
  adding: python/pytz/zoneinfo/Pacific/Funafuti (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Galapagos (deflated 57%)
  adding: python/pytz/zoneinfo/Pacific/Gambier (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Guadalcanal (deflated 61%)
  adding: python/pytz/zoneinfo/Pacific/Guam (deflated 47%)
  adding: python/pytz/zoneinfo/Pacific/Honolulu (deflated 57%)
  adding: python/pytz/zoneinfo/Pacific/Johnston (deflated 57%)
  adding: python/pytz/zoneinfo/Pacific/Kiritimati (deflated 58%)
  adding: python/pytz/zoneinfo/Pacific/Kosrae (deflated 47%)
  adding: python/pytz/zoneinfo/Pacific/Kwajalein (deflated 53%)
  adding: python/pytz/zoneinfo/Pacific/Majuro (deflated 53%)
  adding: python/pytz/zoneinfo/Pacific/Marquesas (deflated 60%)
  adding: python/pytz/zoneinfo/Pacific/Midway (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Nauru (deflated 55%)
  adding: python/pytz/zoneinfo/Pacific/Niue (deflated 59%)
  adding: python/pytz/zoneinfo/Pacific/Norfolk (deflated 51%)
  adding: python/pytz/zoneinfo/Pacific/Noumea (deflated 56%)
  adding: python/pytz/zoneinfo/Pacific/Pago_Pago (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Palau (deflated 56%)
  adding: python/pytz/zoneinfo/Pacific/Pitcairn (deflated 59%)
  adding: python/pytz/zoneinfo/Pacific/Pohnpei (deflated 48%)
  adding: python/pytz/zoneinfo/Pacific/Ponape (deflated 48%)
  adding: python/pytz/zoneinfo/Pacific/Port_Moresby (deflated 52%)
  adding: python/pytz/zoneinfo/Pacific/Rarotonga (deflated 49%)
  adding: python/pytz/zoneinfo/Pacific/Saipan (deflated 47%)
  adding: python/pytz/zoneinfo/Pacific/Samoa (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Tahiti (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Tarawa (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Tongatapu (deflated 54%)
  adding: python/pytz/zoneinfo/Pacific/Truk (deflated 51%)
  adding: python/pytz/zoneinfo/Pacific/Wake (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Wallis (deflated 62%)
  adding: python/pytz/zoneinfo/Pacific/Yap (deflated 51%)
  adding: python/pytz/zoneinfo/US/ (stored 0%)
  adding: python/pytz/zoneinfo/US/Alaska (deflated 52%)
  adding: python/pytz/zoneinfo/US/Aleutian (deflated 51%)
  adding: python/pytz/zoneinfo/US/Arizona (deflated 52%)
  adding: python/pytz/zoneinfo/US/Central (deflated 53%)
  adding: python/pytz/zoneinfo/US/East-Indiana (deflated 52%)
  adding: python/pytz/zoneinfo/US/Eastern (deflated 53%)
  adding: python/pytz/zoneinfo/US/Hawaii (deflated 57%)
  adding: python/pytz/zoneinfo/US/Indiana-Starke (deflated 52%)
  adding: python/pytz/zoneinfo/US/Michigan (deflated 52%)
  adding: python/pytz/zoneinfo/US/Mountain (deflated 53%)
  adding: python/pytz/zoneinfo/US/Pacific (deflated 53%)
  adding: python/pytz/zoneinfo/US/Samoa (deflated 62%)
  adding: python/pytz/__pycache__/ (stored 0%)
  adding: python/pytz/__pycache__/__init__.cpython-37.pyc (deflated 60%)
  adding: python/pytz/__pycache__/exceptions.cpython-37.pyc (deflated 56%)
  adding: python/pytz/__pycache__/lazy.cpython-37.pyc (deflated 59%)
  adding: python/pytz/__pycache__/reference.cpython-37.pyc (deflated 52%)
  adding: python/pytz/__pycache__/tzfile.cpython-37.pyc (deflated 39%)
  adding: python/pytz/__pycache__/tzinfo.cpython-37.pyc (deflated 64%)
  adding: python/numpy.libs/ (stored 0%)
  adding: python/numpy.libs/libquadmath-2d0c479f.so.0.0.0 (deflated 45%)
  adding: python/numpy.libs/libz-eb09ad1d.so.1.2.3 (deflated 50%)
  adding: python/numpy.libs/libopenblasp-r0-5bebc122.3.13.dev.so (deflated 71%)
  adding: python/numpy.libs/libgfortran-2e0d59d6.so.5.0.0 (deflated 69%)
  adding: python/numpy/ (stored 0%)
  adding: python/numpy/char.pyi (deflated 61%)
  adding: python/numpy/_globals.py (deflated 57%)
  adding: python/numpy/setup.py (deflated 67%)
  adding: python/numpy/__init__.py (deflated 62%)
  adding: python/numpy/version.py (deflated 33%)
  adding: python/numpy/conftest.py (deflated 63%)
  adding: python/numpy/__init__.pyi (deflated 81%)
  adding: python/numpy/__init__.pxd (deflated 78%)
  adding: python/numpy/_distributor_init.py (deflated 37%)
  adding: python/numpy/__init__.cython-30.pxd (deflated 78%)
  adding: python/numpy/emath.pyi (deflated 37%)
  adding: python/numpy/__config__.py (deflated 63%)
  adding: python/numpy/ctypeslib.py (deflated 69%)
  adding: python/numpy/ctypeslib.pyi (deflated 31%)
  adding: python/numpy/LICENSE.txt (deflated 67%)
  adding: python/numpy/rec.pyi (deflated 40%)
  adding: python/numpy/_pytesttester.py (deflated 63%)
  adding: python/numpy/matlib.py (deflated 70%)
  adding: python/numpy/dual.py (deflated 59%)
  adding: python/numpy/py.typed (stored 0%)
  adding: python/numpy/tests/ (stored 0%)
  adding: python/numpy/tests/__init__.py (stored 0%)
  adding: python/numpy/tests/test_warnings.py (deflated 63%)
  adding: python/numpy/tests/test_reloading.py (deflated 61%)
  adding: python/numpy/tests/test_numpy_version.py (deflated 48%)
  adding: python/numpy/tests/test_ctypeslib.py (deflated 77%)
  adding: python/numpy/tests/test_scripts.py (deflated 58%)
  adding: python/numpy/tests/test_public_api.py (deflated 70%)
  adding: python/numpy/tests/test_matlib.py (deflated 74%)
  adding: python/numpy/tests/__pycache__/ (stored 0%)
  adding: python/numpy/tests/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/numpy/tests/__pycache__/test_ctypeslib.cpython-37.pyc (deflated 58%)
  adding: python/numpy/tests/__pycache__/test_matlib.cpython-37.pyc (deflated 54%)
  adding: python/numpy/tests/__pycache__/test_numpy_version.cpython-37.pyc (deflated 32%)
  adding: python/numpy/tests/__pycache__/test_public_api.cpython-37.pyc (deflated 55%)
  adding: python/numpy/tests/__pycache__/test_reloading.cpython-37.pyc (deflated 41%)
  adding: python/numpy/tests/__pycache__/test_scripts.cpython-37.pyc (deflated 36%)
  adding: python/numpy/tests/__pycache__/test_warnings.cpython-37.pyc (deflated 44%)
  adding: python/numpy/random/ (stored 0%)
  adding: python/numpy/random/setup.py (deflated 74%)
  adding: python/numpy/random/__init__.py (deflated 74%)
  adding: python/numpy/random/_mt19937.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/numpy/random/bit_generator.pxd (deflated 62%)
  adding: python/numpy/random/bit_generator.cpython-37m-x86_64-linux-gnu.so (deflated 65%)
  adding: python/numpy/random/__init__.pyi (deflated 59%)
  adding: python/numpy/random/_common.cpython-37m-x86_64-linux-gnu.so (deflated 63%)
  adding: python/numpy/random/c_distributions.pxd (deflated 82%)
  adding: python/numpy/random/__init__.pxd (deflated 51%)
  adding: python/numpy/random/_sfc64.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/numpy/random/_bounded_integers.cpython-37m-x86_64-linux-gnu.so (deflated 66%)
  adding: python/numpy/random/_bounded_integers.pxd (deflated 79%)
  adding: python/numpy/random/_philox.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/numpy/random/_generator.cpython-37m-x86_64-linux-gnu.so (deflated 66%)
  adding: python/numpy/random/_pcg64.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/numpy/random/mtrand.cpython-37m-x86_64-linux-gnu.so (deflated 69%)
  adding: python/numpy/random/_common.pxd (deflated 79%)
  adding: python/numpy/random/_pickle.py (deflated 79%)
  adding: python/numpy/random/_examples/ (stored 0%)
  adding: python/numpy/random/_examples/numba/ (stored 0%)
  adding: python/numpy/random/_examples/numba/extending.py (deflated 62%)
  adding: python/numpy/random/_examples/numba/extending_distributions.py (deflated 56%)
  adding: python/numpy/random/_examples/numba/__pycache__/ (stored 0%)
  adding: python/numpy/random/_examples/numba/__pycache__/extending.cpython-37.pyc (deflated 41%)
  adding: python/numpy/random/_examples/numba/__pycache__/extending_distributions.cpython-37.pyc (deflated 44%)
  adding: python/numpy/random/_examples/cython/ (stored 0%)
  adding: python/numpy/random/_examples/cython/setup.py (deflated 62%)
  adding: python/numpy/random/_examples/cython/extending_distributions.pyx (deflated 70%)
  adding: python/numpy/random/_examples/cython/extending.pyx (deflated 65%)
  adding: python/numpy/random/_examples/cython/__pycache__/ (stored 0%)
  adding: python/numpy/random/_examples/cython/__pycache__/setup.cpython-37.pyc (deflated 33%)
  adding: python/numpy/random/_examples/cffi/ (stored 0%)
  adding: python/numpy/random/_examples/cffi/extending.py (deflated 50%)
  adding: python/numpy/random/_examples/cffi/parse.py (deflated 67%)
  adding: python/numpy/random/_examples/cffi/__pycache__/ (stored 0%)
  adding: python/numpy/random/_examples/cffi/__pycache__/extending.cpython-37.pyc (deflated 27%)
  adding: python/numpy/random/_examples/cffi/__pycache__/parse.cpython-37.pyc (deflated 33%)
  adding: python/numpy/random/tests/ (stored 0%)
  adding: python/numpy/random/tests/test_generator_mt19937_regressions.py (deflated 69%)
  adding: python/numpy/random/tests/__init__.py (stored 0%)
  adding: python/numpy/random/tests/test_generator_mt19937.py (deflated 82%)
  adding: python/numpy/random/tests/test_smoke.py (deflated 85%)
  adding: python/numpy/random/tests/test_random.py (deflated 81%)
  adding: python/numpy/random/tests/test_direct.py (deflated 79%)
  adding: python/numpy/random/tests/test_randomstate.py (deflated 80%)
  adding: python/numpy/random/tests/test_regression.py (deflated 68%)
  adding: python/numpy/random/tests/test_extending.py (deflated 61%)
  adding: python/numpy/random/tests/test_randomstate_regression.py (deflated 69%)
  adding: python/numpy/random/tests/test_seed_sequence.py (deflated 56%)
  adding: python/numpy/random/tests/data/ (stored 0%)
  adding: python/numpy/random/tests/data/mt19937-testset-1.csv (deflated 52%)
  adding: python/numpy/random/tests/data/philox-testset-2.csv (deflated 47%)
  adding: python/numpy/random/tests/data/__init__.py (stored 0%)
  adding: python/numpy/random/tests/data/pcg64-testset-2.csv (deflated 47%)
  adding: python/numpy/random/tests/data/sfc64-testset-2.csv (deflated 48%)
  adding: python/numpy/random/tests/data/pcg64-testset-1.csv (deflated 47%)
  adding: python/numpy/random/tests/data/philox-testset-1.csv (deflated 47%)
  adding: python/numpy/random/tests/data/sfc64-testset-1.csv (deflated 47%)
  adding: python/numpy/random/tests/data/mt19937-testset-2.csv (deflated 52%)
  adding: python/numpy/random/tests/data/__pycache__/ (stored 0%)
  adding: python/numpy/random/tests/data/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/random/tests/__pycache__/ (stored 0%)
  adding: python/numpy/random/tests/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/random/tests/__pycache__/test_direct.cpython-37.pyc (deflated 59%)
  adding: python/numpy/random/tests/__pycache__/test_extending.cpython-37.pyc (deflated 38%)
  adding: python/numpy/random/tests/__pycache__/test_generator_mt19937.cpython-37.pyc (deflated 67%)
  adding: python/numpy/random/tests/__pycache__/test_generator_mt19937_regressions.cpython-37.pyc (deflated 60%)
  adding: python/numpy/random/tests/__pycache__/test_random.cpython-37.pyc (deflated 69%)
  adding: python/numpy/random/tests/__pycache__/test_randomstate.cpython-37.pyc (deflated 67%)
  adding: python/numpy/random/tests/__pycache__/test_randomstate_regression.cpython-37.pyc (deflated 59%)
  adding: python/numpy/random/tests/__pycache__/test_regression.cpython-37.pyc (deflated 60%)
  adding: python/numpy/random/tests/__pycache__/test_seed_sequence.cpython-37.pyc (deflated 32%)
  adding: python/numpy/random/tests/__pycache__/test_smoke.cpython-37.pyc (deflated 69%)
  adding: python/numpy/random/lib/ (stored 0%)
  adding: python/numpy/random/lib/libnpyrandom.a (deflated 68%)
  adding: python/numpy/random/__pycache__/ (stored 0%)
  adding: python/numpy/random/__pycache__/__init__.cpython-37.pyc (deflated 68%)
  adding: python/numpy/random/__pycache__/_pickle.cpython-37.pyc (deflated 62%)
  adding: python/numpy/random/__pycache__/setup.cpython-37.pyc (deflated 41%)
  adding: python/numpy/fft/ (stored 0%)
  adding: python/numpy/fft/_pocketfft.py (deflated 83%)
  adding: python/numpy/fft/setup.py (deflated 51%)
  adding: python/numpy/fft/__init__.py (deflated 63%)
  adding: python/numpy/fft/helper.py (deflated 73%)
  adding: python/numpy/fft/__init__.pyi (deflated 64%)
  adding: python/numpy/fft/_pocketfft_internal.cpython-37m-x86_64-linux-gnu.so (deflated 51%)
  adding: python/numpy/fft/tests/ (stored 0%)
  adding: python/numpy/fft/tests/test_pocketfft.py (deflated 80%)
  adding: python/numpy/fft/tests/__init__.py (stored 0%)
  adding: python/numpy/fft/tests/test_helper.py (deflated 79%)
  adding: python/numpy/fft/tests/__pycache__/ (stored 0%)
  adding: python/numpy/fft/tests/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/numpy/fft/tests/__pycache__/test_helper.cpython-37.pyc (deflated 58%)
  adding: python/numpy/fft/tests/__pycache__/test_pocketfft.cpython-37.pyc (deflated 64%)
  adding: python/numpy/fft/__pycache__/ (stored 0%)
  adding: python/numpy/fft/__pycache__/__init__.cpython-37.pyc (deflated 61%)
  adding: python/numpy/fft/__pycache__/_pocketfft.cpython-37.pyc (deflated 81%)
  adding: python/numpy/fft/__pycache__/helper.cpython-37.pyc (deflated 65%)
  adding: python/numpy/fft/__pycache__/setup.cpython-37.pyc (deflated 29%)
  adding: python/numpy/typing/ (stored 0%)
  adding: python/numpy/typing/_array_like.py (deflated 54%)
  adding: python/numpy/typing/setup.py (deflated 49%)
  adding: python/numpy/typing/__init__.py (deflated 62%)
  adding: python/numpy/typing/_add_docstring.py (deflated 64%)
  adding: python/numpy/typing/_callable.py (deflated 88%)
  adding: python/numpy/typing/_dtype_like.py (deflated 55%)
  adding: python/numpy/typing/_shape.py (deflated 24%)
  adding: python/numpy/typing/_scalars.py (deflated 49%)
  adding: python/numpy/typing/tests/ (stored 0%)
  adding: python/numpy/typing/tests/__init__.py (stored 0%)
  adding: python/numpy/typing/tests/test_typing.py (deflated 71%)
  adding: python/numpy/typing/tests/test_isfile.py (deflated 65%)
  adding: python/numpy/typing/tests/data/ (stored 0%)
  adding: python/numpy/typing/tests/data/mypy.ini (deflated 41%)
  adding: python/numpy/typing/tests/data/pass/ (stored 0%)
  adding: python/numpy/typing/tests/data/pass/numerictypes.py (deflated 65%)
  adding: python/numpy/typing/tests/data/pass/bitwise_ops.py (deflated 64%)
  adding: python/numpy/typing/tests/data/pass/numeric.py (deflated 62%)
  adding: python/numpy/typing/tests/data/pass/array_constructors.py (deflated 68%)
  adding: python/numpy/typing/tests/data/pass/warnings_and_errors.py (deflated 55%)
  adding: python/numpy/typing/tests/data/pass/ndarray_misc.py (deflated 66%)
  adding: python/numpy/typing/tests/data/pass/simple.py (deflated 63%)
  adding: python/numpy/typing/tests/data/pass/fromnumeric.py (deflated 75%)
  adding: python/numpy/typing/tests/data/pass/ndarray_conversion.py (deflated 66%)
  adding: python/numpy/typing/tests/data/pass/ndarray_shape_manipulation.py (deflated 63%)
  adding: python/numpy/typing/tests/data/pass/arithmetic.py (deflated 66%)
  adding: python/numpy/typing/tests/data/pass/modules.py (deflated 61%)
  adding: python/numpy/typing/tests/data/pass/simple_py3.py (deflated 13%)
  adding: python/numpy/typing/tests/data/pass/mod.py (deflated 70%)
  adding: python/numpy/typing/tests/data/pass/dtype.py (deflated 63%)
  adding: python/numpy/typing/tests/data/pass/ufunc_config.py (deflated 66%)
  adding: python/numpy/typing/tests/data/pass/ufuncs.py (deflated 39%)
  adding: python/numpy/typing/tests/data/pass/scalars.py (deflated 67%)
  adding: python/numpy/typing/tests/data/pass/flatiter.py (deflated 17%)
  adding: python/numpy/typing/tests/data/pass/array_like.py (deflated 57%)
  adding: python/numpy/typing/tests/data/pass/literal.py (deflated 66%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/ (stored 0%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/arithmetic.cpython-37.pyc (deflated 67%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/array_constructors.cpython-37.pyc (deflated 52%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/array_like.cpython-37.pyc (deflated 39%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/bitwise_ops.cpython-37.pyc (deflated 59%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/dtype.cpython-37.pyc (deflated 40%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/flatiter.cpython-37.pyc (deflated 27%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/fromnumeric.cpython-37.pyc (deflated 65%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/literal.cpython-37.pyc (deflated 38%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/mod.cpython-37.pyc (deflated 60%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/modules.cpython-37.pyc (deflated 43%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/ndarray_conversion.cpython-37.pyc (deflated 43%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/ndarray_misc.cpython-37.pyc (deflated 51%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/ndarray_shape_manipulation.cpython-37.pyc (deflated 40%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/numeric.cpython-37.pyc (deflated 46%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/numerictypes.cpython-37.pyc (deflated 40%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/scalars.cpython-37.pyc (deflated 57%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/simple.cpython-37.pyc (deflated 51%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/simple_py3.cpython-37.pyc (deflated 15%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/ufunc_config.cpython-37.pyc (deflated 55%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/ufuncs.cpython-37.pyc (deflated 32%)
  adding: python/numpy/typing/tests/data/pass/__pycache__/warnings_and_errors.cpython-37.pyc (deflated 24%)
  adding: python/numpy/typing/tests/data/fail/ (stored 0%)
  adding: python/numpy/typing/tests/data/fail/numerictypes.py (deflated 48%)
  adding: python/numpy/typing/tests/data/fail/bitwise_ops.py (deflated 48%)
  adding: python/numpy/typing/tests/data/fail/array_constructors.py (deflated 67%)
  adding: python/numpy/typing/tests/data/fail/warnings_and_errors.py (deflated 54%)
  adding: python/numpy/typing/tests/data/fail/ndarray_misc.py (deflated 55%)
  adding: python/numpy/typing/tests/data/fail/fromnumeric.py (deflated 86%)
  adding: python/numpy/typing/tests/data/fail/arithmetic.py (deflated 58%)
  adding: python/numpy/typing/tests/data/fail/modules.py (deflated 61%)
  adding: python/numpy/typing/tests/data/fail/constants.py (deflated 54%)
  adding: python/numpy/typing/tests/data/fail/ndarray.py (deflated 35%)
  adding: python/numpy/typing/tests/data/fail/dtype.py (deflated 43%)
  adding: python/numpy/typing/tests/data/fail/ufunc_config.py (deflated 69%)
  adding: python/numpy/typing/tests/data/fail/ufuncs.py (deflated 37%)
  adding: python/numpy/typing/tests/data/fail/scalars.py (deflated 67%)
  adding: python/numpy/typing/tests/data/fail/flatiter.py (deflated 53%)
  adding: python/numpy/typing/tests/data/fail/array_like.py (deflated 52%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/ (stored 0%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/arithmetic.cpython-37.pyc (deflated 25%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/array_constructors.cpython-37.pyc (deflated 37%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/array_like.cpython-37.pyc (deflated 32%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/bitwise_ops.cpython-37.pyc (deflated 25%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/constants.cpython-37.pyc (deflated 16%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/dtype.cpython-37.pyc (deflated 30%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/flatiter.cpython-37.pyc (deflated 36%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/fromnumeric.cpython-37.pyc (deflated 57%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/modules.cpython-37.pyc (deflated 24%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/ndarray.cpython-37.pyc (deflated 15%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/ndarray_misc.cpython-37.pyc (deflated 29%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/numerictypes.cpython-37.pyc (deflated 25%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/scalars.cpython-37.pyc (deflated 45%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/ufunc_config.cpython-37.pyc (deflated 56%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/ufuncs.cpython-37.pyc (deflated 19%)
  adding: python/numpy/typing/tests/data/fail/__pycache__/warnings_and_errors.cpython-37.pyc (deflated 19%)
  adding: python/numpy/typing/tests/data/reveal/ (stored 0%)
  adding: python/numpy/typing/tests/data/reveal/numerictypes.py (deflated 65%)
  adding: python/numpy/typing/tests/data/reveal/bitwise_ops.py (deflated 90%)
  adding: python/numpy/typing/tests/data/reveal/numeric.py (deflated 79%)
  adding: python/numpy/typing/tests/data/reveal/array_constructors.py (deflated 82%)
  adding: python/numpy/typing/tests/data/reveal/warnings_and_errors.py (deflated 65%)
  adding: python/numpy/typing/tests/data/reveal/ndarray_misc.py (deflated 87%)
  adding: python/numpy/typing/tests/data/reveal/fromnumeric.py (deflated 89%)
  adding: python/numpy/typing/tests/data/reveal/ndarray_conversion.py (deflated 74%)
  adding: python/numpy/typing/tests/data/reveal/ndarray_shape_manipulation.py (deflated 76%)
  adding: python/numpy/typing/tests/data/reveal/arithmetic.py (deflated 92%)
  adding: python/numpy/typing/tests/data/reveal/nbit_base_example.py (deflated 58%)
  adding: python/numpy/typing/tests/data/reveal/modules.py (deflated 81%)
  adding: python/numpy/typing/tests/data/reveal/constants.py (deflated 77%)
  adding: python/numpy/typing/tests/data/reveal/mod.py (deflated 91%)
  adding: python/numpy/typing/tests/data/reveal/dtype.py (deflated 80%)
  adding: python/numpy/typing/tests/data/reveal/ufunc_config.py (deflated 73%)
  adding: python/numpy/typing/tests/data/reveal/scalars.py (deflated 76%)
  adding: python/numpy/typing/tests/data/reveal/flatiter.py (deflated 62%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/ (stored 0%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/arithmetic.cpython-37.pyc (deflated 74%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/array_constructors.cpython-37.pyc (deflated 54%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/bitwise_ops.cpython-37.pyc (deflated 67%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/constants.cpython-37.pyc (deflated 50%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/dtype.cpython-37.pyc (deflated 51%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/flatiter.cpython-37.pyc (deflated 30%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/fromnumeric.cpython-37.pyc (deflated 71%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/mod.cpython-37.pyc (deflated 66%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/modules.cpython-37.pyc (deflated 51%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/nbit_base_example.cpython-37.pyc (deflated 33%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/ndarray_conversion.cpython-37.pyc (deflated 44%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/ndarray_misc.cpython-37.pyc (deflated 60%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/ndarray_shape_manipulation.cpython-37.pyc (deflated 40%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/numeric.cpython-37.pyc (deflated 51%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/numerictypes.cpython-37.pyc (deflated 34%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/scalars.cpython-37.pyc (deflated 38%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/ufunc_config.cpython-37.pyc (deflated 43%)
  adding: python/numpy/typing/tests/data/reveal/__pycache__/warnings_and_errors.cpython-37.pyc (deflated 32%)
  adding: python/numpy/typing/tests/__pycache__/ (stored 0%)
  adding: python/numpy/typing/tests/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/typing/tests/__pycache__/test_isfile.cpython-37.pyc (deflated 39%)
  adding: python/numpy/typing/tests/__pycache__/test_typing.cpython-37.pyc (deflated 45%)
  adding: python/numpy/typing/__pycache__/ (stored 0%)
  adding: python/numpy/typing/__pycache__/__init__.cpython-37.pyc (deflated 57%)
  adding: python/numpy/typing/__pycache__/_add_docstring.cpython-37.pyc (deflated 49%)
  adding: python/numpy/typing/__pycache__/_array_like.cpython-37.pyc (deflated 38%)
  adding: python/numpy/typing/__pycache__/_callable.cpython-37.pyc (deflated 78%)
  adding: python/numpy/typing/__pycache__/_dtype_like.cpython-37.pyc (deflated 39%)
  adding: python/numpy/typing/__pycache__/_scalars.cpython-37.pyc (deflated 31%)
  adding: python/numpy/typing/__pycache__/_shape.cpython-37.pyc (deflated 17%)
  adding: python/numpy/typing/__pycache__/setup.cpython-37.pyc (deflated 33%)
  adding: python/numpy/polynomial/ (stored 0%)
  adding: python/numpy/polynomial/setup.py (deflated 48%)
  adding: python/numpy/polynomial/__init__.py (deflated 63%)
  adding: python/numpy/polynomial/chebyshev.py (deflated 75%)
  adding: python/numpy/polynomial/_polybase.py (deflated 77%)
  adding: python/numpy/polynomial/hermite.py (deflated 75%)
  adding: python/numpy/polynomial/laguerre.py (deflated 75%)
  adding: python/numpy/polynomial/__init__.pyi (deflated 52%)
  adding: python/numpy/polynomial/polynomial.py (deflated 75%)
  adding: python/numpy/polynomial/hermite_e.py (deflated 75%)
  adding: python/numpy/polynomial/legendre.py (deflated 75%)
  adding: python/numpy/polynomial/polyutils.py (deflated 69%)
  adding: python/numpy/polynomial/tests/ (stored 0%)
  adding: python/numpy/polynomial/tests/test_hermite.py (deflated 82%)
  adding: python/numpy/polynomial/tests/test_printing.py (deflated 81%)
  adding: python/numpy/polynomial/tests/test_laguerre.py (deflated 82%)
  adding: python/numpy/polynomial/tests/test_polyutils.py (deflated 75%)
  adding: python/numpy/polynomial/tests/__init__.py (stored 0%)
  adding: python/numpy/polynomial/tests/test_legendre.py (deflated 81%)
  adding: python/numpy/polynomial/tests/test_polynomial.py (deflated 82%)
  adding: python/numpy/polynomial/tests/test_chebyshev.py (deflated 82%)
  adding: python/numpy/polynomial/tests/test_classes.py (deflated 82%)
  adding: python/numpy/polynomial/tests/test_hermite_e.py (deflated 82%)
  adding: python/numpy/polynomial/tests/__pycache__/ (stored 0%)
  adding: python/numpy/polynomial/tests/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/polynomial/tests/__pycache__/test_chebyshev.cpython-37.pyc (deflated 65%)
  adding: python/numpy/polynomial/tests/__pycache__/test_classes.cpython-37.pyc (deflated 64%)
  adding: python/numpy/polynomial/tests/__pycache__/test_hermite.cpython-37.pyc (deflated 64%)
  adding: python/numpy/polynomial/tests/__pycache__/test_hermite_e.cpython-37.pyc (deflated 64%)
  adding: python/numpy/polynomial/tests/__pycache__/test_laguerre.cpython-37.pyc (deflated 64%)
  adding: python/numpy/polynomial/tests/__pycache__/test_legendre.cpython-37.pyc (deflated 64%)
  adding: python/numpy/polynomial/tests/__pycache__/test_polynomial.cpython-37.pyc (deflated 64%)
  adding: python/numpy/polynomial/tests/__pycache__/test_polyutils.cpython-37.pyc (deflated 54%)
  adding: python/numpy/polynomial/tests/__pycache__/test_printing.cpython-37.pyc (deflated 71%)
  adding: python/numpy/polynomial/__pycache__/ (stored 0%)
  adding: python/numpy/polynomial/__pycache__/__init__.cpython-37.pyc (deflated 59%)
  adding: python/numpy/polynomial/__pycache__/_polybase.cpython-37.pyc (deflated 68%)
  adding: python/numpy/polynomial/__pycache__/chebyshev.cpython-37.pyc (deflated 70%)
  adding: python/numpy/polynomial/__pycache__/hermite.cpython-37.pyc (deflated 70%)
  adding: python/numpy/polynomial/__pycache__/hermite_e.cpython-37.pyc (deflated 71%)
  adding: python/numpy/polynomial/__pycache__/laguerre.cpython-37.pyc (deflated 71%)
  adding: python/numpy/polynomial/__pycache__/legendre.cpython-37.pyc (deflated 70%)
  adding: python/numpy/polynomial/__pycache__/polynomial.cpython-37.pyc (deflated 70%)
  adding: python/numpy/polynomial/__pycache__/polyutils.cpython-37.pyc (deflated 60%)
  adding: python/numpy/polynomial/__pycache__/setup.cpython-37.pyc (deflated 32%)
  adding: python/numpy/ma/ (stored 0%)
  adding: python/numpy/ma/core.py (deflated 78%)
  adding: python/numpy/ma/setup.py (deflated 47%)
  adding: python/numpy/ma/__init__.py (deflated 50%)
  adding: python/numpy/ma/testutils.py (deflated 76%)
  adding: python/numpy/ma/timer_comparison.py (deflated 78%)
  adding: python/numpy/ma/mrecords.py (deflated 73%)
  adding: python/numpy/ma/__init__.pyi (deflated 69%)
  adding: python/numpy/ma/bench.py (deflated 75%)
  adding: python/numpy/ma/extras.py (deflated 76%)
  adding: python/numpy/ma/tests/ (stored 0%)
  adding: python/numpy/ma/tests/test_old_ma.py (deflated 78%)
  adding: python/numpy/ma/tests/test_subclassing.py (deflated 74%)
  adding: python/numpy/ma/tests/__init__.py (stored 0%)
  adding: python/numpy/ma/tests/test_extras.py (deflated 84%)
  adding: python/numpy/ma/tests/test_mrecords.py (deflated 80%)
  adding: python/numpy/ma/tests/test_deprecations.py (deflated 70%)
  adding: python/numpy/ma/tests/test_core.py (deflated 81%)
  adding: python/numpy/ma/tests/test_regression.py (deflated 65%)
  adding: python/numpy/ma/tests/__pycache__/ (stored 0%)
  adding: python/numpy/ma/tests/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/numpy/ma/tests/__pycache__/test_core.cpython-37.pyc (deflated 68%)
  adding: python/numpy/ma/tests/__pycache__/test_deprecations.cpython-37.pyc (deflated 56%)
  adding: python/numpy/ma/tests/__pycache__/test_extras.cpython-37.pyc (deflated 67%)
  adding: python/numpy/ma/tests/__pycache__/test_mrecords.cpython-37.pyc (deflated 59%)
  adding: python/numpy/ma/tests/__pycache__/test_old_ma.cpython-37.pyc (deflated 61%)
  adding: python/numpy/ma/tests/__pycache__/test_regression.cpython-37.pyc (deflated 57%)
  adding: python/numpy/ma/tests/__pycache__/test_subclassing.cpython-37.pyc (deflated 59%)
  adding: python/numpy/ma/__pycache__/ (stored 0%)
  adding: python/numpy/ma/__pycache__/__init__.cpython-37.pyc (deflated 43%)
  adding: python/numpy/ma/__pycache__/bench.cpython-37.pyc (deflated 51%)
  adding: python/numpy/ma/__pycache__/core.cpython-37.pyc (deflated 69%)
  adding: python/numpy/ma/__pycache__/extras.cpython-37.pyc (deflated 65%)
  adding: python/numpy/ma/__pycache__/mrecords.cpython-37.pyc (deflated 57%)
  adding: python/numpy/ma/__pycache__/setup.cpython-37.pyc (deflated 30%)
  adding: python/numpy/ma/__pycache__/testutils.cpython-37.pyc (deflated 56%)
  adding: python/numpy/ma/__pycache__/timer_comparison.cpython-37.pyc (deflated 55%)
  adding: python/numpy/doc/ (stored 0%)
  adding: python/numpy/doc/__init__.py (deflated 40%)
  adding: python/numpy/doc/constants.py (deflated 79%)
  adding: python/numpy/doc/ufuncs.py (deflated 59%)
  adding: python/numpy/doc/__pycache__/ (stored 0%)
  adding: python/numpy/doc/__pycache__/__init__.cpython-37.pyc (deflated 27%)
  adding: python/numpy/doc/__pycache__/constants.cpython-37.pyc (deflated 72%)
  adding: python/numpy/doc/__pycache__/ufuncs.cpython-37.pyc (deflated 57%)
  adding: python/numpy/testing/ (stored 0%)
  adding: python/numpy/testing/setup.py (deflated 52%)
  adding: python/numpy/testing/__init__.py (deflated 50%)
  adding: python/numpy/testing/utils.py (deflated 56%)
  adding: python/numpy/testing/__init__.pyi (deflated 60%)
  adding: python/numpy/testing/print_coercion_tables.py (deflated 71%)
  adding: python/numpy/testing/tests/ (stored 0%)
  adding: python/numpy/testing/tests/__init__.py (stored 0%)
  adding: python/numpy/testing/tests/test_utils.py (deflated 84%)
  adding: python/numpy/testing/tests/test_doctesting.py (deflated 47%)
  adding: python/numpy/testing/tests/test_decorators.py (deflated 78%)
  adding: python/numpy/testing/tests/__pycache__/ (stored 0%)
  adding: python/numpy/testing/tests/__pycache__/__init__.cpython-37.pyc (deflated 22%)
  adding: python/numpy/testing/tests/__pycache__/test_decorators.cpython-37.pyc (deflated 65%)
  adding: python/numpy/testing/tests/__pycache__/test_doctesting.cpython-37.pyc (deflated 46%)
  adding: python/numpy/testing/tests/__pycache__/test_utils.cpython-37.pyc (deflated 73%)
  adding: python/numpy/testing/_private/ (stored 0%)
  adding: python/numpy/testing/_private/noseclasses.py (deflated 68%)
  adding: python/numpy/testing/_private/__init__.py (stored 0%)
  adding: python/numpy/testing/_private/parameterized.py (deflated 67%)
  adding: python/numpy/testing/_private/utils.py (deflated 75%)
  adding: python/numpy/testing/_private/nosetester.py (deflated 70%)
  adding: python/numpy/testing/_private/decorators.py (deflated 71%)
  adding: python/numpy/testing/_private/__pycache__/ (stored 0%)
  adding: python/numpy/testing/_private/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/testing/_private/__pycache__/decorators.cpython-37.pyc (deflated 61%)
  adding: python/numpy/testing/_private/__pycache__/noseclasses.cpython-37.pyc (deflated 51%)
  adding: python/numpy/testing/_private/__pycache__/nosetester.cpython-37.pyc (deflated 58%)
  adding: python/numpy/testing/_private/__pycache__/parameterized.cpython-37.pyc (deflated 54%)
  adding: python/numpy/testing/_private/__pycache__/utils.cpython-37.pyc (deflated 63%)
  adding: python/numpy/testing/__pycache__/ (stored 0%)
  adding: python/numpy/testing/__pycache__/__init__.cpython-37.pyc (deflated 32%)
  adding: python/numpy/testing/__pycache__/print_coercion_tables.cpython-37.pyc (deflated 46%)
  adding: python/numpy/testing/__pycache__/setup.cpython-37.pyc (deflated 33%)
  adding: python/numpy/testing/__pycache__/utils.cpython-37.pyc (deflated 38%)
  adding: python/numpy/linalg/ (stored 0%)
  adding: python/numpy/linalg/setup.py (deflated 66%)
  adding: python/numpy/linalg/__init__.py (deflated 52%)
  adding: python/numpy/linalg/linalg.py (deflated 73%)
  adding: python/numpy/linalg/__init__.pyi (deflated 52%)
  adding: python/numpy/linalg/lapack_lite.cpython-37m-x86_64-linux-gnu.so (deflated 73%)
  adding: python/numpy/linalg/_umath_linalg.cpython-37m-x86_64-linux-gnu.so (deflated 66%)
  adding: python/numpy/linalg/tests/ (stored 0%)
  adding: python/numpy/linalg/tests/__init__.py (stored 0%)
  adding: python/numpy/linalg/tests/test_linalg.py (deflated 80%)
  adding: python/numpy/linalg/tests/test_deprecations.py (deflated 57%)
  adding: python/numpy/linalg/tests/test_build.py (deflated 57%)
  adding: python/numpy/linalg/tests/test_regression.py (deflated 73%)
  adding: python/numpy/linalg/tests/__pycache__/ (stored 0%)
  adding: python/numpy/linalg/tests/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/linalg/tests/__pycache__/test_build.cpython-37.pyc (deflated 42%)
  adding: python/numpy/linalg/tests/__pycache__/test_deprecations.cpython-37.pyc (deflated 36%)
  adding: python/numpy/linalg/tests/__pycache__/test_linalg.cpython-37.pyc (deflated 65%)
  adding: python/numpy/linalg/tests/__pycache__/test_regression.cpython-37.pyc (deflated 49%)
  adding: python/numpy/linalg/__pycache__/ (stored 0%)
  adding: python/numpy/linalg/__pycache__/__init__.cpython-37.pyc (deflated 48%)
  adding: python/numpy/linalg/__pycache__/linalg.cpython-37.pyc (deflated 66%)
  adding: python/numpy/linalg/__pycache__/setup.cpython-37.pyc (deflated 43%)
  adding: python/numpy/core/ (stored 0%)
  adding: python/numpy/core/numerictypes.py (deflated 70%)
  adding: python/numpy/core/memmap.py (deflated 67%)
  adding: python/numpy/core/_multiarray_tests.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/numpy/core/numeric.pyi (deflated 79%)
  adding: python/numpy/core/_ufunc_config.pyi (deflated 63%)
  adding: python/numpy/core/setup_common.py (deflated 68%)
  adding: python/numpy/core/numeric.py (deflated 74%)
  adding: python/numpy/core/setup.py (deflated 78%)
  adding: python/numpy/core/__init__.py (deflated 58%)
  adding: python/numpy/core/numerictypes.pyi (deflated 61%)
  adding: python/numpy/core/umath.py (deflated 55%)
  adding: python/numpy/core/_type_aliases.py (deflated 66%)
  adding: python/numpy/core/function_base.pyi (deflated 72%)
  adding: python/numpy/core/fromnumeric.py (deflated 78%)
  adding: python/numpy/core/multiarray.py (deflated 74%)
  adding: python/numpy/core/_umath_tests.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/numpy/core/function_base.py (deflated 71%)
  adding: python/numpy/core/records.py (deflated 73%)
  adding: python/numpy/core/_simd.cpython-37m-x86_64-linux-gnu.so (deflated 85%)
  adding: python/numpy/core/generate_numpy_api.py (deflated 69%)
  adding: python/numpy/core/_multiarray_umath.cpython-37m-x86_64-linux-gnu.so (deflated 69%)
  adding: python/numpy/core/_exceptions.py (deflated 68%)
  adding: python/numpy/core/getlimits.py (deflated 73%)
  adding: python/numpy/core/_internal.pyi (deflated 65%)
  adding: python/numpy/core/_dtype_ctypes.py (deflated 66%)
  adding: python/numpy/core/_ufunc_config.py (deflated 71%)
  adding: python/numpy/core/_internal.py (deflated 70%)
  adding: python/numpy/core/_rational_tests.cpython-37m-x86_64-linux-gnu.so (deflated 63%)
  adding: python/numpy/core/_dtype.py (deflated 69%)
  adding: python/numpy/core/__init__.pyi (stored 0%)
  adding: python/numpy/core/arrayprint.py (deflated 76%)
  adding: python/numpy/core/_type_aliases.pyi (deflated 53%)
  adding: python/numpy/core/shape_base.pyi (deflated 69%)
  adding: python/numpy/core/_struct_ufunc_tests.cpython-37m-x86_64-linux-gnu.so (deflated 66%)
  adding: python/numpy/core/fromnumeric.pyi (deflated 84%)
  adding: python/numpy/core/overrides.py (deflated 69%)
  adding: python/numpy/core/cversions.py (deflated 41%)
  adding: python/numpy/core/machar.py (deflated 73%)
  adding: python/numpy/core/_asarray.py (deflated 77%)
  adding: python/numpy/core/_add_newdocs.py (deflated 75%)
  adding: python/numpy/core/_operand_flag_tests.cpython-37m-x86_64-linux-gnu.so (deflated 73%)
  adding: python/numpy/core/_string_helpers.py (deflated 70%)
  adding: python/numpy/core/_methods.py (deflated 71%)
  adding: python/numpy/core/umath_tests.py (deflated 39%)
  adding: python/numpy/core/_add_newdocs_scalars.py (deflated 72%)
  adding: python/numpy/core/shape_base.py (deflated 73%)
  adding: python/numpy/core/_asarray.pyi (deflated 73%)
  adding: python/numpy/core/einsumfunc.py (deflated 73%)
  adding: python/numpy/core/defchararray.py (deflated 83%)
  adding: python/numpy/core/tests/ (stored 0%)
  adding: python/numpy/core/tests/test_umath_complex.py (deflated 80%)
  adding: python/numpy/core/tests/test__exceptions.py (deflated 68%)
  adding: python/numpy/core/tests/test_api.py (deflated 78%)
  adding: python/numpy/core/tests/test_unicode.py (deflated 84%)
  adding: python/numpy/core/tests/test_indexing.py (deflated 75%)
  adding: python/numpy/core/tests/test_scalar_methods.py (deflated 69%)
  adding: python/numpy/core/tests/test_simd.py (deflated 80%)
  adding: python/numpy/core/tests/test_getlimits.py (deflated 70%)
  adding: python/numpy/core/tests/test_longdouble.py (deflated 81%)
  adding: python/numpy/core/tests/test_numerictypes.py (deflated 79%)
  adding: python/numpy/core/tests/__init__.py (stored 0%)
  adding: python/numpy/core/tests/test_umath_accuracy.py (deflated 64%)
  adding: python/numpy/core/tests/test_abc.py (deflated 83%)
  adding: python/numpy/core/tests/test_scalar_ctors.py (deflated 72%)
  adding: python/numpy/core/tests/test_shape_base.py (deflated 81%)
  adding: python/numpy/core/tests/test_multiarray.py (deflated 80%)
  adding: python/numpy/core/tests/test_mem_overlap.py (deflated 77%)
  adding: python/numpy/core/tests/test_overrides.py (deflated 80%)
  adding: python/numpy/core/tests/test_umath.py (deflated 81%)
  adding: python/numpy/core/tests/test_extint128.py (deflated 78%)
  adding: python/numpy/core/tests/test_einsum.py (deflated 82%)
  adding: python/numpy/core/tests/test_scalarprint.py (deflated 73%)
  adding: python/numpy/core/tests/test_conversion_utils.py (deflated 75%)
  adding: python/numpy/core/tests/test_defchararray.py (deflated 84%)
  adding: python/numpy/core/tests/test_records.py (deflated 75%)
  adding: python/numpy/core/tests/test_numeric.py (deflated 81%)
  adding: python/numpy/core/tests/test_cython.py (deflated 68%)
  adding: python/numpy/core/tests/test_deprecations.py (deflated 73%)
  adding: python/numpy/core/tests/test_scalarinherit.py (deflated 69%)
  adding: python/numpy/core/tests/test_machar.py (deflated 51%)
  adding: python/numpy/core/tests/test_print.py (deflated 78%)
  adding: python/numpy/core/tests/_locales.py (deflated 64%)
  adding: python/numpy/core/tests/test_array_coercion.py (deflated 74%)
  adding: python/numpy/core/tests/test_half.py (deflated 78%)
  adding: python/numpy/core/tests/test_datetime.py (deflated 85%)
  adding: python/numpy/core/tests/test_cpu_features.py (deflated 70%)
  adding: python/numpy/core/tests/test_cpu_dispatcher.py (deflated 62%)
  adding: python/numpy/core/tests/test_errstate.py (deflated 67%)
  adding: python/numpy/core/tests/test_casting_unittests.py (deflated 74%)
  adding: python/numpy/core/tests/test_scalarbuffer.py (deflated 72%)
  adding: python/numpy/core/tests/test_nditer.py (deflated 85%)
  adding: python/numpy/core/tests/test_item_selection.py (deflated 68%)
  adding: python/numpy/core/tests/test_regression.py (deflated 74%)
  adding: python/numpy/core/tests/test_memmap.py (deflated 75%)
  adding: python/numpy/core/tests/test_scalarmath.py (deflated 76%)
  adding: python/numpy/core/tests/test_protocols.py (deflated 58%)
  adding: python/numpy/core/tests/test_ufunc.py (deflated 79%)
  adding: python/numpy/core/tests/test_arrayprint.py (deflated 79%)
  adding: python/numpy/core/tests/test_function_base.py (deflated 78%)
  adding: python/numpy/core/tests/test_indexerrors.py (deflated 83%)
  adding: python/numpy/core/tests/test_simd_module.py (deflated 70%)
  adding: python/numpy/core/tests/test_dtype.py (deflated 80%)
  adding: python/numpy/core/tests/examples/ (stored 0%)
  adding: python/numpy/core/tests/examples/setup.py (deflated 40%)
  adding: python/numpy/core/tests/examples/checks.pyx (deflated 56%)
  adding: python/numpy/core/tests/examples/__pycache__/ (stored 0%)
  adding: python/numpy/core/tests/examples/__pycache__/setup.cpython-37.pyc (deflated 26%)
  adding: python/numpy/core/tests/data/ (stored 0%)
  adding: python/numpy/core/tests/data/umath-validation-set-exp (deflated 69%)
  adding: python/numpy/core/tests/data/umath-validation-set-sin (deflated 87%)
  adding: python/numpy/core/tests/data/umath-validation-set-cos (deflated 89%)
  adding: python/numpy/core/tests/data/umath-validation-set-log (deflated 65%)
  adding: python/numpy/core/tests/data/astype_copy.pkl (deflated 6%)
  adding: python/numpy/core/tests/data/umath-validation-set-README (deflated 50%)
  adding: python/numpy/core/tests/data/recarray_from_file.fits (deflated 90%)
  adding: python/numpy/core/tests/__pycache__/ (stored 0%)
  adding: python/numpy/core/tests/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/numpy/core/tests/__pycache__/_locales.cpython-37.pyc (deflated 50%)
  adding: python/numpy/core/tests/__pycache__/test_protocols.cpython-37.pyc (deflated 55%)
  adding: python/numpy/core/tests/__pycache__/test__exceptions.cpython-37.pyc (deflated 51%)
  adding: python/numpy/core/tests/__pycache__/test_abc.cpython-37.pyc (deflated 63%)
  adding: python/numpy/core/tests/__pycache__/test_api.cpython-37.pyc (deflated 58%)
  adding: python/numpy/core/tests/__pycache__/test_records.cpython-37.pyc (deflated 60%)
  adding: python/numpy/core/tests/__pycache__/test_array_coercion.cpython-37.pyc (deflated 62%)
  adding: python/numpy/core/tests/__pycache__/test_regression.cpython-37.pyc (deflated 65%)
  adding: python/numpy/core/tests/__pycache__/test_arrayprint.cpython-37.pyc (deflated 65%)
  adding: python/numpy/core/tests/__pycache__/test_print.cpython-37.pyc (deflated 57%)
  adding: python/numpy/core/tests/__pycache__/test_casting_unittests.cpython-37.pyc (deflated 54%)
  adding: python/numpy/core/tests/__pycache__/test_scalar_ctors.cpython-37.pyc (deflated 56%)
  adding: python/numpy/core/tests/__pycache__/test_conversion_utils.cpython-37.pyc (deflated 63%)
  adding: python/numpy/core/tests/__pycache__/test_scalar_methods.cpython-37.pyc (deflated 43%)
  adding: python/numpy/core/tests/__pycache__/test_cpu_dispatcher.cpython-37.pyc (deflated 36%)
  adding: python/numpy/core/tests/__pycache__/test_scalarinherit.cpython-37.pyc (deflated 61%)
  adding: python/numpy/core/tests/__pycache__/test_cpu_features.cpython-37.pyc (deflated 50%)
  adding: python/numpy/core/tests/__pycache__/test_cython.cpython-37.pyc (deflated 48%)
  adding: python/numpy/core/tests/__pycache__/test_datetime.cpython-37.pyc (deflated 67%)
  adding: python/numpy/core/tests/__pycache__/test_scalarbuffer.cpython-37.pyc (deflated 52%)
  adding: python/numpy/core/tests/__pycache__/test_defchararray.cpython-37.pyc (deflated 73%)
  adding: python/numpy/core/tests/__pycache__/test_scalarmath.cpython-37.pyc (deflated 60%)
  adding: python/numpy/core/tests/__pycache__/test_deprecations.cpython-37.pyc (deflated 65%)
  adding: python/numpy/core/tests/__pycache__/test_dtype.cpython-37.pyc (deflated 66%)
  adding: python/numpy/core/tests/__pycache__/test_einsum.cpython-37.pyc (deflated 67%)
  adding: python/numpy/core/tests/__pycache__/test_errstate.cpython-37.pyc (deflated 50%)
  adding: python/numpy/core/tests/__pycache__/test_scalarprint.cpython-37.pyc (deflated 55%)
  adding: python/numpy/core/tests/__pycache__/test_extint128.cpython-37.pyc (deflated 63%)
  adding: python/numpy/core/tests/__pycache__/test_shape_base.cpython-37.pyc (deflated 67%)
  adding: python/numpy/core/tests/__pycache__/test_function_base.cpython-37.pyc (deflated 66%)
  adding: python/numpy/core/tests/__pycache__/test_simd.cpython-37.pyc (deflated 65%)
  adding: python/numpy/core/tests/__pycache__/test_getlimits.cpython-37.pyc (deflated 58%)
  adding: python/numpy/core/tests/__pycache__/test_half.cpython-37.pyc (deflated 61%)
  adding: python/numpy/core/tests/__pycache__/test_simd_module.cpython-37.pyc (deflated 50%)
  adding: python/numpy/core/tests/__pycache__/test_indexerrors.cpython-37.pyc (deflated 74%)
  adding: python/numpy/core/tests/__pycache__/test_indexing.cpython-37.pyc (deflated 67%)
  adding: python/numpy/core/tests/__pycache__/test_ufunc.cpython-37.pyc (deflated 66%)
  adding: python/numpy/core/tests/__pycache__/test_item_selection.cpython-37.pyc (deflated 48%)
  adding: python/numpy/core/tests/__pycache__/test_longdouble.cpython-37.pyc (deflated 63%)
  adding: python/numpy/core/tests/__pycache__/test_machar.cpython-37.pyc (deflated 38%)
  adding: python/numpy/core/tests/__pycache__/test_mem_overlap.cpython-37.pyc (deflated 59%)
  adding: python/numpy/core/tests/__pycache__/test_memmap.cpython-37.pyc (deflated 58%)
  adding: python/numpy/core/tests/__pycache__/test_multiarray.cpython-37.pyc (deflated 67%)
  adding: python/numpy/core/tests/__pycache__/test_nditer.cpython-37.pyc (deflated 70%)
  adding: python/numpy/core/tests/__pycache__/test_numeric.cpython-37.pyc (deflated 67%)
  adding: python/numpy/core/tests/__pycache__/test_numerictypes.cpython-37.pyc (deflated 66%)
  adding: python/numpy/core/tests/__pycache__/test_overrides.cpython-37.pyc (deflated 67%)
  adding: python/numpy/core/tests/__pycache__/test_umath.cpython-37.pyc (deflated 69%)
  adding: python/numpy/core/tests/__pycache__/test_umath_accuracy.cpython-37.pyc (deflated 38%)
  adding: python/numpy/core/tests/__pycache__/test_umath_complex.cpython-37.pyc (deflated 65%)
  adding: python/numpy/core/tests/__pycache__/test_unicode.cpython-37.pyc (deflated 74%)
  adding: python/numpy/core/include/ (stored 0%)
  adding: python/numpy/core/include/numpy/ (stored 0%)
  adding: python/numpy/core/include/numpy/__multiarray_api.h (deflated 87%)
  adding: python/numpy/core/include/numpy/utils.h (deflated 64%)
  adding: python/numpy/core/include/numpy/_neighborhood_iterator_imp.h (deflated 66%)
  adding: python/numpy/core/include/numpy/arrayobject.h (deflated 32%)
  adding: python/numpy/core/include/numpy/_numpyconfig.h (deflated 67%)
  adding: python/numpy/core/include/numpy/ndarraytypes.h (deflated 75%)
  adding: python/numpy/core/include/numpy/arrayscalars.h (deflated 78%)
  adding: python/numpy/core/include/numpy/halffloat.h (deflated 70%)
  adding: python/numpy/core/include/numpy/npy_interrupt.h (deflated 59%)
  adding: python/numpy/core/include/numpy/npy_cpu.h (deflated 73%)
  adding: python/numpy/core/include/numpy/npy_no_deprecated_api.h (deflated 42%)
  adding: python/numpy/core/include/numpy/multiarray_api.txt (deflated 72%)
  adding: python/numpy/core/include/numpy/old_defines.h (deflated 79%)
  adding: python/numpy/core/include/numpy/npy_os.h (deflated 69%)
  adding: python/numpy/core/include/numpy/npy_common.h (deflated 82%)
  adding: python/numpy/core/include/numpy/ndarrayobject.h (deflated 74%)
  adding: python/numpy/core/include/numpy/ufunc_api.txt (deflated 85%)
  adding: python/numpy/core/include/numpy/oldnumeric.h (deflated 51%)
  adding: python/numpy/core/include/numpy/npy_3kcompat.h (deflated 74%)
  adding: python/numpy/core/include/numpy/ufuncobject.h (deflated 70%)
  adding: python/numpy/core/include/numpy/__ufunc_api.h (deflated 88%)
  adding: python/numpy/core/include/numpy/npy_math.h (deflated 80%)
  adding: python/numpy/core/include/numpy/noprefix.h (deflated 74%)
  adding: python/numpy/core/include/numpy/numpyconfig.h (deflated 65%)
  adding: python/numpy/core/include/numpy/npy_endian.h (deflated 79%)
  adding: python/numpy/core/include/numpy/npy_1_7_deprecated_api.h (deflated 66%)
  adding: python/numpy/core/include/numpy/random/ (stored 0%)
  adding: python/numpy/core/include/numpy/random/distributions.h (deflated 81%)
  adding: python/numpy/core/include/numpy/random/bitgen.h (deflated 43%)
  adding: python/numpy/core/lib/ (stored 0%)
  adding: python/numpy/core/lib/libnpymath.a (deflated 74%)
  adding: python/numpy/core/lib/npy-pkg-config/ (stored 0%)
  adding: python/numpy/core/lib/npy-pkg-config/mlib.ini (deflated 20%)
  adding: python/numpy/core/lib/npy-pkg-config/npymath.ini (deflated 36%)
  adding: python/numpy/core/__pycache__/ (stored 0%)
  adding: python/numpy/core/__pycache__/__init__.cpython-37.pyc (deflated 41%)
  adding: python/numpy/core/__pycache__/_add_newdocs.cpython-37.pyc (deflated 72%)
  adding: python/numpy/core/__pycache__/_add_newdocs_scalars.cpython-37.pyc (deflated 60%)
  adding: python/numpy/core/__pycache__/_asarray.cpython-37.pyc (deflated 70%)
  adding: python/numpy/core/__pycache__/_dtype.cpython-37.pyc (deflated 49%)
  adding: python/numpy/core/__pycache__/_dtype_ctypes.cpython-37.pyc (deflated 45%)
  adding: python/numpy/core/__pycache__/_exceptions.cpython-37.pyc (deflated 57%)
  adding: python/numpy/core/__pycache__/_internal.cpython-37.pyc (deflated 55%)
  adding: python/numpy/core/__pycache__/_methods.cpython-37.pyc (deflated 48%)
  adding: python/numpy/core/__pycache__/_string_helpers.cpython-37.pyc (deflated 63%)
  adding: python/numpy/core/__pycache__/_type_aliases.cpython-37.pyc (deflated 44%)
  adding: python/numpy/core/__pycache__/_ufunc_config.cpython-37.pyc (deflated 64%)
  adding: python/numpy/core/__pycache__/arrayprint.cpython-37.pyc (deflated 65%)
  adding: python/numpy/core/__pycache__/cversions.cpython-37.pyc (deflated 28%)
  adding: python/numpy/core/__pycache__/defchararray.cpython-37.pyc (deflated 77%)
  adding: python/numpy/core/__pycache__/einsumfunc.cpython-37.pyc (deflated 63%)
  adding: python/numpy/core/__pycache__/fromnumeric.cpython-37.pyc (deflated 75%)
  adding: python/numpy/core/__pycache__/function_base.cpython-37.pyc (deflated 64%)
  adding: python/numpy/core/__pycache__/generate_numpy_api.cpython-37.pyc (deflated 56%)
  adding: python/numpy/core/__pycache__/getlimits.cpython-37.pyc (deflated 56%)
  adding: python/numpy/core/__pycache__/machar.cpython-37.pyc (deflated 54%)
  adding: python/numpy/core/__pycache__/memmap.cpython-37.pyc (deflated 57%)
  adding: python/numpy/core/__pycache__/multiarray.cpython-37.pyc (deflated 70%)
  adding: python/numpy/core/__pycache__/numeric.cpython-37.pyc (deflated 68%)
  adding: python/numpy/core/__pycache__/numerictypes.cpython-37.pyc (deflated 61%)
  adding: python/numpy/core/__pycache__/overrides.cpython-37.pyc (deflated 57%)
  adding: python/numpy/core/__pycache__/records.cpython-37.pyc (deflated 60%)
  adding: python/numpy/core/__pycache__/setup.cpython-37.pyc (deflated 54%)
  adding: python/numpy/core/__pycache__/setup_common.cpython-37.pyc (deflated 50%)
  adding: python/numpy/core/__pycache__/shape_base.cpython-37.pyc (deflated 65%)
  adding: python/numpy/core/__pycache__/umath.cpython-37.pyc (deflated 36%)
  adding: python/numpy/core/__pycache__/umath_tests.cpython-37.pyc (deflated 27%)
  adding: python/numpy/f2py/ (stored 0%)
  adding: python/numpy/f2py/common_rules.py (deflated 65%)
  adding: python/numpy/f2py/use_rules.py (deflated 60%)
  adding: python/numpy/f2py/f2py_testing.py (deflated 63%)
  adding: python/numpy/f2py/setup.py (deflated 55%)
  adding: python/numpy/f2py/__init__.py (deflated 62%)
  adding: python/numpy/f2py/f90mod_rules.py (deflated 71%)
  adding: python/numpy/f2py/__version__.py (deflated 12%)
  adding: python/numpy/f2py/__main__.py (deflated 8%)
  adding: python/numpy/f2py/capi_maps.py (deflated 78%)
  adding: python/numpy/f2py/__init__.pyi (deflated 14%)
  adding: python/numpy/f2py/f2py2e.py (deflated 71%)
  adding: python/numpy/f2py/diagnose.py (deflated 81%)
  adding: python/numpy/f2py/crackfortran.py (deflated 78%)
  adding: python/numpy/f2py/rules.py (deflated 80%)
  adding: python/numpy/f2py/auxfuncs.py (deflated 78%)
  adding: python/numpy/f2py/cfuncs.py (deflated 80%)
  adding: python/numpy/f2py/cb_rules.py (deflated 79%)
  adding: python/numpy/f2py/func2subr.py (deflated 79%)
  adding: python/numpy/f2py/tests/ (stored 0%)
  adding: python/numpy/f2py/tests/test_return_logical.py (deflated 82%)
  adding: python/numpy/f2py/tests/test_callback.py (deflated 73%)
  adding: python/numpy/f2py/tests/test_module_doc.py (deflated 51%)
  adding: python/numpy/f2py/tests/test_quoted_character.py (deflated 48%)
  adding: python/numpy/f2py/tests/__init__.py (stored 0%)
  adding: python/numpy/f2py/tests/test_compile_function.py (deflated 60%)
  adding: python/numpy/f2py/tests/util.py (deflated 73%)
  adding: python/numpy/f2py/tests/test_return_character.py (deflated 79%)
  adding: python/numpy/f2py/tests/test_return_integer.py (deflated 82%)
  adding: python/numpy/f2py/tests/test_array_from_pyobj.py (deflated 82%)
  adding: python/numpy/f2py/tests/test_string.py (deflated 47%)
  adding: python/numpy/f2py/tests/test_crackfortran.py (deflated 76%)
  adding: python/numpy/f2py/tests/test_parameter.py (deflated 84%)
  adding: python/numpy/f2py/tests/test_kind.py (deflated 63%)
  adding: python/numpy/f2py/tests/test_regression.py (deflated 63%)
  adding: python/numpy/f2py/tests/test_mixed.py (deflated 54%)
  adding: python/numpy/f2py/tests/test_block_docstring.py (deflated 40%)
  adding: python/numpy/f2py/tests/test_common.py (deflated 54%)
  adding: python/numpy/f2py/tests/test_return_real.py (deflated 79%)
  adding: python/numpy/f2py/tests/test_return_complex.py (deflated 80%)
  adding: python/numpy/f2py/tests/test_size.py (deflated 71%)
  adding: python/numpy/f2py/tests/test_semicolon_split.py (deflated 69%)
  adding: python/numpy/f2py/tests/test_assumed_shape.py (deflated 66%)
  adding: python/numpy/f2py/tests/src/ (stored 0%)
  adding: python/numpy/f2py/tests/src/parameter/ (stored 0%)
  adding: python/numpy/f2py/tests/src/parameter/constant_both.f90 (deflated 81%)
  adding: python/numpy/f2py/tests/src/parameter/constant_compound.f90 (deflated 47%)
  adding: python/numpy/f2py/tests/src/parameter/constant_real.f90 (deflated 60%)
  adding: python/numpy/f2py/tests/src/parameter/constant_integer.f90 (deflated 61%)
  adding: python/numpy/f2py/tests/src/parameter/constant_non_compound.f90 (deflated 50%)
  adding: python/numpy/f2py/tests/src/mixed/ (stored 0%)
  adding: python/numpy/f2py/tests/src/mixed/foo_free.f90 (deflated 32%)
  adding: python/numpy/f2py/tests/src/mixed/foo.f (deflated 25%)
  adding: python/numpy/f2py/tests/src/mixed/foo_fixed.f90 (deflated 45%)
  adding: python/numpy/f2py/tests/src/size/ (stored 0%)
  adding: python/numpy/f2py/tests/src/size/foo.f90 (deflated 66%)
  adding: python/numpy/f2py/tests/src/common/ (stored 0%)
  adding: python/numpy/f2py/tests/src/common/block.f (deflated 45%)
  adding: python/numpy/f2py/tests/src/regression/ (stored 0%)
  adding: python/numpy/f2py/tests/src/regression/inout.f90 (deflated 42%)
  adding: python/numpy/f2py/tests/src/string/ (stored 0%)
  adding: python/numpy/f2py/tests/src/string/char.f90 (deflated 62%)
  adding: python/numpy/f2py/tests/src/kind/ (stored 0%)
  adding: python/numpy/f2py/tests/src/kind/foo.f90 (deflated 59%)
  adding: python/numpy/f2py/tests/src/assumed_shape/ (stored 0%)
  adding: python/numpy/f2py/tests/src/assumed_shape/precision.f90 (deflated 38%)
  adding: python/numpy/f2py/tests/src/assumed_shape/foo_use.f90 (deflated 39%)
  adding: python/numpy/f2py/tests/src/assumed_shape/foo_mod.f90 (deflated 62%)
  adding: python/numpy/f2py/tests/src/assumed_shape/foo_free.f90 (deflated 63%)
  adding: python/numpy/f2py/tests/src/assumed_shape/.f2py_f2cmap (deflated 7%)
  adding: python/numpy/f2py/tests/src/array_from_pyobj/ (stored 0%)
  adding: python/numpy/f2py/tests/src/array_from_pyobj/wrapmodule.c (deflated 70%)
  adding: python/numpy/f2py/tests/src/module_data/ (stored 0%)
  adding: python/numpy/f2py/tests/src/module_data/mod.mod (stored 0%)
  adding: python/numpy/f2py/tests/src/module_data/module_data_docstring.f90 (deflated 42%)
  adding: python/numpy/f2py/tests/__pycache__/ (stored 0%)
  adding: python/numpy/f2py/tests/__pycache__/__init__.cpython-37.pyc (deflated 21%)
  adding: python/numpy/f2py/tests/__pycache__/test_array_from_pyobj.cpython-37.pyc (deflated 62%)
  adding: python/numpy/f2py/tests/__pycache__/test_assumed_shape.cpython-37.pyc (deflated 45%)
  adding: python/numpy/f2py/tests/__pycache__/test_block_docstring.cpython-37.pyc (deflated 32%)
  adding: python/numpy/f2py/tests/__pycache__/test_callback.cpython-37.pyc (deflated 62%)
  adding: python/numpy/f2py/tests/__pycache__/test_common.cpython-37.pyc (deflated 37%)
  adding: python/numpy/f2py/tests/__pycache__/test_compile_function.cpython-37.pyc (deflated 42%)
  adding: python/numpy/f2py/tests/__pycache__/test_crackfortran.cpython-37.pyc (deflated 63%)
  adding: python/numpy/f2py/tests/__pycache__/test_kind.cpython-37.pyc (deflated 41%)
  adding: python/numpy/f2py/tests/__pycache__/test_mixed.cpython-37.pyc (deflated 40%)
  adding: python/numpy/f2py/tests/__pycache__/test_module_doc.cpython-37.pyc (deflated 40%)
  adding: python/numpy/f2py/tests/__pycache__/test_parameter.cpython-37.pyc (deflated 70%)
  adding: python/numpy/f2py/tests/__pycache__/test_quoted_character.cpython-37.pyc (deflated 42%)
  adding: python/numpy/f2py/tests/__pycache__/test_regression.cpython-37.pyc (deflated 46%)
  adding: python/numpy/f2py/tests/__pycache__/test_return_character.cpython-37.pyc (deflated 67%)
  adding: python/numpy/f2py/tests/__pycache__/test_return_complex.cpython-37.pyc (deflated 68%)
  adding: python/numpy/f2py/tests/__pycache__/test_return_integer.cpython-37.pyc (deflated 71%)
  adding: python/numpy/f2py/tests/__pycache__/test_return_logical.cpython-37.pyc (deflated 72%)
  adding: python/numpy/f2py/tests/__pycache__/test_return_real.cpython-37.pyc (deflated 67%)
  adding: python/numpy/f2py/tests/__pycache__/test_semicolon_split.cpython-37.pyc (deflated 55%)
  adding: python/numpy/f2py/tests/__pycache__/test_size.cpython-37.pyc (deflated 51%)
  adding: python/numpy/f2py/tests/__pycache__/test_string.cpython-37.pyc (deflated 35%)
  adding: python/numpy/f2py/tests/__pycache__/util.cpython-37.pyc (deflated 50%)
  adding: python/numpy/f2py/src/ (stored 0%)
  adding: python/numpy/f2py/src/fortranobject.c (deflated 78%)
  adding: python/numpy/f2py/src/fortranobject.h (deflated 66%)
  adding: python/numpy/f2py/__pycache__/ (stored 0%)
  adding: python/numpy/f2py/__pycache__/__init__.cpython-37.pyc (deflated 45%)
  adding: python/numpy/f2py/__pycache__/__main__.cpython-37.pyc (deflated 20%)
  adding: python/numpy/f2py/__pycache__/__version__.cpython-37.pyc (deflated 21%)
  adding: python/numpy/f2py/__pycache__/auxfuncs.cpython-37.pyc (deflated 63%)
  adding: python/numpy/f2py/__pycache__/capi_maps.cpython-37.pyc (deflated 50%)
  adding: python/numpy/f2py/__pycache__/cb_rules.cpython-37.pyc (deflated 64%)
  adding: python/numpy/f2py/__pycache__/cfuncs.cpython-37.pyc (deflated 74%)
  adding: python/numpy/f2py/__pycache__/common_rules.cpython-37.pyc (deflated 44%)
  adding: python/numpy/f2py/__pycache__/crackfortran.cpython-37.pyc (deflated 55%)
  adding: python/numpy/f2py/__pycache__/diagnose.cpython-37.pyc (deflated 56%)
  adding: python/numpy/f2py/__pycache__/f2py2e.cpython-37.pyc (deflated 54%)
  adding: python/numpy/f2py/__pycache__/f2py_testing.cpython-37.pyc (deflated 34%)
  adding: python/numpy/f2py/__pycache__/f90mod_rules.cpython-37.pyc (deflated 49%)
  adding: python/numpy/f2py/__pycache__/func2subr.cpython-37.pyc (deflated 50%)
  adding: python/numpy/f2py/__pycache__/rules.cpython-37.pyc (deflated 62%)
  adding: python/numpy/f2py/__pycache__/setup.cpython-37.pyc (deflated 40%)
  adding: python/numpy/f2py/__pycache__/use_rules.cpython-37.pyc (deflated 39%)
  adding: python/numpy/matrixlib/ (stored 0%)
  adding: python/numpy/matrixlib/setup.py (deflated 47%)
  adding: python/numpy/matrixlib/__init__.py (deflated 36%)
  adding: python/numpy/matrixlib/__init__.pyi (deflated 27%)
  adding: python/numpy/matrixlib/defmatrix.py (deflated 78%)
  adding: python/numpy/matrixlib/tests/ (stored 0%)
  adding: python/numpy/matrixlib/tests/test_masked_matrix.py (deflated 74%)
  adding: python/numpy/matrixlib/tests/__init__.py (stored 0%)
  adding: python/numpy/matrixlib/tests/test_multiarray.py (deflated 51%)
  adding: python/numpy/matrixlib/tests/test_numeric.py (deflated 53%)
  adding: python/numpy/matrixlib/tests/test_matrix_linalg.py (deflated 70%)
  adding: python/numpy/matrixlib/tests/test_interaction.py (deflated 75%)
  adding: python/numpy/matrixlib/tests/test_regression.py (deflated 60%)
  adding: python/numpy/matrixlib/tests/test_defmatrix.py (deflated 77%)
  adding: python/numpy/matrixlib/tests/__pycache__/ (stored 0%)
  adding: python/numpy/matrixlib/tests/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/matrixlib/tests/__pycache__/test_defmatrix.cpython-37.pyc (deflated 63%)
  adding: python/numpy/matrixlib/tests/__pycache__/test_interaction.cpython-37.pyc (deflated 58%)
  adding: python/numpy/matrixlib/tests/__pycache__/test_masked_matrix.cpython-37.pyc (deflated 57%)
  adding: python/numpy/matrixlib/tests/__pycache__/test_matrix_linalg.cpython-37.pyc (deflated 62%)
  adding: python/numpy/matrixlib/tests/__pycache__/test_multiarray.cpython-37.pyc (deflated 40%)
  adding: python/numpy/matrixlib/tests/__pycache__/test_numeric.cpython-37.pyc (deflated 41%)
  adding: python/numpy/matrixlib/tests/__pycache__/test_regression.cpython-37.pyc (deflated 49%)
  adding: python/numpy/matrixlib/__pycache__/ (stored 0%)
  adding: python/numpy/matrixlib/__pycache__/__init__.cpython-37.pyc (deflated 21%)
  adding: python/numpy/matrixlib/__pycache__/defmatrix.cpython-37.pyc (deflated 70%)
  adding: python/numpy/matrixlib/__pycache__/setup.cpython-37.pyc (deflated 31%)
  adding: python/numpy/distutils/ (stored 0%)
  adding: python/numpy/distutils/ccompiler_opt.py (deflated 77%)
  adding: python/numpy/distutils/core.py (deflated 74%)
  adding: python/numpy/distutils/setup.py (deflated 57%)
  adding: python/numpy/distutils/__init__.py (deflated 53%)
  adding: python/numpy/distutils/conv_template.py (deflated 65%)
  adding: python/numpy/distutils/exec_command.py (deflated 66%)
  adding: python/numpy/distutils/pathccompiler.py (deflated 62%)
  adding: python/numpy/distutils/extension.py (deflated 71%)
  adding: python/numpy/distutils/from_template.py (deflated 66%)
  adding: python/numpy/distutils/__init__.pyi (deflated 9%)
  adding: python/numpy/distutils/_shell_utils.py (deflated 61%)
  adding: python/numpy/distutils/msvccompiler.py (deflated 60%)
  adding: python/numpy/distutils/line_endings.py (deflated 74%)
  adding: python/numpy/distutils/numpy_distribution.py (deflated 51%)
  adding: python/numpy/distutils/log.py (deflated 64%)
  adding: python/numpy/distutils/msvc9compiler.py (deflated 61%)
  adding: python/numpy/distutils/intelccompiler.py (deflated 76%)
  adding: python/numpy/distutils/system_info.py (deflated 77%)
  adding: python/numpy/distutils/mingw32ccompiler.py (deflated 69%)
  adding: python/numpy/distutils/__config__.py (deflated 63%)
  adding: python/numpy/distutils/npy_pkg_config.py (deflated 70%)
  adding: python/numpy/distutils/lib2def.py (deflated 63%)
  adding: python/numpy/distutils/ccompiler.py (deflated 71%)
  adding: python/numpy/distutils/unixccompiler.py (deflated 63%)
  adding: python/numpy/distutils/cpuinfo.py (deflated 80%)
  adding: python/numpy/distutils/misc_util.py (deflated 76%)
  adding: python/numpy/distutils/mingw/ (stored 0%)
  adding: python/numpy/distutils/mingw/gfortran_vs2003_hack.c (deflated 6%)
  adding: python/numpy/distutils/tests/ (stored 0%)
  adding: python/numpy/distutils/tests/__init__.py (stored 0%)
  adding: python/numpy/distutils/tests/test_system_info.py (deflated 73%)
  adding: python/numpy/distutils/tests/test_mingw32ccompiler.py (deflated 58%)
  adding: python/numpy/distutils/tests/test_fcompiler_nagfor.py (deflated 63%)
  adding: python/numpy/distutils/tests/test_build_ext.py (deflated 63%)
  adding: python/numpy/distutils/tests/test_ccompiler_opt.py (deflated 79%)
  adding: python/numpy/distutils/tests/test_misc_util.py (deflated 75%)
  adding: python/numpy/distutils/tests/test_exec_command.py (deflated 78%)
  adding: python/numpy/distutils/tests/test_npy_pkg_config.py (deflated 75%)
  adding: python/numpy/distutils/tests/test_ccompiler_opt_conf.py (deflated 75%)
  adding: python/numpy/distutils/tests/test_fcompiler_intel.py (deflated 69%)
  adding: python/numpy/distutils/tests/test_fcompiler_gnu.py (deflated 72%)
  adding: python/numpy/distutils/tests/test_fcompiler.py (deflated 67%)
  adding: python/numpy/distutils/tests/test_from_template.py (deflated 64%)
  adding: python/numpy/distutils/tests/test_shell_utils.py (deflated 63%)
  adding: python/numpy/distutils/tests/__pycache__/ (stored 0%)
  adding: python/numpy/distutils/tests/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/distutils/tests/__pycache__/test_build_ext.cpython-37.pyc (deflated 46%)
  adding: python/numpy/distutils/tests/__pycache__/test_ccompiler_opt.cpython-37.pyc (deflated 63%)
  adding: python/numpy/distutils/tests/__pycache__/test_ccompiler_opt_conf.cpython-37.pyc (deflated 53%)
  adding: python/numpy/distutils/tests/__pycache__/test_exec_command.cpython-37.pyc (deflated 63%)
  adding: python/numpy/distutils/tests/__pycache__/test_fcompiler.cpython-37.pyc (deflated 38%)
  adding: python/numpy/distutils/tests/__pycache__/test_fcompiler_gnu.cpython-37.pyc (deflated 60%)
  adding: python/numpy/distutils/tests/__pycache__/test_fcompiler_intel.cpython-37.pyc (deflated 55%)
  adding: python/numpy/distutils/tests/__pycache__/test_fcompiler_nagfor.cpython-37.pyc (deflated 41%)
  adding: python/numpy/distutils/tests/__pycache__/test_from_template.cpython-37.pyc (deflated 50%)
  adding: python/numpy/distutils/tests/__pycache__/test_mingw32ccompiler.cpython-37.pyc (deflated 38%)
  adding: python/numpy/distutils/tests/__pycache__/test_misc_util.cpython-37.pyc (deflated 55%)
  adding: python/numpy/distutils/tests/__pycache__/test_npy_pkg_config.cpython-37.pyc (deflated 57%)
  adding: python/numpy/distutils/tests/__pycache__/test_shell_utils.cpython-37.pyc (deflated 42%)
  adding: python/numpy/distutils/tests/__pycache__/test_system_info.cpython-37.pyc (deflated 52%)
  adding: python/numpy/distutils/checks/ (stored 0%)
  adding: python/numpy/distutils/checks/cpu_neon_fp16.c (deflated 27%)
  adding: python/numpy/distutils/checks/cpu_neon_vfpv4.c (deflated 53%)
  adding: python/numpy/distutils/checks/cpu_sse.c (deflated 19%)
  adding: python/numpy/distutils/checks/cpu_vsx2.c (deflated 32%)
  adding: python/numpy/distutils/checks/cpu_avx512_icl.c (deflated 44%)
  adding: python/numpy/distutils/checks/cpu_fma3.c (deflated 39%)
  adding: python/numpy/distutils/checks/cpu_f16c.c (deflated 41%)
  adding: python/numpy/distutils/checks/cpu_avx512_clx.c (deflated 38%)
  adding: python/numpy/distutils/checks/cpu_avx512f.c (deflated 23%)
  adding: python/numpy/distutils/checks/cpu_vsx3.c (deflated 30%)
  adding: python/numpy/distutils/checks/cpu_avx512cd.c (deflated 23%)
  adding: python/numpy/distutils/checks/cpu_xop.c (deflated 35%)
  adding: python/numpy/distutils/checks/cpu_avx512_cnl.c (deflated 47%)
  adding: python/numpy/distutils/checks/cpu_fma4.c (deflated 41%)
  adding: python/numpy/distutils/checks/cpu_asimddp.c (deflated 43%)
  adding: python/numpy/distutils/checks/cpu_avx.c (deflated 27%)
  adding: python/numpy/distutils/checks/cpu_asimdhp.c (deflated 42%)
  adding: python/numpy/distutils/checks/cpu_avx512_knm.c (deflated 45%)
  adding: python/numpy/distutils/checks/cpu_ssse3.c (deflated 23%)
  adding: python/numpy/distutils/checks/cpu_sse2.c (deflated 23%)
  adding: python/numpy/distutils/checks/cpu_neon.c (deflated 41%)
  adding: python/numpy/distutils/checks/cpu_sse3.c (deflated 19%)
  adding: python/numpy/distutils/checks/cpu_asimdfhm.c (deflated 47%)
  adding: python/numpy/distutils/checks/cpu_avx512_knl.c (deflated 28%)
  adding: python/numpy/distutils/checks/extra_avx512bw_mask.c (deflated 46%)
  adding: python/numpy/distutils/checks/cpu_avx512_skx.c (deflated 34%)
  adding: python/numpy/distutils/checks/extra_avx512f_reduce.c (deflated 74%)
  adding: python/numpy/distutils/checks/cpu_sse42.c (deflated 19%)
  adding: python/numpy/distutils/checks/cpu_vsx.c (deflated 47%)
  adding: python/numpy/distutils/checks/extra_avx512dq_mask.c (deflated 39%)
  adding: python/numpy/distutils/checks/cpu_avx2.c (deflated 23%)
  adding: python/numpy/distutils/checks/cpu_popcnt.c (deflated 48%)
  adding: python/numpy/distutils/checks/test_flags.c (stored 0%)
  adding: python/numpy/distutils/checks/cpu_sse41.c (deflated 12%)
  adding: python/numpy/distutils/checks/cpu_asimd.c (deflated 59%)
  adding: python/numpy/distutils/fcompiler/ (stored 0%)
  adding: python/numpy/distutils/fcompiler/compaq.py (deflated 66%)
  adding: python/numpy/distutils/fcompiler/__init__.py (deflated 74%)
  adding: python/numpy/distutils/fcompiler/hpux.py (deflated 56%)
  adding: python/numpy/distutils/fcompiler/gnu.py (deflated 72%)
  adding: python/numpy/distutils/fcompiler/vast.py (deflated 57%)
  adding: python/numpy/distutils/fcompiler/mips.py (deflated 60%)
  adding: python/numpy/distutils/fcompiler/sun.py (deflated 56%)
  adding: python/numpy/distutils/fcompiler/ibm.py (deflated 63%)
  adding: python/numpy/distutils/fcompiler/lahey.py (deflated 57%)
  adding: python/numpy/distutils/fcompiler/intel.py (deflated 75%)
  adding: python/numpy/distutils/fcompiler/g95.py (deflated 57%)
  adding: python/numpy/distutils/fcompiler/environment.py (deflated 71%)
  adding: python/numpy/distutils/fcompiler/absoft.py (deflated 68%)
  adding: python/numpy/distutils/fcompiler/pg.py (deflated 69%)
  adding: python/numpy/distutils/fcompiler/nv.py (deflated 55%)
  adding: python/numpy/distutils/fcompiler/none.py (deflated 61%)
  adding: python/numpy/distutils/fcompiler/pathf95.py (deflated 55%)
  adding: python/numpy/distutils/fcompiler/fujitsu.py (deflated 54%)
  adding: python/numpy/distutils/fcompiler/nag.py (deflated 70%)
  adding: python/numpy/distutils/fcompiler/__pycache__/ (stored 0%)
  adding: python/numpy/distutils/fcompiler/__pycache__/__init__.cpython-37.pyc (deflated 54%)
  adding: python/numpy/distutils/fcompiler/__pycache__/absoft.cpython-37.pyc (deflated 52%)
  adding: python/numpy/distutils/fcompiler/__pycache__/compaq.cpython-37.pyc (deflated 49%)
  adding: python/numpy/distutils/fcompiler/__pycache__/environment.cpython-37.pyc (deflated 49%)
  adding: python/numpy/distutils/fcompiler/__pycache__/fujitsu.cpython-37.pyc (deflated 45%)
  adding: python/numpy/distutils/fcompiler/__pycache__/g95.cpython-37.pyc (deflated 43%)
  adding: python/numpy/distutils/fcompiler/__pycache__/gnu.cpython-37.pyc (deflated 49%)
  adding: python/numpy/distutils/fcompiler/__pycache__/hpux.cpython-37.pyc (deflated 46%)
  adding: python/numpy/distutils/fcompiler/__pycache__/ibm.cpython-37.pyc (deflated 42%)
  adding: python/numpy/distutils/fcompiler/__pycache__/intel.cpython-37.pyc (deflated 59%)
  adding: python/numpy/distutils/fcompiler/__pycache__/lahey.cpython-37.pyc (deflated 44%)
  adding: python/numpy/distutils/fcompiler/__pycache__/mips.cpython-37.pyc (deflated 44%)
  adding: python/numpy/distutils/fcompiler/__pycache__/nag.cpython-37.pyc (deflated 52%)
  adding: python/numpy/distutils/fcompiler/__pycache__/none.cpython-37.pyc (deflated 41%)
  adding: python/numpy/distutils/fcompiler/__pycache__/nv.cpython-37.pyc (deflated 46%)
  adding: python/numpy/distutils/fcompiler/__pycache__/pathf95.cpython-37.pyc (deflated 42%)
  adding: python/numpy/distutils/fcompiler/__pycache__/pg.cpython-37.pyc (deflated 55%)
  adding: python/numpy/distutils/fcompiler/__pycache__/sun.cpython-37.pyc (deflated 44%)
  adding: python/numpy/distutils/fcompiler/__pycache__/vast.cpython-37.pyc (deflated 41%)
  adding: python/numpy/distutils/command/ (stored 0%)
  adding: python/numpy/distutils/command/build_scripts.py (deflated 69%)
  adding: python/numpy/distutils/command/install_clib.py (deflated 64%)
  adding: python/numpy/distutils/command/__init__.py (deflated 59%)
  adding: python/numpy/distutils/command/build_clib.py (deflated 78%)
  adding: python/numpy/distutils/command/install_data.py (deflated 61%)
  adding: python/numpy/distutils/command/config.py (deflated 75%)
  adding: python/numpy/distutils/command/install_headers.py (deflated 59%)
  adding: python/numpy/distutils/command/develop.py (deflated 51%)
  adding: python/numpy/distutils/command/bdist_rpm.py (deflated 60%)
  adding: python/numpy/distutils/command/build_py.py (deflated 66%)
  adding: python/numpy/distutils/command/sdist.py (deflated 61%)
  adding: python/numpy/distutils/command/egg_info.py (deflated 54%)
  adding: python/numpy/distutils/command/build_ext.py (deflated 79%)
  adding: python/numpy/distutils/command/build_src.py (deflated 79%)
  adding: python/numpy/distutils/command/build.py (deflated 63%)
  adding: python/numpy/distutils/command/install.py (deflated 63%)
  adding: python/numpy/distutils/command/autodist.py (deflated 75%)
  adding: python/numpy/distutils/command/config_compiler.py (deflated 77%)
  adding: python/numpy/distutils/command/__pycache__/ (stored 0%)
  adding: python/numpy/distutils/command/__pycache__/__init__.cpython-37.pyc (deflated 34%)
  adding: python/numpy/distutils/command/__pycache__/autodist.cpython-37.pyc (deflated 63%)
  adding: python/numpy/distutils/command/__pycache__/bdist_rpm.cpython-37.pyc (deflated 37%)
  adding: python/numpy/distutils/command/__pycache__/build.cpython-37.pyc (deflated 45%)
  adding: python/numpy/distutils/command/__pycache__/build_clib.cpython-37.pyc (deflated 48%)
  adding: python/numpy/distutils/command/__pycache__/build_ext.cpython-37.pyc (deflated 49%)
  adding: python/numpy/distutils/command/__pycache__/build_py.cpython-37.pyc (deflated 45%)
  adding: python/numpy/distutils/command/__pycache__/build_scripts.cpython-37.pyc (deflated 45%)
  adding: python/numpy/distutils/command/__pycache__/build_src.cpython-37.pyc (deflated 51%)
  adding: python/numpy/distutils/command/__pycache__/config.cpython-37.pyc (deflated 56%)
  adding: python/numpy/distutils/command/__pycache__/config_compiler.cpython-37.pyc (deflated 58%)
  adding: python/numpy/distutils/command/__pycache__/develop.cpython-37.pyc (deflated 39%)
  adding: python/numpy/distutils/command/__pycache__/egg_info.cpython-37.pyc (deflated 40%)
  adding: python/numpy/distutils/command/__pycache__/install.cpython-37.pyc (deflated 42%)
  adding: python/numpy/distutils/command/__pycache__/install_clib.cpython-37.pyc (deflated 45%)
  adding: python/numpy/distutils/command/__pycache__/install_data.cpython-37.pyc (deflated 42%)
  adding: python/numpy/distutils/command/__pycache__/install_headers.cpython-37.pyc (deflated 35%)
  adding: python/numpy/distutils/command/__pycache__/sdist.cpython-37.pyc (deflated 37%)
  adding: python/numpy/distutils/__pycache__/ (stored 0%)
  adding: python/numpy/distutils/__pycache__/__config__.cpython-37.pyc (deflated 46%)
  adding: python/numpy/distutils/__pycache__/__init__.cpython-37.pyc (deflated 39%)
  adding: python/numpy/distutils/__pycache__/_shell_utils.cpython-37.pyc (deflated 48%)
  adding: python/numpy/distutils/__pycache__/ccompiler.cpython-37.pyc (deflated 52%)
  adding: python/numpy/distutils/__pycache__/ccompiler_opt.cpython-37.pyc (deflated 61%)
  adding: python/numpy/distutils/__pycache__/conv_template.cpython-37.pyc (deflated 49%)
  adding: python/numpy/distutils/__pycache__/core.cpython-37.pyc (deflated 45%)
  adding: python/numpy/distutils/__pycache__/cpuinfo.cpython-37.pyc (deflated 74%)
  adding: python/numpy/distutils/__pycache__/exec_command.cpython-37.pyc (deflated 50%)
  adding: python/numpy/distutils/__pycache__/extension.cpython-37.pyc (deflated 48%)
  adding: python/numpy/distutils/__pycache__/from_template.cpython-37.pyc (deflated 47%)
  adding: python/numpy/distutils/__pycache__/intelccompiler.cpython-37.pyc (deflated 57%)
  adding: python/numpy/distutils/__pycache__/lib2def.cpython-37.pyc (deflated 41%)
  adding: python/numpy/distutils/__pycache__/line_endings.cpython-37.pyc (deflated 52%)
  adding: python/numpy/distutils/__pycache__/log.cpython-37.pyc (deflated 42%)
  adding: python/numpy/distutils/__pycache__/mingw32ccompiler.cpython-37.pyc (deflated 48%)
  adding: python/numpy/distutils/__pycache__/misc_util.cpython-37.pyc (deflated 61%)
  adding: python/numpy/distutils/__pycache__/msvc9compiler.cpython-37.pyc (deflated 47%)
  adding: python/numpy/distutils/__pycache__/msvccompiler.cpython-37.pyc (deflated 47%)
  adding: python/numpy/distutils/__pycache__/npy_pkg_config.cpython-37.pyc (deflated 55%)
  adding: python/numpy/distutils/__pycache__/numpy_distribution.cpython-37.pyc (deflated 41%)
  adding: python/numpy/distutils/__pycache__/pathccompiler.cpython-37.pyc (deflated 39%)
  adding: python/numpy/distutils/__pycache__/setup.cpython-37.pyc (deflated 36%)
  adding: python/numpy/distutils/__pycache__/system_info.cpython-37.pyc (deflated 62%)
  adding: python/numpy/distutils/__pycache__/unixccompiler.cpython-37.pyc (deflated 41%)
  adding: python/numpy/lib/ (stored 0%)
  adding: python/numpy/lib/npyio.py (deflated 74%)
  adding: python/numpy/lib/arrayterator.py (deflated 66%)
  adding: python/numpy/lib/setup.py (deflated 51%)
  adding: python/numpy/lib/type_check.py (deflated 73%)
  adding: python/numpy/lib/__init__.py (deflated 63%)
  adding: python/numpy/lib/arraysetops.py (deflated 74%)
  adding: python/numpy/lib/histograms.py (deflated 72%)
  adding: python/numpy/lib/index_tricks.py (deflated 72%)
  adding: python/numpy/lib/function_base.py (deflated 73%)
  adding: python/numpy/lib/format.py (deflated 69%)
  adding: python/numpy/lib/recfunctions.py (deflated 76%)
  adding: python/numpy/lib/utils.py (deflated 71%)
  adding: python/numpy/lib/__init__.pyi (deflated 64%)
  adding: python/numpy/lib/_version.py (deflated 71%)
  adding: python/numpy/lib/ufunclike.py (deflated 75%)
  adding: python/numpy/lib/twodim_base.py (deflated 73%)
  adding: python/numpy/lib/polynomial.py (deflated 72%)
  adding: python/numpy/lib/_iotools.py (deflated 74%)
  adding: python/numpy/lib/_datasource.py (deflated 75%)
  adding: python/numpy/lib/scimath.py (deflated 78%)
  adding: python/numpy/lib/mixins.py (deflated 69%)
  adding: python/numpy/lib/nanfunctions.py (deflated 82%)
  adding: python/numpy/lib/arraypad.py (deflated 75%)
  adding: python/numpy/lib/user_array.py (deflated 80%)
  adding: python/numpy/lib/stride_tricks.py (deflated 69%)
  adding: python/numpy/lib/shape_base.py (deflated 74%)
  adding: python/numpy/lib/tests/ (stored 0%)
  adding: python/numpy/lib/tests/test_recfunctions.py (deflated 84%)
  adding: python/numpy/lib/tests/test_stride_tricks.py (deflated 80%)
  adding: python/numpy/lib/tests/__init__.py (stored 0%)
  adding: python/numpy/lib/tests/test_arrayterator.py (deflated 64%)
  adding: python/numpy/lib/tests/test__version.py (deflated 76%)
  adding: python/numpy/lib/tests/test_shape_base.py (deflated 80%)
  adding: python/numpy/lib/tests/test__iotools.py (deflated 80%)
  adding: python/numpy/lib/tests/test_format.py (deflated 82%)
  adding: python/numpy/lib/tests/test_index_tricks.py (deflated 78%)
  adding: python/numpy/lib/tests/test_io.py (deflated 81%)
  adding: python/numpy/lib/tests/test_arraypad.py (deflated 86%)
  adding: python/numpy/lib/tests/test_financial_expired.py (deflated 37%)
  adding: python/numpy/lib/tests/test__datasource.py (deflated 79%)
  adding: python/numpy/lib/tests/test_packbits.py (deflated 80%)
  adding: python/numpy/lib/tests/test_nanfunctions.py (deflated 85%)
  adding: python/numpy/lib/tests/test_utils.py (deflated 68%)
  adding: python/numpy/lib/tests/test_twodim_base.py (deflated 80%)
  adding: python/numpy/lib/tests/test_polynomial.py (deflated 74%)
  adding: python/numpy/lib/tests/test_regression.py (deflated 70%)
  adding: python/numpy/lib/tests/test_ufunclike.py (deflated 73%)
  adding: python/numpy/lib/tests/test_arraysetops.py (deflated 80%)
  adding: python/numpy/lib/tests/test_function_base.py (deflated 82%)
  adding: python/numpy/lib/tests/test_mixins.py (deflated 75%)
  adding: python/numpy/lib/tests/test_type_check.py (deflated 84%)
  adding: python/numpy/lib/tests/test_histograms.py (deflated 77%)
  adding: python/numpy/lib/tests/data/ (stored 0%)
  adding: python/numpy/lib/tests/data/win64python2.npy (deflated 22%)
  adding: python/numpy/lib/tests/data/py2-objarr.npz (deflated 23%)
  adding: python/numpy/lib/tests/data/python3.npy (deflated 23%)
  adding: python/numpy/lib/tests/data/py3-objarr.npz (deflated 21%)
  adding: python/numpy/lib/tests/data/py3-objarr.npy (deflated 13%)
  adding: python/numpy/lib/tests/data/py2-objarr.npy (deflated 14%)
  adding: python/numpy/lib/tests/__pycache__/ (stored 0%)
  adding: python/numpy/lib/tests/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/numpy/lib/tests/__pycache__/test__datasource.cpython-37.pyc (deflated 66%)
  adding: python/numpy/lib/tests/__pycache__/test__iotools.cpython-37.pyc (deflated 61%)
  adding: python/numpy/lib/tests/__pycache__/test__version.cpython-37.pyc (deflated 62%)
  adding: python/numpy/lib/tests/__pycache__/test_arraypad.cpython-37.pyc (deflated 78%)
  adding: python/numpy/lib/tests/__pycache__/test_arraysetops.cpython-37.pyc (deflated 61%)
  adding: python/numpy/lib/tests/__pycache__/test_arrayterator.cpython-37.pyc (deflated 46%)
  adding: python/numpy/lib/tests/__pycache__/test_financial_expired.cpython-37.pyc (deflated 28%)
  adding: python/numpy/lib/tests/__pycache__/test_format.cpython-37.pyc (deflated 73%)
  adding: python/numpy/lib/tests/__pycache__/test_function_base.cpython-37.pyc (deflated 68%)
  adding: python/numpy/lib/tests/__pycache__/test_histograms.cpython-37.pyc (deflated 62%)
  adding: python/numpy/lib/tests/__pycache__/test_index_tricks.cpython-37.pyc (deflated 62%)
  adding: python/numpy/lib/tests/__pycache__/test_io.cpython-37.pyc (deflated 68%)
  adding: python/numpy/lib/tests/__pycache__/test_mixins.cpython-37.pyc (deflated 58%)
  adding: python/numpy/lib/tests/__pycache__/test_nanfunctions.cpython-37.pyc (deflated 68%)
  adding: python/numpy/lib/tests/__pycache__/test_packbits.cpython-37.pyc (deflated 57%)
  adding: python/numpy/lib/tests/__pycache__/test_polynomial.cpython-37.pyc (deflated 57%)
  adding: python/numpy/lib/tests/__pycache__/test_recfunctions.cpython-37.pyc (deflated 68%)
  adding: python/numpy/lib/tests/__pycache__/test_regression.cpython-37.pyc (deflated 57%)
  adding: python/numpy/lib/tests/__pycache__/test_shape_base.cpython-37.pyc (deflated 68%)
  adding: python/numpy/lib/tests/__pycache__/test_stride_tricks.cpython-37.pyc (deflated 61%)
  adding: python/numpy/lib/tests/__pycache__/test_twodim_base.cpython-37.pyc (deflated 61%)
  adding: python/numpy/lib/tests/__pycache__/test_type_check.cpython-37.pyc (deflated 74%)
  adding: python/numpy/lib/tests/__pycache__/test_ufunclike.cpython-37.pyc (deflated 55%)
  adding: python/numpy/lib/tests/__pycache__/test_utils.cpython-37.pyc (deflated 57%)
  adding: python/numpy/lib/__pycache__/ (stored 0%)
  adding: python/numpy/lib/__pycache__/__init__.cpython-37.pyc (deflated 44%)
  adding: python/numpy/lib/__pycache__/_datasource.cpython-37.pyc (deflated 66%)
  adding: python/numpy/lib/__pycache__/_iotools.cpython-37.pyc (deflated 60%)
  adding: python/numpy/lib/__pycache__/_version.cpython-37.pyc (deflated 57%)
  adding: python/numpy/lib/__pycache__/arraypad.cpython-37.pyc (deflated 64%)
  adding: python/numpy/lib/__pycache__/arraysetops.cpython-37.pyc (deflated 66%)
  adding: python/numpy/lib/__pycache__/arrayterator.cpython-37.pyc (deflated 55%)
  adding: python/numpy/lib/__pycache__/format.cpython-37.pyc (deflated 59%)
  adding: python/numpy/lib/__pycache__/function_base.cpython-37.pyc (deflated 66%)
  adding: python/numpy/lib/__pycache__/histograms.cpython-37.pyc (deflated 62%)
  adding: python/numpy/lib/__pycache__/index_tricks.cpython-37.pyc (deflated 63%)
  adding: python/numpy/lib/__pycache__/mixins.cpython-37.pyc (deflated 60%)
  adding: python/numpy/lib/__pycache__/nanfunctions.cpython-37.pyc (deflated 76%)
  adding: python/numpy/lib/__pycache__/npyio.cpython-37.pyc (deflated 62%)
  adding: python/numpy/lib/__pycache__/polynomial.cpython-37.pyc (deflated 64%)
  adding: python/numpy/lib/__pycache__/recfunctions.cpython-37.pyc (deflated 64%)
  adding: python/numpy/lib/__pycache__/scimath.cpython-37.pyc (deflated 73%)
  adding: python/numpy/lib/__pycache__/setup.cpython-37.pyc (deflated 32%)
  adding: python/numpy/lib/__pycache__/shape_base.cpython-37.pyc (deflated 67%)
  adding: python/numpy/lib/__pycache__/stride_tricks.cpython-37.pyc (deflated 62%)
  adding: python/numpy/lib/__pycache__/twodim_base.cpython-37.pyc (deflated 67%)
  adding: python/numpy/lib/__pycache__/type_check.cpython-37.pyc (deflated 64%)
  adding: python/numpy/lib/__pycache__/ufunclike.cpython-37.pyc (deflated 66%)
  adding: python/numpy/lib/__pycache__/user_array.cpython-37.pyc (deflated 70%)
  adding: python/numpy/lib/__pycache__/utils.cpython-37.pyc (deflated 54%)
  adding: python/numpy/compat/ (stored 0%)
  adding: python/numpy/compat/setup.py (deflated 48%)
  adding: python/numpy/compat/__init__.py (deflated 43%)
  adding: python/numpy/compat/py3k.py (deflated 61%)
  adding: python/numpy/compat/_inspect.py (deflated 71%)
  adding: python/numpy/compat/tests/ (stored 0%)
  adding: python/numpy/compat/tests/test_compat.py (deflated 62%)
  adding: python/numpy/compat/tests/__init__.py (stored 0%)
  adding: python/numpy/compat/tests/__pycache__/ (stored 0%)
  adding: python/numpy/compat/tests/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/numpy/compat/tests/__pycache__/test_compat.cpython-37.pyc (deflated 38%)
  adding: python/numpy/compat/__pycache__/ (stored 0%)
  adding: python/numpy/compat/__pycache__/__init__.cpython-37.pyc (deflated 29%)
  adding: python/numpy/compat/__pycache__/_inspect.cpython-37.pyc (deflated 61%)
  adding: python/numpy/compat/__pycache__/py3k.cpython-37.pyc (deflated 51%)
  adding: python/numpy/compat/__pycache__/setup.cpython-37.pyc (deflated 31%)
  adding: python/numpy/__pycache__/ (stored 0%)
  adding: python/numpy/__pycache__/__config__.cpython-37.pyc (deflated 46%)
  adding: python/numpy/__pycache__/__init__.cpython-37.pyc (deflated 47%)
  adding: python/numpy/__pycache__/_distributor_init.cpython-37.pyc (deflated 32%)
  adding: python/numpy/__pycache__/_globals.cpython-37.pyc (deflated 49%)
  adding: python/numpy/__pycache__/_pytesttester.cpython-37.pyc (deflated 50%)
  adding: python/numpy/__pycache__/conftest.cpython-37.pyc (deflated 45%)
  adding: python/numpy/__pycache__/ctypeslib.cpython-37.pyc (deflated 53%)
  adding: python/numpy/__pycache__/dual.cpython-37.pyc (deflated 41%)
  adding: python/numpy/__pycache__/matlib.cpython-37.pyc (deflated 65%)
  adding: python/numpy/__pycache__/setup.cpython-37.pyc (deflated 40%)
  adding: python/numpy/__pycache__/version.cpython-37.pyc (deflated 24%)
  adding: python/pandas/ (stored 0%)
  adding: python/pandas/_version.py (deflated 31%)
  adding: python/pandas/_testing.py (deflated 76%)
  adding: python/pandas/conftest.py (deflated 74%)
  adding: python/pandas/testing.py (deflated 54%)
  adding: python/pandas/__init__.py (deflated 63%)
  adding: python/pandas/_typing.py (deflated 64%)
  adding: python/pandas/tests/ (stored 0%)
  adding: python/pandas/tests/test_take.py (deflated 85%)
  adding: python/pandas/tests/test_aggregation.py (deflated 78%)
  adding: python/pandas/tests/test_downstream.py (deflated 61%)
  adding: python/pandas/tests/test_algos.py (deflated 83%)
  adding: python/pandas/tests/test_nanops.py (deflated 81%)
  adding: python/pandas/tests/test_optional_dependency.py (deflated 67%)
  adding: python/pandas/tests/__init__.py (stored 0%)
  adding: python/pandas/tests/test_sorting.py (deflated 78%)
  adding: python/pandas/tests/test_register_accessor.py (deflated 65%)
  adding: python/pandas/tests/test_strings.py (deflated 84%)
  adding: python/pandas/tests/test_errors.py (deflated 66%)
  adding: python/pandas/tests/test_common.py (deflated 68%)
  adding: python/pandas/tests/test_multilevel.py (deflated 78%)
  adding: python/pandas/tests/test_flags.py (deflated 76%)
  adding: python/pandas/tests/test_expressions.py (deflated 78%)
  adding: python/pandas/tests/window/ (stored 0%)
  adding: python/pandas/tests/window/test_dtypes.py (deflated 77%)
  adding: python/pandas/tests/window/test_numba.py (deflated 73%)
  adding: python/pandas/tests/window/test_rolling.py (deflated 79%)
  adding: python/pandas/tests/window/test_pairwise.py (deflated 84%)
  adding: python/pandas/tests/window/test_timeseries_window.py (deflated 84%)
  adding: python/pandas/tests/window/test_apply.py (deflated 72%)
  adding: python/pandas/tests/window/test_ewm.py (deflated 69%)
  adding: python/pandas/tests/window/conftest.py (deflated 81%)
  adding: python/pandas/tests/window/test_api.py (deflated 76%)
  adding: python/pandas/tests/window/test_expanding.py (deflated 77%)
  adding: python/pandas/tests/window/__init__.py (deflated 26%)
  adding: python/pandas/tests/window/test_win_type.py (deflated 70%)
  adding: python/pandas/tests/window/test_base_indexer.py (deflated 77%)
  adding: python/pandas/tests/window/test_groupby.py (deflated 82%)
  adding: python/pandas/tests/window/moments/ (stored 0%)
  adding: python/pandas/tests/window/moments/test_moments_rolling_skew_kurt.py (deflated 78%)
  adding: python/pandas/tests/window/moments/test_moments_rolling.py (deflated 80%)
  adding: python/pandas/tests/window/moments/test_moments_consistency_expanding.py (deflated 84%)
  adding: python/pandas/tests/window/moments/test_moments_rolling_quantile.py (deflated 76%)
  adding: python/pandas/tests/window/moments/test_moments_consistency_rolling.py (deflated 83%)
  adding: python/pandas/tests/window/moments/test_moments_consistency_ewm.py (deflated 81%)
  adding: python/pandas/tests/window/moments/test_moments_ewm.py (deflated 82%)
  adding: python/pandas/tests/window/moments/test_moments_rolling_apply.py (deflated 73%)
  adding: python/pandas/tests/window/moments/__init__.py (stored 0%)
  adding: python/pandas/tests/window/moments/test_moments_rolling_functions.py (deflated 84%)
  adding: python/pandas/tests/window/moments/__pycache__/ (stored 0%)
  adding: python/pandas/tests/window/moments/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_consistency_ewm.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_consistency_expanding.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_consistency_rolling.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_ewm.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_rolling.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_rolling_apply.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_rolling_functions.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_rolling_quantile.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/window/moments/__pycache__/test_moments_rolling_skew_kurt.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/window/__pycache__/ (stored 0%)
  adding: python/pandas/tests/window/__pycache__/__init__.cpython-37.pyc (deflated 15%)
  adding: python/pandas/tests/window/__pycache__/conftest.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/window/__pycache__/test_api.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/window/__pycache__/test_apply.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/window/__pycache__/test_base_indexer.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/window/__pycache__/test_dtypes.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/window/__pycache__/test_ewm.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/window/__pycache__/test_expanding.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/window/__pycache__/test_groupby.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/window/__pycache__/test_numba.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/window/__pycache__/test_pairwise.cpython-37.pyc (deflated 69%)
  adding: python/pandas/tests/window/__pycache__/test_rolling.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/window/__pycache__/test_timeseries_window.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/window/__pycache__/test_win_type.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/scalar/ (stored 0%)
  adding: python/pandas/tests/scalar/test_nat.py (deflated 75%)
  adding: python/pandas/tests/scalar/__init__.py (stored 0%)
  adding: python/pandas/tests/scalar/test_na_scalar.py (deflated 75%)
  adding: python/pandas/tests/scalar/timestamp/ (stored 0%)
  adding: python/pandas/tests/scalar/timestamp/test_constructors.py (deflated 79%)
  adding: python/pandas/tests/scalar/timestamp/test_rendering.py (deflated 73%)
  adding: python/pandas/tests/scalar/timestamp/test_timezones.py (deflated 81%)
  adding: python/pandas/tests/scalar/timestamp/test_unary_ops.py (deflated 79%)
  adding: python/pandas/tests/scalar/timestamp/test_timestamp.py (deflated 79%)
  adding: python/pandas/tests/scalar/timestamp/test_comparisons.py (deflated 78%)
  adding: python/pandas/tests/scalar/timestamp/__init__.py (stored 0%)
  adding: python/pandas/tests/scalar/timestamp/test_arithmetic.py (deflated 76%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/ (stored 0%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/test_arithmetic.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/test_comparisons.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/test_constructors.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/test_rendering.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/test_timestamp.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/test_timezones.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/scalar/timestamp/__pycache__/test_unary_ops.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/scalar/timedelta/ (stored 0%)
  adding: python/pandas/tests/scalar/timedelta/test_formats.py (deflated 68%)
  adding: python/pandas/tests/scalar/timedelta/test_constructors.py (deflated 79%)
  adding: python/pandas/tests/scalar/timedelta/__init__.py (stored 0%)
  adding: python/pandas/tests/scalar/timedelta/test_arithmetic.py (deflated 84%)
  adding: python/pandas/tests/scalar/timedelta/test_timedelta.py (deflated 80%)
  adding: python/pandas/tests/scalar/timedelta/__pycache__/ (stored 0%)
  adding: python/pandas/tests/scalar/timedelta/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/scalar/timedelta/__pycache__/test_arithmetic.cpython-37.pyc (deflated 69%)
  adding: python/pandas/tests/scalar/timedelta/__pycache__/test_constructors.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/scalar/timedelta/__pycache__/test_formats.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/scalar/timedelta/__pycache__/test_timedelta.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/scalar/period/ (stored 0%)
  adding: python/pandas/tests/scalar/period/__init__.py (stored 0%)
  adding: python/pandas/tests/scalar/period/test_period.py (deflated 84%)
  adding: python/pandas/tests/scalar/period/test_asfreq.py (deflated 88%)
  adding: python/pandas/tests/scalar/period/__pycache__/ (stored 0%)
  adding: python/pandas/tests/scalar/period/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/scalar/period/__pycache__/test_asfreq.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/scalar/period/__pycache__/test_period.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/scalar/interval/ (stored 0%)
  adding: python/pandas/tests/scalar/interval/test_interval.py (deflated 79%)
  adding: python/pandas/tests/scalar/interval/test_ops.py (deflated 70%)
  adding: python/pandas/tests/scalar/interval/__init__.py (stored 0%)
  adding: python/pandas/tests/scalar/interval/test_arithmetic.py (deflated 66%)
  adding: python/pandas/tests/scalar/interval/__pycache__/ (stored 0%)
  adding: python/pandas/tests/scalar/interval/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/scalar/interval/__pycache__/test_arithmetic.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/scalar/interval/__pycache__/test_interval.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/scalar/interval/__pycache__/test_ops.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/scalar/__pycache__/ (stored 0%)
  adding: python/pandas/tests/scalar/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/scalar/__pycache__/test_na_scalar.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/scalar/__pycache__/test_nat.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/ (stored 0%)
  adding: python/pandas/tests/indexes/test_index_new.py (deflated 68%)
  adding: python/pandas/tests/indexes/test_any_index.py (deflated 68%)
  adding: python/pandas/tests/indexes/test_indexing.py (deflated 70%)
  adding: python/pandas/tests/indexes/test_numpy_compat.py (deflated 74%)
  adding: python/pandas/tests/indexes/test_datetimelike.py (deflated 81%)
  adding: python/pandas/tests/indexes/test_frozen.py (deflated 72%)
  adding: python/pandas/tests/indexes/conftest.py (deflated 52%)
  adding: python/pandas/tests/indexes/common.py (deflated 78%)
  adding: python/pandas/tests/indexes/test_numeric.py (deflated 78%)
  adding: python/pandas/tests/indexes/test_base.py (deflated 80%)
  adding: python/pandas/tests/indexes/datetimelike.py (deflated 71%)
  adding: python/pandas/tests/indexes/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/test_setops.py (deflated 80%)
  adding: python/pandas/tests/indexes/test_common.py (deflated 75%)
  adding: python/pandas/tests/indexes/test_engines.py (deflated 83%)
  adding: python/pandas/tests/indexes/base_class/ (stored 0%)
  adding: python/pandas/tests/indexes/base_class/test_formats.py (deflated 85%)
  adding: python/pandas/tests/indexes/base_class/test_where.py (deflated 39%)
  adding: python/pandas/tests/indexes/base_class/test_constructors.py (deflated 55%)
  adding: python/pandas/tests/indexes/base_class/test_indexing.py (deflated 63%)
  adding: python/pandas/tests/indexes/base_class/test_reshape.py (deflated 67%)
  adding: python/pandas/tests/indexes/base_class/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/base_class/test_setops.py (deflated 79%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/test_constructors.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/test_formats.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/test_indexing.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/test_reshape.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/test_setops.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/base_class/__pycache__/test_where.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/indexes/datetimes/ (stored 0%)
  adding: python/pandas/tests/indexes/datetimes/test_formats.py (deflated 82%)
  adding: python/pandas/tests/indexes/datetimes/test_fillna.py (deflated 80%)
  adding: python/pandas/tests/indexes/datetimes/test_constructors.py (deflated 82%)
  adding: python/pandas/tests/indexes/datetimes/test_indexing.py (deflated 82%)
  adding: python/pandas/tests/indexes/datetimes/test_to_period.py (deflated 77%)
  adding: python/pandas/tests/indexes/datetimes/test_delete.py (deflated 82%)
  adding: python/pandas/tests/indexes/datetimes/test_astype.py (deflated 82%)
  adding: python/pandas/tests/indexes/datetimes/test_date_range.py (deflated 81%)
  adding: python/pandas/tests/indexes/datetimes/test_pickle.py (deflated 63%)
  adding: python/pandas/tests/indexes/datetimes/test_timezones.py (deflated 82%)
  adding: python/pandas/tests/indexes/datetimes/test_misc.py (deflated 80%)
  adding: python/pandas/tests/indexes/datetimes/test_datetimelike.py (deflated 57%)
  adding: python/pandas/tests/indexes/datetimes/test_scalar_compat.py (deflated 80%)
  adding: python/pandas/tests/indexes/datetimes/test_map.py (deflated 54%)
  adding: python/pandas/tests/indexes/datetimes/test_partial_slicing.py (deflated 78%)
  adding: python/pandas/tests/indexes/datetimes/test_datetime.py (deflated 76%)
  adding: python/pandas/tests/indexes/datetimes/test_join.py (deflated 72%)
  adding: python/pandas/tests/indexes/datetimes/test_ops.py (deflated 79%)
  adding: python/pandas/tests/indexes/datetimes/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/datetimes/test_shift.py (deflated 75%)
  adding: python/pandas/tests/indexes/datetimes/test_setops.py (deflated 81%)
  adding: python/pandas/tests/indexes/datetimes/test_snap.py (deflated 65%)
  adding: python/pandas/tests/indexes/datetimes/test_insert.py (deflated 77%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_astype.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_constructors.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_date_range.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_datetime.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_datetimelike.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_delete.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_fillna.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_formats.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_indexing.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_insert.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_join.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_map.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_misc.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_ops.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_partial_slicing.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_pickle.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_scalar_compat.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_setops.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_shift.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_snap.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_timezones.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/indexes/datetimes/__pycache__/test_to_period.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/ranges/ (stored 0%)
  adding: python/pandas/tests/indexes/ranges/test_constructors.py (deflated 77%)
  adding: python/pandas/tests/indexes/ranges/test_indexing.py (deflated 76%)
  adding: python/pandas/tests/indexes/ranges/test_join.py (deflated 84%)
  adding: python/pandas/tests/indexes/ranges/test_range.py (deflated 78%)
  adding: python/pandas/tests/indexes/ranges/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/ranges/test_setops.py (deflated 85%)
  adding: python/pandas/tests/indexes/ranges/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/ranges/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/indexes/ranges/__pycache__/test_constructors.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/ranges/__pycache__/test_indexing.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/ranges/__pycache__/test_join.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/ranges/__pycache__/test_range.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/indexes/ranges/__pycache__/test_setops.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/timedeltas/ (stored 0%)
  adding: python/pandas/tests/indexes/timedeltas/test_formats.py (deflated 80%)
  adding: python/pandas/tests/indexes/timedeltas/test_fillna.py (deflated 58%)
  adding: python/pandas/tests/indexes/timedeltas/test_constructors.py (deflated 77%)
  adding: python/pandas/tests/indexes/timedeltas/test_indexing.py (deflated 79%)
  adding: python/pandas/tests/indexes/timedeltas/test_delete.py (deflated 74%)
  adding: python/pandas/tests/indexes/timedeltas/test_astype.py (deflated 77%)
  adding: python/pandas/tests/indexes/timedeltas/test_searchsorted.py (deflated 55%)
  adding: python/pandas/tests/indexes/timedeltas/test_scalar_compat.py (deflated 73%)
  adding: python/pandas/tests/indexes/timedeltas/test_partial_slicing.py (deflated 70%)
  adding: python/pandas/tests/indexes/timedeltas/test_join.py (deflated 62%)
  adding: python/pandas/tests/indexes/timedeltas/test_ops.py (deflated 78%)
  adding: python/pandas/tests/indexes/timedeltas/test_timedelta_range.py (deflated 72%)
  adding: python/pandas/tests/indexes/timedeltas/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/timedeltas/test_shift.py (deflated 78%)
  adding: python/pandas/tests/indexes/timedeltas/test_setops.py (deflated 79%)
  adding: python/pandas/tests/indexes/timedeltas/test_insert.py (deflated 74%)
  adding: python/pandas/tests/indexes/timedeltas/test_timedelta.py (deflated 75%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_astype.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_constructors.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_delete.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_fillna.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_formats.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_indexing.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_insert.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_join.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_ops.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_partial_slicing.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_scalar_compat.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_searchsorted.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_setops.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_shift.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_timedelta.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/timedeltas/__pycache__/test_timedelta_range.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/indexes/categorical/ (stored 0%)
  adding: python/pandas/tests/indexes/categorical/test_formats.py (deflated 87%)
  adding: python/pandas/tests/indexes/categorical/test_fillna.py (deflated 67%)
  adding: python/pandas/tests/indexes/categorical/test_constructors.py (deflated 83%)
  adding: python/pandas/tests/indexes/categorical/test_indexing.py (deflated 81%)
  adding: python/pandas/tests/indexes/categorical/test_astype.py (deflated 70%)
  adding: python/pandas/tests/indexes/categorical/test_map.py (deflated 74%)
  adding: python/pandas/tests/indexes/categorical/test_equals.py (deflated 75%)
  adding: python/pandas/tests/indexes/categorical/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/categorical/test_category.py (deflated 79%)
  adding: python/pandas/tests/indexes/categorical/test_reindex.py (deflated 80%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_astype.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_category.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_constructors.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_equals.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_fillna.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_formats.cpython-37.pyc (deflated 77%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_indexing.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_map.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/categorical/__pycache__/test_reindex.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/numeric/ (stored 0%)
  adding: python/pandas/tests/indexes/numeric/test_indexing.py (deflated 80%)
  adding: python/pandas/tests/indexes/numeric/test_astype.py (deflated 74%)
  adding: python/pandas/tests/indexes/numeric/test_join.py (deflated 89%)
  adding: python/pandas/tests/indexes/numeric/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/numeric/test_setops.py (deflated 76%)
  adding: python/pandas/tests/indexes/numeric/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/numeric/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/indexes/numeric/__pycache__/test_astype.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexes/numeric/__pycache__/test_indexing.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/numeric/__pycache__/test_join.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/indexes/numeric/__pycache__/test_setops.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/period/ (stored 0%)
  adding: python/pandas/tests/indexes/period/test_formats.py (deflated 81%)
  adding: python/pandas/tests/indexes/period/test_fillna.py (deflated 73%)
  adding: python/pandas/tests/indexes/period/test_period_range.py (deflated 80%)
  adding: python/pandas/tests/indexes/period/test_constructors.py (deflated 81%)
  adding: python/pandas/tests/indexes/period/test_indexing.py (deflated 82%)
  adding: python/pandas/tests/indexes/period/test_astype.py (deflated 80%)
  adding: python/pandas/tests/indexes/period/test_searchsorted.py (deflated 73%)
  adding: python/pandas/tests/indexes/period/test_scalar_compat.py (deflated 65%)
  adding: python/pandas/tests/indexes/period/test_partial_slicing.py (deflated 76%)
  adding: python/pandas/tests/indexes/period/test_join.py (deflated 62%)
  adding: python/pandas/tests/indexes/period/test_to_timestamp.py (deflated 75%)
  adding: python/pandas/tests/indexes/period/test_ops.py (deflated 82%)
  adding: python/pandas/tests/indexes/period/test_factorize.py (deflated 75%)
  adding: python/pandas/tests/indexes/period/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/period/test_shift.py (deflated 81%)
  adding: python/pandas/tests/indexes/period/test_monotonic.py (deflated 80%)
  adding: python/pandas/tests/indexes/period/test_tools.py (deflated 53%)
  adding: python/pandas/tests/indexes/period/test_setops.py (deflated 84%)
  adding: python/pandas/tests/indexes/period/test_period.py (deflated 79%)
  adding: python/pandas/tests/indexes/period/test_asfreq.py (deflated 83%)
  adding: python/pandas/tests/indexes/period/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/period/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_asfreq.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_astype.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_constructors.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_factorize.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_fillna.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_formats.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_indexing.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_join.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_monotonic.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_ops.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_partial_slicing.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_period.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_period_range.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_scalar_compat.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_searchsorted.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_setops.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_shift.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_to_timestamp.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/period/__pycache__/test_tools.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/indexes/interval/ (stored 0%)
  adding: python/pandas/tests/indexes/interval/test_formats.py (deflated 70%)
  adding: python/pandas/tests/indexes/interval/test_constructors.py (deflated 79%)
  adding: python/pandas/tests/indexes/interval/test_indexing.py (deflated 82%)
  adding: python/pandas/tests/indexes/interval/test_interval_range.py (deflated 84%)
  adding: python/pandas/tests/indexes/interval/test_astype.py (deflated 80%)
  adding: python/pandas/tests/indexes/interval/test_interval_tree.py (deflated 78%)
  adding: python/pandas/tests/indexes/interval/test_interval.py (deflated 83%)
  adding: python/pandas/tests/indexes/interval/test_base.py (deflated 67%)
  adding: python/pandas/tests/indexes/interval/test_equals.py (deflated 71%)
  adding: python/pandas/tests/indexes/interval/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/interval/test_setops.py (deflated 83%)
  adding: python/pandas/tests/indexes/interval/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/interval/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_astype.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_base.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_constructors.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_equals.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_formats.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_indexing.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_interval.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_interval_range.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_interval_tree.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/interval/__pycache__/test_setops.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/multi/ (stored 0%)
  adding: python/pandas/tests/indexes/multi/test_formats.py (deflated 81%)
  adding: python/pandas/tests/indexes/multi/test_compat.py (deflated 69%)
  adding: python/pandas/tests/indexes/multi/test_missing.py (deflated 69%)
  adding: python/pandas/tests/indexes/multi/test_constructors.py (deflated 81%)
  adding: python/pandas/tests/indexes/multi/test_get_set.py (deflated 81%)
  adding: python/pandas/tests/indexes/multi/test_get_level_values.py (deflated 75%)
  adding: python/pandas/tests/indexes/multi/test_indexing.py (deflated 79%)
  adding: python/pandas/tests/indexes/multi/test_take.py (deflated 73%)
  adding: python/pandas/tests/indexes/multi/test_astype.py (deflated 54%)
  adding: python/pandas/tests/indexes/multi/test_conversion.py (deflated 76%)
  adding: python/pandas/tests/indexes/multi/test_lexsort.py (deflated 77%)
  adding: python/pandas/tests/indexes/multi/conftest.py (deflated 69%)
  adding: python/pandas/tests/indexes/multi/test_join.py (deflated 74%)
  adding: python/pandas/tests/indexes/multi/test_equivalence.py (deflated 75%)
  adding: python/pandas/tests/indexes/multi/test_isin.py (deflated 74%)
  adding: python/pandas/tests/indexes/multi/test_partial_indexing.py (deflated 71%)
  adding: python/pandas/tests/indexes/multi/test_copy.py (deflated 72%)
  adding: python/pandas/tests/indexes/multi/test_duplicates.py (deflated 76%)
  adding: python/pandas/tests/indexes/multi/test_reshape.py (deflated 71%)
  adding: python/pandas/tests/indexes/multi/test_drop.py (deflated 77%)
  adding: python/pandas/tests/indexes/multi/test_analytics.py (deflated 71%)
  adding: python/pandas/tests/indexes/multi/__init__.py (stored 0%)
  adding: python/pandas/tests/indexes/multi/test_monotonic.py (deflated 87%)
  adding: python/pandas/tests/indexes/multi/test_sorting.py (deflated 73%)
  adding: python/pandas/tests/indexes/multi/test_setops.py (deflated 79%)
  adding: python/pandas/tests/indexes/multi/test_names.py (deflated 72%)
  adding: python/pandas/tests/indexes/multi/test_integrity.py (deflated 71%)
  adding: python/pandas/tests/indexes/multi/test_reindex.py (deflated 74%)
  adding: python/pandas/tests/indexes/multi/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/multi/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/indexes/multi/__pycache__/conftest.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_analytics.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_astype.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_compat.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_constructors.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_conversion.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_copy.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_drop.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_duplicates.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_equivalence.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_formats.cpython-37.pyc (deflated 70%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_get_level_values.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_get_set.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_indexing.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_integrity.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_isin.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_join.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_lexsort.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_missing.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_monotonic.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_names.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_partial_indexing.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_reindex.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_reshape.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_setops.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_sorting.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/multi/__pycache__/test_take.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/indexes/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexes/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/indexes/__pycache__/common.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/indexes/__pycache__/conftest.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/indexes/__pycache__/datetimelike.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/__pycache__/test_any_index.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/indexes/__pycache__/test_base.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/indexes/__pycache__/test_common.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/indexes/__pycache__/test_datetimelike.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/__pycache__/test_engines.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/indexes/__pycache__/test_frozen.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/indexes/__pycache__/test_index_new.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexes/__pycache__/test_indexing.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexes/__pycache__/test_numeric.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexes/__pycache__/test_numpy_compat.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/indexes/__pycache__/test_setops.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/arithmetic/ (stored 0%)
  adding: python/pandas/tests/arithmetic/test_array_ops.py (deflated 57%)
  adding: python/pandas/tests/arithmetic/test_datetime64.py (deflated 84%)
  adding: python/pandas/tests/arithmetic/test_interval.py (deflated 80%)
  adding: python/pandas/tests/arithmetic/conftest.py (deflated 74%)
  adding: python/pandas/tests/arithmetic/common.py (deflated 67%)
  adding: python/pandas/tests/arithmetic/test_object.py (deflated 78%)
  adding: python/pandas/tests/arithmetic/test_numeric.py (deflated 81%)
  adding: python/pandas/tests/arithmetic/test_categorical.py (deflated 44%)
  adding: python/pandas/tests/arithmetic/__init__.py (stored 0%)
  adding: python/pandas/tests/arithmetic/test_period.py (deflated 86%)
  adding: python/pandas/tests/arithmetic/test_timedelta64.py (deflated 85%)
  adding: python/pandas/tests/arithmetic/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arithmetic/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/arithmetic/__pycache__/common.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/arithmetic/__pycache__/conftest.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_array_ops.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_categorical.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_datetime64.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_interval.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_numeric.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_object.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_period.cpython-37.pyc (deflated 71%)
  adding: python/pandas/tests/arithmetic/__pycache__/test_timedelta64.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/dtypes/ (stored 0%)
  adding: python/pandas/tests/dtypes/test_missing.py (deflated 82%)
  adding: python/pandas/tests/dtypes/test_dtypes.py (deflated 83%)
  adding: python/pandas/tests/dtypes/test_inference.py (deflated 83%)
  adding: python/pandas/tests/dtypes/test_concat.py (deflated 73%)
  adding: python/pandas/tests/dtypes/__init__.py (stored 0%)
  adding: python/pandas/tests/dtypes/test_common.py (deflated 83%)
  adding: python/pandas/tests/dtypes/test_generic.py (deflated 70%)
  adding: python/pandas/tests/dtypes/cast/ (stored 0%)
  adding: python/pandas/tests/dtypes/cast/test_construct_from_scalar.py (deflated 54%)
  adding: python/pandas/tests/dtypes/cast/test_downcast.py (deflated 71%)
  adding: python/pandas/tests/dtypes/cast/test_infer_dtype.py (deflated 75%)
  adding: python/pandas/tests/dtypes/cast/test_upcast.py (deflated 73%)
  adding: python/pandas/tests/dtypes/cast/test_construct_object_arr.py (deflated 51%)
  adding: python/pandas/tests/dtypes/cast/test_promote.py (deflated 85%)
  adding: python/pandas/tests/dtypes/cast/test_construct_ndarray.py (deflated 63%)
  adding: python/pandas/tests/dtypes/cast/test_dict_compat.py (deflated 57%)
  adding: python/pandas/tests/dtypes/cast/__init__.py (stored 0%)
  adding: python/pandas/tests/dtypes/cast/test_infer_datetimelike.py (deflated 47%)
  adding: python/pandas/tests/dtypes/cast/test_find_common_type.py (deflated 80%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/ (stored 0%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_construct_from_scalar.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_construct_ndarray.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_construct_object_arr.cpython-37.pyc (deflated 34%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_dict_compat.cpython-37.pyc (deflated 32%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_downcast.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_find_common_type.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_infer_datetimelike.cpython-37.pyc (deflated 34%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_infer_dtype.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_promote.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/dtypes/cast/__pycache__/test_upcast.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/dtypes/__pycache__/ (stored 0%)
  adding: python/pandas/tests/dtypes/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/dtypes/__pycache__/test_common.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/dtypes/__pycache__/test_concat.cpython-37.pyc (deflated 44%)
  adding: python/pandas/tests/dtypes/__pycache__/test_dtypes.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/dtypes/__pycache__/test_generic.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/dtypes/__pycache__/test_inference.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/dtypes/__pycache__/test_missing.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/series/ (stored 0%)
  adding: python/pandas/tests/series/test_subclass.py (deflated 70%)
  adding: python/pandas/tests/series/test_missing.py (deflated 66%)
  adding: python/pandas/tests/series/test_constructors.py (deflated 80%)
  adding: python/pandas/tests/series/test_dtypes.py (deflated 75%)
  adding: python/pandas/tests/series/test_logical_ops.py (deflated 83%)
  adding: python/pandas/tests/series/test_reductions.py (deflated 66%)
  adding: python/pandas/tests/series/test_validate.py (deflated 49%)
  adding: python/pandas/tests/series/test_api.py (deflated 70%)
  adding: python/pandas/tests/series/test_repr.py (deflated 78%)
  adding: python/pandas/tests/series/test_npfuncs.py (deflated 36%)
  adding: python/pandas/tests/series/test_duplicates.py (deflated 66%)
  adding: python/pandas/tests/series/test_cumulative.py (deflated 81%)
  adding: python/pandas/tests/series/__init__.py (stored 0%)
  adding: python/pandas/tests/series/test_arithmetic.py (deflated 77%)
  adding: python/pandas/tests/series/test_ufunc.py (deflated 78%)
  adding: python/pandas/tests/series/test_unary.py (deflated 75%)
  adding: python/pandas/tests/series/test_iteration.py (deflated 80%)
  adding: python/pandas/tests/series/indexing/ (stored 0%)
  adding: python/pandas/tests/series/indexing/test_where.py (deflated 78%)
  adding: python/pandas/tests/series/indexing/test_indexing.py (deflated 77%)
  adding: python/pandas/tests/series/indexing/test_take.py (deflated 59%)
  adding: python/pandas/tests/series/indexing/test_set_value.py (deflated 62%)
  adding: python/pandas/tests/series/indexing/test_xs.py (deflated 67%)
  adding: python/pandas/tests/series/indexing/test_getitem.py (deflated 74%)
  adding: python/pandas/tests/series/indexing/test_datetime.py (deflated 79%)
  adding: python/pandas/tests/series/indexing/test_mask.py (deflated 68%)
  adding: python/pandas/tests/series/indexing/test_numeric.py (deflated 70%)
  adding: python/pandas/tests/series/indexing/test_get.py (deflated 74%)
  adding: python/pandas/tests/series/indexing/test_delitem.py (deflated 72%)
  adding: python/pandas/tests/series/indexing/__init__.py (stored 0%)
  adding: python/pandas/tests/series/indexing/test_setitem.py (deflated 75%)
  adding: python/pandas/tests/series/indexing/__pycache__/ (stored 0%)
  adding: python/pandas/tests/series/indexing/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_datetime.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_delitem.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_get.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_getitem.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_indexing.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_mask.cpython-37.pyc (deflated 44%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_numeric.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_set_value.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_setitem.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_take.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_where.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/series/indexing/__pycache__/test_xs.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/series/apply/ (stored 0%)
  adding: python/pandas/tests/series/apply/test_apply_relabeling.py (deflated 69%)
  adding: python/pandas/tests/series/apply/test_series_transform.py (deflated 66%)
  adding: python/pandas/tests/series/apply/test_series_apply.py (deflated 80%)
  adding: python/pandas/tests/series/apply/__init__.py (stored 0%)
  adding: python/pandas/tests/series/apply/__pycache__/ (stored 0%)
  adding: python/pandas/tests/series/apply/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/series/apply/__pycache__/test_apply_relabeling.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/series/apply/__pycache__/test_series_apply.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/series/apply/__pycache__/test_series_transform.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/series/methods/ (stored 0%)
  adding: python/pandas/tests/series/methods/test_to_csv.py (deflated 72%)
  adding: python/pandas/tests/series/methods/test_is_monotonic.py (deflated 67%)
  adding: python/pandas/tests/series/methods/test_convert_dtypes.py (deflated 72%)
  adding: python/pandas/tests/series/methods/test_explode.py (deflated 74%)
  adding: python/pandas/tests/series/methods/test_between.py (deflated 66%)
  adding: python/pandas/tests/series/methods/test_reindex_like.py (deflated 66%)
  adding: python/pandas/tests/series/methods/test_combine.py (deflated 55%)
  adding: python/pandas/tests/series/methods/test_fillna.py (deflated 86%)
  adding: python/pandas/tests/series/methods/test_autocorr.py (deflated 68%)
  adding: python/pandas/tests/series/methods/test_quantile.py (deflated 79%)
  adding: python/pandas/tests/series/methods/test_sort_index.py (deflated 84%)
  adding: python/pandas/tests/series/methods/test_view.py (deflated 52%)
  adding: python/pandas/tests/series/methods/test_drop_duplicates.py (deflated 83%)
  adding: python/pandas/tests/series/methods/test_repeat.py (deflated 60%)
  adding: python/pandas/tests/series/methods/test_cov_corr.py (deflated 75%)
  adding: python/pandas/tests/series/methods/test_nlargest.py (deflated 73%)
  adding: python/pandas/tests/series/methods/test_rename_axis.py (deflated 62%)
  adding: python/pandas/tests/series/methods/test_astype.py (deflated 75%)
  adding: python/pandas/tests/series/methods/test_interpolate.py (deflated 84%)
  adding: python/pandas/tests/series/methods/test_describe.py (deflated 80%)
  adding: python/pandas/tests/series/methods/test_searchsorted.py (deflated 76%)
  adding: python/pandas/tests/series/methods/test_head_tail.py (deflated 65%)
  adding: python/pandas/tests/series/methods/test_value_counts.py (deflated 84%)
  adding: python/pandas/tests/series/methods/test_compare.py (deflated 76%)
  adding: python/pandas/tests/series/methods/test_tz_localize.py (deflated 69%)
  adding: python/pandas/tests/series/methods/test_align.py (deflated 74%)
  adding: python/pandas/tests/series/methods/test_values.py (deflated 49%)
  adding: python/pandas/tests/series/methods/test_argsort.py (deflated 64%)
  adding: python/pandas/tests/series/methods/test_rename.py (deflated 71%)
  adding: python/pandas/tests/series/methods/test_duplicated.py (deflated 70%)
  adding: python/pandas/tests/series/methods/test_update.py (deflated 77%)
  adding: python/pandas/tests/series/methods/test_tz_convert.py (deflated 57%)
  adding: python/pandas/tests/series/methods/test_dropna.py (deflated 73%)
  adding: python/pandas/tests/series/methods/test_get_numeric_data.py (deflated 66%)
  adding: python/pandas/tests/series/methods/test_append.py (deflated 83%)
  adding: python/pandas/tests/series/methods/test_isin.py (deflated 72%)
  adding: python/pandas/tests/series/methods/test_unstack.py (deflated 73%)
  adding: python/pandas/tests/series/methods/test_item.py (deflated 70%)
  adding: python/pandas/tests/series/methods/test_diff.py (deflated 68%)
  adding: python/pandas/tests/series/methods/test_replace.py (deflated 78%)
  adding: python/pandas/tests/series/methods/test_copy.py (deflated 73%)
  adding: python/pandas/tests/series/methods/test_pct_change.py (deflated 72%)
  adding: python/pandas/tests/series/methods/test_infer_objects.py (deflated 64%)
  adding: python/pandas/tests/series/methods/test_clip.py (deflated 73%)
  adding: python/pandas/tests/series/methods/test_asof.py (deflated 78%)
  adding: python/pandas/tests/series/methods/test_drop.py (deflated 72%)
  adding: python/pandas/tests/series/methods/test_matmul.py (deflated 77%)
  adding: python/pandas/tests/series/methods/test_pop.py (deflated 39%)
  adding: python/pandas/tests/series/methods/test_truncate.py (deflated 67%)
  adding: python/pandas/tests/series/methods/test_to_frame.py (deflated 69%)
  adding: python/pandas/tests/series/methods/test_combine_first.py (deflated 71%)
  adding: python/pandas/tests/series/methods/test_equals.py (deflated 60%)
  adding: python/pandas/tests/series/methods/__init__.py (deflated 29%)
  adding: python/pandas/tests/series/methods/test_shift.py (deflated 79%)
  adding: python/pandas/tests/series/methods/test_convert.py (deflated 80%)
  adding: python/pandas/tests/series/methods/test_to_dict.py (deflated 56%)
  adding: python/pandas/tests/series/methods/test_isna.py (deflated 65%)
  adding: python/pandas/tests/series/methods/test_reset_index.py (deflated 72%)
  adding: python/pandas/tests/series/methods/test_round.py (deflated 67%)
  adding: python/pandas/tests/series/methods/test_asfreq.py (deflated 71%)
  adding: python/pandas/tests/series/methods/test_rank.py (deflated 80%)
  adding: python/pandas/tests/series/methods/test_reindex.py (deflated 76%)
  adding: python/pandas/tests/series/methods/test_count.py (deflated 68%)
  adding: python/pandas/tests/series/methods/test_sort_values.py (deflated 78%)
  adding: python/pandas/tests/series/methods/test_set_name.py (deflated 60%)
  adding: python/pandas/tests/series/methods/__pycache__/ (stored 0%)
  adding: python/pandas/tests/series/methods/__pycache__/test_rename_axis.cpython-37.pyc (deflated 44%)
  adding: python/pandas/tests/series/methods/__pycache__/__init__.cpython-37.pyc (deflated 25%)
  adding: python/pandas/tests/series/methods/__pycache__/test_repeat.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/series/methods/__pycache__/test_align.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/series/methods/__pycache__/test_sort_index.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/series/methods/__pycache__/test_append.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/series/methods/__pycache__/test_sort_values.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/series/methods/__pycache__/test_argsort.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/series/methods/__pycache__/test_to_csv.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/series/methods/__pycache__/test_asfreq.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/series/methods/__pycache__/test_to_dict.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/series/methods/__pycache__/test_asof.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/series/methods/__pycache__/test_to_frame.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/series/methods/__pycache__/test_astype.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/series/methods/__pycache__/test_truncate.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/series/methods/__pycache__/test_autocorr.cpython-37.pyc (deflated 38%)
  adding: python/pandas/tests/series/methods/__pycache__/test_tz_convert.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/series/methods/__pycache__/test_between.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/series/methods/__pycache__/test_tz_localize.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/series/methods/__pycache__/test_clip.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/series/methods/__pycache__/test_unstack.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/series/methods/__pycache__/test_combine.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/series/methods/__pycache__/test_nlargest.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/series/methods/__pycache__/test_combine_first.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/series/methods/__pycache__/test_update.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/series/methods/__pycache__/test_compare.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/series/methods/__pycache__/test_value_counts.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/series/methods/__pycache__/test_convert.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/series/methods/__pycache__/test_pct_change.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/series/methods/__pycache__/test_convert_dtypes.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/series/methods/__pycache__/test_values.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/series/methods/__pycache__/test_copy.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/series/methods/__pycache__/test_view.cpython-37.pyc (deflated 34%)
  adding: python/pandas/tests/series/methods/__pycache__/test_count.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/series/methods/__pycache__/test_cov_corr.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/series/methods/__pycache__/test_describe.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/series/methods/__pycache__/test_diff.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/series/methods/__pycache__/test_drop.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/series/methods/__pycache__/test_quantile.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/series/methods/__pycache__/test_drop_duplicates.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/series/methods/__pycache__/test_dropna.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/series/methods/__pycache__/test_pop.cpython-37.pyc (deflated 29%)
  adding: python/pandas/tests/series/methods/__pycache__/test_duplicated.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/series/methods/__pycache__/test_equals.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/series/methods/__pycache__/test_explode.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/series/methods/__pycache__/test_fillna.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/series/methods/__pycache__/test_rank.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/series/methods/__pycache__/test_get_numeric_data.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/series/methods/__pycache__/test_reindex.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/series/methods/__pycache__/test_head_tail.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/series/methods/__pycache__/test_rename.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/series/methods/__pycache__/test_infer_objects.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/series/methods/__pycache__/test_reindex_like.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/series/methods/__pycache__/test_interpolate.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/series/methods/__pycache__/test_is_monotonic.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/series/methods/__pycache__/test_isin.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/series/methods/__pycache__/test_isna.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/series/methods/__pycache__/test_item.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/series/methods/__pycache__/test_matmul.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/series/methods/__pycache__/test_replace.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/series/methods/__pycache__/test_set_name.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/series/methods/__pycache__/test_reset_index.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/series/methods/__pycache__/test_round.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/series/methods/__pycache__/test_shift.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/series/methods/__pycache__/test_searchsorted.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/series/accessors/ (stored 0%)
  adding: python/pandas/tests/series/accessors/test_sparse_accessor.py (deflated 37%)
  adding: python/pandas/tests/series/accessors/test_cat_accessor.py (deflated 75%)
  adding: python/pandas/tests/series/accessors/test_dt_accessor.py (deflated 80%)
  adding: python/pandas/tests/series/accessors/__init__.py (stored 0%)
  adding: python/pandas/tests/series/accessors/test_str_accessor.py (deflated 52%)
  adding: python/pandas/tests/series/accessors/__pycache__/ (stored 0%)
  adding: python/pandas/tests/series/accessors/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/series/accessors/__pycache__/test_cat_accessor.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/series/accessors/__pycache__/test_dt_accessor.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/series/accessors/__pycache__/test_sparse_accessor.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/series/accessors/__pycache__/test_str_accessor.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/series/__pycache__/ (stored 0%)
  adding: python/pandas/tests/series/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/series/__pycache__/test_api.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/series/__pycache__/test_arithmetic.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/series/__pycache__/test_constructors.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/series/__pycache__/test_cumulative.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/series/__pycache__/test_dtypes.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/series/__pycache__/test_duplicates.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/series/__pycache__/test_iteration.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/series/__pycache__/test_logical_ops.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/series/__pycache__/test_missing.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/series/__pycache__/test_npfuncs.cpython-37.pyc (deflated 32%)
  adding: python/pandas/tests/series/__pycache__/test_reductions.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/series/__pycache__/test_repr.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/series/__pycache__/test_subclass.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/series/__pycache__/test_ufunc.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/series/__pycache__/test_unary.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/series/__pycache__/test_validate.cpython-37.pyc (deflated 29%)
  adding: python/pandas/tests/computation/ (stored 0%)
  adding: python/pandas/tests/computation/test_compat.py (deflated 63%)
  adding: python/pandas/tests/computation/__init__.py (stored 0%)
  adding: python/pandas/tests/computation/test_eval.py (deflated 83%)
  adding: python/pandas/tests/computation/__pycache__/ (stored 0%)
  adding: python/pandas/tests/computation/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/computation/__pycache__/test_compat.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/computation/__pycache__/test_eval.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/api/ (stored 0%)
  adding: python/pandas/tests/api/test_api.py (deflated 73%)
  adding: python/pandas/tests/api/__init__.py (stored 0%)
  adding: python/pandas/tests/api/test_types.py (deflated 70%)
  adding: python/pandas/tests/api/__pycache__/ (stored 0%)
  adding: python/pandas/tests/api/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/api/__pycache__/test_api.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/api/__pycache__/test_types.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/indexing/ (stored 0%)
  adding: python/pandas/tests/indexing/test_indexing.py (deflated 78%)
  adding: python/pandas/tests/indexing/test_iat.py (deflated 51%)
  adding: python/pandas/tests/indexing/test_datetime.py (deflated 75%)
  adding: python/pandas/tests/indexing/common.py (deflated 72%)
  adding: python/pandas/tests/indexing/test_chaining_and_caching.py (deflated 76%)
  adding: python/pandas/tests/indexing/test_coercion.py (deflated 86%)
  adding: python/pandas/tests/indexing/test_indexers.py (deflated 73%)
  adding: python/pandas/tests/indexing/test_categorical.py (deflated 81%)
  adding: python/pandas/tests/indexing/test_na_indexing.py (deflated 70%)
  adding: python/pandas/tests/indexing/test_check_indexer.py (deflated 74%)
  adding: python/pandas/tests/indexing/test_partial.py (deflated 84%)
  adding: python/pandas/tests/indexing/__init__.py (stored 0%)
  adding: python/pandas/tests/indexing/test_floats.py (deflated 81%)
  adding: python/pandas/tests/indexing/test_iloc.py (deflated 79%)
  adding: python/pandas/tests/indexing/test_scalar.py (deflated 75%)
  adding: python/pandas/tests/indexing/test_at.py (deflated 75%)
  adding: python/pandas/tests/indexing/test_loc.py (deflated 80%)
  adding: python/pandas/tests/indexing/multiindex/ (stored 0%)
  adding: python/pandas/tests/indexing/multiindex/test_ix.py (deflated 60%)
  adding: python/pandas/tests/indexing/multiindex/test_slice.py (deflated 84%)
  adding: python/pandas/tests/indexing/multiindex/test_multiindex.py (deflated 66%)
  adding: python/pandas/tests/indexing/multiindex/test_getitem.py (deflated 75%)
  adding: python/pandas/tests/indexing/multiindex/test_datetime.py (deflated 59%)
  adding: python/pandas/tests/indexing/multiindex/test_chaining_and_caching.py (deflated 55%)
  adding: python/pandas/tests/indexing/multiindex/test_partial.py (deflated 77%)
  adding: python/pandas/tests/indexing/multiindex/__init__.py (stored 0%)
  adding: python/pandas/tests/indexing/multiindex/test_sorted.py (deflated 75%)
  adding: python/pandas/tests/indexing/multiindex/test_insert.py (deflated 56%)
  adding: python/pandas/tests/indexing/multiindex/test_iloc.py (deflated 72%)
  adding: python/pandas/tests/indexing/multiindex/test_indexing_slow.py (deflated 65%)
  adding: python/pandas/tests/indexing/multiindex/test_loc.py (deflated 77%)
  adding: python/pandas/tests/indexing/multiindex/test_setitem.py (deflated 75%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_chaining_and_caching.cpython-37.pyc (deflated 38%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_datetime.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_getitem.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_iloc.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_indexing_slow.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_insert.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_ix.cpython-37.pyc (deflated 44%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_loc.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_multiindex.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_partial.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_setitem.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_slice.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/indexing/multiindex/__pycache__/test_sorted.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexing/interval/ (stored 0%)
  adding: python/pandas/tests/indexing/interval/test_interval.py (deflated 74%)
  adding: python/pandas/tests/indexing/interval/test_interval_new.py (deflated 83%)
  adding: python/pandas/tests/indexing/interval/__init__.py (stored 0%)
  adding: python/pandas/tests/indexing/interval/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexing/interval/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/indexing/interval/__pycache__/test_interval.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/indexing/interval/__pycache__/test_interval_new.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/indexing/__pycache__/ (stored 0%)
  adding: python/pandas/tests/indexing/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/indexing/__pycache__/common.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/indexing/__pycache__/test_at.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexing/__pycache__/test_categorical.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexing/__pycache__/test_chaining_and_caching.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/indexing/__pycache__/test_check_indexer.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexing/__pycache__/test_coercion.cpython-37.pyc (deflated 69%)
  adding: python/pandas/tests/indexing/__pycache__/test_datetime.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/indexing/__pycache__/test_floats.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/indexing/__pycache__/test_iat.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/indexing/__pycache__/test_iloc.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/indexing/__pycache__/test_indexers.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/indexing/__pycache__/test_indexing.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/indexing/__pycache__/test_loc.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/indexing/__pycache__/test_na_indexing.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/indexing/__pycache__/test_partial.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/indexing/__pycache__/test_scalar.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/base/ (stored 0%)
  adding: python/pandas/tests/base/test_fillna.py (deflated 65%)
  adding: python/pandas/tests/base/test_constructors.py (deflated 68%)
  adding: python/pandas/tests/base/test_misc.py (deflated 67%)
  adding: python/pandas/tests/base/test_unique.py (deflated 76%)
  adding: python/pandas/tests/base/test_value_counts.py (deflated 75%)
  adding: python/pandas/tests/base/test_conversion.py (deflated 78%)
  adding: python/pandas/tests/base/test_transpose.py (deflated 67%)
  adding: python/pandas/tests/base/common.py (deflated 33%)
  adding: python/pandas/tests/base/__init__.py (stored 0%)
  adding: python/pandas/tests/base/__pycache__/ (stored 0%)
  adding: python/pandas/tests/base/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/base/__pycache__/common.cpython-37.pyc (deflated 25%)
  adding: python/pandas/tests/base/__pycache__/test_constructors.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/base/__pycache__/test_conversion.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/base/__pycache__/test_fillna.cpython-37.pyc (deflated 38%)
  adding: python/pandas/tests/base/__pycache__/test_misc.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/base/__pycache__/test_transpose.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/base/__pycache__/test_unique.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/base/__pycache__/test_value_counts.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/libs/ (stored 0%)
  adding: python/pandas/tests/libs/test_join.py (deflated 87%)
  adding: python/pandas/tests/libs/test_lib.py (deflated 84%)
  adding: python/pandas/tests/libs/test_hashtable.py (deflated 83%)
  adding: python/pandas/tests/libs/__init__.py (stored 0%)
  adding: python/pandas/tests/libs/__pycache__/ (stored 0%)
  adding: python/pandas/tests/libs/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/libs/__pycache__/test_hashtable.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/libs/__pycache__/test_join.cpython-37.pyc (deflated 69%)
  adding: python/pandas/tests/libs/__pycache__/test_lib.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/plotting/ (stored 0%)
  adding: python/pandas/tests/plotting/test_converter.py (deflated 76%)
  adding: python/pandas/tests/plotting/test_series.py (deflated 82%)
  adding: python/pandas/tests/plotting/test_boxplot_method.py (deflated 80%)
  adding: python/pandas/tests/plotting/test_misc.py (deflated 78%)
  adding: python/pandas/tests/plotting/test_datetimelike.py (deflated 83%)
  adding: python/pandas/tests/plotting/common.py (deflated 75%)
  adding: python/pandas/tests/plotting/test_style.py (deflated 82%)
  adding: python/pandas/tests/plotting/__init__.py (stored 0%)
  adding: python/pandas/tests/plotting/test_hist_method.py (deflated 82%)
  adding: python/pandas/tests/plotting/test_backend.py (deflated 70%)
  adding: python/pandas/tests/plotting/test_common.py (deflated 61%)
  adding: python/pandas/tests/plotting/test_groupby.py (deflated 71%)
  adding: python/pandas/tests/plotting/frame/ (stored 0%)
  adding: python/pandas/tests/plotting/frame/test_frame.py (deflated 82%)
  adding: python/pandas/tests/plotting/frame/test_frame_groupby.py (deflated 73%)
  adding: python/pandas/tests/plotting/frame/test_frame_color.py (deflated 81%)
  adding: python/pandas/tests/plotting/frame/test_frame_subplots.py (deflated 81%)
  adding: python/pandas/tests/plotting/frame/__init__.py (stored 0%)
  adding: python/pandas/tests/plotting/frame/__pycache__/ (stored 0%)
  adding: python/pandas/tests/plotting/frame/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/plotting/frame/__pycache__/test_frame.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/plotting/frame/__pycache__/test_frame_color.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/plotting/frame/__pycache__/test_frame_groupby.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/plotting/frame/__pycache__/test_frame_subplots.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/plotting/__pycache__/ (stored 0%)
  adding: python/pandas/tests/plotting/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/plotting/__pycache__/common.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/plotting/__pycache__/test_backend.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/plotting/__pycache__/test_boxplot_method.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/plotting/__pycache__/test_common.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/plotting/__pycache__/test_converter.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/plotting/__pycache__/test_datetimelike.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/plotting/__pycache__/test_groupby.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/plotting/__pycache__/test_hist_method.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/plotting/__pycache__/test_misc.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/plotting/__pycache__/test_series.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/plotting/__pycache__/test_style.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/reductions/ (stored 0%)
  adding: python/pandas/tests/reductions/test_reductions.py (deflated 83%)
  adding: python/pandas/tests/reductions/__init__.py (deflated 16%)
  adding: python/pandas/tests/reductions/test_stat_reductions.py (deflated 75%)
  adding: python/pandas/tests/reductions/__pycache__/ (stored 0%)
  adding: python/pandas/tests/reductions/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/reductions/__pycache__/test_reductions.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/reductions/__pycache__/test_stat_reductions.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/ (stored 0%)
  adding: python/pandas/tests/io/test_orc.py (deflated 80%)
  adding: python/pandas/tests/io/test_html.py (deflated 82%)
  adding: python/pandas/tests/io/test_clipboard.py (deflated 73%)
  adding: python/pandas/tests/io/test_parquet.py (deflated 79%)
  adding: python/pandas/tests/io/test_pickle.py (deflated 75%)
  adding: python/pandas/tests/io/test_feather.py (deflated 71%)
  adding: python/pandas/tests/io/test_gcs.py (deflated 69%)
  adding: python/pandas/tests/io/conftest.py (deflated 65%)
  adding: python/pandas/tests/io/test_spss.py (deflated 77%)
  adding: python/pandas/tests/io/generate_legacy_storage_files.py (deflated 70%)
  adding: python/pandas/tests/io/test_stata.py (deflated 81%)
  adding: python/pandas/tests/io/test_gbq.py (deflated 73%)
  adding: python/pandas/tests/io/__init__.py (deflated 57%)
  adding: python/pandas/tests/io/test_date_converters.py (deflated 70%)
  adding: python/pandas/tests/io/test_fsspec.py (deflated 79%)
  adding: python/pandas/tests/io/test_s3.py (deflated 53%)
  adding: python/pandas/tests/io/test_sql.py (deflated 81%)
  adding: python/pandas/tests/io/test_common.py (deflated 74%)
  adding: python/pandas/tests/io/test_compression.py (deflated 78%)
  adding: python/pandas/tests/io/pytables/ (stored 0%)
  adding: python/pandas/tests/io/pytables/test_compat.py (deflated 68%)
  adding: python/pandas/tests/io/pytables/test_complex.py (deflated 84%)
  adding: python/pandas/tests/io/pytables/test_timezones.py (deflated 81%)
  adding: python/pandas/tests/io/pytables/test_pytables_missing.py (deflated 38%)
  adding: python/pandas/tests/io/pytables/conftest.py (deflated 44%)
  adding: python/pandas/tests/io/pytables/common.py (deflated 63%)
  adding: python/pandas/tests/io/pytables/test_store.py (deflated 84%)
  adding: python/pandas/tests/io/pytables/__init__.py (deflated 48%)
  adding: python/pandas/tests/io/pytables/__pycache__/ (stored 0%)
  adding: python/pandas/tests/io/pytables/__pycache__/__init__.cpython-37.pyc (deflated 28%)
  adding: python/pandas/tests/io/pytables/__pycache__/common.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/io/pytables/__pycache__/conftest.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/io/pytables/__pycache__/test_compat.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/io/pytables/__pycache__/test_complex.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/io/pytables/__pycache__/test_pytables_missing.cpython-37.pyc (deflated 32%)
  adding: python/pandas/tests/io/pytables/__pycache__/test_store.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/io/pytables/__pycache__/test_timezones.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/formats/ (stored 0%)
  adding: python/pandas/tests/io/formats/test_info.py (deflated 77%)
  adding: python/pandas/tests/io/formats/test_to_csv.py (deflated 80%)
  adding: python/pandas/tests/io/formats/test_console.py (deflated 67%)
  adding: python/pandas/tests/io/formats/test_to_latex.py (deflated 86%)
  adding: python/pandas/tests/io/formats/test_format.py (deflated 82%)
  adding: python/pandas/tests/io/formats/test_to_string.py (deflated 73%)
  adding: python/pandas/tests/io/formats/test_eng_formatting.py (deflated 82%)
  adding: python/pandas/tests/io/formats/test_to_excel.py (deflated 82%)
  adding: python/pandas/tests/io/formats/test_to_markdown.py (deflated 72%)
  adding: python/pandas/tests/io/formats/test_style.py (deflated 86%)
  adding: python/pandas/tests/io/formats/test_css.py (deflated 78%)
  adding: python/pandas/tests/io/formats/test_to_html.py (deflated 76%)
  adding: python/pandas/tests/io/formats/__init__.py (stored 0%)
  adding: python/pandas/tests/io/formats/test_printing.py (deflated 76%)
  adding: python/pandas/tests/io/formats/__pycache__/ (stored 0%)
  adding: python/pandas/tests/io/formats/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/io/formats/__pycache__/test_console.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/io/formats/__pycache__/test_css.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/io/formats/__pycache__/test_eng_formatting.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/formats/__pycache__/test_format.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/io/formats/__pycache__/test_info.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/io/formats/__pycache__/test_printing.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/formats/__pycache__/test_style.cpython-37.pyc (deflated 70%)
  adding: python/pandas/tests/io/formats/__pycache__/test_to_csv.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/io/formats/__pycache__/test_to_excel.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/io/formats/__pycache__/test_to_html.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/io/formats/__pycache__/test_to_latex.cpython-37.pyc (deflated 78%)
  adding: python/pandas/tests/io/formats/__pycache__/test_to_markdown.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/io/formats/__pycache__/test_to_string.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/io/excel/ (stored 0%)
  adding: python/pandas/tests/io/excel/test_xlwt.py (deflated 68%)
  adding: python/pandas/tests/io/excel/test_xlsxwriter.py (deflated 63%)
  adding: python/pandas/tests/io/excel/test_odf.py (deflated 52%)
  adding: python/pandas/tests/io/excel/test_xlrd.py (deflated 71%)
  adding: python/pandas/tests/io/excel/test_openpyxl.py (deflated 72%)
  adding: python/pandas/tests/io/excel/conftest.py (deflated 57%)
  adding: python/pandas/tests/io/excel/test_odswriter.py (deflated 40%)
  adding: python/pandas/tests/io/excel/test_writers.py (deflated 80%)
  adding: python/pandas/tests/io/excel/test_style.py (deflated 74%)
  adding: python/pandas/tests/io/excel/__init__.py (deflated 58%)
  adding: python/pandas/tests/io/excel/test_readers.py (deflated 82%)
  adding: python/pandas/tests/io/excel/__pycache__/ (stored 0%)
  adding: python/pandas/tests/io/excel/__pycache__/__init__.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/io/excel/__pycache__/conftest.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/io/excel/__pycache__/test_odf.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/io/excel/__pycache__/test_odswriter.cpython-37.pyc (deflated 29%)
  adding: python/pandas/tests/io/excel/__pycache__/test_openpyxl.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/io/excel/__pycache__/test_readers.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/io/excel/__pycache__/test_style.cpython-37.pyc (deflated 44%)
  adding: python/pandas/tests/io/excel/__pycache__/test_writers.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/io/excel/__pycache__/test_xlrd.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/io/excel/__pycache__/test_xlsxwriter.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/io/excel/__pycache__/test_xlwt.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/io/parser/ (stored 0%)
  adding: python/pandas/tests/io/parser/test_c_parser_only.py (deflated 71%)
  adding: python/pandas/tests/io/parser/test_multi_thread.py (deflated 66%)
  adding: python/pandas/tests/io/parser/test_dtypes.py (deflated 82%)
  adding: python/pandas/tests/io/parser/test_read_fwf.py (deflated 76%)
  adding: python/pandas/tests/io/parser/test_na_values.py (deflated 77%)
  adding: python/pandas/tests/io/parser/conftest.py (deflated 72%)
  adding: python/pandas/tests/io/parser/test_dialect.py (deflated 71%)
  adding: python/pandas/tests/io/parser/test_encoding.py (deflated 69%)
  adding: python/pandas/tests/io/parser/test_skiprows.py (deflated 75%)
  adding: python/pandas/tests/io/parser/test_comment.py (deflated 73%)
  adding: python/pandas/tests/io/parser/test_index_col.py (deflated 73%)
  adding: python/pandas/tests/io/parser/test_quoting.py (deflated 73%)
  adding: python/pandas/tests/io/parser/test_parse_dates.py (deflated 84%)
  adding: python/pandas/tests/io/parser/__init__.py (stored 0%)
  adding: python/pandas/tests/io/parser/test_usecols.py (deflated 80%)
  adding: python/pandas/tests/io/parser/test_python_parser_only.py (deflated 72%)
  adding: python/pandas/tests/io/parser/test_textreader.py (deflated 77%)
  adding: python/pandas/tests/io/parser/test_unsupported.py (deflated 71%)
  adding: python/pandas/tests/io/parser/test_header.py (deflated 81%)
  adding: python/pandas/tests/io/parser/test_mangle_dupes.py (deflated 72%)
  adding: python/pandas/tests/io/parser/test_common.py (deflated 79%)
  adding: python/pandas/tests/io/parser/test_network.py (deflated 76%)
  adding: python/pandas/tests/io/parser/test_compression.py (deflated 72%)
  adding: python/pandas/tests/io/parser/test_converters.py (deflated 65%)
  adding: python/pandas/tests/io/parser/__pycache__/ (stored 0%)
  adding: python/pandas/tests/io/parser/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/io/parser/__pycache__/conftest.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/parser/__pycache__/test_c_parser_only.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/parser/__pycache__/test_comment.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/parser/__pycache__/test_common.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/io/parser/__pycache__/test_compression.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/io/parser/__pycache__/test_converters.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/io/parser/__pycache__/test_dialect.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/io/parser/__pycache__/test_dtypes.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/io/parser/__pycache__/test_encoding.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/io/parser/__pycache__/test_header.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/io/parser/__pycache__/test_index_col.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/io/parser/__pycache__/test_mangle_dupes.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/io/parser/__pycache__/test_multi_thread.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/io/parser/__pycache__/test_na_values.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/parser/__pycache__/test_network.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/io/parser/__pycache__/test_parse_dates.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/io/parser/__pycache__/test_python_parser_only.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/io/parser/__pycache__/test_quoting.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/io/parser/__pycache__/test_read_fwf.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/io/parser/__pycache__/test_skiprows.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/io/parser/__pycache__/test_textreader.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/io/parser/__pycache__/test_unsupported.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/io/parser/__pycache__/test_usecols.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/io/sas/ (stored 0%)
  adding: python/pandas/tests/io/sas/test_sas.py (deflated 53%)
  adding: python/pandas/tests/io/sas/test_sas7bdat.py (deflated 75%)
  adding: python/pandas/tests/io/sas/test_xport.py (deflated 76%)
  adding: python/pandas/tests/io/sas/__init__.py (stored 0%)
  adding: python/pandas/tests/io/sas/__pycache__/ (stored 0%)
  adding: python/pandas/tests/io/sas/__pycache__/__init__.cpython-37.pyc (deflated 21%)
  adding: python/pandas/tests/io/sas/__pycache__/test_sas.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/io/sas/__pycache__/test_sas7bdat.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/io/sas/__pycache__/test_xport.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/io/json/ (stored 0%)
  adding: python/pandas/tests/io/json/test_readlines.py (deflated 74%)
  adding: python/pandas/tests/io/json/test_json_table_schema.py (deflated 83%)
  adding: python/pandas/tests/io/json/test_ujson.py (deflated 79%)
  adding: python/pandas/tests/io/json/test_pandas.py (deflated 79%)
  adding: python/pandas/tests/io/json/conftest.py (deflated 30%)
  adding: python/pandas/tests/io/json/test_normalize.py (deflated 82%)
  adding: python/pandas/tests/io/json/test_deprecated_kwargs.py (deflated 70%)
  adding: python/pandas/tests/io/json/__init__.py (stored 0%)
  adding: python/pandas/tests/io/json/test_compression.py (deflated 72%)
  adding: python/pandas/tests/io/json/__pycache__/ (stored 0%)
  adding: python/pandas/tests/io/json/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/io/json/__pycache__/conftest.cpython-37.pyc (deflated 26%)
  adding: python/pandas/tests/io/json/__pycache__/test_compression.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/io/json/__pycache__/test_deprecated_kwargs.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/io/json/__pycache__/test_json_table_schema.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/io/json/__pycache__/test_normalize.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/io/json/__pycache__/test_pandas.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/io/json/__pycache__/test_readlines.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/io/json/__pycache__/test_ujson.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/io/__pycache__/ (stored 0%)
  adding: python/pandas/tests/io/__pycache__/__init__.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/io/__pycache__/conftest.cpython-37.pyc (deflated 44%)
  adding: python/pandas/tests/io/__pycache__/generate_legacy_storage_files.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/io/__pycache__/test_clipboard.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/io/__pycache__/test_common.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/io/__pycache__/test_compression.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/io/__pycache__/test_date_converters.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/io/__pycache__/test_feather.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/io/__pycache__/test_fsspec.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/io/__pycache__/test_gbq.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/io/__pycache__/test_gcs.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/io/__pycache__/test_html.cpython-37.pyc (deflated 69%)
  adding: python/pandas/tests/io/__pycache__/test_orc.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/io/__pycache__/test_parquet.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/io/__pycache__/test_pickle.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/io/__pycache__/test_s3.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/io/__pycache__/test_spss.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/io/__pycache__/test_sql.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/io/__pycache__/test_stata.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/config/ (stored 0%)
  adding: python/pandas/tests/config/test_config.py (deflated 82%)
  adding: python/pandas/tests/config/test_localization.py (deflated 63%)
  adding: python/pandas/tests/config/__init__.py (stored 0%)
  adding: python/pandas/tests/config/__pycache__/ (stored 0%)
  adding: python/pandas/tests/config/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/config/__pycache__/test_config.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/config/__pycache__/test_localization.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/reshape/ (stored 0%)
  adding: python/pandas/tests/reshape/test_pivot_multilevel.py (deflated 84%)
  adding: python/pandas/tests/reshape/test_util.py (deflated 68%)
  adding: python/pandas/tests/reshape/test_pivot.py (deflated 83%)
  adding: python/pandas/tests/reshape/test_get_dummies.py (deflated 83%)
  adding: python/pandas/tests/reshape/test_melt.py (deflated 84%)
  adding: python/pandas/tests/reshape/test_crosstab.py (deflated 84%)
  adding: python/pandas/tests/reshape/test_qcut.py (deflated 71%)
  adding: python/pandas/tests/reshape/test_union_categoricals.py (deflated 89%)
  adding: python/pandas/tests/reshape/__init__.py (stored 0%)
  adding: python/pandas/tests/reshape/test_cut.py (deflated 78%)
  adding: python/pandas/tests/reshape/merge/ (stored 0%)
  adding: python/pandas/tests/reshape/merge/test_merge_asof.py (deflated 88%)
  adding: python/pandas/tests/reshape/merge/test_merge_cross.py (deflated 73%)
  adding: python/pandas/tests/reshape/merge/test_join.py (deflated 79%)
  adding: python/pandas/tests/reshape/merge/test_merge_index_as_string.py (deflated 74%)
  adding: python/pandas/tests/reshape/merge/test_merge.py (deflated 82%)
  adding: python/pandas/tests/reshape/merge/__init__.py (stored 0%)
  adding: python/pandas/tests/reshape/merge/test_multi.py (deflated 82%)
  adding: python/pandas/tests/reshape/merge/test_merge_ordered.py (deflated 80%)
  adding: python/pandas/tests/reshape/merge/__pycache__/ (stored 0%)
  adding: python/pandas/tests/reshape/merge/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/reshape/merge/__pycache__/test_join.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/reshape/merge/__pycache__/test_merge.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/reshape/merge/__pycache__/test_merge_asof.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/reshape/merge/__pycache__/test_merge_cross.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/reshape/merge/__pycache__/test_merge_index_as_string.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/reshape/merge/__pycache__/test_merge_ordered.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/reshape/merge/__pycache__/test_multi.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/reshape/concat/ (stored 0%)
  adding: python/pandas/tests/reshape/concat/test_series.py (deflated 73%)
  adding: python/pandas/tests/reshape/concat/conftest.py (deflated 20%)
  adding: python/pandas/tests/reshape/concat/test_invalid.py (deflated 59%)
  adding: python/pandas/tests/reshape/concat/test_sort.py (deflated 75%)
  adding: python/pandas/tests/reshape/concat/test_concat.py (deflated 79%)
  adding: python/pandas/tests/reshape/concat/test_append.py (deflated 77%)
  adding: python/pandas/tests/reshape/concat/test_index.py (deflated 77%)
  adding: python/pandas/tests/reshape/concat/test_categorical.py (deflated 77%)
  adding: python/pandas/tests/reshape/concat/test_datetimes.py (deflated 83%)
  adding: python/pandas/tests/reshape/concat/__init__.py (stored 0%)
  adding: python/pandas/tests/reshape/concat/test_append_common.py (deflated 87%)
  adding: python/pandas/tests/reshape/concat/test_empty.py (deflated 77%)
  adding: python/pandas/tests/reshape/concat/test_dataframe.py (deflated 78%)
  adding: python/pandas/tests/reshape/concat/__pycache__/ (stored 0%)
  adding: python/pandas/tests/reshape/concat/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/reshape/concat/__pycache__/conftest.cpython-37.pyc (deflated 25%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_append.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_append_common.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_categorical.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_concat.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_dataframe.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_datetimes.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_empty.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_index.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_invalid.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_series.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/reshape/concat/__pycache__/test_sort.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/reshape/__pycache__/ (stored 0%)
  adding: python/pandas/tests/reshape/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/reshape/__pycache__/test_crosstab.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/reshape/__pycache__/test_cut.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/reshape/__pycache__/test_get_dummies.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/reshape/__pycache__/test_melt.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/reshape/__pycache__/test_pivot.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/reshape/__pycache__/test_pivot_multilevel.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/reshape/__pycache__/test_qcut.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/reshape/__pycache__/test_union_categoricals.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/reshape/__pycache__/test_util.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/tseries/ (stored 0%)
  adding: python/pandas/tests/tseries/__init__.py (stored 0%)
  adding: python/pandas/tests/tseries/offsets/ (stored 0%)
  adding: python/pandas/tests/tseries/offsets/test_offsets.py (deflated 87%)
  adding: python/pandas/tests/tseries/offsets/test_ticks.py (deflated 77%)
  adding: python/pandas/tests/tseries/offsets/conftest.py (deflated 60%)
  adding: python/pandas/tests/tseries/offsets/common.py (deflated 64%)
  adding: python/pandas/tests/tseries/offsets/test_offsets_properties.py (deflated 60%)
  adding: python/pandas/tests/tseries/offsets/__init__.py (stored 0%)
  adding: python/pandas/tests/tseries/offsets/test_fiscal.py (deflated 86%)
  adding: python/pandas/tests/tseries/offsets/test_yqm_offsets.py (deflated 92%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/ (stored 0%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/common.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/conftest.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/test_fiscal.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/test_offsets.cpython-37.pyc (deflated 70%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/test_offsets_properties.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/test_ticks.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/tseries/offsets/__pycache__/test_yqm_offsets.cpython-37.pyc (deflated 77%)
  adding: python/pandas/tests/tseries/frequencies/ (stored 0%)
  adding: python/pandas/tests/tseries/frequencies/test_freq_code.py (deflated 63%)
  adding: python/pandas/tests/tseries/frequencies/test_inference.py (deflated 76%)
  adding: python/pandas/tests/tseries/frequencies/test_frequencies.py (deflated 64%)
  adding: python/pandas/tests/tseries/frequencies/__init__.py (stored 0%)
  adding: python/pandas/tests/tseries/frequencies/__pycache__/ (stored 0%)
  adding: python/pandas/tests/tseries/frequencies/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/tseries/frequencies/__pycache__/test_freq_code.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/tseries/frequencies/__pycache__/test_frequencies.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/tseries/frequencies/__pycache__/test_inference.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/tseries/holiday/ (stored 0%)
  adding: python/pandas/tests/tseries/holiday/test_observance.py (deflated 79%)
  adding: python/pandas/tests/tseries/holiday/test_holiday.py (deflated 77%)
  adding: python/pandas/tests/tseries/holiday/__init__.py (stored 0%)
  adding: python/pandas/tests/tseries/holiday/test_federal.py (deflated 63%)
  adding: python/pandas/tests/tseries/holiday/test_calendar.py (deflated 67%)
  adding: python/pandas/tests/tseries/holiday/__pycache__/ (stored 0%)
  adding: python/pandas/tests/tseries/holiday/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/tseries/holiday/__pycache__/test_calendar.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/tseries/holiday/__pycache__/test_federal.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/tseries/holiday/__pycache__/test_holiday.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/tseries/holiday/__pycache__/test_observance.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/tseries/__pycache__/ (stored 0%)
  adding: python/pandas/tests/tseries/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/arrays/ (stored 0%)
  adding: python/pandas/tests/arrays/test_numpy.py (deflated 75%)
  adding: python/pandas/tests/arrays/test_timedeltas.py (deflated 80%)
  adding: python/pandas/tests/arrays/test_array.py (deflated 80%)
  adding: python/pandas/tests/arrays/test_datetimelike.py (deflated 82%)
  adding: python/pandas/tests/arrays/test_datetimes.py (deflated 80%)
  adding: python/pandas/tests/arrays/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/test_period.py (deflated 78%)
  adding: python/pandas/tests/arrays/sparse/ (stored 0%)
  adding: python/pandas/tests/arrays/sparse/test_array.py (deflated 83%)
  adding: python/pandas/tests/arrays/sparse/test_arithmetics.py (deflated 87%)
  adding: python/pandas/tests/arrays/sparse/test_combine_concat.py (deflated 71%)
  adding: python/pandas/tests/arrays/sparse/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/sparse/test_accessor.py (deflated 73%)
  adding: python/pandas/tests/arrays/sparse/test_libsparse.py (deflated 85%)
  adding: python/pandas/tests/arrays/sparse/test_dtype.py (deflated 78%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/test_accessor.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/test_arithmetics.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/test_array.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/test_combine_concat.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/test_dtype.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/arrays/sparse/__pycache__/test_libsparse.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/arrays/floating/ (stored 0%)
  adding: python/pandas/tests/arrays/floating/test_construction.py (deflated 76%)
  adding: python/pandas/tests/arrays/floating/test_function.py (deflated 76%)
  adding: python/pandas/tests/arrays/floating/test_astype.py (deflated 79%)
  adding: python/pandas/tests/arrays/floating/conftest.py (deflated 60%)
  adding: python/pandas/tests/arrays/floating/test_comparison.py (deflated 76%)
  adding: python/pandas/tests/arrays/floating/test_concat.py (deflated 57%)
  adding: python/pandas/tests/arrays/floating/test_to_numpy.py (deflated 82%)
  adding: python/pandas/tests/arrays/floating/test_repr.py (deflated 61%)
  adding: python/pandas/tests/arrays/floating/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/floating/test_arithmetic.py (deflated 74%)
  adding: python/pandas/tests/arrays/floating/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/floating/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/arrays/floating/__pycache__/conftest.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_arithmetic.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_astype.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_comparison.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_concat.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_construction.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_function.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_repr.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/arrays/floating/__pycache__/test_to_numpy.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/arrays/boolean/ (stored 0%)
  adding: python/pandas/tests/arrays/boolean/test_construction.py (deflated 84%)
  adding: python/pandas/tests/arrays/boolean/test_function.py (deflated 78%)
  adding: python/pandas/tests/arrays/boolean/test_indexing.py (deflated 41%)
  adding: python/pandas/tests/arrays/boolean/test_logical.py (deflated 85%)
  adding: python/pandas/tests/arrays/boolean/test_astype.py (deflated 74%)
  adding: python/pandas/tests/arrays/boolean/test_comparison.py (deflated 77%)
  adding: python/pandas/tests/arrays/boolean/test_repr.py (deflated 50%)
  adding: python/pandas/tests/arrays/boolean/test_ops.py (deflated 61%)
  adding: python/pandas/tests/arrays/boolean/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/boolean/test_arithmetic.py (deflated 69%)
  adding: python/pandas/tests/arrays/boolean/test_reduction.py (deflated 68%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_arithmetic.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_astype.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_comparison.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_construction.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_function.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_indexing.cpython-37.pyc (deflated 30%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_logical.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_ops.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_reduction.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/arrays/boolean/__pycache__/test_repr.cpython-37.pyc (deflated 32%)
  adding: python/pandas/tests/arrays/masked/ (stored 0%)
  adding: python/pandas/tests/arrays/masked/test_arrow_compat.py (deflated 63%)
  adding: python/pandas/tests/arrays/masked/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/masked/test_arithmetic.py (deflated 74%)
  adding: python/pandas/tests/arrays/masked/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/masked/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/arrays/masked/__pycache__/test_arithmetic.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/arrays/masked/__pycache__/test_arrow_compat.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/arrays/string_/ (stored 0%)
  adding: python/pandas/tests/arrays/string_/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/string_/test_string.py (deflated 80%)
  adding: python/pandas/tests/arrays/string_/test_string_arrow.py (deflated 51%)
  adding: python/pandas/tests/arrays/string_/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/string_/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/arrays/string_/__pycache__/test_string.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/arrays/string_/__pycache__/test_string_arrow.cpython-37.pyc (deflated 34%)
  adding: python/pandas/tests/arrays/categorical/ (stored 0%)
  adding: python/pandas/tests/arrays/categorical/test_subclass.py (deflated 70%)
  adding: python/pandas/tests/arrays/categorical/test_missing.py (deflated 76%)
  adding: python/pandas/tests/arrays/categorical/test_constructors.py (deflated 83%)
  adding: python/pandas/tests/arrays/categorical/test_indexing.py (deflated 78%)
  adding: python/pandas/tests/arrays/categorical/test_take.py (deflated 78%)
  adding: python/pandas/tests/arrays/categorical/test_dtypes.py (deflated 81%)
  adding: python/pandas/tests/arrays/categorical/test_warnings.py (deflated 45%)
  adding: python/pandas/tests/arrays/categorical/conftest.py (deflated 22%)
  adding: python/pandas/tests/arrays/categorical/common.py (deflated 40%)
  adding: python/pandas/tests/arrays/categorical/test_algos.py (deflated 76%)
  adding: python/pandas/tests/arrays/categorical/test_operators.py (deflated 81%)
  adding: python/pandas/tests/arrays/categorical/test_api.py (deflated 83%)
  adding: python/pandas/tests/arrays/categorical/test_repr.py (deflated 91%)
  adding: python/pandas/tests/arrays/categorical/test_replace.py (deflated 66%)
  adding: python/pandas/tests/arrays/categorical/test_analytics.py (deflated 80%)
  adding: python/pandas/tests/arrays/categorical/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/categorical/test_sorting.py (deflated 84%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/common.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/conftest.cpython-37.pyc (deflated 26%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_algos.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_analytics.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_api.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_constructors.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_dtypes.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_indexing.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_missing.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_operators.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_replace.cpython-37.pyc (deflated 44%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_repr.cpython-37.pyc (deflated 82%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_sorting.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_subclass.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_take.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/arrays/categorical/__pycache__/test_warnings.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/arrays/integer/ (stored 0%)
  adding: python/pandas/tests/arrays/integer/test_construction.py (deflated 75%)
  adding: python/pandas/tests/arrays/integer/test_function.py (deflated 75%)
  adding: python/pandas/tests/arrays/integer/test_indexing.py (deflated 53%)
  adding: python/pandas/tests/arrays/integer/test_dtypes.py (deflated 78%)
  adding: python/pandas/tests/arrays/integer/conftest.py (deflated 66%)
  adding: python/pandas/tests/arrays/integer/test_comparison.py (deflated 74%)
  adding: python/pandas/tests/arrays/integer/test_concat.py (deflated 77%)
  adding: python/pandas/tests/arrays/integer/test_repr.py (deflated 68%)
  adding: python/pandas/tests/arrays/integer/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/integer/test_arithmetic.py (deflated 77%)
  adding: python/pandas/tests/arrays/integer/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/integer/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/arrays/integer/__pycache__/conftest.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_arithmetic.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_comparison.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_concat.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_construction.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_dtypes.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_function.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_indexing.cpython-37.pyc (deflated 38%)
  adding: python/pandas/tests/arrays/integer/__pycache__/test_repr.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/arrays/interval/ (stored 0%)
  adding: python/pandas/tests/arrays/interval/test_astype.py (deflated 56%)
  adding: python/pandas/tests/arrays/interval/test_interval.py (deflated 73%)
  adding: python/pandas/tests/arrays/interval/test_ops.py (deflated 70%)
  adding: python/pandas/tests/arrays/interval/__init__.py (stored 0%)
  adding: python/pandas/tests/arrays/interval/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/interval/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/arrays/interval/__pycache__/test_astype.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/arrays/interval/__pycache__/test_interval.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/arrays/interval/__pycache__/test_ops.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/arrays/__pycache__/ (stored 0%)
  adding: python/pandas/tests/arrays/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/arrays/__pycache__/test_array.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/arrays/__pycache__/test_datetimelike.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/arrays/__pycache__/test_datetimes.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/arrays/__pycache__/test_numpy.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/arrays/__pycache__/test_period.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/arrays/__pycache__/test_timedeltas.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/generic/ (stored 0%)
  adding: python/pandas/tests/generic/test_series.py (deflated 71%)
  adding: python/pandas/tests/generic/test_frame.py (deflated 73%)
  adding: python/pandas/tests/generic/test_duplicate_labels.py (deflated 84%)
  adding: python/pandas/tests/generic/test_to_xarray.py (deflated 77%)
  adding: python/pandas/tests/generic/__init__.py (stored 0%)
  adding: python/pandas/tests/generic/test_label_or_level_utils.py (deflated 83%)
  adding: python/pandas/tests/generic/test_finalize.py (deflated 85%)
  adding: python/pandas/tests/generic/test_generic.py (deflated 77%)
  adding: python/pandas/tests/generic/methods/ (stored 0%)
  adding: python/pandas/tests/generic/methods/test_reorder_levels.py (deflated 76%)
  adding: python/pandas/tests/generic/methods/test_sample.py (deflated 76%)
  adding: python/pandas/tests/generic/methods/test_first_valid_index.py (deflated 74%)
  adding: python/pandas/tests/generic/methods/test_dot.py (deflated 76%)
  adding: python/pandas/tests/generic/methods/test_pipe.py (deflated 69%)
  adding: python/pandas/tests/generic/methods/__init__.py (stored 0%)
  adding: python/pandas/tests/generic/methods/test_set_axis.py (deflated 68%)
  adding: python/pandas/tests/generic/methods/__pycache__/ (stored 0%)
  adding: python/pandas/tests/generic/methods/__pycache__/__init__.cpython-37.pyc (deflated 13%)
  adding: python/pandas/tests/generic/methods/__pycache__/test_dot.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/generic/methods/__pycache__/test_first_valid_index.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/generic/methods/__pycache__/test_pipe.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/generic/methods/__pycache__/test_reorder_levels.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/generic/methods/__pycache__/test_sample.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/generic/methods/__pycache__/test_set_axis.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/generic/__pycache__/ (stored 0%)
  adding: python/pandas/tests/generic/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/generic/__pycache__/test_duplicate_labels.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/generic/__pycache__/test_finalize.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/generic/__pycache__/test_frame.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/generic/__pycache__/test_generic.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/generic/__pycache__/test_label_or_level_utils.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/generic/__pycache__/test_series.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/generic/__pycache__/test_to_xarray.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/resample/ (stored 0%)
  adding: python/pandas/tests/resample/test_datetime_index.py (deflated 79%)
  adding: python/pandas/tests/resample/test_deprecated.py (deflated 76%)
  adding: python/pandas/tests/resample/test_resample_api.py (deflated 77%)
  adding: python/pandas/tests/resample/test_time_grouper.py (deflated 77%)
  adding: python/pandas/tests/resample/conftest.py (deflated 79%)
  adding: python/pandas/tests/resample/test_period_index.py (deflated 79%)
  adding: python/pandas/tests/resample/test_base.py (deflated 71%)
  adding: python/pandas/tests/resample/__init__.py (stored 0%)
  adding: python/pandas/tests/resample/test_timedelta.py (deflated 72%)
  adding: python/pandas/tests/resample/test_resampler_grouper.py (deflated 74%)
  adding: python/pandas/tests/resample/__pycache__/ (stored 0%)
  adding: python/pandas/tests/resample/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/resample/__pycache__/conftest.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/resample/__pycache__/test_base.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/resample/__pycache__/test_datetime_index.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/resample/__pycache__/test_deprecated.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/resample/__pycache__/test_period_index.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/resample/__pycache__/test_resample_api.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/resample/__pycache__/test_resampler_grouper.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/resample/__pycache__/test_time_grouper.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/resample/__pycache__/test_timedelta.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/frame/ (stored 0%)
  adding: python/pandas/tests/frame/test_subclass.py (deflated 84%)
  adding: python/pandas/tests/frame/test_nonunique_indexes.py (deflated 80%)
  adding: python/pandas/tests/frame/test_constructors.py (deflated 81%)
  adding: python/pandas/tests/frame/test_logical_ops.py (deflated 79%)
  adding: python/pandas/tests/frame/test_stack_unstack.py (deflated 81%)
  adding: python/pandas/tests/frame/conftest.py (deflated 64%)
  adding: python/pandas/tests/frame/common.py (deflated 69%)
  adding: python/pandas/tests/frame/test_alter_axes.py (deflated 74%)
  adding: python/pandas/tests/frame/test_reductions.py (deflated 81%)
  adding: python/pandas/tests/frame/test_validate.py (deflated 57%)
  adding: python/pandas/tests/frame/test_query_eval.py (deflated 84%)
  adding: python/pandas/tests/frame/test_repr_info.py (deflated 71%)
  adding: python/pandas/tests/frame/test_api.py (deflated 74%)
  adding: python/pandas/tests/frame/test_block_internals.py (deflated 74%)
  adding: python/pandas/tests/frame/test_npfuncs.py (deflated 53%)
  adding: python/pandas/tests/frame/test_cumulative.py (deflated 80%)
  adding: python/pandas/tests/frame/__init__.py (stored 0%)
  adding: python/pandas/tests/frame/test_arithmetic.py (deflated 78%)
  adding: python/pandas/tests/frame/test_ufunc.py (deflated 78%)
  adding: python/pandas/tests/frame/test_unary.py (deflated 76%)
  adding: python/pandas/tests/frame/test_iteration.py (deflated 70%)
  adding: python/pandas/tests/frame/indexing/ (stored 0%)
  adding: python/pandas/tests/frame/indexing/test_where.py (deflated 80%)
  adding: python/pandas/tests/frame/indexing/test_indexing.py (deflated 79%)
  adding: python/pandas/tests/frame/indexing/test_take.py (deflated 83%)
  adding: python/pandas/tests/frame/indexing/test_lookup.py (deflated 74%)
  adding: python/pandas/tests/frame/indexing/test_set_value.py (deflated 72%)
  adding: python/pandas/tests/frame/indexing/test_get_value.py (deflated 52%)
  adding: python/pandas/tests/frame/indexing/test_xs.py (deflated 75%)
  adding: python/pandas/tests/frame/indexing/test_getitem.py (deflated 73%)
  adding: python/pandas/tests/frame/indexing/test_mask.py (deflated 73%)
  adding: python/pandas/tests/frame/indexing/test_get.py (deflated 59%)
  adding: python/pandas/tests/frame/indexing/test_delitem.py (deflated 65%)
  adding: python/pandas/tests/frame/indexing/test_categorical.py (deflated 85%)
  adding: python/pandas/tests/frame/indexing/__init__.py (stored 0%)
  adding: python/pandas/tests/frame/indexing/test_insert.py (deflated 67%)
  adding: python/pandas/tests/frame/indexing/test_setitem.py (deflated 73%)
  adding: python/pandas/tests/frame/indexing/__pycache__/ (stored 0%)
  adding: python/pandas/tests/frame/indexing/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_categorical.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_delitem.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_get.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_get_value.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_getitem.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_indexing.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_insert.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_lookup.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_mask.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_set_value.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_setitem.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_take.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_where.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/indexing/__pycache__/test_xs.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/apply/ (stored 0%)
  adding: python/pandas/tests/frame/apply/test_apply_relabeling.py (deflated 78%)
  adding: python/pandas/tests/frame/apply/test_frame_transform.py (deflated 74%)
  adding: python/pandas/tests/frame/apply/__init__.py (stored 0%)
  adding: python/pandas/tests/frame/apply/test_frame_apply.py (deflated 81%)
  adding: python/pandas/tests/frame/apply/__pycache__/ (stored 0%)
  adding: python/pandas/tests/frame/apply/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/frame/apply/__pycache__/test_apply_relabeling.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/frame/apply/__pycache__/test_frame_apply.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/frame/apply/__pycache__/test_frame_transform.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/frame/methods/ (stored 0%)
  adding: python/pandas/tests/frame/methods/test_to_csv.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_convert_dtypes.py (deflated 60%)
  adding: python/pandas/tests/frame/methods/test_explode.py (deflated 79%)
  adding: python/pandas/tests/frame/methods/test_reindex_like.py (deflated 62%)
  adding: python/pandas/tests/frame/methods/test_combine.py (deflated 64%)
  adding: python/pandas/tests/frame/methods/test_filter.py (deflated 77%)
  adding: python/pandas/tests/frame/methods/test_fillna.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_first_and_last.py (deflated 76%)
  adding: python/pandas/tests/frame/methods/test_swapaxes.py (deflated 61%)
  adding: python/pandas/tests/frame/methods/test_quantile.py (deflated 84%)
  adding: python/pandas/tests/frame/methods/test_sort_index.py (deflated 82%)
  adding: python/pandas/tests/frame/methods/test_drop_duplicates.py (deflated 85%)
  adding: python/pandas/tests/frame/methods/test_to_period.py (deflated 71%)
  adding: python/pandas/tests/frame/methods/test_cov_corr.py (deflated 77%)
  adding: python/pandas/tests/frame/methods/test_nlargest.py (deflated 75%)
  adding: python/pandas/tests/frame/methods/test_dtypes.py (deflated 75%)
  adding: python/pandas/tests/frame/methods/test_rename_axis.py (deflated 73%)
  adding: python/pandas/tests/frame/methods/test_astype.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_interpolate.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_select_dtypes.py (deflated 87%)
  adding: python/pandas/tests/frame/methods/test_is_homogeneous_dtype.py (deflated 71%)
  adding: python/pandas/tests/frame/methods/test_describe.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_at_time.py (deflated 71%)
  adding: python/pandas/tests/frame/methods/test_head_tail.py (deflated 73%)
  adding: python/pandas/tests/frame/methods/test_value_counts.py (deflated 83%)
  adding: python/pandas/tests/frame/methods/test_compare.py (deflated 81%)
  adding: python/pandas/tests/frame/methods/test_tz_localize.py (deflated 63%)
  adding: python/pandas/tests/frame/methods/test_between_time.py (deflated 78%)
  adding: python/pandas/tests/frame/methods/test_set_index.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_align.py (deflated 79%)
  adding: python/pandas/tests/frame/methods/test_transpose.py (deflated 70%)
  adding: python/pandas/tests/frame/methods/test_values.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_join.py (deflated 75%)
  adding: python/pandas/tests/frame/methods/test_rename.py (deflated 81%)
  adding: python/pandas/tests/frame/methods/test_duplicated.py (deflated 66%)
  adding: python/pandas/tests/frame/methods/test_update.py (deflated 77%)
  adding: python/pandas/tests/frame/methods/test_tz_convert.py (deflated 75%)
  adding: python/pandas/tests/frame/methods/test_dropna.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_to_numpy.py (deflated 66%)
  adding: python/pandas/tests/frame/methods/test_get_numeric_data.py (deflated 73%)
  adding: python/pandas/tests/frame/methods/test_append.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_isin.py (deflated 78%)
  adding: python/pandas/tests/frame/methods/test_to_timestamp.py (deflated 81%)
  adding: python/pandas/tests/frame/methods/test_diff.py (deflated 78%)
  adding: python/pandas/tests/frame/methods/test_replace.py (deflated 86%)
  adding: python/pandas/tests/frame/methods/test_copy.py (deflated 59%)
  adding: python/pandas/tests/frame/methods/test_pct_change.py (deflated 75%)
  adding: python/pandas/tests/frame/methods/test_to_records.py (deflated 79%)
  adding: python/pandas/tests/frame/methods/test_infer_objects.py (deflated 68%)
  adding: python/pandas/tests/frame/methods/test_clip.py (deflated 75%)
  adding: python/pandas/tests/frame/methods/test_asof.py (deflated 73%)
  adding: python/pandas/tests/frame/methods/test_drop.py (deflated 78%)
  adding: python/pandas/tests/frame/methods/test_matmul.py (deflated 74%)
  adding: python/pandas/tests/frame/methods/test_pop.py (deflated 66%)
  adding: python/pandas/tests/frame/methods/test_truncate.py (deflated 73%)
  adding: python/pandas/tests/frame/methods/test_combine_first.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_equals.py (deflated 70%)
  adding: python/pandas/tests/frame/methods/__init__.py (deflated 29%)
  adding: python/pandas/tests/frame/methods/test_shift.py (deflated 79%)
  adding: python/pandas/tests/frame/methods/test_convert.py (deflated 69%)
  adding: python/pandas/tests/frame/methods/test_swaplevel.py (deflated 69%)
  adding: python/pandas/tests/frame/methods/test_to_dict.py (deflated 75%)
  adding: python/pandas/tests/frame/methods/test_reset_index.py (deflated 80%)
  adding: python/pandas/tests/frame/methods/test_round.py (deflated 78%)
  adding: python/pandas/tests/frame/methods/test_to_dict_of_blocks.py (deflated 64%)
  adding: python/pandas/tests/frame/methods/test_asfreq.py (deflated 66%)
  adding: python/pandas/tests/frame/methods/test_rank.py (deflated 79%)
  adding: python/pandas/tests/frame/methods/test_add_prefix_suffix.py (deflated 71%)
  adding: python/pandas/tests/frame/methods/test_reindex.py (deflated 81%)
  adding: python/pandas/tests/frame/methods/test_count.py (deflated 74%)
  adding: python/pandas/tests/frame/methods/test_droplevel.py (deflated 60%)
  adding: python/pandas/tests/frame/methods/test_sort_values.py (deflated 84%)
  adding: python/pandas/tests/frame/methods/test_assign.py (deflated 74%)
  adding: python/pandas/tests/frame/methods/__pycache__/ (stored 0%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_reindex.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/methods/__pycache__/__init__.cpython-37.pyc (deflated 25%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_interpolate.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_add_prefix_suffix.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_reindex_like.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_align.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_rename.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_append.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_rename_axis.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_asfreq.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_replace.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_asof.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_reset_index.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_assign.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_round.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_astype.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_to_csv.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_at_time.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_is_homogeneous_dtype.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_between_time.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_to_dict.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_clip.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_to_dict_of_blocks.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_combine.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_isin.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_combine_first.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_to_numpy.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_compare.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_to_period.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_convert.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_join.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_convert_dtypes.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_to_records.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_copy.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_to_timestamp.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_count.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_transpose.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_cov_corr.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_truncate.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_describe.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_tz_convert.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_diff.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_tz_localize.cpython-37.pyc (deflated 41%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_drop.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_matmul.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_drop_duplicates.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_nlargest.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_droplevel.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_update.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_dropna.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_value_counts.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_dtypes.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_pct_change.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_duplicated.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_values.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_equals.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_explode.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_fillna.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_filter.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_pop.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_first_and_last.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_quantile.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_get_numeric_data.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_sort_values.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_head_tail.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_rank.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_infer_objects.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_select_dtypes.cpython-37.pyc (deflated 70%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_swapaxes.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_set_index.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_shift.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_swaplevel.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/frame/methods/__pycache__/test_sort_index.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/frame/__pycache__/ (stored 0%)
  adding: python/pandas/tests/frame/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/frame/__pycache__/common.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/frame/__pycache__/conftest.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/frame/__pycache__/test_alter_axes.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/frame/__pycache__/test_api.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/frame/__pycache__/test_arithmetic.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/frame/__pycache__/test_block_internals.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/frame/__pycache__/test_constructors.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/frame/__pycache__/test_cumulative.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/frame/__pycache__/test_iteration.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/frame/__pycache__/test_logical_ops.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/frame/__pycache__/test_nonunique_indexes.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/frame/__pycache__/test_npfuncs.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/frame/__pycache__/test_query_eval.cpython-37.pyc (deflated 70%)
  adding: python/pandas/tests/frame/__pycache__/test_reductions.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/frame/__pycache__/test_repr_info.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/__pycache__/test_stack_unstack.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/frame/__pycache__/test_subclass.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/frame/__pycache__/test_ufunc.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/__pycache__/test_unary.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/frame/__pycache__/test_validate.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/groupby/ (stored 0%)
  adding: python/pandas/tests/groupby/test_groupby_shift_diff.py (deflated 68%)
  adding: python/pandas/tests/groupby/test_grouping.py (deflated 79%)
  adding: python/pandas/tests/groupby/test_function.py (deflated 78%)
  adding: python/pandas/tests/groupby/test_missing.py (deflated 69%)
  adding: python/pandas/tests/groupby/test_nunique.py (deflated 74%)
  adding: python/pandas/tests/groupby/test_allowlist.py (deflated 71%)
  adding: python/pandas/tests/groupby/test_quantile.py (deflated 73%)
  adding: python/pandas/tests/groupby/test_index_as_string.py (deflated 70%)
  adding: python/pandas/tests/groupby/test_apply_mutate.py (deflated 62%)
  adding: python/pandas/tests/groupby/test_groupby_subclass.py (deflated 64%)
  adding: python/pandas/tests/groupby/test_apply.py (deflated 74%)
  adding: python/pandas/tests/groupby/test_value_counts.py (deflated 64%)
  adding: python/pandas/tests/groupby/test_sample.py (deflated 82%)
  adding: python/pandas/tests/groupby/test_size.py (deflated 63%)
  adding: python/pandas/tests/groupby/conftest.py (deflated 79%)
  adding: python/pandas/tests/groupby/test_filters.py (deflated 86%)
  adding: python/pandas/tests/groupby/test_nth.py (deflated 80%)
  adding: python/pandas/tests/groupby/test_groupby_dropna.py (deflated 80%)
  adding: python/pandas/tests/groupby/test_libgroupby.py (deflated 77%)
  adding: python/pandas/tests/groupby/test_pipe.py (deflated 62%)
  adding: python/pandas/tests/groupby/test_categorical.py (deflated 80%)
  adding: python/pandas/tests/groupby/__init__.py (stored 0%)
  adding: python/pandas/tests/groupby/test_timegrouper.py (deflated 82%)
  adding: python/pandas/tests/groupby/test_counting.py (deflated 77%)
  adding: python/pandas/tests/groupby/test_bin_groupby.py (deflated 69%)
  adding: python/pandas/tests/groupby/test_rank.py (deflated 85%)
  adding: python/pandas/tests/groupby/test_groupby.py (deflated 77%)
  adding: python/pandas/tests/groupby/transform/ (stored 0%)
  adding: python/pandas/tests/groupby/transform/test_numba.py (deflated 78%)
  adding: python/pandas/tests/groupby/transform/test_transform.py (deflated 75%)
  adding: python/pandas/tests/groupby/transform/__init__.py (stored 0%)
  adding: python/pandas/tests/groupby/transform/__pycache__/ (stored 0%)
  adding: python/pandas/tests/groupby/transform/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/groupby/transform/__pycache__/test_numba.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/groupby/transform/__pycache__/test_transform.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/groupby/aggregate/ (stored 0%)
  adding: python/pandas/tests/groupby/aggregate/test_other.py (deflated 76%)
  adding: python/pandas/tests/groupby/aggregate/test_aggregate.py (deflated 78%)
  adding: python/pandas/tests/groupby/aggregate/test_numba.py (deflated 77%)
  adding: python/pandas/tests/groupby/aggregate/__init__.py (stored 0%)
  adding: python/pandas/tests/groupby/aggregate/test_cython.py (deflated 73%)
  adding: python/pandas/tests/groupby/aggregate/__pycache__/ (stored 0%)
  adding: python/pandas/tests/groupby/aggregate/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/groupby/aggregate/__pycache__/test_aggregate.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/groupby/aggregate/__pycache__/test_cython.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/groupby/aggregate/__pycache__/test_numba.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/groupby/aggregate/__pycache__/test_other.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/groupby/__pycache__/ (stored 0%)
  adding: python/pandas/tests/groupby/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/groupby/__pycache__/conftest.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/groupby/__pycache__/test_allowlist.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/groupby/__pycache__/test_apply.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/groupby/__pycache__/test_apply_mutate.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/groupby/__pycache__/test_bin_groupby.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/groupby/__pycache__/test_categorical.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/groupby/__pycache__/test_counting.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/groupby/__pycache__/test_filters.cpython-37.pyc (deflated 73%)
  adding: python/pandas/tests/groupby/__pycache__/test_function.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/groupby/__pycache__/test_groupby.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/groupby/__pycache__/test_groupby_dropna.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/groupby/__pycache__/test_groupby_shift_diff.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/groupby/__pycache__/test_groupby_subclass.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/groupby/__pycache__/test_grouping.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/groupby/__pycache__/test_index_as_string.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/groupby/__pycache__/test_libgroupby.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/groupby/__pycache__/test_missing.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/groupby/__pycache__/test_nth.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/groupby/__pycache__/test_nunique.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/groupby/__pycache__/test_pipe.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/groupby/__pycache__/test_quantile.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/groupby/__pycache__/test_rank.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/groupby/__pycache__/test_sample.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/groupby/__pycache__/test_size.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/groupby/__pycache__/test_timegrouper.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/groupby/__pycache__/test_value_counts.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/tslibs/ (stored 0%)
  adding: python/pandas/tests/tslibs/test_ccalendar.py (deflated 67%)
  adding: python/pandas/tests/tslibs/test_timedeltas.py (deflated 56%)
  adding: python/pandas/tests/tslibs/test_libfrequencies.py (deflated 63%)
  adding: python/pandas/tests/tslibs/test_parsing.py (deflated 72%)
  adding: python/pandas/tests/tslibs/test_array_to_datetime.py (deflated 74%)
  adding: python/pandas/tests/tslibs/test_parse_iso8601.py (deflated 68%)
  adding: python/pandas/tests/tslibs/test_timezones.py (deflated 72%)
  adding: python/pandas/tests/tslibs/test_conversion.py (deflated 69%)
  adding: python/pandas/tests/tslibs/test_api.py (deflated 61%)
  adding: python/pandas/tests/tslibs/test_liboffsets.py (deflated 73%)
  adding: python/pandas/tests/tslibs/__init__.py (stored 0%)
  adding: python/pandas/tests/tslibs/test_to_offset.py (deflated 74%)
  adding: python/pandas/tests/tslibs/test_period_asfreq.py (deflated 70%)
  adding: python/pandas/tests/tslibs/test_fields.py (deflated 59%)
  adding: python/pandas/tests/tslibs/__pycache__/ (stored 0%)
  adding: python/pandas/tests/tslibs/__pycache__/__init__.cpython-37.pyc (deflated 21%)
  adding: python/pandas/tests/tslibs/__pycache__/test_api.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/tslibs/__pycache__/test_array_to_datetime.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/tslibs/__pycache__/test_ccalendar.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/tslibs/__pycache__/test_conversion.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/tslibs/__pycache__/test_fields.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/tslibs/__pycache__/test_libfrequencies.cpython-37.pyc (deflated 34%)
  adding: python/pandas/tests/tslibs/__pycache__/test_liboffsets.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/tslibs/__pycache__/test_parse_iso8601.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/tslibs/__pycache__/test_parsing.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/tslibs/__pycache__/test_period_asfreq.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/tslibs/__pycache__/test_timedeltas.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/tslibs/__pycache__/test_timezones.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/tslibs/__pycache__/test_to_offset.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/internals/ (stored 0%)
  adding: python/pandas/tests/internals/__init__.py (stored 0%)
  adding: python/pandas/tests/internals/test_internals.py (deflated 79%)
  adding: python/pandas/tests/internals/__pycache__/ (stored 0%)
  adding: python/pandas/tests/internals/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/internals/__pycache__/test_internals.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/extension/ (stored 0%)
  adding: python/pandas/tests/extension/test_numpy.py (deflated 77%)
  adding: python/pandas/tests/extension/test_boolean.py (deflated 77%)
  adding: python/pandas/tests/extension/test_interval.py (deflated 67%)
  adding: python/pandas/tests/extension/test_datetime.py (deflated 74%)
  adding: python/pandas/tests/extension/conftest.py (deflated 70%)
  adding: python/pandas/tests/extension/test_floating.py (deflated 71%)
  adding: python/pandas/tests/extension/test_categorical.py (deflated 69%)
  adding: python/pandas/tests/extension/test_external_block.py (deflated 48%)
  adding: python/pandas/tests/extension/__init__.py (stored 0%)
  adding: python/pandas/tests/extension/test_string.py (deflated 72%)
  adding: python/pandas/tests/extension/test_integer.py (deflated 71%)
  adding: python/pandas/tests/extension/test_period.py (deflated 74%)
  adding: python/pandas/tests/extension/test_sparse.py (deflated 75%)
  adding: python/pandas/tests/extension/test_common.py (deflated 70%)
  adding: python/pandas/tests/extension/decimal/ (stored 0%)
  adding: python/pandas/tests/extension/decimal/test_decimal.py (deflated 75%)
  adding: python/pandas/tests/extension/decimal/__init__.py (deflated 36%)
  adding: python/pandas/tests/extension/decimal/array.py (deflated 69%)
  adding: python/pandas/tests/extension/decimal/__pycache__/ (stored 0%)
  adding: python/pandas/tests/extension/decimal/__pycache__/__init__.cpython-37.pyc (deflated 23%)
  adding: python/pandas/tests/extension/decimal/__pycache__/array.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/extension/decimal/__pycache__/test_decimal.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/extension/base/ (stored 0%)
  adding: python/pandas/tests/extension/base/printing.py (deflated 60%)
  adding: python/pandas/tests/extension/base/dtype.py (deflated 71%)
  adding: python/pandas/tests/extension/base/interface.py (deflated 69%)
  adding: python/pandas/tests/extension/base/ops.py (deflated 78%)
  adding: python/pandas/tests/extension/base/base.py (deflated 70%)
  adding: python/pandas/tests/extension/base/getitem.py (deflated 81%)
  adding: python/pandas/tests/extension/base/io.py (deflated 47%)
  adding: python/pandas/tests/extension/base/missing.py (deflated 81%)
  adding: python/pandas/tests/extension/base/methods.py (deflated 78%)
  adding: python/pandas/tests/extension/base/casting.py (deflated 67%)
  adding: python/pandas/tests/extension/base/reshaping.py (deflated 79%)
  adding: python/pandas/tests/extension/base/setitem.py (deflated 80%)
  adding: python/pandas/tests/extension/base/groupby.py (deflated 78%)
  adding: python/pandas/tests/extension/base/__init__.py (deflated 61%)
  adding: python/pandas/tests/extension/base/constructors.py (deflated 78%)
  adding: python/pandas/tests/extension/base/reduce.py (deflated 72%)
  adding: python/pandas/tests/extension/base/__pycache__/ (stored 0%)
  adding: python/pandas/tests/extension/base/__pycache__/__init__.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/extension/base/__pycache__/base.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/extension/base/__pycache__/casting.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/extension/base/__pycache__/constructors.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/extension/base/__pycache__/dtype.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/extension/base/__pycache__/getitem.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/extension/base/__pycache__/groupby.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/extension/base/__pycache__/interface.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/extension/base/__pycache__/io.cpython-37.pyc (deflated 34%)
  adding: python/pandas/tests/extension/base/__pycache__/methods.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/extension/base/__pycache__/missing.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/extension/base/__pycache__/ops.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/extension/base/__pycache__/printing.cpython-37.pyc (deflated 46%)
  adding: python/pandas/tests/extension/base/__pycache__/reduce.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/extension/base/__pycache__/reshaping.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/extension/base/__pycache__/setitem.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/extension/list/ (stored 0%)
  adding: python/pandas/tests/extension/list/__init__.py (deflated 26%)
  adding: python/pandas/tests/extension/list/test_list.py (deflated 46%)
  adding: python/pandas/tests/extension/list/array.py (deflated 65%)
  adding: python/pandas/tests/extension/list/__pycache__/ (stored 0%)
  adding: python/pandas/tests/extension/list/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/extension/list/__pycache__/array.cpython-37.pyc (deflated 52%)
  adding: python/pandas/tests/extension/list/__pycache__/test_list.cpython-37.pyc (deflated 36%)
  adding: python/pandas/tests/extension/json/ (stored 0%)
  adding: python/pandas/tests/extension/json/test_json.py (deflated 72%)
  adding: python/pandas/tests/extension/json/__init__.py (deflated 26%)
  adding: python/pandas/tests/extension/json/array.py (deflated 66%)
  adding: python/pandas/tests/extension/json/__pycache__/ (stored 0%)
  adding: python/pandas/tests/extension/json/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/extension/json/__pycache__/array.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/extension/json/__pycache__/test_json.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/extension/arrow/ (stored 0%)
  adding: python/pandas/tests/extension/arrow/arrays.py (deflated 71%)
  adding: python/pandas/tests/extension/arrow/__init__.py (stored 0%)
  adding: python/pandas/tests/extension/arrow/test_string.py (deflated 34%)
  adding: python/pandas/tests/extension/arrow/test_bool.py (deflated 67%)
  adding: python/pandas/tests/extension/arrow/__pycache__/ (stored 0%)
  adding: python/pandas/tests/extension/arrow/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/tests/extension/arrow/__pycache__/arrays.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/extension/arrow/__pycache__/test_bool.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/extension/arrow/__pycache__/test_string.cpython-37.pyc (deflated 26%)
  adding: python/pandas/tests/extension/__pycache__/ (stored 0%)
  adding: python/pandas/tests/extension/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/extension/__pycache__/conftest.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/extension/__pycache__/test_boolean.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/extension/__pycache__/test_categorical.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/extension/__pycache__/test_common.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/extension/__pycache__/test_datetime.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/extension/__pycache__/test_external_block.cpython-37.pyc (deflated 37%)
  adding: python/pandas/tests/extension/__pycache__/test_floating.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/extension/__pycache__/test_integer.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/extension/__pycache__/test_interval.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/extension/__pycache__/test_numpy.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/extension/__pycache__/test_period.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/extension/__pycache__/test_sparse.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/extension/__pycache__/test_string.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/tools/ (stored 0%)
  adding: python/pandas/tests/tools/test_to_datetime.py (deflated 82%)
  adding: python/pandas/tests/tools/test_to_time.py (deflated 66%)
  adding: python/pandas/tests/tools/__init__.py (stored 0%)
  adding: python/pandas/tests/tools/test_to_numeric.py (deflated 78%)
  adding: python/pandas/tests/tools/test_to_timedelta.py (deflated 78%)
  adding: python/pandas/tests/tools/__pycache__/ (stored 0%)
  adding: python/pandas/tests/tools/__pycache__/__init__.cpython-37.pyc (deflated 21%)
  adding: python/pandas/tests/tools/__pycache__/test_to_datetime.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/tools/__pycache__/test_to_numeric.cpython-37.pyc (deflated 58%)
  adding: python/pandas/tests/tools/__pycache__/test_to_time.cpython-37.pyc (deflated 40%)
  adding: python/pandas/tests/tools/__pycache__/test_to_timedelta.cpython-37.pyc (deflated 56%)
  adding: python/pandas/tests/util/ (stored 0%)
  adding: python/pandas/tests/util/test_assert_produces_warning.py (deflated 78%)
  adding: python/pandas/tests/util/test_assert_frame_equal.py (deflated 80%)
  adding: python/pandas/tests/util/test_numba.py (deflated 40%)
  adding: python/pandas/tests/util/test_util.py (deflated 60%)
  adding: python/pandas/tests/util/test_assert_interval_array_equal.py (deflated 77%)
  adding: python/pandas/tests/util/test_deprecate_nonkeyword_arguments.py (deflated 78%)
  adding: python/pandas/tests/util/test_assert_index_equal.py (deflated 83%)
  adding: python/pandas/tests/util/conftest.py (deflated 71%)
  adding: python/pandas/tests/util/test_deprecate.py (deflated 71%)
  adding: python/pandas/tests/util/test_validate_kwargs.py (deflated 65%)
  adding: python/pandas/tests/util/test_assert_almost_equal.py (deflated 81%)
  adding: python/pandas/tests/util/test_deprecate_kwarg.py (deflated 67%)
  adding: python/pandas/tests/util/test_assert_extension_array_equal.py (deflated 73%)
  adding: python/pandas/tests/util/__init__.py (stored 0%)
  adding: python/pandas/tests/util/test_validate_args_and_kwargs.py (deflated 74%)
  adding: python/pandas/tests/util/test_assert_numpy_array_equal.py (deflated 82%)
  adding: python/pandas/tests/util/test_assert_series_equal.py (deflated 79%)
  adding: python/pandas/tests/util/test_assert_categorical_equal.py (deflated 78%)
  adding: python/pandas/tests/util/test_safe_import.py (deflated 63%)
  adding: python/pandas/tests/util/test_doc.py (deflated 73%)
  adding: python/pandas/tests/util/test_show_versions.py (deflated 57%)
  adding: python/pandas/tests/util/test_validate_args.py (deflated 70%)
  adding: python/pandas/tests/util/test_hashing.py (deflated 65%)
  adding: python/pandas/tests/util/__pycache__/ (stored 0%)
  adding: python/pandas/tests/util/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/tests/util/__pycache__/conftest.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/util/__pycache__/test_assert_almost_equal.cpython-37.pyc (deflated 67%)
  adding: python/pandas/tests/util/__pycache__/test_assert_categorical_equal.cpython-37.pyc (deflated 60%)
  adding: python/pandas/tests/util/__pycache__/test_assert_extension_array_equal.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/util/__pycache__/test_assert_frame_equal.cpython-37.pyc (deflated 64%)
  adding: python/pandas/tests/util/__pycache__/test_assert_index_equal.cpython-37.pyc (deflated 68%)
  adding: python/pandas/tests/util/__pycache__/test_assert_interval_array_equal.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/util/__pycache__/test_assert_numpy_array_equal.cpython-37.pyc (deflated 70%)
  adding: python/pandas/tests/util/__pycache__/test_assert_produces_warning.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tests/util/__pycache__/test_assert_series_equal.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/util/__pycache__/test_deprecate.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/util/__pycache__/test_deprecate_kwarg.cpython-37.pyc (deflated 53%)
  adding: python/pandas/tests/util/__pycache__/test_deprecate_nonkeyword_arguments.cpython-37.pyc (deflated 63%)
  adding: python/pandas/tests/util/__pycache__/test_doc.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/util/__pycache__/test_hashing.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/util/__pycache__/test_numba.cpython-37.pyc (deflated 32%)
  adding: python/pandas/tests/util/__pycache__/test_safe_import.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/util/__pycache__/test_show_versions.cpython-37.pyc (deflated 39%)
  adding: python/pandas/tests/util/__pycache__/test_util.cpython-37.pyc (deflated 47%)
  adding: python/pandas/tests/util/__pycache__/test_validate_args.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/util/__pycache__/test_validate_args_and_kwargs.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/util/__pycache__/test_validate_kwargs.cpython-37.pyc (deflated 42%)
  adding: python/pandas/tests/__pycache__/ (stored 0%)
  adding: python/pandas/tests/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tests/__pycache__/test_aggregation.cpython-37.pyc (deflated 61%)
  adding: python/pandas/tests/__pycache__/test_algos.cpython-37.pyc (deflated 65%)
  adding: python/pandas/tests/__pycache__/test_common.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tests/__pycache__/test_downstream.cpython-37.pyc (deflated 45%)
  adding: python/pandas/tests/__pycache__/test_errors.cpython-37.pyc (deflated 48%)
  adding: python/pandas/tests/__pycache__/test_expressions.cpython-37.pyc (deflated 54%)
  adding: python/pandas/tests/__pycache__/test_flags.cpython-37.pyc (deflated 49%)
  adding: python/pandas/tests/__pycache__/test_multilevel.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tests/__pycache__/test_nanops.cpython-37.pyc (deflated 62%)
  adding: python/pandas/tests/__pycache__/test_optional_dependency.cpython-37.pyc (deflated 43%)
  adding: python/pandas/tests/__pycache__/test_register_accessor.cpython-37.pyc (deflated 50%)
  adding: python/pandas/tests/__pycache__/test_sorting.cpython-37.pyc (deflated 55%)
  adding: python/pandas/tests/__pycache__/test_strings.cpython-37.pyc (deflated 66%)
  adding: python/pandas/tests/__pycache__/test_take.cpython-37.pyc (deflated 64%)
  adding: python/pandas/core/ (stored 0%)
  adding: python/pandas/core/api.py (deflated 69%)
  adding: python/pandas/core/aggregation.py (deflated 72%)
  adding: python/pandas/core/frame.py (deflated 76%)
  adding: python/pandas/core/config_init.py (deflated 74%)
  adding: python/pandas/core/series.py (deflated 77%)
  adding: python/pandas/core/construction.py (deflated 72%)
  adding: python/pandas/core/generic.py (deflated 77%)
  adding: python/pandas/core/nanops.py (deflated 78%)
  adding: python/pandas/core/sorting.py (deflated 69%)
  adding: python/pandas/core/common.py (deflated 69%)
  adding: python/pandas/core/accessor.py (deflated 69%)
  adding: python/pandas/core/base.py (deflated 74%)
  adding: python/pandas/core/indexing.py (deflated 77%)
  adding: python/pandas/core/index.py (deflated 50%)
  adding: python/pandas/core/arraylike.py (deflated 74%)
  adding: python/pandas/core/missing.py (deflated 70%)
  adding: python/pandas/core/resample.py (deflated 78%)
  adding: python/pandas/core/shared_docs.py (deflated 65%)
  adding: python/pandas/core/__init__.py (stored 0%)
  adding: python/pandas/core/algorithms.py (deflated 74%)
  adding: python/pandas/core/flags.py (deflated 66%)
  adding: python/pandas/core/apply.py (deflated 73%)
  adding: python/pandas/core/indexers.py (deflated 72%)
  adding: python/pandas/core/window/ (stored 0%)
  adding: python/pandas/core/window/numba_.py (deflated 73%)
  adding: python/pandas/core/window/ewm.py (deflated 73%)
  adding: python/pandas/core/window/common.py (deflated 74%)
  adding: python/pandas/core/window/expanding.py (deflated 73%)
  adding: python/pandas/core/window/__init__.py (deflated 54%)
  adding: python/pandas/core/window/rolling.py (deflated 77%)
  adding: python/pandas/core/window/indexers.py (deflated 76%)
  adding: python/pandas/core/window/__pycache__/ (stored 0%)
  adding: python/pandas/core/window/__pycache__/__init__.cpython-37.pyc (deflated 35%)
  adding: python/pandas/core/window/__pycache__/common.cpython-37.pyc (deflated 45%)
  adding: python/pandas/core/window/__pycache__/ewm.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/window/__pycache__/expanding.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/window/__pycache__/indexers.cpython-37.pyc (deflated 60%)
  adding: python/pandas/core/window/__pycache__/numba_.cpython-37.pyc (deflated 49%)
  adding: python/pandas/core/window/__pycache__/rolling.cpython-37.pyc (deflated 65%)
  adding: python/pandas/core/indexes/ (stored 0%)
  adding: python/pandas/core/indexes/api.py (deflated 71%)
  adding: python/pandas/core/indexes/category.py (deflated 73%)
  adding: python/pandas/core/indexes/frozen.py (deflated 66%)
  adding: python/pandas/core/indexes/range.py (deflated 74%)
  adding: python/pandas/core/indexes/interval.py (deflated 75%)
  adding: python/pandas/core/indexes/timedeltas.py (deflated 68%)
  adding: python/pandas/core/indexes/base.py (deflated 77%)
  adding: python/pandas/core/indexes/accessors.py (deflated 78%)
  adding: python/pandas/core/indexes/extension.py (deflated 72%)
  adding: python/pandas/core/indexes/period.py (deflated 72%)
  adding: python/pandas/core/indexes/multi.py (deflated 78%)
  adding: python/pandas/core/indexes/datetimelike.py (deflated 75%)
  adding: python/pandas/core/indexes/__init__.py (stored 0%)
  adding: python/pandas/core/indexes/datetimes.py (deflated 74%)
  adding: python/pandas/core/indexes/numeric.py (deflated 70%)
  adding: python/pandas/core/indexes/__pycache__/ (stored 0%)
  adding: python/pandas/core/indexes/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/core/indexes/__pycache__/accessors.cpython-37.pyc (deflated 67%)
  adding: python/pandas/core/indexes/__pycache__/api.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/indexes/__pycache__/base.cpython-37.pyc (deflated 67%)
  adding: python/pandas/core/indexes/__pycache__/category.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/indexes/__pycache__/datetimelike.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/indexes/__pycache__/datetimes.cpython-37.pyc (deflated 61%)
  adding: python/pandas/core/indexes/__pycache__/extension.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/indexes/__pycache__/frozen.cpython-37.pyc (deflated 53%)
  adding: python/pandas/core/indexes/__pycache__/interval.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/indexes/__pycache__/multi.cpython-37.pyc (deflated 64%)
  adding: python/pandas/core/indexes/__pycache__/numeric.cpython-37.pyc (deflated 52%)
  adding: python/pandas/core/indexes/__pycache__/period.cpython-37.pyc (deflated 54%)
  adding: python/pandas/core/indexes/__pycache__/range.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/indexes/__pycache__/timedeltas.cpython-37.pyc (deflated 54%)
  adding: python/pandas/core/dtypes/ (stored 0%)
  adding: python/pandas/core/dtypes/api.py (deflated 69%)
  adding: python/pandas/core/dtypes/generic.py (deflated 73%)
  adding: python/pandas/core/dtypes/dtypes.py (deflated 76%)
  adding: python/pandas/core/dtypes/common.py (deflated 82%)
  adding: python/pandas/core/dtypes/base.py (deflated 69%)
  adding: python/pandas/core/dtypes/missing.py (deflated 74%)
  adding: python/pandas/core/dtypes/cast.py (deflated 75%)
  adding: python/pandas/core/dtypes/inference.py (deflated 75%)
  adding: python/pandas/core/dtypes/__init__.py (stored 0%)
  adding: python/pandas/core/dtypes/concat.py (deflated 70%)
  adding: python/pandas/core/dtypes/__pycache__/ (stored 0%)
  adding: python/pandas/core/dtypes/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/core/dtypes/__pycache__/api.cpython-37.pyc (deflated 47%)
  adding: python/pandas/core/dtypes/__pycache__/base.cpython-37.pyc (deflated 61%)
  adding: python/pandas/core/dtypes/__pycache__/cast.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/dtypes/__pycache__/common.cpython-37.pyc (deflated 75%)
  adding: python/pandas/core/dtypes/__pycache__/concat.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/dtypes/__pycache__/dtypes.cpython-37.pyc (deflated 61%)
  adding: python/pandas/core/dtypes/__pycache__/generic.cpython-37.pyc (deflated 48%)
  adding: python/pandas/core/dtypes/__pycache__/inference.cpython-37.pyc (deflated 67%)
  adding: python/pandas/core/dtypes/__pycache__/missing.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/sparse/ (stored 0%)
  adding: python/pandas/core/sparse/api.py (deflated 26%)
  adding: python/pandas/core/sparse/__init__.py (stored 0%)
  adding: python/pandas/core/sparse/__pycache__/ (stored 0%)
  adding: python/pandas/core/sparse/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/core/sparse/__pycache__/api.cpython-37.pyc (deflated 22%)
  adding: python/pandas/core/computation/ (stored 0%)
  adding: python/pandas/core/computation/api.py (deflated 3%)
  adding: python/pandas/core/computation/parsing.py (deflated 65%)
  adding: python/pandas/core/computation/expr.py (deflated 73%)
  adding: python/pandas/core/computation/engines.py (deflated 62%)
  adding: python/pandas/core/computation/ops.py (deflated 73%)
  adding: python/pandas/core/computation/common.py (deflated 47%)
  adding: python/pandas/core/computation/check.py (deflated 43%)
  adding: python/pandas/core/computation/scope.py (deflated 69%)
  adding: python/pandas/core/computation/expressions.py (deflated 67%)
  adding: python/pandas/core/computation/align.py (deflated 65%)
  adding: python/pandas/core/computation/__init__.py (stored 0%)
  adding: python/pandas/core/computation/eval.py (deflated 67%)
  adding: python/pandas/core/computation/pytables.py (deflated 74%)
  adding: python/pandas/core/computation/__pycache__/ (stored 0%)
  adding: python/pandas/core/computation/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/core/computation/__pycache__/align.cpython-37.pyc (deflated 47%)
  adding: python/pandas/core/computation/__pycache__/api.cpython-37.pyc (deflated 21%)
  adding: python/pandas/core/computation/__pycache__/check.cpython-37.pyc (deflated 19%)
  adding: python/pandas/core/computation/__pycache__/common.cpython-37.pyc (deflated 32%)
  adding: python/pandas/core/computation/__pycache__/engines.cpython-37.pyc (deflated 50%)
  adding: python/pandas/core/computation/__pycache__/eval.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/computation/__pycache__/expr.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/computation/__pycache__/expressions.cpython-37.pyc (deflated 46%)
  adding: python/pandas/core/computation/__pycache__/ops.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/computation/__pycache__/parsing.cpython-37.pyc (deflated 52%)
  adding: python/pandas/core/computation/__pycache__/pytables.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/computation/__pycache__/scope.cpython-37.pyc (deflated 52%)
  adding: python/pandas/core/reshape/ (stored 0%)
  adding: python/pandas/core/reshape/api.py (deflated 59%)
  adding: python/pandas/core/reshape/tile.py (deflated 70%)
  adding: python/pandas/core/reshape/util.py (deflated 55%)
  adding: python/pandas/core/reshape/merge.py (deflated 77%)
  adding: python/pandas/core/reshape/reshape.py (deflated 73%)
  adding: python/pandas/core/reshape/pivot.py (deflated 74%)
  adding: python/pandas/core/reshape/__init__.py (stored 0%)
  adding: python/pandas/core/reshape/melt.py (deflated 70%)
  adding: python/pandas/core/reshape/concat.py (deflated 72%)
  adding: python/pandas/core/reshape/__pycache__/ (stored 0%)
  adding: python/pandas/core/reshape/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/core/reshape/__pycache__/api.cpython-37.pyc (deflated 40%)
  adding: python/pandas/core/reshape/__pycache__/concat.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/reshape/__pycache__/melt.cpython-37.pyc (deflated 60%)
  adding: python/pandas/core/reshape/__pycache__/merge.cpython-37.pyc (deflated 60%)
  adding: python/pandas/core/reshape/__pycache__/pivot.cpython-37.pyc (deflated 53%)
  adding: python/pandas/core/reshape/__pycache__/reshape.cpython-37.pyc (deflated 54%)
  adding: python/pandas/core/reshape/__pycache__/tile.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/reshape/__pycache__/util.cpython-37.pyc (deflated 41%)
  adding: python/pandas/core/arrays/ (stored 0%)
  adding: python/pandas/core/arrays/_mixins.py (deflated 75%)
  adding: python/pandas/core/arrays/boolean.py (deflated 76%)
  adding: python/pandas/core/arrays/interval.py (deflated 76%)
  adding: python/pandas/core/arrays/_arrow_utils.py (deflated 72%)
  adding: python/pandas/core/arrays/timedeltas.py (deflated 76%)
  adding: python/pandas/core/arrays/base.py (deflated 74%)
  adding: python/pandas/core/arrays/string_.py (deflated 72%)
  adding: python/pandas/core/arrays/string_arrow.py (deflated 71%)
  adding: python/pandas/core/arrays/integer.py (deflated 72%)
  adding: python/pandas/core/arrays/masked.py (deflated 70%)
  adding: python/pandas/core/arrays/period.py (deflated 74%)
  adding: python/pandas/core/arrays/floating.py (deflated 70%)
  adding: python/pandas/core/arrays/datetimelike.py (deflated 76%)
  adding: python/pandas/core/arrays/_ranges.py (deflated 67%)
  adding: python/pandas/core/arrays/__init__.py (deflated 72%)
  adding: python/pandas/core/arrays/numpy_.py (deflated 77%)
  adding: python/pandas/core/arrays/datetimes.py (deflated 77%)
  adding: python/pandas/core/arrays/categorical.py (deflated 76%)
  adding: python/pandas/core/arrays/numeric.py (deflated 72%)
  adding: python/pandas/core/arrays/sparse/ (stored 0%)
  adding: python/pandas/core/arrays/sparse/dtype.py (deflated 71%)
  adding: python/pandas/core/arrays/sparse/scipy_sparse.py (deflated 67%)
  adding: python/pandas/core/arrays/sparse/accessor.py (deflated 72%)
  adding: python/pandas/core/arrays/sparse/__init__.py (deflated 49%)
  adding: python/pandas/core/arrays/sparse/array.py (deflated 75%)
  adding: python/pandas/core/arrays/sparse/__pycache__/ (stored 0%)
  adding: python/pandas/core/arrays/sparse/__pycache__/__init__.cpython-37.pyc (deflated 36%)
  adding: python/pandas/core/arrays/sparse/__pycache__/accessor.cpython-37.pyc (deflated 61%)
  adding: python/pandas/core/arrays/sparse/__pycache__/array.cpython-37.pyc (deflated 57%)
  adding: python/pandas/core/arrays/sparse/__pycache__/dtype.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/arrays/sparse/__pycache__/scipy_sparse.cpython-37.pyc (deflated 53%)
  adding: python/pandas/core/arrays/__pycache__/ (stored 0%)
  adding: python/pandas/core/arrays/__pycache__/__init__.cpython-37.pyc (deflated 51%)
  adding: python/pandas/core/arrays/__pycache__/_arrow_utils.cpython-37.pyc (deflated 54%)
  adding: python/pandas/core/arrays/__pycache__/_mixins.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/arrays/__pycache__/_ranges.cpython-37.pyc (deflated 47%)
  adding: python/pandas/core/arrays/__pycache__/base.cpython-37.pyc (deflated 66%)
  adding: python/pandas/core/arrays/__pycache__/boolean.cpython-37.pyc (deflated 60%)
  adding: python/pandas/core/arrays/__pycache__/categorical.cpython-37.pyc (deflated 65%)
  adding: python/pandas/core/arrays/__pycache__/datetimelike.cpython-37.pyc (deflated 61%)
  adding: python/pandas/core/arrays/__pycache__/datetimes.cpython-37.pyc (deflated 66%)
  adding: python/pandas/core/arrays/__pycache__/floating.cpython-37.pyc (deflated 53%)
  adding: python/pandas/core/arrays/__pycache__/integer.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/arrays/__pycache__/interval.cpython-37.pyc (deflated 62%)
  adding: python/pandas/core/arrays/__pycache__/masked.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/arrays/__pycache__/numeric.cpython-37.pyc (deflated 40%)
  adding: python/pandas/core/arrays/__pycache__/numpy_.cpython-37.pyc (deflated 61%)
  adding: python/pandas/core/arrays/__pycache__/period.cpython-37.pyc (deflated 57%)
  adding: python/pandas/core/arrays/__pycache__/string_.cpython-37.pyc (deflated 54%)
  adding: python/pandas/core/arrays/__pycache__/string_arrow.cpython-37.pyc (deflated 57%)
  adding: python/pandas/core/arrays/__pycache__/timedeltas.cpython-37.pyc (deflated 57%)
  adding: python/pandas/core/ops/ (stored 0%)
  adding: python/pandas/core/ops/mask_ops.py (deflated 77%)
  adding: python/pandas/core/ops/roperator.py (deflated 65%)
  adding: python/pandas/core/ops/docstrings.py (deflated 77%)
  adding: python/pandas/core/ops/common.py (deflated 64%)
  adding: python/pandas/core/ops/dispatch.py (deflated 50%)
  adding: python/pandas/core/ops/missing.py (deflated 67%)
  adding: python/pandas/core/ops/methods.py (deflated 70%)
  adding: python/pandas/core/ops/__init__.py (deflated 71%)
  adding: python/pandas/core/ops/invalid.py (deflated 58%)
  adding: python/pandas/core/ops/array_ops.py (deflated 70%)
  adding: python/pandas/core/ops/__pycache__/ (stored 0%)
  adding: python/pandas/core/ops/__pycache__/__init__.cpython-37.pyc (deflated 47%)
  adding: python/pandas/core/ops/__pycache__/array_ops.cpython-37.pyc (deflated 51%)
  adding: python/pandas/core/ops/__pycache__/common.cpython-37.pyc (deflated 50%)
  adding: python/pandas/core/ops/__pycache__/dispatch.cpython-37.pyc (deflated 35%)
  adding: python/pandas/core/ops/__pycache__/docstrings.cpython-37.pyc (deflated 68%)
  adding: python/pandas/core/ops/__pycache__/invalid.cpython-37.pyc (deflated 41%)
  adding: python/pandas/core/ops/__pycache__/mask_ops.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/ops/__pycache__/methods.cpython-37.pyc (deflated 47%)
  adding: python/pandas/core/ops/__pycache__/missing.cpython-37.pyc (deflated 50%)
  adding: python/pandas/core/ops/__pycache__/roperator.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/groupby/ (stored 0%)
  adding: python/pandas/core/groupby/numba_.py (deflated 76%)
  adding: python/pandas/core/groupby/generic.py (deflated 75%)
  adding: python/pandas/core/groupby/ops.py (deflated 75%)
  adding: python/pandas/core/groupby/base.py (deflated 66%)
  adding: python/pandas/core/groupby/groupby.py (deflated 76%)
  adding: python/pandas/core/groupby/__init__.py (deflated 54%)
  adding: python/pandas/core/groupby/grouper.py (deflated 72%)
  adding: python/pandas/core/groupby/categorical.py (deflated 66%)
  adding: python/pandas/core/groupby/__pycache__/ (stored 0%)
  adding: python/pandas/core/groupby/__pycache__/__init__.cpython-37.pyc (deflated 35%)
  adding: python/pandas/core/groupby/__pycache__/base.cpython-37.pyc (deflated 41%)
  adding: python/pandas/core/groupby/__pycache__/categorical.cpython-37.pyc (deflated 52%)
  adding: python/pandas/core/groupby/__pycache__/generic.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/groupby/__pycache__/groupby.cpython-37.pyc (deflated 65%)
  adding: python/pandas/core/groupby/__pycache__/grouper.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/groupby/__pycache__/numba_.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/groupby/__pycache__/ops.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/strings/ (stored 0%)
  adding: python/pandas/core/strings/accessor.py (deflated 78%)
  adding: python/pandas/core/strings/base.py (deflated 80%)
  adding: python/pandas/core/strings/object_array.py (deflated 76%)
  adding: python/pandas/core/strings/__init__.py (deflated 54%)
  adding: python/pandas/core/strings/__pycache__/ (stored 0%)
  adding: python/pandas/core/strings/__pycache__/__init__.cpython-37.pyc (deflated 44%)
  adding: python/pandas/core/strings/__pycache__/accessor.cpython-37.pyc (deflated 71%)
  adding: python/pandas/core/strings/__pycache__/base.cpython-37.pyc (deflated 72%)
  adding: python/pandas/core/strings/__pycache__/object_array.cpython-37.pyc (deflated 66%)
  adding: python/pandas/core/internals/ (stored 0%)
  adding: python/pandas/core/internals/blocks.py (deflated 76%)
  adding: python/pandas/core/internals/construction.py (deflated 74%)
  adding: python/pandas/core/internals/ops.py (deflated 68%)
  adding: python/pandas/core/internals/managers.py (deflated 75%)
  adding: python/pandas/core/internals/__init__.py (deflated 65%)
  adding: python/pandas/core/internals/concat.py (deflated 73%)
  adding: python/pandas/core/internals/__pycache__/ (stored 0%)
  adding: python/pandas/core/internals/__pycache__/__init__.cpython-37.pyc (deflated 45%)
  adding: python/pandas/core/internals/__pycache__/blocks.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/internals/__pycache__/concat.cpython-37.pyc (deflated 49%)
  adding: python/pandas/core/internals/__pycache__/construction.cpython-37.pyc (deflated 53%)
  adding: python/pandas/core/internals/__pycache__/managers.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/internals/__pycache__/ops.cpython-37.pyc (deflated 39%)
  adding: python/pandas/core/array_algos/ (stored 0%)
  adding: python/pandas/core/array_algos/masked_reductions.py (deflated 74%)
  adding: python/pandas/core/array_algos/transforms.py (deflated 58%)
  adding: python/pandas/core/array_algos/__init__.py (deflated 43%)
  adding: python/pandas/core/array_algos/replace.py (deflated 64%)
  adding: python/pandas/core/array_algos/__pycache__/ (stored 0%)
  adding: python/pandas/core/array_algos/__pycache__/__init__.cpython-37.pyc (deflated 36%)
  adding: python/pandas/core/array_algos/__pycache__/masked_reductions.cpython-37.pyc (deflated 57%)
  adding: python/pandas/core/array_algos/__pycache__/replace.cpython-37.pyc (deflated 45%)
  adding: python/pandas/core/array_algos/__pycache__/transforms.cpython-37.pyc (deflated 27%)
  adding: python/pandas/core/tools/ (stored 0%)
  adding: python/pandas/core/tools/timedeltas.py (deflated 67%)
  adding: python/pandas/core/tools/__init__.py (stored 0%)
  adding: python/pandas/core/tools/datetimes.py (deflated 73%)
  adding: python/pandas/core/tools/times.py (deflated 71%)
  adding: python/pandas/core/tools/numeric.py (deflated 66%)
  adding: python/pandas/core/tools/__pycache__/ (stored 0%)
  adding: python/pandas/core/tools/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/core/tools/__pycache__/datetimes.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/tools/__pycache__/numeric.cpython-37.pyc (deflated 51%)
  adding: python/pandas/core/tools/__pycache__/timedeltas.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/tools/__pycache__/times.cpython-37.pyc (deflated 44%)
  adding: python/pandas/core/util/ (stored 0%)
  adding: python/pandas/core/util/hashing.py (deflated 70%)
  adding: python/pandas/core/util/numba_.py (deflated 64%)
  adding: python/pandas/core/util/__init__.py (stored 0%)
  adding: python/pandas/core/util/__pycache__/ (stored 0%)
  adding: python/pandas/core/util/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/core/util/__pycache__/hashing.cpython-37.pyc (deflated 51%)
  adding: python/pandas/core/util/__pycache__/numba_.cpython-37.pyc (deflated 46%)
  adding: python/pandas/core/__pycache__/ (stored 0%)
  adding: python/pandas/core/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/core/__pycache__/accessor.cpython-37.pyc (deflated 59%)
  adding: python/pandas/core/__pycache__/aggregation.cpython-37.pyc (deflated 56%)
  adding: python/pandas/core/__pycache__/algorithms.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/__pycache__/api.cpython-37.pyc (deflated 50%)
  adding: python/pandas/core/__pycache__/apply.cpython-37.pyc (deflated 54%)
  adding: python/pandas/core/__pycache__/arraylike.cpython-37.pyc (deflated 60%)
  adding: python/pandas/core/__pycache__/base.cpython-37.pyc (deflated 64%)
  adding: python/pandas/core/__pycache__/common.cpython-37.pyc (deflated 57%)
  adding: python/pandas/core/__pycache__/config_init.cpython-37.pyc (deflated 60%)
  adding: python/pandas/core/__pycache__/construction.cpython-37.pyc (deflated 58%)
  adding: python/pandas/core/__pycache__/flags.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/__pycache__/frame.cpython-37.pyc (deflated 68%)
  adding: python/pandas/core/__pycache__/generic.cpython-37.pyc (deflated 69%)
  adding: python/pandas/core/__pycache__/index.cpython-37.pyc (deflated 34%)
  adding: python/pandas/core/__pycache__/indexers.cpython-37.pyc (deflated 60%)
  adding: python/pandas/core/__pycache__/indexing.cpython-37.pyc (deflated 63%)
  adding: python/pandas/core/__pycache__/missing.cpython-37.pyc (deflated 55%)
  adding: python/pandas/core/__pycache__/nanops.cpython-37.pyc (deflated 62%)
  adding: python/pandas/core/__pycache__/resample.cpython-37.pyc (deflated 66%)
  adding: python/pandas/core/__pycache__/series.cpython-37.pyc (deflated 68%)
  adding: python/pandas/core/__pycache__/shared_docs.cpython-37.pyc (deflated 63%)
  adding: python/pandas/core/__pycache__/sorting.cpython-37.pyc (deflated 53%)
  adding: python/pandas/api/ (stored 0%)
  adding: python/pandas/api/__init__.py (deflated 7%)
  adding: python/pandas/api/types/ (stored 0%)
  adding: python/pandas/api/types/__init__.py (deflated 55%)
  adding: python/pandas/api/types/__pycache__/ (stored 0%)
  adding: python/pandas/api/types/__pycache__/__init__.cpython-37.pyc (deflated 34%)
  adding: python/pandas/api/extensions/ (stored 0%)
  adding: python/pandas/api/extensions/__init__.py (deflated 61%)
  adding: python/pandas/api/extensions/__pycache__/ (stored 0%)
  adding: python/pandas/api/extensions/__pycache__/__init__.cpython-37.pyc (deflated 38%)
  adding: python/pandas/api/indexers/ (stored 0%)
  adding: python/pandas/api/indexers/__init__.py (deflated 51%)
  adding: python/pandas/api/indexers/__pycache__/ (stored 0%)
  adding: python/pandas/api/indexers/__pycache__/__init__.cpython-37.pyc (deflated 29%)
  adding: python/pandas/api/__pycache__/ (stored 0%)
  adding: python/pandas/api/__pycache__/__init__.cpython-37.pyc (deflated 14%)
  adding: python/pandas/plotting/ (stored 0%)
  adding: python/pandas/plotting/_misc.py (deflated 72%)
  adding: python/pandas/plotting/__init__.py (deflated 60%)
  adding: python/pandas/plotting/_core.py (deflated 76%)
  adding: python/pandas/plotting/_matplotlib/ (stored 0%)
  adding: python/pandas/plotting/_matplotlib/style.py (deflated 73%)
  adding: python/pandas/plotting/_matplotlib/tools.py (deflated 68%)
  adding: python/pandas/plotting/_matplotlib/boxplot.py (deflated 72%)
  adding: python/pandas/plotting/_matplotlib/core.py (deflated 76%)
  adding: python/pandas/plotting/_matplotlib/converter.py (deflated 77%)
  adding: python/pandas/plotting/_matplotlib/__init__.py (deflated 61%)
  adding: python/pandas/plotting/_matplotlib/timeseries.py (deflated 70%)
  adding: python/pandas/plotting/_matplotlib/misc.py (deflated 71%)
  adding: python/pandas/plotting/_matplotlib/hist.py (deflated 72%)
  adding: python/pandas/plotting/_matplotlib/compat.py (deflated 62%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/ (stored 0%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/__init__.cpython-37.pyc (deflated 39%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/boxplot.cpython-37.pyc (deflated 49%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/compat.cpython-37.pyc (deflated 38%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/converter.cpython-37.pyc (deflated 55%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/core.cpython-37.pyc (deflated 54%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/hist.cpython-37.pyc (deflated 49%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/misc.cpython-37.pyc (deflated 47%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/style.cpython-37.pyc (deflated 60%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/timeseries.cpython-37.pyc (deflated 46%)
  adding: python/pandas/plotting/_matplotlib/__pycache__/tools.cpython-37.pyc (deflated 50%)
  adding: python/pandas/plotting/__pycache__/ (stored 0%)
  adding: python/pandas/plotting/__pycache__/__init__.cpython-37.pyc (deflated 51%)
  adding: python/pandas/plotting/__pycache__/_core.cpython-37.pyc (deflated 72%)
  adding: python/pandas/plotting/__pycache__/_misc.cpython-37.pyc (deflated 64%)
  adding: python/pandas/_libs/ (stored 0%)
  adding: python/pandas/_libs/testing.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/pandas/_libs/groupby.cpython-37m-x86_64-linux-gnu.so (deflated 63%)
  adding: python/pandas/_libs/parsers.cpython-37m-x86_64-linux-gnu.so (deflated 57%)
  adding: python/pandas/_libs/reduction.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/interval.cpython-37m-x86_64-linux-gnu.so (deflated 71%)
  adding: python/pandas/_libs/reshape.cpython-37m-x86_64-linux-gnu.so (deflated 62%)
  adding: python/pandas/_libs/hashing.cpython-37m-x86_64-linux-gnu.so (deflated 57%)
  adding: python/pandas/_libs/indexing.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/writers.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/index.cpython-37m-x86_64-linux-gnu.so (deflated 68%)
  adding: python/pandas/_libs/internals.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/hashtable.cpython-37m-x86_64-linux-gnu.so (deflated 68%)
  adding: python/pandas/_libs/json.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/ops.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/algos.cpython-37m-x86_64-linux-gnu.so (deflated 68%)
  adding: python/pandas/_libs/ops_dispatch.cpython-37m-x86_64-linux-gnu.so (deflated 63%)
  adding: python/pandas/_libs/__init__.py (deflated 51%)
  adding: python/pandas/_libs/sparse.cpython-37m-x86_64-linux-gnu.so (deflated 62%)
  adding: python/pandas/_libs/properties.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/lib.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/pandas/_libs/tslib.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/join.cpython-37m-x86_64-linux-gnu.so (deflated 71%)
  adding: python/pandas/_libs/missing.cpython-37m-x86_64-linux-gnu.so (deflated 60%)
  adding: python/pandas/_libs/window/ (stored 0%)
  adding: python/pandas/_libs/window/aggregations.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/window/__init__.py (stored 0%)
  adding: python/pandas/_libs/window/indexers.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/window/__pycache__/ (stored 0%)
  adding: python/pandas/_libs/window/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/_libs/tslibs/ (stored 0%)
  adding: python/pandas/_libs/tslibs/fields.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/tslibs/dtypes.cpython-37m-x86_64-linux-gnu.so (deflated 62%)
  adding: python/pandas/_libs/tslibs/ccalendar.cpython-37m-x86_64-linux-gnu.so (deflated 60%)
  adding: python/pandas/_libs/tslibs/base.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/tslibs/timezones.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/tslibs/tzconversion.cpython-37m-x86_64-linux-gnu.so (deflated 62%)
  adding: python/pandas/_libs/tslibs/nattype.cpython-37m-x86_64-linux-gnu.so (deflated 66%)
  adding: python/pandas/_libs/tslibs/conversion.cpython-37m-x86_64-linux-gnu.so (deflated 57%)
  adding: python/pandas/_libs/tslibs/vectorized.cpython-37m-x86_64-linux-gnu.so (deflated 58%)
  adding: python/pandas/_libs/tslibs/strptime.cpython-37m-x86_64-linux-gnu.so (deflated 60%)
  adding: python/pandas/_libs/tslibs/period.cpython-37m-x86_64-linux-gnu.so (deflated 62%)
  adding: python/pandas/_libs/tslibs/parsing.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/tslibs/np_datetime.cpython-37m-x86_64-linux-gnu.so (deflated 59%)
  adding: python/pandas/_libs/tslibs/timedeltas.cpython-37m-x86_64-linux-gnu.so (deflated 60%)
  adding: python/pandas/_libs/tslibs/__init__.py (deflated 66%)
  adding: python/pandas/_libs/tslibs/offsets.cpython-37m-x86_64-linux-gnu.so (deflated 61%)
  adding: python/pandas/_libs/tslibs/timestamps.cpython-37m-x86_64-linux-gnu.so (deflated 60%)
  adding: python/pandas/_libs/tslibs/__pycache__/ (stored 0%)
  adding: python/pandas/_libs/tslibs/__pycache__/__init__.cpython-37.pyc (deflated 42%)
  adding: python/pandas/_libs/__pycache__/ (stored 0%)
  adding: python/pandas/_libs/__pycache__/__init__.cpython-37.pyc (deflated 32%)
  adding: python/pandas/io/ (stored 0%)
  adding: python/pandas/io/api.py (deflated 66%)
  adding: python/pandas/io/html.py (deflated 72%)
  adding: python/pandas/io/feather_format.py (deflated 65%)
  adding: python/pandas/io/date_converters.py (deflated 74%)
  adding: python/pandas/io/clipboards.py (deflated 61%)
  adding: python/pandas/io/common.py (deflated 72%)
  adding: python/pandas/io/parquet.py (deflated 73%)
  adding: python/pandas/io/pickle.py (deflated 70%)
  adding: python/pandas/io/__init__.py (stored 0%)
  adding: python/pandas/io/sql.py (deflated 78%)
  adding: python/pandas/io/orc.py (deflated 51%)
  adding: python/pandas/io/gbq.py (deflated 69%)
  adding: python/pandas/io/parsers.py (deflated 76%)
  adding: python/pandas/io/pytables.py (deflated 77%)
  adding: python/pandas/io/stata.py (deflated 77%)
  adding: python/pandas/io/spss.py (deflated 56%)
  adding: python/pandas/io/clipboard/ (stored 0%)
  adding: python/pandas/io/clipboard/__init__.py (deflated 73%)
  adding: python/pandas/io/clipboard/__pycache__/ (stored 0%)
  adding: python/pandas/io/clipboard/__pycache__/__init__.cpython-37.pyc (deflated 57%)
  adding: python/pandas/io/formats/ (stored 0%)
  adding: python/pandas/io/formats/console.py (deflated 66%)
  adding: python/pandas/io/formats/style.py (deflated 75%)
  adding: python/pandas/io/formats/_color_data.py (deflated 64%)
  adding: python/pandas/io/formats/printing.py (deflated 69%)
  adding: python/pandas/io/formats/latex.py (deflated 77%)
  adding: python/pandas/io/formats/html.py (deflated 78%)
  adding: python/pandas/io/formats/format.py (deflated 76%)
  adding: python/pandas/io/formats/string.py (deflated 71%)
  adding: python/pandas/io/formats/info.py (deflated 77%)
  adding: python/pandas/io/formats/css.py (deflated 71%)
  adding: python/pandas/io/formats/excel.py (deflated 74%)
  adding: python/pandas/io/formats/__init__.py (stored 0%)
  adding: python/pandas/io/formats/csvs.py (deflated 73%)
  adding: python/pandas/io/formats/templates/ (stored 0%)
  adding: python/pandas/io/formats/templates/html.tpl (deflated 71%)
  adding: python/pandas/io/formats/__pycache__/ (stored 0%)
  adding: python/pandas/io/formats/__pycache__/__init__.cpython-37.pyc (deflated 19%)
  adding: python/pandas/io/formats/__pycache__/_color_data.cpython-37.pyc (deflated 48%)
  adding: python/pandas/io/formats/__pycache__/console.cpython-37.pyc (deflated 43%)
  adding: python/pandas/io/formats/__pycache__/css.cpython-37.pyc (deflated 49%)
  adding: python/pandas/io/formats/__pycache__/csvs.cpython-37.pyc (deflated 54%)
  adding: python/pandas/io/formats/__pycache__/excel.cpython-37.pyc (deflated 54%)
  adding: python/pandas/io/formats/__pycache__/format.cpython-37.pyc (deflated 59%)
  adding: python/pandas/io/formats/__pycache__/html.cpython-37.pyc (deflated 53%)
  adding: python/pandas/io/formats/__pycache__/info.cpython-37.pyc (deflated 67%)
  adding: python/pandas/io/formats/__pycache__/latex.cpython-37.pyc (deflated 65%)
  adding: python/pandas/io/formats/__pycache__/printing.cpython-37.pyc (deflated 53%)
  adding: python/pandas/io/formats/__pycache__/string.cpython-37.pyc (deflated 50%)
  adding: python/pandas/io/formats/__pycache__/style.cpython-37.pyc (deflated 63%)
  adding: python/pandas/io/excel/ (stored 0%)
  adding: python/pandas/io/excel/_xlwt.py (deflated 69%)
  adding: python/pandas/io/excel/_xlrd.py (deflated 68%)
  adding: python/pandas/io/excel/_openpyxl.py (deflated 76%)
  adding: python/pandas/io/excel/_base.py (deflated 72%)
  adding: python/pandas/io/excel/_odswriter.py (deflated 75%)
  adding: python/pandas/io/excel/_pyxlsb.py (deflated 62%)
  adding: python/pandas/io/excel/_odfreader.py (deflated 71%)
  adding: python/pandas/io/excel/_util.py (deflated 65%)
  adding: python/pandas/io/excel/__init__.py (deflated 66%)
  adding: python/pandas/io/excel/_xlsxwriter.py (deflated 74%)
  adding: python/pandas/io/excel/__pycache__/ (stored 0%)
  adding: python/pandas/io/excel/__pycache__/__init__.cpython-37.pyc (deflated 42%)
  adding: python/pandas/io/excel/__pycache__/_base.cpython-37.pyc (deflated 60%)
  adding: python/pandas/io/excel/__pycache__/_odfreader.cpython-37.pyc (deflated 49%)
  adding: python/pandas/io/excel/__pycache__/_odswriter.cpython-37.pyc (deflated 49%)
  adding: python/pandas/io/excel/__pycache__/_openpyxl.cpython-37.pyc (deflated 61%)
  adding: python/pandas/io/excel/__pycache__/_pyxlsb.cpython-37.pyc (deflated 51%)
  adding: python/pandas/io/excel/__pycache__/_util.cpython-37.pyc (deflated 51%)
  adding: python/pandas/io/excel/__pycache__/_xlrd.cpython-37.pyc (deflated 47%)
  adding: python/pandas/io/excel/__pycache__/_xlsxwriter.cpython-37.pyc (deflated 46%)
  adding: python/pandas/io/excel/__pycache__/_xlwt.cpython-37.pyc (deflated 45%)
  adding: python/pandas/io/sas/ (stored 0%)
  adding: python/pandas/io/sas/sas_xport.py (deflated 67%)
  adding: python/pandas/io/sas/sas_constants.py (deflated 76%)
  adding: python/pandas/io/sas/sasreader.py (deflated 66%)
  adding: python/pandas/io/sas/sas7bdat.py (deflated 79%)
  adding: python/pandas/io/sas/__init__.py (deflated 9%)
  adding: python/pandas/io/sas/_sas.cpython-37m-x86_64-linux-gnu.so (deflated 57%)
  adding: python/pandas/io/sas/__pycache__/ (stored 0%)
  adding: python/pandas/io/sas/__pycache__/__init__.cpython-37.pyc (deflated 18%)
  adding: python/pandas/io/sas/__pycache__/sas7bdat.cpython-37.pyc (deflated 57%)
  adding: python/pandas/io/sas/__pycache__/sas_constants.cpython-37.pyc (deflated 60%)
  adding: python/pandas/io/sas/__pycache__/sas_xport.cpython-37.pyc (deflated 47%)
  adding: python/pandas/io/sas/__pycache__/sasreader.cpython-37.pyc (deflated 50%)
  adding: python/pandas/io/json/ (stored 0%)
  adding: python/pandas/io/json/_table_schema.py (deflated 70%)
  adding: python/pandas/io/json/__init__.py (deflated 59%)
  adding: python/pandas/io/json/_normalize.py (deflated 71%)
  adding: python/pandas/io/json/_json.py (deflated 75%)
  adding: python/pandas/io/json/__pycache__/ (stored 0%)
  adding: python/pandas/io/json/__pycache__/__init__.cpython-37.pyc (deflated 36%)
  adding: python/pandas/io/json/__pycache__/_json.cpython-37.pyc (deflated 58%)
  adding: python/pandas/io/json/__pycache__/_normalize.cpython-37.pyc (deflated 59%)
  adding: python/pandas/io/json/__pycache__/_table_schema.cpython-37.pyc (deflated 55%)
  adding: python/pandas/io/__pycache__/ (stored 0%)
  adding: python/pandas/io/__pycache__/__init__.cpython-37.pyc (deflated 21%)
  adding: python/pandas/io/__pycache__/api.cpython-37.pyc (deflated 45%)
  adding: python/pandas/io/__pycache__/clipboards.cpython-37.pyc (deflated 44%)
  adding: python/pandas/io/__pycache__/common.cpython-37.pyc (deflated 53%)
  adding: python/pandas/io/__pycache__/date_converters.cpython-37.pyc (deflated 58%)
  adding: python/pandas/io/__pycache__/feather_format.cpython-37.pyc (deflated 48%)
  adding: python/pandas/io/__pycache__/gbq.cpython-37.pyc (deflated 61%)
  adding: python/pandas/io/__pycache__/html.cpython-37.pyc (deflated 61%)
  adding: python/pandas/io/__pycache__/orc.cpython-37.pyc (deflated 39%)
  adding: python/pandas/io/__pycache__/parquet.cpython-37.pyc (deflated 54%)
  adding: python/pandas/io/__pycache__/parsers.cpython-37.pyc (deflated 58%)
  adding: python/pandas/io/__pycache__/pickle.cpython-37.pyc (deflated 61%)
  adding: python/pandas/io/__pycache__/pytables.cpython-37.pyc (deflated 60%)
  adding: python/pandas/io/__pycache__/spss.cpython-37.pyc (deflated 38%)
  adding: python/pandas/io/__pycache__/sql.cpython-37.pyc (deflated 65%)
  adding: python/pandas/io/__pycache__/stata.cpython-37.pyc (deflated 61%)
  adding: python/pandas/_config/ (stored 0%)
  adding: python/pandas/_config/localization.py (deflated 64%)
  adding: python/pandas/_config/display.py (deflated 59%)
  adding: python/pandas/_config/config.py (deflated 70%)
  adding: python/pandas/_config/dates.py (deflated 54%)
  adding: python/pandas/_config/__init__.py (deflated 56%)
  adding: python/pandas/_config/__pycache__/ (stored 0%)
  adding: python/pandas/_config/__pycache__/__init__.cpython-37.pyc (deflated 37%)
  adding: python/pandas/_config/__pycache__/config.cpython-37.pyc (deflated 58%)
  adding: python/pandas/_config/__pycache__/dates.cpython-37.pyc (deflated 34%)
  adding: python/pandas/_config/__pycache__/display.cpython-37.pyc (deflated 36%)
  adding: python/pandas/_config/__pycache__/localization.cpython-37.pyc (deflated 51%)
  adding: python/pandas/tseries/ (stored 0%)
  adding: python/pandas/tseries/api.py (deflated 27%)
  adding: python/pandas/tseries/frequencies.py (deflated 75%)
  adding: python/pandas/tseries/offsets.py (deflated 72%)
  adding: python/pandas/tseries/holiday.py (deflated 76%)
  adding: python/pandas/tseries/__init__.py (stored 0%)
  adding: python/pandas/tseries/__pycache__/ (stored 0%)
  adding: python/pandas/tseries/__pycache__/__init__.cpython-37.pyc (deflated 20%)
  adding: python/pandas/tseries/__pycache__/api.cpython-37.pyc (deflated 23%)
  adding: python/pandas/tseries/__pycache__/frequencies.cpython-37.pyc (deflated 57%)
  adding: python/pandas/tseries/__pycache__/holiday.cpython-37.pyc (deflated 59%)
  adding: python/pandas/tseries/__pycache__/offsets.cpython-37.pyc (deflated 47%)
  adding: python/pandas/arrays/ (stored 0%)
  adding: python/pandas/arrays/__init__.py (deflated 58%)
  adding: python/pandas/arrays/__pycache__/ (stored 0%)
  adding: python/pandas/arrays/__pycache__/__init__.cpython-37.pyc (deflated 36%)
  adding: python/pandas/errors/ (stored 0%)
  adding: python/pandas/errors/__init__.py (deflated 64%)
  adding: python/pandas/errors/__pycache__/ (stored 0%)
  adding: python/pandas/errors/__pycache__/__init__.cpython-37.pyc (deflated 61%)
  adding: python/pandas/compat/ (stored 0%)
  adding: python/pandas/compat/pickle_compat.py (deflated 71%)
  adding: python/pandas/compat/_optional.py (deflated 62%)
  adding: python/pandas/compat/__init__.py (deflated 65%)
  adding: python/pandas/compat/chainmap.py (deflated 63%)
  adding: python/pandas/compat/numpy/ (stored 0%)
  adding: python/pandas/compat/numpy/__init__.py (deflated 62%)
  adding: python/pandas/compat/numpy/function.py (deflated 76%)
  adding: python/pandas/compat/numpy/__pycache__/ (stored 0%)
  adding: python/pandas/compat/numpy/__pycache__/__init__.cpython-37.pyc (deflated 45%)
  adding: python/pandas/compat/numpy/__pycache__/function.cpython-37.pyc (deflated 58%)
  adding: python/pandas/compat/__pycache__/ (stored 0%)
  adding: python/pandas/compat/__pycache__/__init__.cpython-37.pyc (deflated 55%)
  adding: python/pandas/compat/__pycache__/_optional.cpython-37.pyc (deflated 45%)
  adding: python/pandas/compat/__pycache__/chainmap.cpython-37.pyc (deflated 42%)
  adding: python/pandas/compat/__pycache__/pickle_compat.cpython-37.pyc (deflated 52%)
  adding: python/pandas/util/ (stored 0%)
  adding: python/pandas/util/_depr_module.py (deflated 72%)
  adding: python/pandas/util/_decorators.py (deflated 73%)
  adding: python/pandas/util/_test_decorators.py (deflated 67%)
  adding: python/pandas/util/testing.py (deflated 36%)
  adding: python/pandas/util/_tester.py (deflated 53%)
  adding: python/pandas/util/_exceptions.py (deflated 50%)
  adding: python/pandas/util/_print_versions.py (deflated 63%)
  adding: python/pandas/util/_doctools.py (deflated 70%)
  adding: python/pandas/util/__init__.py (deflated 42%)
  adding: python/pandas/util/_validators.py (deflated 71%)
  adding: python/pandas/util/__pycache__/ (stored 0%)
  adding: python/pandas/util/__pycache__/__init__.cpython-37.pyc (deflated 30%)
  adding: python/pandas/util/__pycache__/_decorators.cpython-37.pyc (deflated 59%)
  adding: python/pandas/util/__pycache__/_depr_module.cpython-37.pyc (deflated 49%)
  adding: python/pandas/util/__pycache__/_doctools.cpython-37.pyc (deflated 50%)
  adding: python/pandas/util/__pycache__/_exceptions.cpython-37.pyc (deflated 27%)
  adding: python/pandas/util/__pycache__/_print_versions.cpython-37.pyc (deflated 43%)
  adding: python/pandas/util/__pycache__/_test_decorators.cpython-37.pyc (deflated 52%)
  adding: python/pandas/util/__pycache__/_tester.cpython-37.pyc (deflated 30%)
  adding: python/pandas/util/__pycache__/_validators.cpython-37.pyc (deflated 60%)
  adding: python/pandas/util/__pycache__/testing.cpython-37.pyc (deflated 23%)
  adding: python/pandas/__pycache__/ (stored 0%)
  adding: python/pandas/__pycache__/__init__.cpython-37.pyc (deflated 46%)
  adding: python/pandas/__pycache__/_testing.cpython-37.pyc (deflated 62%)
  adding: python/pandas/__pycache__/_typing.cpython-37.pyc (deflated 42%)
  adding: python/pandas/__pycache__/_version.cpython-37.pyc (deflated 26%)
  adding: python/pandas/__pycache__/conftest.cpython-37.pyc (deflated 61%)
  adding: python/pandas/__pycache__/testing.cpython-37.pyc (deflated 28%)
  adding: python/bin/ (stored 0%)
  adding: python/bin/f2py (deflated 26%)
  adding: python/bin/f2py3 (deflated 26%)
  adding: python/bin/f2py3.7 (deflated 26%)
(env) [ec2-user@ip-172-24-121-11 lambda]$ zip -sf layer.zip
Archive contains:
  python/
  python/six.py
  python/dateutil/
  python/dateutil/__init__.py
  python/dateutil/_common.py
  python/dateutil/_version.py
  python/dateutil/easter.py
  python/dateutil/relativedelta.py
  python/dateutil/rrule.py
  python/dateutil/tzwin.py
  python/dateutil/utils.py
  python/dateutil/parser/
  python/dateutil/parser/__init__.py
  python/dateutil/parser/_parser.py
  python/dateutil/parser/isoparser.py
  python/dateutil/parser/__pycache__/
  python/dateutil/parser/__pycache__/__init__.cpython-37.pyc
  python/dateutil/parser/__pycache__/_parser.cpython-37.pyc
  python/dateutil/parser/__pycache__/isoparser.cpython-37.pyc
  python/dateutil/tz/
  python/dateutil/tz/__init__.py
  python/dateutil/tz/_common.py
  python/dateutil/tz/_factories.py
  python/dateutil/tz/tz.py
  python/dateutil/tz/win.py
  python/dateutil/tz/__pycache__/
  python/dateutil/tz/__pycache__/__init__.cpython-37.pyc
  python/dateutil/tz/__pycache__/_common.cpython-37.pyc
  python/dateutil/tz/__pycache__/_factories.cpython-37.pyc
  python/dateutil/tz/__pycache__/tz.cpython-37.pyc
  python/dateutil/tz/__pycache__/win.cpython-37.pyc
  python/dateutil/zoneinfo/
  python/dateutil/zoneinfo/__init__.py
  python/dateutil/zoneinfo/dateutil-zoneinfo.tar.gz
  python/dateutil/zoneinfo/rebuild.py
  python/dateutil/zoneinfo/__pycache__/
  python/dateutil/zoneinfo/__pycache__/__init__.cpython-37.pyc
  python/dateutil/zoneinfo/__pycache__/rebuild.cpython-37.pyc
  python/dateutil/__pycache__/
  python/dateutil/__pycache__/__init__.cpython-37.pyc
  python/dateutil/__pycache__/_common.cpython-37.pyc
  python/dateutil/__pycache__/_version.cpython-37.pyc
  python/dateutil/__pycache__/easter.cpython-37.pyc
  python/dateutil/__pycache__/relativedelta.cpython-37.pyc
  python/dateutil/__pycache__/rrule.cpython-37.pyc
  python/dateutil/__pycache__/tzwin.cpython-37.pyc
  python/dateutil/__pycache__/utils.cpython-37.pyc
  python/pytz/
  python/pytz/__init__.py
  python/pytz/exceptions.py
  python/pytz/lazy.py
  python/pytz/reference.py
  python/pytz/tzfile.py
  python/pytz/tzinfo.py
  python/pytz/zoneinfo/
  python/pytz/zoneinfo/CET
  python/pytz/zoneinfo/CST6CDT
  python/pytz/zoneinfo/Cuba
  python/pytz/zoneinfo/EET
  python/pytz/zoneinfo/EST
  python/pytz/zoneinfo/EST5EDT
  python/pytz/zoneinfo/Egypt
  python/pytz/zoneinfo/Eire
  python/pytz/zoneinfo/Factory
  python/pytz/zoneinfo/GB
  python/pytz/zoneinfo/GB-Eire
  python/pytz/zoneinfo/GMT
  python/pytz/zoneinfo/GMT+0
  python/pytz/zoneinfo/GMT-0
  python/pytz/zoneinfo/GMT0
  python/pytz/zoneinfo/Greenwich
  python/pytz/zoneinfo/HST
  python/pytz/zoneinfo/Hongkong
  python/pytz/zoneinfo/Iceland
  python/pytz/zoneinfo/Iran
  python/pytz/zoneinfo/Israel
  python/pytz/zoneinfo/Jamaica
  python/pytz/zoneinfo/Japan
  python/pytz/zoneinfo/Kwajalein
  python/pytz/zoneinfo/Libya
  python/pytz/zoneinfo/MET
  python/pytz/zoneinfo/MST
  python/pytz/zoneinfo/MST7MDT
  python/pytz/zoneinfo/NZ
  python/pytz/zoneinfo/NZ-CHAT
  python/pytz/zoneinfo/Navajo
  python/pytz/zoneinfo/PRC
  python/pytz/zoneinfo/PST8PDT
  python/pytz/zoneinfo/Poland
  python/pytz/zoneinfo/Portugal
  python/pytz/zoneinfo/ROC
  python/pytz/zoneinfo/ROK
  python/pytz/zoneinfo/Singapore
  python/pytz/zoneinfo/Turkey
  python/pytz/zoneinfo/UCT
  python/pytz/zoneinfo/UTC
  python/pytz/zoneinfo/Universal
  python/pytz/zoneinfo/W-SU
  python/pytz/zoneinfo/WET
  python/pytz/zoneinfo/Zulu
  python/pytz/zoneinfo/iso3166.tab
  python/pytz/zoneinfo/leapseconds
  python/pytz/zoneinfo/tzdata.zi
  python/pytz/zoneinfo/zone.tab
  python/pytz/zoneinfo/zone1970.tab
  python/pytz/zoneinfo/Africa/
  python/pytz/zoneinfo/Africa/Abidjan
  python/pytz/zoneinfo/Africa/Accra
  python/pytz/zoneinfo/Africa/Addis_Ababa
  python/pytz/zoneinfo/Africa/Algiers
  python/pytz/zoneinfo/Africa/Asmara
  python/pytz/zoneinfo/Africa/Asmera
  python/pytz/zoneinfo/Africa/Bamako
  python/pytz/zoneinfo/Africa/Bangui
  python/pytz/zoneinfo/Africa/Banjul
  python/pytz/zoneinfo/Africa/Bissau
  python/pytz/zoneinfo/Africa/Blantyre
  python/pytz/zoneinfo/Africa/Brazzaville
  python/pytz/zoneinfo/Africa/Bujumbura
  python/pytz/zoneinfo/Africa/Cairo
  python/pytz/zoneinfo/Africa/Casablanca
  python/pytz/zoneinfo/Africa/Ceuta
  python/pytz/zoneinfo/Africa/Conakry
  python/pytz/zoneinfo/Africa/Dakar
  python/pytz/zoneinfo/Africa/Dar_es_Salaam
  python/pytz/zoneinfo/Africa/Djibouti
  python/pytz/zoneinfo/Africa/Douala
  python/pytz/zoneinfo/Africa/El_Aaiun
  python/pytz/zoneinfo/Africa/Freetown
  python/pytz/zoneinfo/Africa/Gaborone
  python/pytz/zoneinfo/Africa/Harare
  python/pytz/zoneinfo/Africa/Johannesburg
  python/pytz/zoneinfo/Africa/Juba
  python/pytz/zoneinfo/Africa/Kampala
  python/pytz/zoneinfo/Africa/Khartoum
  python/pytz/zoneinfo/Africa/Kigali
  python/pytz/zoneinfo/Africa/Kinshasa
  python/pytz/zoneinfo/Africa/Lagos
  python/pytz/zoneinfo/Africa/Libreville
  python/pytz/zoneinfo/Africa/Lome
  python/pytz/zoneinfo/Africa/Luanda
  python/pytz/zoneinfo/Africa/Lubumbashi
  python/pytz/zoneinfo/Africa/Lusaka
  python/pytz/zoneinfo/Africa/Malabo
  python/pytz/zoneinfo/Africa/Maputo
  python/pytz/zoneinfo/Africa/Maseru
  python/pytz/zoneinfo/Africa/Mbabane
  python/pytz/zoneinfo/Africa/Mogadishu
  python/pytz/zoneinfo/Africa/Monrovia
  python/pytz/zoneinfo/Africa/Nairobi
  python/pytz/zoneinfo/Africa/Ndjamena
  python/pytz/zoneinfo/Africa/Niamey
  python/pytz/zoneinfo/Africa/Nouakchott
  python/pytz/zoneinfo/Africa/Ouagadougou
  python/pytz/zoneinfo/Africa/Porto-Novo
  python/pytz/zoneinfo/Africa/Sao_Tome
  python/pytz/zoneinfo/Africa/Timbuktu
  python/pytz/zoneinfo/Africa/Tripoli
  python/pytz/zoneinfo/Africa/Tunis
  python/pytz/zoneinfo/Africa/Windhoek
  python/pytz/zoneinfo/America/
  python/pytz/zoneinfo/America/Adak
  python/pytz/zoneinfo/America/Anchorage
  python/pytz/zoneinfo/America/Anguilla
  python/pytz/zoneinfo/America/Antigua
  python/pytz/zoneinfo/America/Araguaina
  python/pytz/zoneinfo/America/Aruba
  python/pytz/zoneinfo/America/Asuncion
  python/pytz/zoneinfo/America/Atikokan
  python/pytz/zoneinfo/America/Atka
  python/pytz/zoneinfo/America/Bahia
  python/pytz/zoneinfo/America/Bahia_Banderas
  python/pytz/zoneinfo/America/Barbados
  python/pytz/zoneinfo/America/Belem
  python/pytz/zoneinfo/America/Belize
  python/pytz/zoneinfo/America/Blanc-Sablon
  python/pytz/zoneinfo/America/Boa_Vista
  python/pytz/zoneinfo/America/Bogota
  python/pytz/zoneinfo/America/Boise
  python/pytz/zoneinfo/America/Buenos_Aires
  python/pytz/zoneinfo/America/Cambridge_Bay
  python/pytz/zoneinfo/America/Campo_Grande
  python/pytz/zoneinfo/America/Cancun
  python/pytz/zoneinfo/America/Caracas
  python/pytz/zoneinfo/America/Catamarca
  python/pytz/zoneinfo/America/Cayenne
  python/pytz/zoneinfo/America/Cayman
  python/pytz/zoneinfo/America/Chicago
  python/pytz/zoneinfo/America/Chihuahua
  python/pytz/zoneinfo/America/Coral_Harbour
  python/pytz/zoneinfo/America/Cordoba
  python/pytz/zoneinfo/America/Costa_Rica
  python/pytz/zoneinfo/America/Creston
  python/pytz/zoneinfo/America/Cuiaba
  python/pytz/zoneinfo/America/Curacao
  python/pytz/zoneinfo/America/Danmarkshavn
  python/pytz/zoneinfo/America/Dawson
  python/pytz/zoneinfo/America/Dawson_Creek
  python/pytz/zoneinfo/America/Denver
  python/pytz/zoneinfo/America/Detroit
  python/pytz/zoneinfo/America/Dominica
  python/pytz/zoneinfo/America/Edmonton
  python/pytz/zoneinfo/America/Eirunepe
  python/pytz/zoneinfo/America/El_Salvador
  python/pytz/zoneinfo/America/Ensenada
  python/pytz/zoneinfo/America/Fort_Nelson
  python/pytz/zoneinfo/America/Fort_Wayne
  python/pytz/zoneinfo/America/Fortaleza
  python/pytz/zoneinfo/America/Glace_Bay
  python/pytz/zoneinfo/America/Godthab
  python/pytz/zoneinfo/America/Goose_Bay
  python/pytz/zoneinfo/America/Grand_Turk
  python/pytz/zoneinfo/America/Grenada
  python/pytz/zoneinfo/America/Guadeloupe
  python/pytz/zoneinfo/America/Guatemala
  python/pytz/zoneinfo/America/Guayaquil
  python/pytz/zoneinfo/America/Guyana
  python/pytz/zoneinfo/America/Halifax
  python/pytz/zoneinfo/America/Havana
  python/pytz/zoneinfo/America/Hermosillo
  python/pytz/zoneinfo/America/Indianapolis
  python/pytz/zoneinfo/America/Inuvik
  python/pytz/zoneinfo/America/Iqaluit
  python/pytz/zoneinfo/America/Jamaica
  python/pytz/zoneinfo/America/Jujuy
  python/pytz/zoneinfo/America/Juneau
  python/pytz/zoneinfo/America/Knox_IN
  python/pytz/zoneinfo/America/Kralendijk
  python/pytz/zoneinfo/America/La_Paz
  python/pytz/zoneinfo/America/Lima
  python/pytz/zoneinfo/America/Los_Angeles
  python/pytz/zoneinfo/America/Louisville
  python/pytz/zoneinfo/America/Lower_Princes
  python/pytz/zoneinfo/America/Maceio
  python/pytz/zoneinfo/America/Managua
  python/pytz/zoneinfo/America/Manaus
  python/pytz/zoneinfo/America/Marigot
  python/pytz/zoneinfo/America/Martinique
  python/pytz/zoneinfo/America/Matamoros
  python/pytz/zoneinfo/America/Mazatlan
  python/pytz/zoneinfo/America/Mendoza
  python/pytz/zoneinfo/America/Menominee
  python/pytz/zoneinfo/America/Merida
  python/pytz/zoneinfo/America/Metlakatla
  python/pytz/zoneinfo/America/Mexico_City
  python/pytz/zoneinfo/America/Miquelon
  python/pytz/zoneinfo/America/Moncton
  python/pytz/zoneinfo/America/Monterrey
  python/pytz/zoneinfo/America/Montevideo
  python/pytz/zoneinfo/America/Montreal
  python/pytz/zoneinfo/America/Montserrat
  python/pytz/zoneinfo/America/Nassau
  python/pytz/zoneinfo/America/New_York
  python/pytz/zoneinfo/America/Nipigon
  python/pytz/zoneinfo/America/Nome
  python/pytz/zoneinfo/America/Noronha
  python/pytz/zoneinfo/America/Nuuk
  python/pytz/zoneinfo/America/Ojinaga
  python/pytz/zoneinfo/America/Panama
  python/pytz/zoneinfo/America/Pangnirtung
  python/pytz/zoneinfo/America/Paramaribo
  python/pytz/zoneinfo/America/Phoenix
  python/pytz/zoneinfo/America/Port-au-Prince
  python/pytz/zoneinfo/America/Port_of_Spain
  python/pytz/zoneinfo/America/Porto_Acre
  python/pytz/zoneinfo/America/Porto_Velho
  python/pytz/zoneinfo/America/Puerto_Rico
  python/pytz/zoneinfo/America/Punta_Arenas
  python/pytz/zoneinfo/America/Rainy_River
  python/pytz/zoneinfo/America/Rankin_Inlet
  python/pytz/zoneinfo/America/Recife
  python/pytz/zoneinfo/America/Regina
  python/pytz/zoneinfo/America/Resolute
  python/pytz/zoneinfo/America/Rio_Branco
  python/pytz/zoneinfo/America/Rosario
  python/pytz/zoneinfo/America/Santa_Isabel
  python/pytz/zoneinfo/America/Santarem
  python/pytz/zoneinfo/America/Santiago
  python/pytz/zoneinfo/America/Santo_Domingo
  python/pytz/zoneinfo/America/Sao_Paulo
  python/pytz/zoneinfo/America/Scoresbysund
  python/pytz/zoneinfo/America/Shiprock
  python/pytz/zoneinfo/America/Sitka
  python/pytz/zoneinfo/America/St_Barthelemy
  python/pytz/zoneinfo/America/St_Johns
  python/pytz/zoneinfo/America/St_Kitts
  python/pytz/zoneinfo/America/St_Lucia
  python/pytz/zoneinfo/America/St_Thomas
  python/pytz/zoneinfo/America/St_Vincent
  python/pytz/zoneinfo/America/Swift_Current
  python/pytz/zoneinfo/America/Tegucigalpa
  python/pytz/zoneinfo/America/Thule
  python/pytz/zoneinfo/America/Thunder_Bay
  python/pytz/zoneinfo/America/Tijuana
  python/pytz/zoneinfo/America/Toronto
  python/pytz/zoneinfo/America/Tortola
  python/pytz/zoneinfo/America/Vancouver
  python/pytz/zoneinfo/America/Virgin
  python/pytz/zoneinfo/America/Whitehorse
  python/pytz/zoneinfo/America/Winnipeg
  python/pytz/zoneinfo/America/Yakutat
  python/pytz/zoneinfo/America/Yellowknife
  python/pytz/zoneinfo/America/Argentina/
  python/pytz/zoneinfo/America/Argentina/Buenos_Aires
  python/pytz/zoneinfo/America/Argentina/Catamarca
  python/pytz/zoneinfo/America/Argentina/ComodRivadavia
  python/pytz/zoneinfo/America/Argentina/Cordoba
  python/pytz/zoneinfo/America/Argentina/Jujuy
  python/pytz/zoneinfo/America/Argentina/La_Rioja
  python/pytz/zoneinfo/America/Argentina/Mendoza
  python/pytz/zoneinfo/America/Argentina/Rio_Gallegos
  python/pytz/zoneinfo/America/Argentina/Salta
  python/pytz/zoneinfo/America/Argentina/San_Juan
  python/pytz/zoneinfo/America/Argentina/San_Luis
  python/pytz/zoneinfo/America/Argentina/Tucuman
  python/pytz/zoneinfo/America/Argentina/Ushuaia
  python/pytz/zoneinfo/America/Indiana/
  python/pytz/zoneinfo/America/Indiana/Indianapolis
  python/pytz/zoneinfo/America/Indiana/Knox
  python/pytz/zoneinfo/America/Indiana/Marengo
  python/pytz/zoneinfo/America/Indiana/Petersburg
  python/pytz/zoneinfo/America/Indiana/Tell_City
  python/pytz/zoneinfo/America/Indiana/Vevay
  python/pytz/zoneinfo/America/Indiana/Vincennes
  python/pytz/zoneinfo/America/Indiana/Winamac
  python/pytz/zoneinfo/America/Kentucky/
  python/pytz/zoneinfo/America/Kentucky/Louisville
  python/pytz/zoneinfo/America/Kentucky/Monticello
  python/pytz/zoneinfo/America/North_Dakota/
  python/pytz/zoneinfo/America/North_Dakota/Beulah
  python/pytz/zoneinfo/America/North_Dakota/Center
  python/pytz/zoneinfo/America/North_Dakota/New_Salem
  python/pytz/zoneinfo/Antarctica/
  python/pytz/zoneinfo/Antarctica/Casey
  python/pytz/zoneinfo/Antarctica/Davis
  python/pytz/zoneinfo/Antarctica/DumontDUrville
  python/pytz/zoneinfo/Antarctica/Macquarie
  python/pytz/zoneinfo/Antarctica/Mawson
  python/pytz/zoneinfo/Antarctica/McMurdo
  python/pytz/zoneinfo/Antarctica/Palmer
  python/pytz/zoneinfo/Antarctica/Rothera
  python/pytz/zoneinfo/Antarctica/South_Pole
  python/pytz/zoneinfo/Antarctica/Syowa
  python/pytz/zoneinfo/Antarctica/Troll
  python/pytz/zoneinfo/Antarctica/Vostok
  python/pytz/zoneinfo/Arctic/
  python/pytz/zoneinfo/Arctic/Longyearbyen
  python/pytz/zoneinfo/Asia/
  python/pytz/zoneinfo/Asia/Aden
  python/pytz/zoneinfo/Asia/Almaty
  python/pytz/zoneinfo/Asia/Amman
  python/pytz/zoneinfo/Asia/Anadyr
  python/pytz/zoneinfo/Asia/Aqtau
  python/pytz/zoneinfo/Asia/Aqtobe
  python/pytz/zoneinfo/Asia/Ashgabat
  python/pytz/zoneinfo/Asia/Ashkhabad
  python/pytz/zoneinfo/Asia/Atyrau
  python/pytz/zoneinfo/Asia/Baghdad
  python/pytz/zoneinfo/Asia/Bahrain
  python/pytz/zoneinfo/Asia/Baku
  python/pytz/zoneinfo/Asia/Bangkok
  python/pytz/zoneinfo/Asia/Barnaul
  python/pytz/zoneinfo/Asia/Beirut
  python/pytz/zoneinfo/Asia/Bishkek
  python/pytz/zoneinfo/Asia/Brunei
  python/pytz/zoneinfo/Asia/Calcutta
  python/pytz/zoneinfo/Asia/Chita
  python/pytz/zoneinfo/Asia/Choibalsan
  python/pytz/zoneinfo/Asia/Chongqing
  python/pytz/zoneinfo/Asia/Chungking
  python/pytz/zoneinfo/Asia/Colombo
  python/pytz/zoneinfo/Asia/Dacca
  python/pytz/zoneinfo/Asia/Damascus
  python/pytz/zoneinfo/Asia/Dhaka
  python/pytz/zoneinfo/Asia/Dili
  python/pytz/zoneinfo/Asia/Dubai
  python/pytz/zoneinfo/Asia/Dushanbe
  python/pytz/zoneinfo/Asia/Famagusta
  python/pytz/zoneinfo/Asia/Gaza
  python/pytz/zoneinfo/Asia/Harbin
  python/pytz/zoneinfo/Asia/Hebron
  python/pytz/zoneinfo/Asia/Ho_Chi_Minh
  python/pytz/zoneinfo/Asia/Hong_Kong
  python/pytz/zoneinfo/Asia/Hovd
  python/pytz/zoneinfo/Asia/Irkutsk
  python/pytz/zoneinfo/Asia/Istanbul
  python/pytz/zoneinfo/Asia/Jakarta
  python/pytz/zoneinfo/Asia/Jayapura
  python/pytz/zoneinfo/Asia/Jerusalem
  python/pytz/zoneinfo/Asia/Kabul
  python/pytz/zoneinfo/Asia/Kamchatka
  python/pytz/zoneinfo/Asia/Karachi
  python/pytz/zoneinfo/Asia/Kashgar
  python/pytz/zoneinfo/Asia/Kathmandu
  python/pytz/zoneinfo/Asia/Katmandu
  python/pytz/zoneinfo/Asia/Khandyga
  python/pytz/zoneinfo/Asia/Kolkata
  python/pytz/zoneinfo/Asia/Krasnoyarsk
  python/pytz/zoneinfo/Asia/Kuala_Lumpur
  python/pytz/zoneinfo/Asia/Kuching
  python/pytz/zoneinfo/Asia/Kuwait
  python/pytz/zoneinfo/Asia/Macao
  python/pytz/zoneinfo/Asia/Macau
  python/pytz/zoneinfo/Asia/Magadan
  python/pytz/zoneinfo/Asia/Makassar
  python/pytz/zoneinfo/Asia/Manila
  python/pytz/zoneinfo/Asia/Muscat
  python/pytz/zoneinfo/Asia/Nicosia
  python/pytz/zoneinfo/Asia/Novokuznetsk
  python/pytz/zoneinfo/Asia/Novosibirsk
  python/pytz/zoneinfo/Asia/Omsk
  python/pytz/zoneinfo/Asia/Oral
  python/pytz/zoneinfo/Asia/Phnom_Penh
  python/pytz/zoneinfo/Asia/Pontianak
  python/pytz/zoneinfo/Asia/Pyongyang
  python/pytz/zoneinfo/Asia/Qatar
  python/pytz/zoneinfo/Asia/Qostanay
  python/pytz/zoneinfo/Asia/Qyzylorda
  python/pytz/zoneinfo/Asia/Rangoon
  python/pytz/zoneinfo/Asia/Riyadh
  python/pytz/zoneinfo/Asia/Saigon
  python/pytz/zoneinfo/Asia/Sakhalin
  python/pytz/zoneinfo/Asia/Samarkand
  python/pytz/zoneinfo/Asia/Seoul
  python/pytz/zoneinfo/Asia/Shanghai
  python/pytz/zoneinfo/Asia/Singapore
  python/pytz/zoneinfo/Asia/Srednekolymsk
  python/pytz/zoneinfo/Asia/Taipei
  python/pytz/zoneinfo/Asia/Tashkent
  python/pytz/zoneinfo/Asia/Tbilisi
  python/pytz/zoneinfo/Asia/Tehran
  python/pytz/zoneinfo/Asia/Tel_Aviv
  python/pytz/zoneinfo/Asia/Thimbu
  python/pytz/zoneinfo/Asia/Thimphu
  python/pytz/zoneinfo/Asia/Tokyo
  python/pytz/zoneinfo/Asia/Tomsk
  python/pytz/zoneinfo/Asia/Ujung_Pandang
  python/pytz/zoneinfo/Asia/Ulaanbaatar
  python/pytz/zoneinfo/Asia/Ulan_Bator
  python/pytz/zoneinfo/Asia/Urumqi
  python/pytz/zoneinfo/Asia/Ust-Nera
  python/pytz/zoneinfo/Asia/Vientiane
  python/pytz/zoneinfo/Asia/Vladivostok
  python/pytz/zoneinfo/Asia/Yakutsk
  python/pytz/zoneinfo/Asia/Yangon
  python/pytz/zoneinfo/Asia/Yekaterinburg
  python/pytz/zoneinfo/Asia/Yerevan
  python/pytz/zoneinfo/Atlantic/
  python/pytz/zoneinfo/Atlantic/Azores
  python/pytz/zoneinfo/Atlantic/Bermuda
  python/pytz/zoneinfo/Atlantic/Canary
  python/pytz/zoneinfo/Atlantic/Cape_Verde
  python/pytz/zoneinfo/Atlantic/Faeroe
  python/pytz/zoneinfo/Atlantic/Faroe
  python/pytz/zoneinfo/Atlantic/Jan_Mayen
  python/pytz/zoneinfo/Atlantic/Madeira
  python/pytz/zoneinfo/Atlantic/Reykjavik
  python/pytz/zoneinfo/Atlantic/South_Georgia
  python/pytz/zoneinfo/Atlantic/St_Helena
  python/pytz/zoneinfo/Atlantic/Stanley
  python/pytz/zoneinfo/Australia/
  python/pytz/zoneinfo/Australia/ACT
  python/pytz/zoneinfo/Australia/Adelaide
  python/pytz/zoneinfo/Australia/Brisbane
  python/pytz/zoneinfo/Australia/Broken_Hill
  python/pytz/zoneinfo/Australia/Canberra
  python/pytz/zoneinfo/Australia/Currie
  python/pytz/zoneinfo/Australia/Darwin
  python/pytz/zoneinfo/Australia/Eucla
  python/pytz/zoneinfo/Australia/Hobart
  python/pytz/zoneinfo/Australia/LHI
  python/pytz/zoneinfo/Australia/Lindeman
  python/pytz/zoneinfo/Australia/Lord_Howe
  python/pytz/zoneinfo/Australia/Melbourne
  python/pytz/zoneinfo/Australia/NSW
  python/pytz/zoneinfo/Australia/North
  python/pytz/zoneinfo/Australia/Perth
  python/pytz/zoneinfo/Australia/Queensland
  python/pytz/zoneinfo/Australia/South
  python/pytz/zoneinfo/Australia/Sydney
  python/pytz/zoneinfo/Australia/Tasmania
  python/pytz/zoneinfo/Australia/Victoria
  python/pytz/zoneinfo/Australia/West
  python/pytz/zoneinfo/Australia/Yancowinna
  python/pytz/zoneinfo/Brazil/
  python/pytz/zoneinfo/Brazil/Acre
  python/pytz/zoneinfo/Brazil/DeNoronha
  python/pytz/zoneinfo/Brazil/East
  python/pytz/zoneinfo/Brazil/West
  python/pytz/zoneinfo/Canada/
  python/pytz/zoneinfo/Canada/Atlantic
  python/pytz/zoneinfo/Canada/Central
  python/pytz/zoneinfo/Canada/Eastern
  python/pytz/zoneinfo/Canada/Mountain
  python/pytz/zoneinfo/Canada/Newfoundland
  python/pytz/zoneinfo/Canada/Pacific
  python/pytz/zoneinfo/Canada/Saskatchewan
  python/pytz/zoneinfo/Canada/Yukon
  python/pytz/zoneinfo/Chile/
  python/pytz/zoneinfo/Chile/Continental
  python/pytz/zoneinfo/Chile/EasterIsland
  python/pytz/zoneinfo/Etc/
  python/pytz/zoneinfo/Etc/GMT
  python/pytz/zoneinfo/Etc/GMT+0
  python/pytz/zoneinfo/Etc/GMT+1
  python/pytz/zoneinfo/Etc/GMT+10
  python/pytz/zoneinfo/Etc/GMT+11
  python/pytz/zoneinfo/Etc/GMT+12
  python/pytz/zoneinfo/Etc/GMT+2
  python/pytz/zoneinfo/Etc/GMT+3
  python/pytz/zoneinfo/Etc/GMT+4
  python/pytz/zoneinfo/Etc/GMT+5
  python/pytz/zoneinfo/Etc/GMT+6
  python/pytz/zoneinfo/Etc/GMT+7
  python/pytz/zoneinfo/Etc/GMT+8
  python/pytz/zoneinfo/Etc/GMT+9
  python/pytz/zoneinfo/Etc/GMT-0
  python/pytz/zoneinfo/Etc/GMT-1
  python/pytz/zoneinfo/Etc/GMT-10
  python/pytz/zoneinfo/Etc/GMT-11
  python/pytz/zoneinfo/Etc/GMT-12
  python/pytz/zoneinfo/Etc/GMT-13
  python/pytz/zoneinfo/Etc/GMT-14
  python/pytz/zoneinfo/Etc/GMT-2
  python/pytz/zoneinfo/Etc/GMT-3
  python/pytz/zoneinfo/Etc/GMT-4
  python/pytz/zoneinfo/Etc/GMT-5
  python/pytz/zoneinfo/Etc/GMT-6
  python/pytz/zoneinfo/Etc/GMT-7
  python/pytz/zoneinfo/Etc/GMT-8
  python/pytz/zoneinfo/Etc/GMT-9
  python/pytz/zoneinfo/Etc/GMT0
  python/pytz/zoneinfo/Etc/Greenwich
  python/pytz/zoneinfo/Etc/UCT
  python/pytz/zoneinfo/Etc/UTC
  python/pytz/zoneinfo/Etc/Universal
  python/pytz/zoneinfo/Etc/Zulu
  python/pytz/zoneinfo/Europe/
  python/pytz/zoneinfo/Europe/Amsterdam
  python/pytz/zoneinfo/Europe/Andorra
  python/pytz/zoneinfo/Europe/Astrakhan
  python/pytz/zoneinfo/Europe/Athens
  python/pytz/zoneinfo/Europe/Belfast
  python/pytz/zoneinfo/Europe/Belgrade
  python/pytz/zoneinfo/Europe/Berlin
  python/pytz/zoneinfo/Europe/Bratislava
  python/pytz/zoneinfo/Europe/Brussels
  python/pytz/zoneinfo/Europe/Bucharest
  python/pytz/zoneinfo/Europe/Budapest
  python/pytz/zoneinfo/Europe/Busingen
  python/pytz/zoneinfo/Europe/Chisinau
  python/pytz/zoneinfo/Europe/Copenhagen
  python/pytz/zoneinfo/Europe/Dublin
  python/pytz/zoneinfo/Europe/Gibraltar
  python/pytz/zoneinfo/Europe/Guernsey
  python/pytz/zoneinfo/Europe/Helsinki
  python/pytz/zoneinfo/Europe/Isle_of_Man
  python/pytz/zoneinfo/Europe/Istanbul
  python/pytz/zoneinfo/Europe/Jersey
  python/pytz/zoneinfo/Europe/Kaliningrad
  python/pytz/zoneinfo/Europe/Kiev
  python/pytz/zoneinfo/Europe/Kirov
  python/pytz/zoneinfo/Europe/Lisbon
  python/pytz/zoneinfo/Europe/Ljubljana
  python/pytz/zoneinfo/Europe/London
  python/pytz/zoneinfo/Europe/Luxembourg
  python/pytz/zoneinfo/Europe/Madrid
  python/pytz/zoneinfo/Europe/Malta
  python/pytz/zoneinfo/Europe/Mariehamn
  python/pytz/zoneinfo/Europe/Minsk
  python/pytz/zoneinfo/Europe/Monaco
  python/pytz/zoneinfo/Europe/Moscow
  python/pytz/zoneinfo/Europe/Nicosia
  python/pytz/zoneinfo/Europe/Oslo
  python/pytz/zoneinfo/Europe/Paris
  python/pytz/zoneinfo/Europe/Podgorica
  python/pytz/zoneinfo/Europe/Prague
  python/pytz/zoneinfo/Europe/Riga
  python/pytz/zoneinfo/Europe/Rome
  python/pytz/zoneinfo/Europe/Samara
  python/pytz/zoneinfo/Europe/San_Marino
  python/pytz/zoneinfo/Europe/Sarajevo
  python/pytz/zoneinfo/Europe/Saratov
  python/pytz/zoneinfo/Europe/Simferopol
  python/pytz/zoneinfo/Europe/Skopje
  python/pytz/zoneinfo/Europe/Sofia
  python/pytz/zoneinfo/Europe/Stockholm
  python/pytz/zoneinfo/Europe/Tallinn
  python/pytz/zoneinfo/Europe/Tirane
  python/pytz/zoneinfo/Europe/Tiraspol
  python/pytz/zoneinfo/Europe/Ulyanovsk
  python/pytz/zoneinfo/Europe/Uzhgorod
  python/pytz/zoneinfo/Europe/Vaduz
  python/pytz/zoneinfo/Europe/Vatican
  python/pytz/zoneinfo/Europe/Vienna
  python/pytz/zoneinfo/Europe/Vilnius
  python/pytz/zoneinfo/Europe/Volgograd
  python/pytz/zoneinfo/Europe/Warsaw
  python/pytz/zoneinfo/Europe/Zagreb
  python/pytz/zoneinfo/Europe/Zaporozhye
  python/pytz/zoneinfo/Europe/Zurich
  python/pytz/zoneinfo/Indian/
  python/pytz/zoneinfo/Indian/Antananarivo
  python/pytz/zoneinfo/Indian/Chagos
  python/pytz/zoneinfo/Indian/Christmas
  python/pytz/zoneinfo/Indian/Cocos
  python/pytz/zoneinfo/Indian/Comoro
  python/pytz/zoneinfo/Indian/Kerguelen
  python/pytz/zoneinfo/Indian/Mahe
  python/pytz/zoneinfo/Indian/Maldives
  python/pytz/zoneinfo/Indian/Mauritius
  python/pytz/zoneinfo/Indian/Mayotte
  python/pytz/zoneinfo/Indian/Reunion
  python/pytz/zoneinfo/Mexico/
  python/pytz/zoneinfo/Mexico/BajaNorte
  python/pytz/zoneinfo/Mexico/BajaSur
  python/pytz/zoneinfo/Mexico/General
  python/pytz/zoneinfo/Pacific/
  python/pytz/zoneinfo/Pacific/Apia
  python/pytz/zoneinfo/Pacific/Auckland
  python/pytz/zoneinfo/Pacific/Bougainville
  python/pytz/zoneinfo/Pacific/Chatham
  python/pytz/zoneinfo/Pacific/Chuuk
  python/pytz/zoneinfo/Pacific/Easter
  python/pytz/zoneinfo/Pacific/Efate
  python/pytz/zoneinfo/Pacific/Enderbury
  python/pytz/zoneinfo/Pacific/Fakaofo
  python/pytz/zoneinfo/Pacific/Fiji
  python/pytz/zoneinfo/Pacific/Funafuti
  python/pytz/zoneinfo/Pacific/Galapagos
  python/pytz/zoneinfo/Pacific/Gambier
  python/pytz/zoneinfo/Pacific/Guadalcanal
  python/pytz/zoneinfo/Pacific/Guam
  python/pytz/zoneinfo/Pacific/Honolulu
  python/pytz/zoneinfo/Pacific/Johnston
  python/pytz/zoneinfo/Pacific/Kiritimati
  python/pytz/zoneinfo/Pacific/Kosrae
  python/pytz/zoneinfo/Pacific/Kwajalein
  python/pytz/zoneinfo/Pacific/Majuro
  python/pytz/zoneinfo/Pacific/Marquesas
  python/pytz/zoneinfo/Pacific/Midway
  python/pytz/zoneinfo/Pacific/Nauru
  python/pytz/zoneinfo/Pacific/Niue
  python/pytz/zoneinfo/Pacific/Norfolk
  python/pytz/zoneinfo/Pacific/Noumea
  python/pytz/zoneinfo/Pacific/Pago_Pago
  python/pytz/zoneinfo/Pacific/Palau
  python/pytz/zoneinfo/Pacific/Pitcairn
  python/pytz/zoneinfo/Pacific/Pohnpei
  python/pytz/zoneinfo/Pacific/Ponape
  python/pytz/zoneinfo/Pacific/Port_Moresby
  python/pytz/zoneinfo/Pacific/Rarotonga
  python/pytz/zoneinfo/Pacific/Saipan
  python/pytz/zoneinfo/Pacific/Samoa
  python/pytz/zoneinfo/Pacific/Tahiti
  python/pytz/zoneinfo/Pacific/Tarawa
  python/pytz/zoneinfo/Pacific/Tongatapu
  python/pytz/zoneinfo/Pacific/Truk
  python/pytz/zoneinfo/Pacific/Wake
  python/pytz/zoneinfo/Pacific/Wallis
  python/pytz/zoneinfo/Pacific/Yap
  python/pytz/zoneinfo/US/
  python/pytz/zoneinfo/US/Alaska
  python/pytz/zoneinfo/US/Aleutian
  python/pytz/zoneinfo/US/Arizona
  python/pytz/zoneinfo/US/Central
  python/pytz/zoneinfo/US/East-Indiana
  python/pytz/zoneinfo/US/Eastern
  python/pytz/zoneinfo/US/Hawaii
  python/pytz/zoneinfo/US/Indiana-Starke
  python/pytz/zoneinfo/US/Michigan
  python/pytz/zoneinfo/US/Mountain
  python/pytz/zoneinfo/US/Pacific
  python/pytz/zoneinfo/US/Samoa
  python/pytz/__pycache__/
  python/pytz/__pycache__/__init__.cpython-37.pyc
  python/pytz/__pycache__/exceptions.cpython-37.pyc
  python/pytz/__pycache__/lazy.cpython-37.pyc
  python/pytz/__pycache__/reference.cpython-37.pyc
  python/pytz/__pycache__/tzfile.cpython-37.pyc
  python/pytz/__pycache__/tzinfo.cpython-37.pyc
  python/numpy.libs/
  python/numpy.libs/libquadmath-2d0c479f.so.0.0.0
  python/numpy.libs/libz-eb09ad1d.so.1.2.3
  python/numpy.libs/libopenblasp-r0-5bebc122.3.13.dev.so
  python/numpy.libs/libgfortran-2e0d59d6.so.5.0.0
  python/numpy/
  python/numpy/char.pyi
  python/numpy/_globals.py
  python/numpy/setup.py
  python/numpy/__init__.py
  python/numpy/version.py
  python/numpy/conftest.py
  python/numpy/__init__.pyi
  python/numpy/__init__.pxd
  python/numpy/_distributor_init.py
  python/numpy/__init__.cython-30.pxd
  python/numpy/emath.pyi
  python/numpy/__config__.py
  python/numpy/ctypeslib.py
  python/numpy/ctypeslib.pyi
  python/numpy/LICENSE.txt
  python/numpy/rec.pyi
  python/numpy/_pytesttester.py
  python/numpy/matlib.py
  python/numpy/dual.py
  python/numpy/py.typed
  python/numpy/tests/
  python/numpy/tests/__init__.py
  python/numpy/tests/test_warnings.py
  python/numpy/tests/test_reloading.py
  python/numpy/tests/test_numpy_version.py
  python/numpy/tests/test_ctypeslib.py
  python/numpy/tests/test_scripts.py
  python/numpy/tests/test_public_api.py
  python/numpy/tests/test_matlib.py
  python/numpy/tests/__pycache__/
  python/numpy/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/tests/__pycache__/test_ctypeslib.cpython-37.pyc
  python/numpy/tests/__pycache__/test_matlib.cpython-37.pyc
  python/numpy/tests/__pycache__/test_numpy_version.cpython-37.pyc
  python/numpy/tests/__pycache__/test_public_api.cpython-37.pyc
  python/numpy/tests/__pycache__/test_reloading.cpython-37.pyc
  python/numpy/tests/__pycache__/test_scripts.cpython-37.pyc
  python/numpy/tests/__pycache__/test_warnings.cpython-37.pyc
  python/numpy/random/
  python/numpy/random/setup.py
  python/numpy/random/__init__.py
  python/numpy/random/_mt19937.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/bit_generator.pxd
  python/numpy/random/bit_generator.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/__init__.pyi
  python/numpy/random/_common.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/c_distributions.pxd
  python/numpy/random/__init__.pxd
  python/numpy/random/_sfc64.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_bounded_integers.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_bounded_integers.pxd
  python/numpy/random/_philox.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_generator.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_pcg64.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/mtrand.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_common.pxd
  python/numpy/random/_pickle.py
  python/numpy/random/_examples/
  python/numpy/random/_examples/numba/
  python/numpy/random/_examples/numba/extending.py
  python/numpy/random/_examples/numba/extending_distributions.py
  python/numpy/random/_examples/numba/__pycache__/
  python/numpy/random/_examples/numba/__pycache__/extending.cpython-37.pyc
  python/numpy/random/_examples/numba/__pycache__/extending_distributions.cpython-37.pyc
  python/numpy/random/_examples/cython/
  python/numpy/random/_examples/cython/setup.py
  python/numpy/random/_examples/cython/extending_distributions.pyx
  python/numpy/random/_examples/cython/extending.pyx
  python/numpy/random/_examples/cython/__pycache__/
  python/numpy/random/_examples/cython/__pycache__/setup.cpython-37.pyc
  python/numpy/random/_examples/cffi/
  python/numpy/random/_examples/cffi/extending.py
  python/numpy/random/_examples/cffi/parse.py
  python/numpy/random/_examples/cffi/__pycache__/
  python/numpy/random/_examples/cffi/__pycache__/extending.cpython-37.pyc
  python/numpy/random/_examples/cffi/__pycache__/parse.cpython-37.pyc
  python/numpy/random/tests/
  python/numpy/random/tests/test_generator_mt19937_regressions.py
  python/numpy/random/tests/__init__.py
  python/numpy/random/tests/test_generator_mt19937.py
  python/numpy/random/tests/test_smoke.py
  python/numpy/random/tests/test_random.py
  python/numpy/random/tests/test_direct.py
  python/numpy/random/tests/test_randomstate.py
  python/numpy/random/tests/test_regression.py
  python/numpy/random/tests/test_extending.py
  python/numpy/random/tests/test_randomstate_regression.py
  python/numpy/random/tests/test_seed_sequence.py
  python/numpy/random/tests/data/
  python/numpy/random/tests/data/mt19937-testset-1.csv
  python/numpy/random/tests/data/philox-testset-2.csv
  python/numpy/random/tests/data/__init__.py
  python/numpy/random/tests/data/pcg64-testset-2.csv
  python/numpy/random/tests/data/sfc64-testset-2.csv
  python/numpy/random/tests/data/pcg64-testset-1.csv
  python/numpy/random/tests/data/philox-testset-1.csv
  python/numpy/random/tests/data/sfc64-testset-1.csv
  python/numpy/random/tests/data/mt19937-testset-2.csv
  python/numpy/random/tests/data/__pycache__/
  python/numpy/random/tests/data/__pycache__/__init__.cpython-37.pyc
  python/numpy/random/tests/__pycache__/
  python/numpy/random/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_direct.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_extending.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_generator_mt19937.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_generator_mt19937_regressions.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_random.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_randomstate.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_randomstate_regression.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_seed_sequence.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_smoke.cpython-37.pyc
  python/numpy/random/lib/
  python/numpy/random/lib/libnpyrandom.a
  python/numpy/random/__pycache__/
  python/numpy/random/__pycache__/__init__.cpython-37.pyc
  python/numpy/random/__pycache__/_pickle.cpython-37.pyc
  python/numpy/random/__pycache__/setup.cpython-37.pyc
  python/numpy/fft/
  python/numpy/fft/_pocketfft.py
  python/numpy/fft/setup.py
  python/numpy/fft/__init__.py
  python/numpy/fft/helper.py
  python/numpy/fft/__init__.pyi
  python/numpy/fft/_pocketfft_internal.cpython-37m-x86_64-linux-gnu.so
  python/numpy/fft/tests/
  python/numpy/fft/tests/test_pocketfft.py
  python/numpy/fft/tests/__init__.py
  python/numpy/fft/tests/test_helper.py
  python/numpy/fft/tests/__pycache__/
  python/numpy/fft/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/fft/tests/__pycache__/test_helper.cpython-37.pyc
  python/numpy/fft/tests/__pycache__/test_pocketfft.cpython-37.pyc
  python/numpy/fft/__pycache__/
  python/numpy/fft/__pycache__/__init__.cpython-37.pyc
  python/numpy/fft/__pycache__/_pocketfft.cpython-37.pyc
  python/numpy/fft/__pycache__/helper.cpython-37.pyc
  python/numpy/fft/__pycache__/setup.cpython-37.pyc
  python/numpy/typing/
  python/numpy/typing/_array_like.py
  python/numpy/typing/setup.py
  python/numpy/typing/__init__.py
  python/numpy/typing/_add_docstring.py
  python/numpy/typing/_callable.py
  python/numpy/typing/_dtype_like.py
  python/numpy/typing/_shape.py
  python/numpy/typing/_scalars.py
  python/numpy/typing/tests/
  python/numpy/typing/tests/__init__.py
  python/numpy/typing/tests/test_typing.py
  python/numpy/typing/tests/test_isfile.py
  python/numpy/typing/tests/data/
  python/numpy/typing/tests/data/mypy.ini
  python/numpy/typing/tests/data/pass/
  python/numpy/typing/tests/data/pass/numerictypes.py
  python/numpy/typing/tests/data/pass/bitwise_ops.py
  python/numpy/typing/tests/data/pass/numeric.py
  python/numpy/typing/tests/data/pass/array_constructors.py
  python/numpy/typing/tests/data/pass/warnings_and_errors.py
  python/numpy/typing/tests/data/pass/ndarray_misc.py
  python/numpy/typing/tests/data/pass/simple.py
  python/numpy/typing/tests/data/pass/fromnumeric.py
  python/numpy/typing/tests/data/pass/ndarray_conversion.py
  python/numpy/typing/tests/data/pass/ndarray_shape_manipulation.py
  python/numpy/typing/tests/data/pass/arithmetic.py
  python/numpy/typing/tests/data/pass/modules.py
  python/numpy/typing/tests/data/pass/simple_py3.py
  python/numpy/typing/tests/data/pass/mod.py
  python/numpy/typing/tests/data/pass/dtype.py
  python/numpy/typing/tests/data/pass/ufunc_config.py
  python/numpy/typing/tests/data/pass/ufuncs.py
  python/numpy/typing/tests/data/pass/scalars.py
  python/numpy/typing/tests/data/pass/flatiter.py
  python/numpy/typing/tests/data/pass/array_like.py
  python/numpy/typing/tests/data/pass/literal.py
  python/numpy/typing/tests/data/pass/__pycache__/
  python/numpy/typing/tests/data/pass/__pycache__/arithmetic.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/array_constructors.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/array_like.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/bitwise_ops.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/dtype.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/flatiter.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/literal.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/mod.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/modules.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ndarray_conversion.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ndarray_misc.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ndarray_shape_manipulation.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/numeric.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/scalars.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/simple.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/simple_py3.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ufunc_config.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ufuncs.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/warnings_and_errors.cpython-37.pyc
  python/numpy/typing/tests/data/fail/
  python/numpy/typing/tests/data/fail/numerictypes.py
  python/numpy/typing/tests/data/fail/bitwise_ops.py
  python/numpy/typing/tests/data/fail/array_constructors.py
  python/numpy/typing/tests/data/fail/warnings_and_errors.py
  python/numpy/typing/tests/data/fail/ndarray_misc.py
  python/numpy/typing/tests/data/fail/fromnumeric.py
  python/numpy/typing/tests/data/fail/arithmetic.py
  python/numpy/typing/tests/data/fail/modules.py
  python/numpy/typing/tests/data/fail/constants.py
  python/numpy/typing/tests/data/fail/ndarray.py
  python/numpy/typing/tests/data/fail/dtype.py
  python/numpy/typing/tests/data/fail/ufunc_config.py
  python/numpy/typing/tests/data/fail/ufuncs.py
  python/numpy/typing/tests/data/fail/scalars.py
  python/numpy/typing/tests/data/fail/flatiter.py
  python/numpy/typing/tests/data/fail/array_like.py
  python/numpy/typing/tests/data/fail/__pycache__/
  python/numpy/typing/tests/data/fail/__pycache__/arithmetic.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/array_constructors.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/array_like.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/bitwise_ops.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/constants.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/dtype.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/flatiter.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/modules.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ndarray.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ndarray_misc.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/scalars.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ufunc_config.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ufuncs.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/warnings_and_errors.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/
  python/numpy/typing/tests/data/reveal/numerictypes.py
  python/numpy/typing/tests/data/reveal/bitwise_ops.py
  python/numpy/typing/tests/data/reveal/numeric.py
  python/numpy/typing/tests/data/reveal/array_constructors.py
  python/numpy/typing/tests/data/reveal/warnings_and_errors.py
  python/numpy/typing/tests/data/reveal/ndarray_misc.py
  python/numpy/typing/tests/data/reveal/fromnumeric.py
  python/numpy/typing/tests/data/reveal/ndarray_conversion.py
  python/numpy/typing/tests/data/reveal/ndarray_shape_manipulation.py
  python/numpy/typing/tests/data/reveal/arithmetic.py
  python/numpy/typing/tests/data/reveal/nbit_base_example.py
  python/numpy/typing/tests/data/reveal/modules.py
  python/numpy/typing/tests/data/reveal/constants.py
  python/numpy/typing/tests/data/reveal/mod.py
  python/numpy/typing/tests/data/reveal/dtype.py
  python/numpy/typing/tests/data/reveal/ufunc_config.py
  python/numpy/typing/tests/data/reveal/scalars.py
  python/numpy/typing/tests/data/reveal/flatiter.py
  python/numpy/typing/tests/data/reveal/__pycache__/
  python/numpy/typing/tests/data/reveal/__pycache__/arithmetic.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/array_constructors.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/bitwise_ops.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/constants.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/dtype.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/flatiter.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/mod.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/modules.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/nbit_base_example.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ndarray_conversion.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ndarray_misc.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ndarray_shape_manipulation.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/numeric.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/scalars.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ufunc_config.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/warnings_and_errors.cpython-37.pyc
  python/numpy/typing/tests/__pycache__/
  python/numpy/typing/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/typing/tests/__pycache__/test_isfile.cpython-37.pyc
  python/numpy/typing/tests/__pycache__/test_typing.cpython-37.pyc
  python/numpy/typing/__pycache__/
  python/numpy/typing/__pycache__/__init__.cpython-37.pyc
  python/numpy/typing/__pycache__/_add_docstring.cpython-37.pyc
  python/numpy/typing/__pycache__/_array_like.cpython-37.pyc
  python/numpy/typing/__pycache__/_callable.cpython-37.pyc
  python/numpy/typing/__pycache__/_dtype_like.cpython-37.pyc
  python/numpy/typing/__pycache__/_scalars.cpython-37.pyc
  python/numpy/typing/__pycache__/_shape.cpython-37.pyc
  python/numpy/typing/__pycache__/setup.cpython-37.pyc
  python/numpy/polynomial/
  python/numpy/polynomial/setup.py
  python/numpy/polynomial/__init__.py
  python/numpy/polynomial/chebyshev.py
  python/numpy/polynomial/_polybase.py
  python/numpy/polynomial/hermite.py
  python/numpy/polynomial/laguerre.py
  python/numpy/polynomial/__init__.pyi
  python/numpy/polynomial/polynomial.py
  python/numpy/polynomial/hermite_e.py
  python/numpy/polynomial/legendre.py
  python/numpy/polynomial/polyutils.py
  python/numpy/polynomial/tests/
  python/numpy/polynomial/tests/test_hermite.py
  python/numpy/polynomial/tests/test_printing.py
  python/numpy/polynomial/tests/test_laguerre.py
  python/numpy/polynomial/tests/test_polyutils.py
  python/numpy/polynomial/tests/__init__.py
  python/numpy/polynomial/tests/test_legendre.py
  python/numpy/polynomial/tests/test_polynomial.py
  python/numpy/polynomial/tests/test_chebyshev.py
  python/numpy/polynomial/tests/test_classes.py
  python/numpy/polynomial/tests/test_hermite_e.py
  python/numpy/polynomial/tests/__pycache__/
  python/numpy/polynomial/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_chebyshev.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_classes.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_hermite.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_hermite_e.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_laguerre.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_legendre.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_polynomial.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_polyutils.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_printing.cpython-37.pyc
  python/numpy/polynomial/__pycache__/
  python/numpy/polynomial/__pycache__/__init__.cpython-37.pyc
  python/numpy/polynomial/__pycache__/_polybase.cpython-37.pyc
  python/numpy/polynomial/__pycache__/chebyshev.cpython-37.pyc
  python/numpy/polynomial/__pycache__/hermite.cpython-37.pyc
  python/numpy/polynomial/__pycache__/hermite_e.cpython-37.pyc
  python/numpy/polynomial/__pycache__/laguerre.cpython-37.pyc
  python/numpy/polynomial/__pycache__/legendre.cpython-37.pyc
  python/numpy/polynomial/__pycache__/polynomial.cpython-37.pyc
  python/numpy/polynomial/__pycache__/polyutils.cpython-37.pyc
  python/numpy/polynomial/__pycache__/setup.cpython-37.pyc
  python/numpy/ma/
  python/numpy/ma/core.py
  python/numpy/ma/setup.py
  python/numpy/ma/__init__.py
  python/numpy/ma/testutils.py
  python/numpy/ma/timer_comparison.py
  python/numpy/ma/mrecords.py
  python/numpy/ma/__init__.pyi
  python/numpy/ma/bench.py
  python/numpy/ma/extras.py
  python/numpy/ma/tests/
  python/numpy/ma/tests/test_old_ma.py
  python/numpy/ma/tests/test_subclassing.py
  python/numpy/ma/tests/__init__.py
  python/numpy/ma/tests/test_extras.py
  python/numpy/ma/tests/test_mrecords.py
  python/numpy/ma/tests/test_deprecations.py
  python/numpy/ma/tests/test_core.py
  python/numpy/ma/tests/test_regression.py
  python/numpy/ma/tests/__pycache__/
  python/numpy/ma/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_core.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_deprecations.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_extras.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_mrecords.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_old_ma.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_subclassing.cpython-37.pyc
  python/numpy/ma/__pycache__/
  python/numpy/ma/__pycache__/__init__.cpython-37.pyc
  python/numpy/ma/__pycache__/bench.cpython-37.pyc
  python/numpy/ma/__pycache__/core.cpython-37.pyc
  python/numpy/ma/__pycache__/extras.cpython-37.pyc
  python/numpy/ma/__pycache__/mrecords.cpython-37.pyc
  python/numpy/ma/__pycache__/setup.cpython-37.pyc
  python/numpy/ma/__pycache__/testutils.cpython-37.pyc
  python/numpy/ma/__pycache__/timer_comparison.cpython-37.pyc
  python/numpy/doc/
  python/numpy/doc/__init__.py
  python/numpy/doc/constants.py
  python/numpy/doc/ufuncs.py
  python/numpy/doc/__pycache__/
  python/numpy/doc/__pycache__/__init__.cpython-37.pyc
  python/numpy/doc/__pycache__/constants.cpython-37.pyc
  python/numpy/doc/__pycache__/ufuncs.cpython-37.pyc
  python/numpy/testing/
  python/numpy/testing/setup.py
  python/numpy/testing/__init__.py
  python/numpy/testing/utils.py
  python/numpy/testing/__init__.pyi
  python/numpy/testing/print_coercion_tables.py
  python/numpy/testing/tests/
  python/numpy/testing/tests/__init__.py
  python/numpy/testing/tests/test_utils.py
  python/numpy/testing/tests/test_doctesting.py
  python/numpy/testing/tests/test_decorators.py
  python/numpy/testing/tests/__pycache__/
  python/numpy/testing/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/testing/tests/__pycache__/test_decorators.cpython-37.pyc
  python/numpy/testing/tests/__pycache__/test_doctesting.cpython-37.pyc
  python/numpy/testing/tests/__pycache__/test_utils.cpython-37.pyc
  python/numpy/testing/_private/
  python/numpy/testing/_private/noseclasses.py
  python/numpy/testing/_private/__init__.py
  python/numpy/testing/_private/parameterized.py
  python/numpy/testing/_private/utils.py
  python/numpy/testing/_private/nosetester.py
  python/numpy/testing/_private/decorators.py
  python/numpy/testing/_private/__pycache__/
  python/numpy/testing/_private/__pycache__/__init__.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/decorators.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/noseclasses.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/nosetester.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/parameterized.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/utils.cpython-37.pyc
  python/numpy/testing/__pycache__/
  python/numpy/testing/__pycache__/__init__.cpython-37.pyc
  python/numpy/testing/__pycache__/print_coercion_tables.cpython-37.pyc
  python/numpy/testing/__pycache__/setup.cpython-37.pyc
  python/numpy/testing/__pycache__/utils.cpython-37.pyc
  python/numpy/linalg/
  python/numpy/linalg/setup.py
  python/numpy/linalg/__init__.py
  python/numpy/linalg/linalg.py
  python/numpy/linalg/__init__.pyi
  python/numpy/linalg/lapack_lite.cpython-37m-x86_64-linux-gnu.so
  python/numpy/linalg/_umath_linalg.cpython-37m-x86_64-linux-gnu.so
  python/numpy/linalg/tests/
  python/numpy/linalg/tests/__init__.py
  python/numpy/linalg/tests/test_linalg.py
  python/numpy/linalg/tests/test_deprecations.py
  python/numpy/linalg/tests/test_build.py
  python/numpy/linalg/tests/test_regression.py
  python/numpy/linalg/tests/__pycache__/
  python/numpy/linalg/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_build.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_deprecations.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_linalg.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/linalg/__pycache__/
  python/numpy/linalg/__pycache__/__init__.cpython-37.pyc
  python/numpy/linalg/__pycache__/linalg.cpython-37.pyc
  python/numpy/linalg/__pycache__/setup.cpython-37.pyc
  python/numpy/core/
  python/numpy/core/numerictypes.py
  python/numpy/core/memmap.py
  python/numpy/core/_multiarray_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/numeric.pyi
  python/numpy/core/_ufunc_config.pyi
  python/numpy/core/setup_common.py
  python/numpy/core/numeric.py
  python/numpy/core/setup.py
  python/numpy/core/__init__.py
  python/numpy/core/numerictypes.pyi
  python/numpy/core/umath.py
  python/numpy/core/_type_aliases.py
  python/numpy/core/function_base.pyi
  python/numpy/core/fromnumeric.py
  python/numpy/core/multiarray.py
  python/numpy/core/_umath_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/function_base.py
  python/numpy/core/records.py
  python/numpy/core/_simd.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/generate_numpy_api.py
  python/numpy/core/_multiarray_umath.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/_exceptions.py
  python/numpy/core/getlimits.py
  python/numpy/core/_internal.pyi
  python/numpy/core/_dtype_ctypes.py
  python/numpy/core/_ufunc_config.py
  python/numpy/core/_internal.py
  python/numpy/core/_rational_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/_dtype.py
  python/numpy/core/__init__.pyi
  python/numpy/core/arrayprint.py
  python/numpy/core/_type_aliases.pyi
  python/numpy/core/shape_base.pyi
  python/numpy/core/_struct_ufunc_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/fromnumeric.pyi
  python/numpy/core/overrides.py
  python/numpy/core/cversions.py
  python/numpy/core/machar.py
  python/numpy/core/_asarray.py
  python/numpy/core/_add_newdocs.py
  python/numpy/core/_operand_flag_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/_string_helpers.py
  python/numpy/core/_methods.py
  python/numpy/core/umath_tests.py
  python/numpy/core/_add_newdocs_scalars.py
  python/numpy/core/shape_base.py
  python/numpy/core/_asarray.pyi
  python/numpy/core/einsumfunc.py
  python/numpy/core/defchararray.py
  python/numpy/core/tests/
  python/numpy/core/tests/test_umath_complex.py
  python/numpy/core/tests/test__exceptions.py
  python/numpy/core/tests/test_api.py
  python/numpy/core/tests/test_unicode.py
  python/numpy/core/tests/test_indexing.py
  python/numpy/core/tests/test_scalar_methods.py
  python/numpy/core/tests/test_simd.py
  python/numpy/core/tests/test_getlimits.py
  python/numpy/core/tests/test_longdouble.py
  python/numpy/core/tests/test_numerictypes.py
  python/numpy/core/tests/__init__.py
  python/numpy/core/tests/test_umath_accuracy.py
  python/numpy/core/tests/test_abc.py
  python/numpy/core/tests/test_scalar_ctors.py
  python/numpy/core/tests/test_shape_base.py
  python/numpy/core/tests/test_multiarray.py
  python/numpy/core/tests/test_mem_overlap.py
  python/numpy/core/tests/test_overrides.py
  python/numpy/core/tests/test_umath.py
  python/numpy/core/tests/test_extint128.py
  python/numpy/core/tests/test_einsum.py
  python/numpy/core/tests/test_scalarprint.py
  python/numpy/core/tests/test_conversion_utils.py
  python/numpy/core/tests/test_defchararray.py
  python/numpy/core/tests/test_records.py
  python/numpy/core/tests/test_numeric.py
  python/numpy/core/tests/test_cython.py
  python/numpy/core/tests/test_deprecations.py
  python/numpy/core/tests/test_scalarinherit.py
  python/numpy/core/tests/test_machar.py
  python/numpy/core/tests/test_print.py
  python/numpy/core/tests/_locales.py
  python/numpy/core/tests/test_array_coercion.py
  python/numpy/core/tests/test_half.py
  python/numpy/core/tests/test_datetime.py
  python/numpy/core/tests/test_cpu_features.py
  python/numpy/core/tests/test_cpu_dispatcher.py
  python/numpy/core/tests/test_errstate.py
  python/numpy/core/tests/test_casting_unittests.py
  python/numpy/core/tests/test_scalarbuffer.py
  python/numpy/core/tests/test_nditer.py
  python/numpy/core/tests/test_item_selection.py
  python/numpy/core/tests/test_regression.py
  python/numpy/core/tests/test_memmap.py
  python/numpy/core/tests/test_scalarmath.py
  python/numpy/core/tests/test_protocols.py
  python/numpy/core/tests/test_ufunc.py
  python/numpy/core/tests/test_arrayprint.py
  python/numpy/core/tests/test_function_base.py
  python/numpy/core/tests/test_indexerrors.py
  python/numpy/core/tests/test_simd_module.py
  python/numpy/core/tests/test_dtype.py
  python/numpy/core/tests/examples/
  python/numpy/core/tests/examples/setup.py
  python/numpy/core/tests/examples/checks.pyx
  python/numpy/core/tests/examples/__pycache__/
  python/numpy/core/tests/examples/__pycache__/setup.cpython-37.pyc
  python/numpy/core/tests/data/
  python/numpy/core/tests/data/umath-validation-set-exp
  python/numpy/core/tests/data/umath-validation-set-sin
  python/numpy/core/tests/data/umath-validation-set-cos
  python/numpy/core/tests/data/umath-validation-set-log
  python/numpy/core/tests/data/astype_copy.pkl
  python/numpy/core/tests/data/umath-validation-set-README
  python/numpy/core/tests/data/recarray_from_file.fits
  python/numpy/core/tests/__pycache__/
  python/numpy/core/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/core/tests/__pycache__/_locales.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_protocols.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test__exceptions.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_abc.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_api.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_records.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_array_coercion.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_arrayprint.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_print.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_casting_unittests.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalar_ctors.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_conversion_utils.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalar_methods.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_cpu_dispatcher.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarinherit.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_cpu_features.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_cython.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_datetime.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarbuffer.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_defchararray.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarmath.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_deprecations.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_dtype.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_einsum.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_errstate.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarprint.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_extint128.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_shape_base.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_function_base.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_simd.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_getlimits.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_half.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_simd_module.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_indexerrors.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_indexing.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_ufunc.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_item_selection.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_longdouble.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_machar.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_mem_overlap.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_memmap.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_multiarray.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_nditer.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_numeric.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_numerictypes.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_overrides.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_umath.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_umath_accuracy.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_umath_complex.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_unicode.cpython-37.pyc
  python/numpy/core/include/
  python/numpy/core/include/numpy/
  python/numpy/core/include/numpy/__multiarray_api.h
  python/numpy/core/include/numpy/utils.h
  python/numpy/core/include/numpy/_neighborhood_iterator_imp.h
  python/numpy/core/include/numpy/arrayobject.h
  python/numpy/core/include/numpy/_numpyconfig.h
  python/numpy/core/include/numpy/ndarraytypes.h
  python/numpy/core/include/numpy/arrayscalars.h
  python/numpy/core/include/numpy/halffloat.h
  python/numpy/core/include/numpy/npy_interrupt.h
  python/numpy/core/include/numpy/npy_cpu.h
  python/numpy/core/include/numpy/npy_no_deprecated_api.h
  python/numpy/core/include/numpy/multiarray_api.txt
  python/numpy/core/include/numpy/old_defines.h
  python/numpy/core/include/numpy/npy_os.h
  python/numpy/core/include/numpy/npy_common.h
  python/numpy/core/include/numpy/ndarrayobject.h
  python/numpy/core/include/numpy/ufunc_api.txt
  python/numpy/core/include/numpy/oldnumeric.h
  python/numpy/core/include/numpy/npy_3kcompat.h
  python/numpy/core/include/numpy/ufuncobject.h
  python/numpy/core/include/numpy/__ufunc_api.h
  python/numpy/core/include/numpy/npy_math.h
  python/numpy/core/include/numpy/noprefix.h
  python/numpy/core/include/numpy/numpyconfig.h
  python/numpy/core/include/numpy/npy_endian.h
  python/numpy/core/include/numpy/npy_1_7_deprecated_api.h
  python/numpy/core/include/numpy/random/
  python/numpy/core/include/numpy/random/distributions.h
  python/numpy/core/include/numpy/random/bitgen.h
  python/numpy/core/lib/
  python/numpy/core/lib/libnpymath.a
  python/numpy/core/lib/npy-pkg-config/
  python/numpy/core/lib/npy-pkg-config/mlib.ini
  python/numpy/core/lib/npy-pkg-config/npymath.ini
  python/numpy/core/__pycache__/
  python/numpy/core/__pycache__/__init__.cpython-37.pyc
  python/numpy/core/__pycache__/_add_newdocs.cpython-37.pyc
  python/numpy/core/__pycache__/_add_newdocs_scalars.cpython-37.pyc
  python/numpy/core/__pycache__/_asarray.cpython-37.pyc
  python/numpy/core/__pycache__/_dtype.cpython-37.pyc
  python/numpy/core/__pycache__/_dtype_ctypes.cpython-37.pyc
  python/numpy/core/__pycache__/_exceptions.cpython-37.pyc
  python/numpy/core/__pycache__/_internal.cpython-37.pyc
  python/numpy/core/__pycache__/_methods.cpython-37.pyc
  python/numpy/core/__pycache__/_string_helpers.cpython-37.pyc
  python/numpy/core/__pycache__/_type_aliases.cpython-37.pyc
  python/numpy/core/__pycache__/_ufunc_config.cpython-37.pyc
  python/numpy/core/__pycache__/arrayprint.cpython-37.pyc
  python/numpy/core/__pycache__/cversions.cpython-37.pyc
  python/numpy/core/__pycache__/defchararray.cpython-37.pyc
  python/numpy/core/__pycache__/einsumfunc.cpython-37.pyc
  python/numpy/core/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/core/__pycache__/function_base.cpython-37.pyc
  python/numpy/core/__pycache__/generate_numpy_api.cpython-37.pyc
  python/numpy/core/__pycache__/getlimits.cpython-37.pyc
  python/numpy/core/__pycache__/machar.cpython-37.pyc
  python/numpy/core/__pycache__/memmap.cpython-37.pyc
  python/numpy/core/__pycache__/multiarray.cpython-37.pyc
  python/numpy/core/__pycache__/numeric.cpython-37.pyc
  python/numpy/core/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/core/__pycache__/overrides.cpython-37.pyc
  python/numpy/core/__pycache__/records.cpython-37.pyc
  python/numpy/core/__pycache__/setup.cpython-37.pyc
  python/numpy/core/__pycache__/setup_common.cpython-37.pyc
  python/numpy/core/__pycache__/shape_base.cpython-37.pyc
  python/numpy/core/__pycache__/umath.cpython-37.pyc
  python/numpy/core/__pycache__/umath_tests.cpython-37.pyc
  python/numpy/f2py/
  python/numpy/f2py/common_rules.py
  python/numpy/f2py/use_rules.py
  python/numpy/f2py/f2py_testing.py
  python/numpy/f2py/setup.py
  python/numpy/f2py/__init__.py
  python/numpy/f2py/f90mod_rules.py
  python/numpy/f2py/__version__.py
  python/numpy/f2py/__main__.py
  python/numpy/f2py/capi_maps.py
  python/numpy/f2py/__init__.pyi
  python/numpy/f2py/f2py2e.py
  python/numpy/f2py/diagnose.py
  python/numpy/f2py/crackfortran.py
  python/numpy/f2py/rules.py
  python/numpy/f2py/auxfuncs.py
  python/numpy/f2py/cfuncs.py
  python/numpy/f2py/cb_rules.py
  python/numpy/f2py/func2subr.py
  python/numpy/f2py/tests/
  python/numpy/f2py/tests/test_return_logical.py
  python/numpy/f2py/tests/test_callback.py
  python/numpy/f2py/tests/test_module_doc.py
  python/numpy/f2py/tests/test_quoted_character.py
  python/numpy/f2py/tests/__init__.py
  python/numpy/f2py/tests/test_compile_function.py
  python/numpy/f2py/tests/util.py
  python/numpy/f2py/tests/test_return_character.py
  python/numpy/f2py/tests/test_return_integer.py
  python/numpy/f2py/tests/test_array_from_pyobj.py
  python/numpy/f2py/tests/test_string.py
  python/numpy/f2py/tests/test_crackfortran.py
  python/numpy/f2py/tests/test_parameter.py
  python/numpy/f2py/tests/test_kind.py
  python/numpy/f2py/tests/test_regression.py
  python/numpy/f2py/tests/test_mixed.py
  python/numpy/f2py/tests/test_block_docstring.py
  python/numpy/f2py/tests/test_common.py
  python/numpy/f2py/tests/test_return_real.py
  python/numpy/f2py/tests/test_return_complex.py
  python/numpy/f2py/tests/test_size.py
  python/numpy/f2py/tests/test_semicolon_split.py
  python/numpy/f2py/tests/test_assumed_shape.py
  python/numpy/f2py/tests/src/
  python/numpy/f2py/tests/src/parameter/
  python/numpy/f2py/tests/src/parameter/constant_both.f90
  python/numpy/f2py/tests/src/parameter/constant_compound.f90
  python/numpy/f2py/tests/src/parameter/constant_real.f90
  python/numpy/f2py/tests/src/parameter/constant_integer.f90
  python/numpy/f2py/tests/src/parameter/constant_non_compound.f90
  python/numpy/f2py/tests/src/mixed/
  python/numpy/f2py/tests/src/mixed/foo_free.f90
  python/numpy/f2py/tests/src/mixed/foo.f
  python/numpy/f2py/tests/src/mixed/foo_fixed.f90
  python/numpy/f2py/tests/src/size/
  python/numpy/f2py/tests/src/size/foo.f90
  python/numpy/f2py/tests/src/common/
  python/numpy/f2py/tests/src/common/block.f
  python/numpy/f2py/tests/src/regression/
  python/numpy/f2py/tests/src/regression/inout.f90
  python/numpy/f2py/tests/src/string/
  python/numpy/f2py/tests/src/string/char.f90
  python/numpy/f2py/tests/src/kind/
  python/numpy/f2py/tests/src/kind/foo.f90
  python/numpy/f2py/tests/src/assumed_shape/
  python/numpy/f2py/tests/src/assumed_shape/precision.f90
  python/numpy/f2py/tests/src/assumed_shape/foo_use.f90
  python/numpy/f2py/tests/src/assumed_shape/foo_mod.f90
  python/numpy/f2py/tests/src/assumed_shape/foo_free.f90
  python/numpy/f2py/tests/src/assumed_shape/.f2py_f2cmap
  python/numpy/f2py/tests/src/array_from_pyobj/
  python/numpy/f2py/tests/src/array_from_pyobj/wrapmodule.c
  python/numpy/f2py/tests/src/module_data/
  python/numpy/f2py/tests/src/module_data/mod.mod
  python/numpy/f2py/tests/src/module_data/module_data_docstring.f90
  python/numpy/f2py/tests/__pycache__/
  python/numpy/f2py/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_array_from_pyobj.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_assumed_shape.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_block_docstring.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_callback.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_common.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_compile_function.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_crackfortran.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_kind.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_mixed.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_module_doc.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_parameter.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_quoted_character.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_character.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_complex.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_integer.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_logical.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_real.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_semicolon_split.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_size.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_string.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/util.cpython-37.pyc
  python/numpy/f2py/src/
  python/numpy/f2py/src/fortranobject.c
  python/numpy/f2py/src/fortranobject.h
  python/numpy/f2py/__pycache__/
  python/numpy/f2py/__pycache__/__init__.cpython-37.pyc
  python/numpy/f2py/__pycache__/__main__.cpython-37.pyc
  python/numpy/f2py/__pycache__/__version__.cpython-37.pyc
  python/numpy/f2py/__pycache__/auxfuncs.cpython-37.pyc
  python/numpy/f2py/__pycache__/capi_maps.cpython-37.pyc
  python/numpy/f2py/__pycache__/cb_rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/cfuncs.cpython-37.pyc
  python/numpy/f2py/__pycache__/common_rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/crackfortran.cpython-37.pyc
  python/numpy/f2py/__pycache__/diagnose.cpython-37.pyc
  python/numpy/f2py/__pycache__/f2py2e.cpython-37.pyc
  python/numpy/f2py/__pycache__/f2py_testing.cpython-37.pyc
  python/numpy/f2py/__pycache__/f90mod_rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/func2subr.cpython-37.pyc
  python/numpy/f2py/__pycache__/rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/setup.cpython-37.pyc
  python/numpy/f2py/__pycache__/use_rules.cpython-37.pyc
  python/numpy/matrixlib/
  python/numpy/matrixlib/setup.py
  python/numpy/matrixlib/__init__.py
  python/numpy/matrixlib/__init__.pyi
  python/numpy/matrixlib/defmatrix.py
  python/numpy/matrixlib/tests/
  python/numpy/matrixlib/tests/test_masked_matrix.py
  python/numpy/matrixlib/tests/__init__.py
  python/numpy/matrixlib/tests/test_multiarray.py
  python/numpy/matrixlib/tests/test_numeric.py
  python/numpy/matrixlib/tests/test_matrix_linalg.py
  python/numpy/matrixlib/tests/test_interaction.py
  python/numpy/matrixlib/tests/test_regression.py
  python/numpy/matrixlib/tests/test_defmatrix.py
  python/numpy/matrixlib/tests/__pycache__/
  python/numpy/matrixlib/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_defmatrix.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_interaction.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_masked_matrix.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_matrix_linalg.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_multiarray.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_numeric.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/matrixlib/__pycache__/
  python/numpy/matrixlib/__pycache__/__init__.cpython-37.pyc
  python/numpy/matrixlib/__pycache__/defmatrix.cpython-37.pyc
  python/numpy/matrixlib/__pycache__/setup.cpython-37.pyc
  python/numpy/distutils/
  python/numpy/distutils/ccompiler_opt.py
  python/numpy/distutils/core.py
  python/numpy/distutils/setup.py
  python/numpy/distutils/__init__.py
  python/numpy/distutils/conv_template.py
  python/numpy/distutils/exec_command.py
  python/numpy/distutils/pathccompiler.py
  python/numpy/distutils/extension.py
  python/numpy/distutils/from_template.py
  python/numpy/distutils/__init__.pyi
  python/numpy/distutils/_shell_utils.py
  python/numpy/distutils/msvccompiler.py
  python/numpy/distutils/line_endings.py
  python/numpy/distutils/numpy_distribution.py
  python/numpy/distutils/log.py
  python/numpy/distutils/msvc9compiler.py
  python/numpy/distutils/intelccompiler.py
  python/numpy/distutils/system_info.py
  python/numpy/distutils/mingw32ccompiler.py
  python/numpy/distutils/__config__.py
  python/numpy/distutils/npy_pkg_config.py
  python/numpy/distutils/lib2def.py
  python/numpy/distutils/ccompiler.py
  python/numpy/distutils/unixccompiler.py
  python/numpy/distutils/cpuinfo.py
  python/numpy/distutils/misc_util.py
  python/numpy/distutils/mingw/
  python/numpy/distutils/mingw/gfortran_vs2003_hack.c
  python/numpy/distutils/tests/
  python/numpy/distutils/tests/__init__.py
  python/numpy/distutils/tests/test_system_info.py
  python/numpy/distutils/tests/test_mingw32ccompiler.py
  python/numpy/distutils/tests/test_fcompiler_nagfor.py
  python/numpy/distutils/tests/test_build_ext.py
  python/numpy/distutils/tests/test_ccompiler_opt.py
  python/numpy/distutils/tests/test_misc_util.py
  python/numpy/distutils/tests/test_exec_command.py
  python/numpy/distutils/tests/test_npy_pkg_config.py
  python/numpy/distutils/tests/test_ccompiler_opt_conf.py
  python/numpy/distutils/tests/test_fcompiler_intel.py
  python/numpy/distutils/tests/test_fcompiler_gnu.py
  python/numpy/distutils/tests/test_fcompiler.py
  python/numpy/distutils/tests/test_from_template.py
  python/numpy/distutils/tests/test_shell_utils.py
  python/numpy/distutils/tests/__pycache__/
  python/numpy/distutils/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_build_ext.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_ccompiler_opt.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_ccompiler_opt_conf.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_exec_command.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler_gnu.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler_intel.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler_nagfor.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_from_template.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_mingw32ccompiler.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_misc_util.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_npy_pkg_config.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_shell_utils.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_system_info.cpython-37.pyc
  python/numpy/distutils/checks/
  python/numpy/distutils/checks/cpu_neon_fp16.c
  python/numpy/distutils/checks/cpu_neon_vfpv4.c
  python/numpy/distutils/checks/cpu_sse.c
  python/numpy/distutils/checks/cpu_vsx2.c
  python/numpy/distutils/checks/cpu_avx512_icl.c
  python/numpy/distutils/checks/cpu_fma3.c
  python/numpy/distutils/checks/cpu_f16c.c
  python/numpy/distutils/checks/cpu_avx512_clx.c
  python/numpy/distutils/checks/cpu_avx512f.c
  python/numpy/distutils/checks/cpu_vsx3.c
  python/numpy/distutils/checks/cpu_avx512cd.c
  python/numpy/distutils/checks/cpu_xop.c
  python/numpy/distutils/checks/cpu_avx512_cnl.c
  python/numpy/distutils/checks/cpu_fma4.c
  python/numpy/distutils/checks/cpu_asimddp.c
  python/numpy/distutils/checks/cpu_avx.c
  python/numpy/distutils/checks/cpu_asimdhp.c
  python/numpy/distutils/checks/cpu_avx512_knm.c
  python/numpy/distutils/checks/cpu_ssse3.c
  python/numpy/distutils/checks/cpu_sse2.c
  python/numpy/distutils/checks/cpu_neon.c
  python/numpy/distutils/checks/cpu_sse3.c
  python/numpy/distutils/checks/cpu_asimdfhm.c
  python/numpy/distutils/checks/cpu_avx512_knl.c
  python/numpy/distutils/checks/extra_avx512bw_mask.c
  python/numpy/distutils/checks/cpu_avx512_skx.c
  python/numpy/distutils/checks/extra_avx512f_reduce.c
  python/numpy/distutils/checks/cpu_sse42.c
  python/numpy/distutils/checks/cpu_vsx.c
  python/numpy/distutils/checks/extra_avx512dq_mask.c
  python/numpy/distutils/checks/cpu_avx2.c
  python/numpy/distutils/checks/cpu_popcnt.c
  python/numpy/distutils/checks/test_flags.c
  python/numpy/distutils/checks/cpu_sse41.c
  python/numpy/distutils/checks/cpu_asimd.c
  python/numpy/distutils/fcompiler/
  python/numpy/distutils/fcompiler/compaq.py
  python/numpy/distutils/fcompiler/__init__.py
  python/numpy/distutils/fcompiler/hpux.py
  python/numpy/distutils/fcompiler/gnu.py
  python/numpy/distutils/fcompiler/vast.py
  python/numpy/distutils/fcompiler/mips.py
  python/numpy/distutils/fcompiler/sun.py
  python/numpy/distutils/fcompiler/ibm.py
  python/numpy/distutils/fcompiler/lahey.py
  python/numpy/distutils/fcompiler/intel.py
  python/numpy/distutils/fcompiler/g95.py
  python/numpy/distutils/fcompiler/environment.py
  python/numpy/distutils/fcompiler/absoft.py
  python/numpy/distutils/fcompiler/pg.py
  python/numpy/distutils/fcompiler/nv.py
  python/numpy/distutils/fcompiler/none.py
  python/numpy/distutils/fcompiler/pathf95.py
  python/numpy/distutils/fcompiler/fujitsu.py
  python/numpy/distutils/fcompiler/nag.py
  python/numpy/distutils/fcompiler/__pycache__/
  python/numpy/distutils/fcompiler/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/absoft.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/compaq.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/environment.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/fujitsu.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/g95.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/gnu.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/hpux.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/ibm.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/intel.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/lahey.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/mips.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/nag.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/none.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/nv.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/pathf95.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/pg.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/sun.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/vast.cpython-37.pyc
  python/numpy/distutils/command/
  python/numpy/distutils/command/build_scripts.py
  python/numpy/distutils/command/install_clib.py
  python/numpy/distutils/command/__init__.py
  python/numpy/distutils/command/build_clib.py
  python/numpy/distutils/command/install_data.py
  python/numpy/distutils/command/config.py
  python/numpy/distutils/command/install_headers.py
  python/numpy/distutils/command/develop.py
  python/numpy/distutils/command/bdist_rpm.py
  python/numpy/distutils/command/build_py.py
  python/numpy/distutils/command/sdist.py
  python/numpy/distutils/command/egg_info.py
  python/numpy/distutils/command/build_ext.py
  python/numpy/distutils/command/build_src.py
  python/numpy/distutils/command/build.py
  python/numpy/distutils/command/install.py
  python/numpy/distutils/command/autodist.py
  python/numpy/distutils/command/config_compiler.py
  python/numpy/distutils/command/__pycache__/
  python/numpy/distutils/command/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/autodist.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/bdist_rpm.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_clib.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_ext.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_py.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_scripts.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_src.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/config.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/config_compiler.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/develop.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/egg_info.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install_clib.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install_data.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install_headers.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/sdist.cpython-37.pyc
  python/numpy/distutils/__pycache__/
  python/numpy/distutils/__pycache__/__config__.cpython-37.pyc
  python/numpy/distutils/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/__pycache__/_shell_utils.cpython-37.pyc
  python/numpy/distutils/__pycache__/ccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/ccompiler_opt.cpython-37.pyc
  python/numpy/distutils/__pycache__/conv_template.cpython-37.pyc
  python/numpy/distutils/__pycache__/core.cpython-37.pyc
  python/numpy/distutils/__pycache__/cpuinfo.cpython-37.pyc
  python/numpy/distutils/__pycache__/exec_command.cpython-37.pyc
  python/numpy/distutils/__pycache__/extension.cpython-37.pyc
  python/numpy/distutils/__pycache__/from_template.cpython-37.pyc
  python/numpy/distutils/__pycache__/intelccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/lib2def.cpython-37.pyc
  python/numpy/distutils/__pycache__/line_endings.cpython-37.pyc
  python/numpy/distutils/__pycache__/log.cpython-37.pyc
  python/numpy/distutils/__pycache__/mingw32ccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/misc_util.cpython-37.pyc
  python/numpy/distutils/__pycache__/msvc9compiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/msvccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/npy_pkg_config.cpython-37.pyc
  python/numpy/distutils/__pycache__/numpy_distribution.cpython-37.pyc
  python/numpy/distutils/__pycache__/pathccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/setup.cpython-37.pyc
  python/numpy/distutils/__pycache__/system_info.cpython-37.pyc
  python/numpy/distutils/__pycache__/unixccompiler.cpython-37.pyc
  python/numpy/lib/
  python/numpy/lib/npyio.py
  python/numpy/lib/arrayterator.py
  python/numpy/lib/setup.py
  python/numpy/lib/type_check.py
  python/numpy/lib/__init__.py
  python/numpy/lib/arraysetops.py
  python/numpy/lib/histograms.py
  python/numpy/lib/index_tricks.py
  python/numpy/lib/function_base.py
  python/numpy/lib/format.py
  python/numpy/lib/recfunctions.py
  python/numpy/lib/utils.py
  python/numpy/lib/__init__.pyi
  python/numpy/lib/_version.py
  python/numpy/lib/ufunclike.py
  python/numpy/lib/twodim_base.py
  python/numpy/lib/polynomial.py
  python/numpy/lib/_iotools.py
  python/numpy/lib/_datasource.py
  python/numpy/lib/scimath.py
  python/numpy/lib/mixins.py
  python/numpy/lib/nanfunctions.py
  python/numpy/lib/arraypad.py
  python/numpy/lib/user_array.py
  python/numpy/lib/stride_tricks.py
  python/numpy/lib/shape_base.py
  python/numpy/lib/tests/
  python/numpy/lib/tests/test_recfunctions.py
  python/numpy/lib/tests/test_stride_tricks.py
  python/numpy/lib/tests/__init__.py
  python/numpy/lib/tests/test_arrayterator.py
  python/numpy/lib/tests/test__version.py
  python/numpy/lib/tests/test_shape_base.py
  python/numpy/lib/tests/test__iotools.py
  python/numpy/lib/tests/test_format.py
  python/numpy/lib/tests/test_index_tricks.py
  python/numpy/lib/tests/test_io.py
  python/numpy/lib/tests/test_arraypad.py
  python/numpy/lib/tests/test_financial_expired.py
  python/numpy/lib/tests/test__datasource.py
  python/numpy/lib/tests/test_packbits.py
  python/numpy/lib/tests/test_nanfunctions.py
  python/numpy/lib/tests/test_utils.py
  python/numpy/lib/tests/test_twodim_base.py
  python/numpy/lib/tests/test_polynomial.py
  python/numpy/lib/tests/test_regression.py
  python/numpy/lib/tests/test_ufunclike.py
  python/numpy/lib/tests/test_arraysetops.py
  python/numpy/lib/tests/test_function_base.py
  python/numpy/lib/tests/test_mixins.py
  python/numpy/lib/tests/test_type_check.py
  python/numpy/lib/tests/test_histograms.py
  python/numpy/lib/tests/data/
  python/numpy/lib/tests/data/win64python2.npy
  python/numpy/lib/tests/data/py2-objarr.npz
  python/numpy/lib/tests/data/python3.npy
  python/numpy/lib/tests/data/py3-objarr.npz
  python/numpy/lib/tests/data/py3-objarr.npy
  python/numpy/lib/tests/data/py2-objarr.npy
  python/numpy/lib/tests/__pycache__/
  python/numpy/lib/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test__datasource.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test__iotools.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test__version.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_arraypad.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_arraysetops.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_arrayterator.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_financial_expired.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_format.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_function_base.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_histograms.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_index_tricks.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_io.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_mixins.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_nanfunctions.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_packbits.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_polynomial.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_recfunctions.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_shape_base.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_stride_tricks.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_twodim_base.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_type_check.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_ufunclike.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_utils.cpython-37.pyc
  python/numpy/lib/__pycache__/
  python/numpy/lib/__pycache__/__init__.cpython-37.pyc
  python/numpy/lib/__pycache__/_datasource.cpython-37.pyc
  python/numpy/lib/__pycache__/_iotools.cpython-37.pyc
  python/numpy/lib/__pycache__/_version.cpython-37.pyc
  python/numpy/lib/__pycache__/arraypad.cpython-37.pyc
  python/numpy/lib/__pycache__/arraysetops.cpython-37.pyc
  python/numpy/lib/__pycache__/arrayterator.cpython-37.pyc
  python/numpy/lib/__pycache__/format.cpython-37.pyc
  python/numpy/lib/__pycache__/function_base.cpython-37.pyc
  python/numpy/lib/__pycache__/histograms.cpython-37.pyc
  python/numpy/lib/__pycache__/index_tricks.cpython-37.pyc
  python/numpy/lib/__pycache__/mixins.cpython-37.pyc
  python/numpy/lib/__pycache__/nanfunctions.cpython-37.pyc
  python/numpy/lib/__pycache__/npyio.cpython-37.pyc
  python/numpy/lib/__pycache__/polynomial.cpython-37.pyc
  python/numpy/lib/__pycache__/recfunctions.cpython-37.pyc
  python/numpy/lib/__pycache__/scimath.cpython-37.pyc
  python/numpy/lib/__pycache__/setup.cpython-37.pyc
  python/numpy/lib/__pycache__/shape_base.cpython-37.pyc
  python/numpy/lib/__pycache__/stride_tricks.cpython-37.pyc
  python/numpy/lib/__pycache__/twodim_base.cpython-37.pyc
  python/numpy/lib/__pycache__/type_check.cpython-37.pyc
  python/numpy/lib/__pycache__/ufunclike.cpython-37.pyc
  python/numpy/lib/__pycache__/user_array.cpython-37.pyc
  python/numpy/lib/__pycache__/utils.cpython-37.pyc
  python/numpy/compat/
  python/numpy/compat/setup.py
  python/numpy/compat/__init__.py
  python/numpy/compat/py3k.py
  python/numpy/compat/_inspect.py
  python/numpy/compat/tests/
  python/numpy/compat/tests/test_compat.py
  python/numpy/compat/tests/__init__.py
  python/numpy/compat/tests/__pycache__/
  python/numpy/compat/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/compat/tests/__pycache__/test_compat.cpython-37.pyc
  python/numpy/compat/__pycache__/
  python/numpy/compat/__pycache__/__init__.cpython-37.pyc
  python/numpy/compat/__pycache__/_inspect.cpython-37.pyc
  python/numpy/compat/__pycache__/py3k.cpython-37.pyc
  python/numpy/compat/__pycache__/setup.cpython-37.pyc
  python/numpy/__pycache__/
  python/numpy/__pycache__/__config__.cpython-37.pyc
  python/numpy/__pycache__/__init__.cpython-37.pyc
  python/numpy/__pycache__/_distributor_init.cpython-37.pyc
  python/numpy/__pycache__/_globals.cpython-37.pyc
  python/numpy/__pycache__/_pytesttester.cpython-37.pyc
  python/numpy/__pycache__/conftest.cpython-37.pyc
  python/numpy/__pycache__/ctypeslib.cpython-37.pyc
  python/numpy/__pycache__/dual.cpython-37.pyc
  python/numpy/__pycache__/matlib.cpython-37.pyc
  python/numpy/__pycache__/setup.cpython-37.pyc
  python/numpy/__pycache__/version.cpython-37.pyc
  python/pandas/
  python/pandas/_version.py
  python/pandas/_testing.py
  python/pandas/conftest.py
  python/pandas/testing.py
  python/pandas/__init__.py
  python/pandas/_typing.py
  python/pandas/tests/
  python/pandas/tests/test_take.py
  python/pandas/tests/test_aggregation.py
  python/pandas/tests/test_downstream.py
  python/pandas/tests/test_algos.py
  python/pandas/tests/test_nanops.py
  python/pandas/tests/test_optional_dependency.py
  python/pandas/tests/__init__.py
  python/pandas/tests/test_sorting.py
  python/pandas/tests/test_register_accessor.py
  python/pandas/tests/test_strings.py
  python/pandas/tests/test_errors.py
  python/pandas/tests/test_common.py
  python/pandas/tests/test_multilevel.py
  python/pandas/tests/test_flags.py
  python/pandas/tests/test_expressions.py
  python/pandas/tests/window/
  python/pandas/tests/window/test_dtypes.py
  python/pandas/tests/window/test_numba.py
  python/pandas/tests/window/test_rolling.py
  python/pandas/tests/window/test_pairwise.py
  python/pandas/tests/window/test_timeseries_window.py
  python/pandas/tests/window/test_apply.py
  python/pandas/tests/window/test_ewm.py
  python/pandas/tests/window/conftest.py
  python/pandas/tests/window/test_api.py
  python/pandas/tests/window/test_expanding.py
  python/pandas/tests/window/__init__.py
  python/pandas/tests/window/test_win_type.py
  python/pandas/tests/window/test_base_indexer.py
  python/pandas/tests/window/test_groupby.py
  python/pandas/tests/window/moments/
  python/pandas/tests/window/moments/test_moments_rolling_skew_kurt.py
  python/pandas/tests/window/moments/test_moments_rolling.py
  python/pandas/tests/window/moments/test_moments_consistency_expanding.py
  python/pandas/tests/window/moments/test_moments_rolling_quantile.py
  python/pandas/tests/window/moments/test_moments_consistency_rolling.py
  python/pandas/tests/window/moments/test_moments_consistency_ewm.py
  python/pandas/tests/window/moments/test_moments_ewm.py
  python/pandas/tests/window/moments/test_moments_rolling_apply.py
  python/pandas/tests/window/moments/__init__.py
  python/pandas/tests/window/moments/test_moments_rolling_functions.py
  python/pandas/tests/window/moments/__pycache__/
  python/pandas/tests/window/moments/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_consistency_ewm.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_consistency_expanding.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_consistency_rolling.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_ewm.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_apply.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_functions.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_quantile.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_skew_kurt.cpython-37.pyc
  python/pandas/tests/window/__pycache__/
  python/pandas/tests/window/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/window/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_apply.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_base_indexer.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_ewm.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_expanding.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_groupby.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_pairwise.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_rolling.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_timeseries_window.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_win_type.cpython-37.pyc
  python/pandas/tests/scalar/
  python/pandas/tests/scalar/test_nat.py
  python/pandas/tests/scalar/__init__.py
  python/pandas/tests/scalar/test_na_scalar.py
  python/pandas/tests/scalar/timestamp/
  python/pandas/tests/scalar/timestamp/test_constructors.py
  python/pandas/tests/scalar/timestamp/test_rendering.py
  python/pandas/tests/scalar/timestamp/test_timezones.py
  python/pandas/tests/scalar/timestamp/test_unary_ops.py
  python/pandas/tests/scalar/timestamp/test_timestamp.py
  python/pandas/tests/scalar/timestamp/test_comparisons.py
  python/pandas/tests/scalar/timestamp/__init__.py
  python/pandas/tests/scalar/timestamp/test_arithmetic.py
  python/pandas/tests/scalar/timestamp/__pycache__/
  python/pandas/tests/scalar/timestamp/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_comparisons.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_rendering.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_timestamp.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_unary_ops.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/
  python/pandas/tests/scalar/timedelta/test_formats.py
  python/pandas/tests/scalar/timedelta/test_constructors.py
  python/pandas/tests/scalar/timedelta/__init__.py
  python/pandas/tests/scalar/timedelta/test_arithmetic.py
  python/pandas/tests/scalar/timedelta/test_timedelta.py
  python/pandas/tests/scalar/timedelta/__pycache__/
  python/pandas/tests/scalar/timedelta/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_timedelta.cpython-37.pyc
  python/pandas/tests/scalar/period/
  python/pandas/tests/scalar/period/__init__.py
  python/pandas/tests/scalar/period/test_period.py
  python/pandas/tests/scalar/period/test_asfreq.py
  python/pandas/tests/scalar/period/__pycache__/
  python/pandas/tests/scalar/period/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/period/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/scalar/period/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/scalar/interval/
  python/pandas/tests/scalar/interval/test_interval.py
  python/pandas/tests/scalar/interval/test_ops.py
  python/pandas/tests/scalar/interval/__init__.py
  python/pandas/tests/scalar/interval/test_arithmetic.py
  python/pandas/tests/scalar/interval/__pycache__/
  python/pandas/tests/scalar/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/interval/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/scalar/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/scalar/interval/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/scalar/__pycache__/
  python/pandas/tests/scalar/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/__pycache__/test_na_scalar.cpython-37.pyc
  python/pandas/tests/scalar/__pycache__/test_nat.cpython-37.pyc
  python/pandas/tests/indexes/
  python/pandas/tests/indexes/test_index_new.py
  python/pandas/tests/indexes/test_any_index.py
  python/pandas/tests/indexes/test_indexing.py
  python/pandas/tests/indexes/test_numpy_compat.py
  python/pandas/tests/indexes/test_datetimelike.py
  python/pandas/tests/indexes/test_frozen.py
  python/pandas/tests/indexes/conftest.py
  python/pandas/tests/indexes/common.py
  python/pandas/tests/indexes/test_numeric.py
  python/pandas/tests/indexes/test_base.py
  python/pandas/tests/indexes/datetimelike.py
  python/pandas/tests/indexes/__init__.py
  python/pandas/tests/indexes/test_setops.py
  python/pandas/tests/indexes/test_common.py
  python/pandas/tests/indexes/test_engines.py
  python/pandas/tests/indexes/base_class/
  python/pandas/tests/indexes/base_class/test_formats.py
  python/pandas/tests/indexes/base_class/test_where.py
  python/pandas/tests/indexes/base_class/test_constructors.py
  python/pandas/tests/indexes/base_class/test_indexing.py
  python/pandas/tests/indexes/base_class/test_reshape.py
  python/pandas/tests/indexes/base_class/__init__.py
  python/pandas/tests/indexes/base_class/test_setops.py
  python/pandas/tests/indexes/base_class/__pycache__/
  python/pandas/tests/indexes/base_class/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_reshape.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_where.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/
  python/pandas/tests/indexes/datetimes/test_formats.py
  python/pandas/tests/indexes/datetimes/test_fillna.py
  python/pandas/tests/indexes/datetimes/test_constructors.py
  python/pandas/tests/indexes/datetimes/test_indexing.py
  python/pandas/tests/indexes/datetimes/test_to_period.py
  python/pandas/tests/indexes/datetimes/test_delete.py
  python/pandas/tests/indexes/datetimes/test_astype.py
  python/pandas/tests/indexes/datetimes/test_date_range.py
  python/pandas/tests/indexes/datetimes/test_pickle.py
  python/pandas/tests/indexes/datetimes/test_timezones.py
  python/pandas/tests/indexes/datetimes/test_misc.py
  python/pandas/tests/indexes/datetimes/test_datetimelike.py
  python/pandas/tests/indexes/datetimes/test_scalar_compat.py
  python/pandas/tests/indexes/datetimes/test_map.py
  python/pandas/tests/indexes/datetimes/test_partial_slicing.py
  python/pandas/tests/indexes/datetimes/test_datetime.py
  python/pandas/tests/indexes/datetimes/test_join.py
  python/pandas/tests/indexes/datetimes/test_ops.py
  python/pandas/tests/indexes/datetimes/__init__.py
  python/pandas/tests/indexes/datetimes/test_shift.py
  python/pandas/tests/indexes/datetimes/test_setops.py
  python/pandas/tests/indexes/datetimes/test_snap.py
  python/pandas/tests/indexes/datetimes/test_insert.py
  python/pandas/tests/indexes/datetimes/__pycache__/
  python/pandas/tests/indexes/datetimes/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_date_range.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_delete.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_map.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_misc.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_partial_slicing.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_pickle.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_scalar_compat.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_snap.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_to_period.cpython-37.pyc
  python/pandas/tests/indexes/ranges/
  python/pandas/tests/indexes/ranges/test_constructors.py
  python/pandas/tests/indexes/ranges/test_indexing.py
  python/pandas/tests/indexes/ranges/test_join.py
  python/pandas/tests/indexes/ranges/test_range.py
  python/pandas/tests/indexes/ranges/__init__.py
  python/pandas/tests/indexes/ranges/test_setops.py
  python/pandas/tests/indexes/ranges/__pycache__/
  python/pandas/tests/indexes/ranges/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_range.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/
  python/pandas/tests/indexes/timedeltas/test_formats.py
  python/pandas/tests/indexes/timedeltas/test_fillna.py
  python/pandas/tests/indexes/timedeltas/test_constructors.py
  python/pandas/tests/indexes/timedeltas/test_indexing.py
  python/pandas/tests/indexes/timedeltas/test_delete.py
  python/pandas/tests/indexes/timedeltas/test_astype.py
  python/pandas/tests/indexes/timedeltas/test_searchsorted.py
  python/pandas/tests/indexes/timedeltas/test_scalar_compat.py
  python/pandas/tests/indexes/timedeltas/test_partial_slicing.py
  python/pandas/tests/indexes/timedeltas/test_join.py
  python/pandas/tests/indexes/timedeltas/test_ops.py
  python/pandas/tests/indexes/timedeltas/test_timedelta_range.py
  python/pandas/tests/indexes/timedeltas/__init__.py
  python/pandas/tests/indexes/timedeltas/test_shift.py
  python/pandas/tests/indexes/timedeltas/test_setops.py
  python/pandas/tests/indexes/timedeltas/test_insert.py
  python/pandas/tests/indexes/timedeltas/test_timedelta.py
  python/pandas/tests/indexes/timedeltas/__pycache__/
  python/pandas/tests/indexes/timedeltas/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_delete.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_partial_slicing.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_scalar_compat.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_searchsorted.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_timedelta.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_timedelta_range.cpython-37.pyc
  python/pandas/tests/indexes/categorical/
  python/pandas/tests/indexes/categorical/test_formats.py
  python/pandas/tests/indexes/categorical/test_fillna.py
  python/pandas/tests/indexes/categorical/test_constructors.py
  python/pandas/tests/indexes/categorical/test_indexing.py
  python/pandas/tests/indexes/categorical/test_astype.py
  python/pandas/tests/indexes/categorical/test_map.py
  python/pandas/tests/indexes/categorical/test_equals.py
  python/pandas/tests/indexes/categorical/__init__.py
  python/pandas/tests/indexes/categorical/test_category.py
  python/pandas/tests/indexes/categorical/test_reindex.py
  python/pandas/tests/indexes/categorical/__pycache__/
  python/pandas/tests/indexes/categorical/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_category.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_map.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/indexes/numeric/
  python/pandas/tests/indexes/numeric/test_indexing.py
  python/pandas/tests/indexes/numeric/test_astype.py
  python/pandas/tests/indexes/numeric/test_join.py
  python/pandas/tests/indexes/numeric/__init__.py
  python/pandas/tests/indexes/numeric/test_setops.py
  python/pandas/tests/indexes/numeric/__pycache__/
  python/pandas/tests/indexes/numeric/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/period/
  python/pandas/tests/indexes/period/test_formats.py
  python/pandas/tests/indexes/period/test_fillna.py
  python/pandas/tests/indexes/period/test_period_range.py
  python/pandas/tests/indexes/period/test_constructors.py
  python/pandas/tests/indexes/period/test_indexing.py
  python/pandas/tests/indexes/period/test_astype.py
  python/pandas/tests/indexes/period/test_searchsorted.py
  python/pandas/tests/indexes/period/test_scalar_compat.py
  python/pandas/tests/indexes/period/test_partial_slicing.py
  python/pandas/tests/indexes/period/test_join.py
  python/pandas/tests/indexes/period/test_to_timestamp.py
  python/pandas/tests/indexes/period/test_ops.py
  python/pandas/tests/indexes/period/test_factorize.py
  python/pandas/tests/indexes/period/__init__.py
  python/pandas/tests/indexes/period/test_shift.py
  python/pandas/tests/indexes/period/test_monotonic.py
  python/pandas/tests/indexes/period/test_tools.py
  python/pandas/tests/indexes/period/test_setops.py
  python/pandas/tests/indexes/period/test_period.py
  python/pandas/tests/indexes/period/test_asfreq.py
  python/pandas/tests/indexes/period/__pycache__/
  python/pandas/tests/indexes/period/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_factorize.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_monotonic.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_partial_slicing.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_period_range.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_scalar_compat.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_searchsorted.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_to_timestamp.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_tools.cpython-37.pyc
  python/pandas/tests/indexes/interval/
  python/pandas/tests/indexes/interval/test_formats.py
  python/pandas/tests/indexes/interval/test_constructors.py
  python/pandas/tests/indexes/interval/test_indexing.py
  python/pandas/tests/indexes/interval/test_interval_range.py
  python/pandas/tests/indexes/interval/test_astype.py
  python/pandas/tests/indexes/interval/test_interval_tree.py
  python/pandas/tests/indexes/interval/test_interval.py
  python/pandas/tests/indexes/interval/test_base.py
  python/pandas/tests/indexes/interval/test_equals.py
  python/pandas/tests/indexes/interval/__init__.py
  python/pandas/tests/indexes/interval/test_setops.py
  python/pandas/tests/indexes/interval/__pycache__/
  python/pandas/tests/indexes/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_base.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_interval_range.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_interval_tree.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/multi/
  python/pandas/tests/indexes/multi/test_formats.py
  python/pandas/tests/indexes/multi/test_compat.py
  python/pandas/tests/indexes/multi/test_missing.py
  python/pandas/tests/indexes/multi/test_constructors.py
  python/pandas/tests/indexes/multi/test_get_set.py
  python/pandas/tests/indexes/multi/test_get_level_values.py
  python/pandas/tests/indexes/multi/test_indexing.py
  python/pandas/tests/indexes/multi/test_take.py
  python/pandas/tests/indexes/multi/test_astype.py
  python/pandas/tests/indexes/multi/test_conversion.py
  python/pandas/tests/indexes/multi/test_lexsort.py
  python/pandas/tests/indexes/multi/conftest.py
  python/pandas/tests/indexes/multi/test_join.py
  python/pandas/tests/indexes/multi/test_equivalence.py
  python/pandas/tests/indexes/multi/test_isin.py
  python/pandas/tests/indexes/multi/test_partial_indexing.py
  python/pandas/tests/indexes/multi/test_copy.py
  python/pandas/tests/indexes/multi/test_duplicates.py
  python/pandas/tests/indexes/multi/test_reshape.py
  python/pandas/tests/indexes/multi/test_drop.py
  python/pandas/tests/indexes/multi/test_analytics.py
  python/pandas/tests/indexes/multi/__init__.py
  python/pandas/tests/indexes/multi/test_monotonic.py
  python/pandas/tests/indexes/multi/test_sorting.py
  python/pandas/tests/indexes/multi/test_setops.py
  python/pandas/tests/indexes/multi/test_names.py
  python/pandas/tests/indexes/multi/test_integrity.py
  python/pandas/tests/indexes/multi/test_reindex.py
  python/pandas/tests/indexes/multi/__pycache__/
  python/pandas/tests/indexes/multi/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_analytics.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_compat.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_conversion.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_copy.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_drop.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_duplicates.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_equivalence.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_get_level_values.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_get_set.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_integrity.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_isin.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_lexsort.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_monotonic.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_names.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_partial_indexing.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_reshape.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_sorting.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/
  python/pandas/tests/indexes/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/common.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/datetimelike.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_any_index.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_base.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_engines.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_frozen.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_index_new.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_numeric.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_numpy_compat.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/arithmetic/
  python/pandas/tests/arithmetic/test_array_ops.py
  python/pandas/tests/arithmetic/test_datetime64.py
  python/pandas/tests/arithmetic/test_interval.py
  python/pandas/tests/arithmetic/conftest.py
  python/pandas/tests/arithmetic/common.py
  python/pandas/tests/arithmetic/test_object.py
  python/pandas/tests/arithmetic/test_numeric.py
  python/pandas/tests/arithmetic/test_categorical.py
  python/pandas/tests/arithmetic/__init__.py
  python/pandas/tests/arithmetic/test_period.py
  python/pandas/tests/arithmetic/test_timedelta64.py
  python/pandas/tests/arithmetic/__pycache__/
  python/pandas/tests/arithmetic/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/common.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_array_ops.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_datetime64.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_numeric.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_object.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_timedelta64.cpython-37.pyc
  python/pandas/tests/dtypes/
  python/pandas/tests/dtypes/test_missing.py
  python/pandas/tests/dtypes/test_dtypes.py
  python/pandas/tests/dtypes/test_inference.py
  python/pandas/tests/dtypes/test_concat.py
  python/pandas/tests/dtypes/__init__.py
  python/pandas/tests/dtypes/test_common.py
  python/pandas/tests/dtypes/test_generic.py
  python/pandas/tests/dtypes/cast/
  python/pandas/tests/dtypes/cast/test_construct_from_scalar.py
  python/pandas/tests/dtypes/cast/test_downcast.py
  python/pandas/tests/dtypes/cast/test_infer_dtype.py
  python/pandas/tests/dtypes/cast/test_upcast.py
  python/pandas/tests/dtypes/cast/test_construct_object_arr.py
  python/pandas/tests/dtypes/cast/test_promote.py
  python/pandas/tests/dtypes/cast/test_construct_ndarray.py
  python/pandas/tests/dtypes/cast/test_dict_compat.py
  python/pandas/tests/dtypes/cast/__init__.py
  python/pandas/tests/dtypes/cast/test_infer_datetimelike.py
  python/pandas/tests/dtypes/cast/test_find_common_type.py
  python/pandas/tests/dtypes/cast/__pycache__/
  python/pandas/tests/dtypes/cast/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_construct_from_scalar.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_construct_ndarray.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_construct_object_arr.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_dict_compat.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_downcast.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_find_common_type.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_infer_datetimelike.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_infer_dtype.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_promote.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_upcast.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/
  python/pandas/tests/dtypes/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_generic.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_inference.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/series/
  python/pandas/tests/series/test_subclass.py
  python/pandas/tests/series/test_missing.py
  python/pandas/tests/series/test_constructors.py
  python/pandas/tests/series/test_dtypes.py
  python/pandas/tests/series/test_logical_ops.py
  python/pandas/tests/series/test_reductions.py
  python/pandas/tests/series/test_validate.py
  python/pandas/tests/series/test_api.py
  python/pandas/tests/series/test_repr.py
  python/pandas/tests/series/test_npfuncs.py
  python/pandas/tests/series/test_duplicates.py
  python/pandas/tests/series/test_cumulative.py
  python/pandas/tests/series/__init__.py
  python/pandas/tests/series/test_arithmetic.py
  python/pandas/tests/series/test_ufunc.py
  python/pandas/tests/series/test_unary.py
  python/pandas/tests/series/test_iteration.py
  python/pandas/tests/series/indexing/
  python/pandas/tests/series/indexing/test_where.py
  python/pandas/tests/series/indexing/test_indexing.py
  python/pandas/tests/series/indexing/test_take.py
  python/pandas/tests/series/indexing/test_set_value.py
  python/pandas/tests/series/indexing/test_xs.py
  python/pandas/tests/series/indexing/test_getitem.py
  python/pandas/tests/series/indexing/test_datetime.py
  python/pandas/tests/series/indexing/test_mask.py
  python/pandas/tests/series/indexing/test_numeric.py
  python/pandas/tests/series/indexing/test_get.py
  python/pandas/tests/series/indexing/test_delitem.py
  python/pandas/tests/series/indexing/__init__.py
  python/pandas/tests/series/indexing/test_setitem.py
  python/pandas/tests/series/indexing/__pycache__/
  python/pandas/tests/series/indexing/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_delitem.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_get.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_getitem.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_mask.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_numeric.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_set_value.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_setitem.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_where.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_xs.cpython-37.pyc
  python/pandas/tests/series/apply/
  python/pandas/tests/series/apply/test_apply_relabeling.py
  python/pandas/tests/series/apply/test_series_transform.py
  python/pandas/tests/series/apply/test_series_apply.py
  python/pandas/tests/series/apply/__init__.py
  python/pandas/tests/series/apply/__pycache__/
  python/pandas/tests/series/apply/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/apply/__pycache__/test_apply_relabeling.cpython-37.pyc
  python/pandas/tests/series/apply/__pycache__/test_series_apply.cpython-37.pyc
  python/pandas/tests/series/apply/__pycache__/test_series_transform.cpython-37.pyc
  python/pandas/tests/series/methods/
  python/pandas/tests/series/methods/test_to_csv.py
  python/pandas/tests/series/methods/test_is_monotonic.py
  python/pandas/tests/series/methods/test_convert_dtypes.py
  python/pandas/tests/series/methods/test_explode.py
  python/pandas/tests/series/methods/test_between.py
  python/pandas/tests/series/methods/test_reindex_like.py
  python/pandas/tests/series/methods/test_combine.py
  python/pandas/tests/series/methods/test_fillna.py
  python/pandas/tests/series/methods/test_autocorr.py
  python/pandas/tests/series/methods/test_quantile.py
  python/pandas/tests/series/methods/test_sort_index.py
  python/pandas/tests/series/methods/test_view.py
  python/pandas/tests/series/methods/test_drop_duplicates.py
  python/pandas/tests/series/methods/test_repeat.py
  python/pandas/tests/series/methods/test_cov_corr.py
  python/pandas/tests/series/methods/test_nlargest.py
  python/pandas/tests/series/methods/test_rename_axis.py
  python/pandas/tests/series/methods/test_astype.py
  python/pandas/tests/series/methods/test_interpolate.py
  python/pandas/tests/series/methods/test_describe.py
  python/pandas/tests/series/methods/test_searchsorted.py
  python/pandas/tests/series/methods/test_head_tail.py
  python/pandas/tests/series/methods/test_value_counts.py
  python/pandas/tests/series/methods/test_compare.py
  python/pandas/tests/series/methods/test_tz_localize.py
  python/pandas/tests/series/methods/test_align.py
  python/pandas/tests/series/methods/test_values.py
  python/pandas/tests/series/methods/test_argsort.py
  python/pandas/tests/series/methods/test_rename.py
  python/pandas/tests/series/methods/test_duplicated.py
  python/pandas/tests/series/methods/test_update.py
  python/pandas/tests/series/methods/test_tz_convert.py
  python/pandas/tests/series/methods/test_dropna.py
  python/pandas/tests/series/methods/test_get_numeric_data.py
  python/pandas/tests/series/methods/test_append.py
  python/pandas/tests/series/methods/test_isin.py
  python/pandas/tests/series/methods/test_unstack.py
  python/pandas/tests/series/methods/test_item.py
  python/pandas/tests/series/methods/test_diff.py
  python/pandas/tests/series/methods/test_replace.py
  python/pandas/tests/series/methods/test_copy.py
  python/pandas/tests/series/methods/test_pct_change.py
  python/pandas/tests/series/methods/test_infer_objects.py
  python/pandas/tests/series/methods/test_clip.py
  python/pandas/tests/series/methods/test_asof.py
  python/pandas/tests/series/methods/test_drop.py
  python/pandas/tests/series/methods/test_matmul.py
  python/pandas/tests/series/methods/test_pop.py
  python/pandas/tests/series/methods/test_truncate.py
  python/pandas/tests/series/methods/test_to_frame.py
  python/pandas/tests/series/methods/test_combine_first.py
  python/pandas/tests/series/methods/test_equals.py
  python/pandas/tests/series/methods/__init__.py
  python/pandas/tests/series/methods/test_shift.py
  python/pandas/tests/series/methods/test_convert.py
  python/pandas/tests/series/methods/test_to_dict.py
  python/pandas/tests/series/methods/test_isna.py
  python/pandas/tests/series/methods/test_reset_index.py
  python/pandas/tests/series/methods/test_round.py
  python/pandas/tests/series/methods/test_asfreq.py
  python/pandas/tests/series/methods/test_rank.py
  python/pandas/tests/series/methods/test_reindex.py
  python/pandas/tests/series/methods/test_count.py
  python/pandas/tests/series/methods/test_sort_values.py
  python/pandas/tests/series/methods/test_set_name.py
  python/pandas/tests/series/methods/__pycache__/
  python/pandas/tests/series/methods/__pycache__/test_rename_axis.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_repeat.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_align.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_sort_index.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_append.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_sort_values.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_argsort.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_to_csv.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_to_dict.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_asof.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_to_frame.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_truncate.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_autocorr.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_tz_convert.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_between.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_tz_localize.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_clip.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_unstack.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_combine.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_nlargest.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_combine_first.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_update.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_compare.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_convert.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_pct_change.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_convert_dtypes.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_values.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_copy.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_view.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_count.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_cov_corr.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_describe.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_diff.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_drop.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_quantile.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_drop_duplicates.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_dropna.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_pop.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_duplicated.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_explode.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_rank.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_get_numeric_data.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_head_tail.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_rename.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_infer_objects.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_reindex_like.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_interpolate.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_is_monotonic.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_isin.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_isna.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_item.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_matmul.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_replace.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_set_name.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_reset_index.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_round.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_searchsorted.cpython-37.pyc
  python/pandas/tests/series/accessors/
  python/pandas/tests/series/accessors/test_sparse_accessor.py
  python/pandas/tests/series/accessors/test_cat_accessor.py
  python/pandas/tests/series/accessors/test_dt_accessor.py
  python/pandas/tests/series/accessors/__init__.py
  python/pandas/tests/series/accessors/test_str_accessor.py
  python/pandas/tests/series/accessors/__pycache__/
  python/pandas/tests/series/accessors/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_cat_accessor.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_dt_accessor.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_sparse_accessor.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_str_accessor.cpython-37.pyc
  python/pandas/tests/series/__pycache__/
  python/pandas/tests/series/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_cumulative.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_duplicates.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_iteration.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_logical_ops.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_npfuncs.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_reductions.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_subclass.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_ufunc.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_unary.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_validate.cpython-37.pyc
  python/pandas/tests/computation/
  python/pandas/tests/computation/test_compat.py
  python/pandas/tests/computation/__init__.py
  python/pandas/tests/computation/test_eval.py
  python/pandas/tests/computation/__pycache__/
  python/pandas/tests/computation/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/computation/__pycache__/test_compat.cpython-37.pyc
  python/pandas/tests/computation/__pycache__/test_eval.cpython-37.pyc
  python/pandas/tests/api/
  python/pandas/tests/api/test_api.py
  python/pandas/tests/api/__init__.py
  python/pandas/tests/api/test_types.py
  python/pandas/tests/api/__pycache__/
  python/pandas/tests/api/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/api/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/api/__pycache__/test_types.cpython-37.pyc
  python/pandas/tests/indexing/
  python/pandas/tests/indexing/test_indexing.py
  python/pandas/tests/indexing/test_iat.py
  python/pandas/tests/indexing/test_datetime.py
  python/pandas/tests/indexing/common.py
  python/pandas/tests/indexing/test_chaining_and_caching.py
  python/pandas/tests/indexing/test_coercion.py
  python/pandas/tests/indexing/test_indexers.py
  python/pandas/tests/indexing/test_categorical.py
  python/pandas/tests/indexing/test_na_indexing.py
  python/pandas/tests/indexing/test_check_indexer.py
  python/pandas/tests/indexing/test_partial.py
  python/pandas/tests/indexing/__init__.py
  python/pandas/tests/indexing/test_floats.py
  python/pandas/tests/indexing/test_iloc.py
  python/pandas/tests/indexing/test_scalar.py
  python/pandas/tests/indexing/test_at.py
  python/pandas/tests/indexing/test_loc.py
  python/pandas/tests/indexing/multiindex/
  python/pandas/tests/indexing/multiindex/test_ix.py
  python/pandas/tests/indexing/multiindex/test_slice.py
  python/pandas/tests/indexing/multiindex/test_multiindex.py
  python/pandas/tests/indexing/multiindex/test_getitem.py
  python/pandas/tests/indexing/multiindex/test_datetime.py
  python/pandas/tests/indexing/multiindex/test_chaining_and_caching.py
  python/pandas/tests/indexing/multiindex/test_partial.py
  python/pandas/tests/indexing/multiindex/__init__.py
  python/pandas/tests/indexing/multiindex/test_sorted.py
  python/pandas/tests/indexing/multiindex/test_insert.py
  python/pandas/tests/indexing/multiindex/test_iloc.py
  python/pandas/tests/indexing/multiindex/test_indexing_slow.py
  python/pandas/tests/indexing/multiindex/test_loc.py
  python/pandas/tests/indexing/multiindex/test_setitem.py
  python/pandas/tests/indexing/multiindex/__pycache__/
  python/pandas/tests/indexing/multiindex/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_chaining_and_caching.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_getitem.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_iloc.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_indexing_slow.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_ix.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_loc.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_multiindex.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_partial.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_setitem.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_slice.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_sorted.cpython-37.pyc
  python/pandas/tests/indexing/interval/
  python/pandas/tests/indexing/interval/test_interval.py
  python/pandas/tests/indexing/interval/test_interval_new.py
  python/pandas/tests/indexing/interval/__init__.py
  python/pandas/tests/indexing/interval/__pycache__/
  python/pandas/tests/indexing/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexing/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/indexing/interval/__pycache__/test_interval_new.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/
  python/pandas/tests/indexing/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/common.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_at.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_chaining_and_caching.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_check_indexer.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_coercion.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_floats.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_iat.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_iloc.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_indexers.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_loc.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_na_indexing.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_partial.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_scalar.cpython-37.pyc
  python/pandas/tests/base/
  python/pandas/tests/base/test_fillna.py
  python/pandas/tests/base/test_constructors.py
  python/pandas/tests/base/test_misc.py
  python/pandas/tests/base/test_unique.py
  python/pandas/tests/base/test_value_counts.py
  python/pandas/tests/base/test_conversion.py
  python/pandas/tests/base/test_transpose.py
  python/pandas/tests/base/common.py
  python/pandas/tests/base/__init__.py
  python/pandas/tests/base/__pycache__/
  python/pandas/tests/base/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/base/__pycache__/common.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_conversion.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_misc.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_transpose.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_unique.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/libs/
  python/pandas/tests/libs/test_join.py
  python/pandas/tests/libs/test_lib.py
  python/pandas/tests/libs/test_hashtable.py
  python/pandas/tests/libs/__init__.py
  python/pandas/tests/libs/__pycache__/
  python/pandas/tests/libs/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/libs/__pycache__/test_hashtable.cpython-37.pyc
  python/pandas/tests/libs/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/libs/__pycache__/test_lib.cpython-37.pyc
  python/pandas/tests/plotting/
  python/pandas/tests/plotting/test_converter.py
  python/pandas/tests/plotting/test_series.py
  python/pandas/tests/plotting/test_boxplot_method.py
  python/pandas/tests/plotting/test_misc.py
  python/pandas/tests/plotting/test_datetimelike.py
  python/pandas/tests/plotting/common.py
  python/pandas/tests/plotting/test_style.py
  python/pandas/tests/plotting/__init__.py
  python/pandas/tests/plotting/test_hist_method.py
  python/pandas/tests/plotting/test_backend.py
  python/pandas/tests/plotting/test_common.py
  python/pandas/tests/plotting/test_groupby.py
  python/pandas/tests/plotting/frame/
  python/pandas/tests/plotting/frame/test_frame.py
  python/pandas/tests/plotting/frame/test_frame_groupby.py
  python/pandas/tests/plotting/frame/test_frame_color.py
  python/pandas/tests/plotting/frame/test_frame_subplots.py
  python/pandas/tests/plotting/frame/__init__.py
  python/pandas/tests/plotting/frame/__pycache__/
  python/pandas/tests/plotting/frame/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame_color.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame_groupby.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame_subplots.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/
  python/pandas/tests/plotting/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/common.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_backend.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_boxplot_method.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_converter.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_groupby.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_hist_method.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_misc.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_series.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_style.cpython-37.pyc
  python/pandas/tests/reductions/
  python/pandas/tests/reductions/test_reductions.py
  python/pandas/tests/reductions/__init__.py
  python/pandas/tests/reductions/test_stat_reductions.py
  python/pandas/tests/reductions/__pycache__/
  python/pandas/tests/reductions/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reductions/__pycache__/test_reductions.cpython-37.pyc
  python/pandas/tests/reductions/__pycache__/test_stat_reductions.cpython-37.pyc
  python/pandas/tests/io/
  python/pandas/tests/io/test_orc.py
  python/pandas/tests/io/test_html.py
  python/pandas/tests/io/test_clipboard.py
  python/pandas/tests/io/test_parquet.py
  python/pandas/tests/io/test_pickle.py
  python/pandas/tests/io/test_feather.py
  python/pandas/tests/io/test_gcs.py
  python/pandas/tests/io/conftest.py
  python/pandas/tests/io/test_spss.py
  python/pandas/tests/io/generate_legacy_storage_files.py
  python/pandas/tests/io/test_stata.py
  python/pandas/tests/io/test_gbq.py
  python/pandas/tests/io/__init__.py
  python/pandas/tests/io/test_date_converters.py
  python/pandas/tests/io/test_fsspec.py
  python/pandas/tests/io/test_s3.py
  python/pandas/tests/io/test_sql.py
  python/pandas/tests/io/test_common.py
  python/pandas/tests/io/test_compression.py
  python/pandas/tests/io/pytables/
  python/pandas/tests/io/pytables/test_compat.py
  python/pandas/tests/io/pytables/test_complex.py
  python/pandas/tests/io/pytables/test_timezones.py
  python/pandas/tests/io/pytables/test_pytables_missing.py
  python/pandas/tests/io/pytables/conftest.py
  python/pandas/tests/io/pytables/common.py
  python/pandas/tests/io/pytables/test_store.py
  python/pandas/tests/io/pytables/__init__.py
  python/pandas/tests/io/pytables/__pycache__/
  python/pandas/tests/io/pytables/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/common.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_compat.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_complex.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_pytables_missing.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_store.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/io/formats/
  python/pandas/tests/io/formats/test_info.py
  python/pandas/tests/io/formats/test_to_csv.py
  python/pandas/tests/io/formats/test_console.py
  python/pandas/tests/io/formats/test_to_latex.py
  python/pandas/tests/io/formats/test_format.py
  python/pandas/tests/io/formats/test_to_string.py
  python/pandas/tests/io/formats/test_eng_formatting.py
  python/pandas/tests/io/formats/test_to_excel.py
  python/pandas/tests/io/formats/test_to_markdown.py
  python/pandas/tests/io/formats/test_style.py
  python/pandas/tests/io/formats/test_css.py
  python/pandas/tests/io/formats/test_to_html.py
  python/pandas/tests/io/formats/__init__.py
  python/pandas/tests/io/formats/test_printing.py
  python/pandas/tests/io/formats/__pycache__/
  python/pandas/tests/io/formats/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_console.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_css.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_eng_formatting.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_format.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_info.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_printing.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_style.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_csv.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_excel.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_html.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_latex.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_markdown.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_string.cpython-37.pyc
  python/pandas/tests/io/excel/
  python/pandas/tests/io/excel/test_xlwt.py
  python/pandas/tests/io/excel/test_xlsxwriter.py
  python/pandas/tests/io/excel/test_odf.py
  python/pandas/tests/io/excel/test_xlrd.py
  python/pandas/tests/io/excel/test_openpyxl.py
  python/pandas/tests/io/excel/conftest.py
  python/pandas/tests/io/excel/test_odswriter.py
  python/pandas/tests/io/excel/test_writers.py
  python/pandas/tests/io/excel/test_style.py
  python/pandas/tests/io/excel/__init__.py
  python/pandas/tests/io/excel/test_readers.py
  python/pandas/tests/io/excel/__pycache__/
  python/pandas/tests/io/excel/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_odf.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_odswriter.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_openpyxl.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_readers.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_style.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_writers.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_xlrd.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_xlsxwriter.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_xlwt.cpython-37.pyc
  python/pandas/tests/io/parser/
  python/pandas/tests/io/parser/test_c_parser_only.py
  python/pandas/tests/io/parser/test_multi_thread.py
  python/pandas/tests/io/parser/test_dtypes.py
  python/pandas/tests/io/parser/test_read_fwf.py
  python/pandas/tests/io/parser/test_na_values.py
  python/pandas/tests/io/parser/conftest.py
  python/pandas/tests/io/parser/test_dialect.py
  python/pandas/tests/io/parser/test_encoding.py
  python/pandas/tests/io/parser/test_skiprows.py
  python/pandas/tests/io/parser/test_comment.py
  python/pandas/tests/io/parser/test_index_col.py
  python/pandas/tests/io/parser/test_quoting.py
  python/pandas/tests/io/parser/test_parse_dates.py
  python/pandas/tests/io/parser/__init__.py
  python/pandas/tests/io/parser/test_usecols.py
  python/pandas/tests/io/parser/test_python_parser_only.py
  python/pandas/tests/io/parser/test_textreader.py
  python/pandas/tests/io/parser/test_unsupported.py
  python/pandas/tests/io/parser/test_header.py
  python/pandas/tests/io/parser/test_mangle_dupes.py
  python/pandas/tests/io/parser/test_common.py
  python/pandas/tests/io/parser/test_network.py
  python/pandas/tests/io/parser/test_compression.py
  python/pandas/tests/io/parser/test_converters.py
  python/pandas/tests/io/parser/__pycache__/
  python/pandas/tests/io/parser/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_c_parser_only.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_comment.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_compression.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_converters.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_dialect.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_encoding.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_header.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_index_col.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_mangle_dupes.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_multi_thread.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_na_values.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_network.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_parse_dates.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_python_parser_only.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_quoting.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_read_fwf.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_skiprows.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_textreader.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_unsupported.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_usecols.cpython-37.pyc
  python/pandas/tests/io/sas/
  python/pandas/tests/io/sas/test_sas.py
  python/pandas/tests/io/sas/test_sas7bdat.py
  python/pandas/tests/io/sas/test_xport.py
  python/pandas/tests/io/sas/__init__.py
  python/pandas/tests/io/sas/__pycache__/
  python/pandas/tests/io/sas/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/sas/__pycache__/test_sas.cpython-37.pyc
  python/pandas/tests/io/sas/__pycache__/test_sas7bdat.cpython-37.pyc
  python/pandas/tests/io/sas/__pycache__/test_xport.cpython-37.pyc
  python/pandas/tests/io/json/
  python/pandas/tests/io/json/test_readlines.py
  python/pandas/tests/io/json/test_json_table_schema.py
  python/pandas/tests/io/json/test_ujson.py
  python/pandas/tests/io/json/test_pandas.py
  python/pandas/tests/io/json/conftest.py
  python/pandas/tests/io/json/test_normalize.py
  python/pandas/tests/io/json/test_deprecated_kwargs.py
  python/pandas/tests/io/json/__init__.py
  python/pandas/tests/io/json/test_compression.py
  python/pandas/tests/io/json/__pycache__/
  python/pandas/tests/io/json/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_compression.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_deprecated_kwargs.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_json_table_schema.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_normalize.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_pandas.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_readlines.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_ujson.cpython-37.pyc
  python/pandas/tests/io/__pycache__/
  python/pandas/tests/io/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/__pycache__/generate_legacy_storage_files.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_clipboard.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_compression.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_date_converters.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_feather.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_fsspec.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_gbq.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_gcs.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_html.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_orc.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_parquet.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_pickle.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_s3.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_spss.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_sql.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_stata.cpython-37.pyc
  python/pandas/tests/config/
  python/pandas/tests/config/test_config.py
  python/pandas/tests/config/test_localization.py
  python/pandas/tests/config/__init__.py
  python/pandas/tests/config/__pycache__/
  python/pandas/tests/config/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/config/__pycache__/test_config.cpython-37.pyc
  python/pandas/tests/config/__pycache__/test_localization.cpython-37.pyc
  python/pandas/tests/reshape/
  python/pandas/tests/reshape/test_pivot_multilevel.py
  python/pandas/tests/reshape/test_util.py
  python/pandas/tests/reshape/test_pivot.py
  python/pandas/tests/reshape/test_get_dummies.py
  python/pandas/tests/reshape/test_melt.py
  python/pandas/tests/reshape/test_crosstab.py
  python/pandas/tests/reshape/test_qcut.py
  python/pandas/tests/reshape/test_union_categoricals.py
  python/pandas/tests/reshape/__init__.py
  python/pandas/tests/reshape/test_cut.py
  python/pandas/tests/reshape/merge/
  python/pandas/tests/reshape/merge/test_merge_asof.py
  python/pandas/tests/reshape/merge/test_merge_cross.py
  python/pandas/tests/reshape/merge/test_join.py
  python/pandas/tests/reshape/merge/test_merge_index_as_string.py
  python/pandas/tests/reshape/merge/test_merge.py
  python/pandas/tests/reshape/merge/__init__.py
  python/pandas/tests/reshape/merge/test_multi.py
  python/pandas/tests/reshape/merge/test_merge_ordered.py
  python/pandas/tests/reshape/merge/__pycache__/
  python/pandas/tests/reshape/merge/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_asof.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_cross.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_index_as_string.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_ordered.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_multi.cpython-37.pyc
  python/pandas/tests/reshape/concat/
  python/pandas/tests/reshape/concat/test_series.py
  python/pandas/tests/reshape/concat/conftest.py
  python/pandas/tests/reshape/concat/test_invalid.py
  python/pandas/tests/reshape/concat/test_sort.py
  python/pandas/tests/reshape/concat/test_concat.py
  python/pandas/tests/reshape/concat/test_append.py
  python/pandas/tests/reshape/concat/test_index.py
  python/pandas/tests/reshape/concat/test_categorical.py
  python/pandas/tests/reshape/concat/test_datetimes.py
  python/pandas/tests/reshape/concat/__init__.py
  python/pandas/tests/reshape/concat/test_append_common.py
  python/pandas/tests/reshape/concat/test_empty.py
  python/pandas/tests/reshape/concat/test_dataframe.py
  python/pandas/tests/reshape/concat/__pycache__/
  python/pandas/tests/reshape/concat/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_append.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_append_common.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_dataframe.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_datetimes.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_empty.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_index.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_invalid.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_series.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_sort.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/
  python/pandas/tests/reshape/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_crosstab.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_cut.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_get_dummies.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_melt.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_pivot.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_pivot_multilevel.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_qcut.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_union_categoricals.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_util.cpython-37.pyc
  python/pandas/tests/tseries/
  python/pandas/tests/tseries/__init__.py
  python/pandas/tests/tseries/offsets/
  python/pandas/tests/tseries/offsets/test_offsets.py
  python/pandas/tests/tseries/offsets/test_ticks.py
  python/pandas/tests/tseries/offsets/conftest.py
  python/pandas/tests/tseries/offsets/common.py
  python/pandas/tests/tseries/offsets/test_offsets_properties.py
  python/pandas/tests/tseries/offsets/__init__.py
  python/pandas/tests/tseries/offsets/test_fiscal.py
  python/pandas/tests/tseries/offsets/test_yqm_offsets.py
  python/pandas/tests/tseries/offsets/__pycache__/
  python/pandas/tests/tseries/offsets/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/common.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_fiscal.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_offsets.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_offsets_properties.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_ticks.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_yqm_offsets.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/
  python/pandas/tests/tseries/frequencies/test_freq_code.py
  python/pandas/tests/tseries/frequencies/test_inference.py
  python/pandas/tests/tseries/frequencies/test_frequencies.py
  python/pandas/tests/tseries/frequencies/__init__.py
  python/pandas/tests/tseries/frequencies/__pycache__/
  python/pandas/tests/tseries/frequencies/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/__pycache__/test_freq_code.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/__pycache__/test_frequencies.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/__pycache__/test_inference.cpython-37.pyc
  python/pandas/tests/tseries/holiday/
  python/pandas/tests/tseries/holiday/test_observance.py
  python/pandas/tests/tseries/holiday/test_holiday.py
  python/pandas/tests/tseries/holiday/__init__.py
  python/pandas/tests/tseries/holiday/test_federal.py
  python/pandas/tests/tseries/holiday/test_calendar.py
  python/pandas/tests/tseries/holiday/__pycache__/
  python/pandas/tests/tseries/holiday/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_calendar.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_federal.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_holiday.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_observance.cpython-37.pyc
  python/pandas/tests/tseries/__pycache__/
  python/pandas/tests/tseries/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/
  python/pandas/tests/arrays/test_numpy.py
  python/pandas/tests/arrays/test_timedeltas.py
  python/pandas/tests/arrays/test_array.py
  python/pandas/tests/arrays/test_datetimelike.py
  python/pandas/tests/arrays/test_datetimes.py
  python/pandas/tests/arrays/__init__.py
  python/pandas/tests/arrays/test_period.py
  python/pandas/tests/arrays/sparse/
  python/pandas/tests/arrays/sparse/test_array.py
  python/pandas/tests/arrays/sparse/test_arithmetics.py
  python/pandas/tests/arrays/sparse/test_combine_concat.py
  python/pandas/tests/arrays/sparse/__init__.py
  python/pandas/tests/arrays/sparse/test_accessor.py
  python/pandas/tests/arrays/sparse/test_libsparse.py
  python/pandas/tests/arrays/sparse/test_dtype.py
  python/pandas/tests/arrays/sparse/__pycache__/
  python/pandas/tests/arrays/sparse/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_accessor.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_arithmetics.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_array.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_combine_concat.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_dtype.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_libsparse.cpython-37.pyc
  python/pandas/tests/arrays/floating/
  python/pandas/tests/arrays/floating/test_construction.py
  python/pandas/tests/arrays/floating/test_function.py
  python/pandas/tests/arrays/floating/test_astype.py
  python/pandas/tests/arrays/floating/conftest.py
  python/pandas/tests/arrays/floating/test_comparison.py
  python/pandas/tests/arrays/floating/test_concat.py
  python/pandas/tests/arrays/floating/test_to_numpy.py
  python/pandas/tests/arrays/floating/test_repr.py
  python/pandas/tests/arrays/floating/__init__.py
  python/pandas/tests/arrays/floating/test_arithmetic.py
  python/pandas/tests/arrays/floating/__pycache__/
  python/pandas/tests/arrays/floating/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_comparison.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_construction.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_to_numpy.cpython-37.pyc
  python/pandas/tests/arrays/boolean/
  python/pandas/tests/arrays/boolean/test_construction.py
  python/pandas/tests/arrays/boolean/test_function.py
  python/pandas/tests/arrays/boolean/test_indexing.py
  python/pandas/tests/arrays/boolean/test_logical.py
  python/pandas/tests/arrays/boolean/test_astype.py
  python/pandas/tests/arrays/boolean/test_comparison.py
  python/pandas/tests/arrays/boolean/test_repr.py
  python/pandas/tests/arrays/boolean/test_ops.py
  python/pandas/tests/arrays/boolean/__init__.py
  python/pandas/tests/arrays/boolean/test_arithmetic.py
  python/pandas/tests/arrays/boolean/test_reduction.py
  python/pandas/tests/arrays/boolean/__pycache__/
  python/pandas/tests/arrays/boolean/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_comparison.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_construction.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_logical.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_reduction.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/masked/
  python/pandas/tests/arrays/masked/test_arrow_compat.py
  python/pandas/tests/arrays/masked/__init__.py
  python/pandas/tests/arrays/masked/test_arithmetic.py
  python/pandas/tests/arrays/masked/__pycache__/
  python/pandas/tests/arrays/masked/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/masked/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/masked/__pycache__/test_arrow_compat.cpython-37.pyc
  python/pandas/tests/arrays/string_/
  python/pandas/tests/arrays/string_/__init__.py
  python/pandas/tests/arrays/string_/test_string.py
  python/pandas/tests/arrays/string_/test_string_arrow.py
  python/pandas/tests/arrays/string_/__pycache__/
  python/pandas/tests/arrays/string_/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/string_/__pycache__/test_string.cpython-37.pyc
  python/pandas/tests/arrays/string_/__pycache__/test_string_arrow.cpython-37.pyc
  python/pandas/tests/arrays/categorical/
  python/pandas/tests/arrays/categorical/test_subclass.py
  python/pandas/tests/arrays/categorical/test_missing.py
  python/pandas/tests/arrays/categorical/test_constructors.py
  python/pandas/tests/arrays/categorical/test_indexing.py
  python/pandas/tests/arrays/categorical/test_take.py
  python/pandas/tests/arrays/categorical/test_dtypes.py
  python/pandas/tests/arrays/categorical/test_warnings.py
  python/pandas/tests/arrays/categorical/conftest.py
  python/pandas/tests/arrays/categorical/common.py
  python/pandas/tests/arrays/categorical/test_algos.py
  python/pandas/tests/arrays/categorical/test_operators.py
  python/pandas/tests/arrays/categorical/test_api.py
  python/pandas/tests/arrays/categorical/test_repr.py
  python/pandas/tests/arrays/categorical/test_replace.py
  python/pandas/tests/arrays/categorical/test_analytics.py
  python/pandas/tests/arrays/categorical/__init__.py
  python/pandas/tests/arrays/categorical/test_sorting.py
  python/pandas/tests/arrays/categorical/__pycache__/
  python/pandas/tests/arrays/categorical/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/common.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_algos.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_analytics.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_operators.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_replace.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_sorting.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_subclass.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_warnings.cpython-37.pyc
  python/pandas/tests/arrays/integer/
  python/pandas/tests/arrays/integer/test_construction.py
  python/pandas/tests/arrays/integer/test_function.py
  python/pandas/tests/arrays/integer/test_indexing.py
  python/pandas/tests/arrays/integer/test_dtypes.py
  python/pandas/tests/arrays/integer/conftest.py
  python/pandas/tests/arrays/integer/test_comparison.py
  python/pandas/tests/arrays/integer/test_concat.py
  python/pandas/tests/arrays/integer/test_repr.py
  python/pandas/tests/arrays/integer/__init__.py
  python/pandas/tests/arrays/integer/test_arithmetic.py
  python/pandas/tests/arrays/integer/__pycache__/
  python/pandas/tests/arrays/integer/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_comparison.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_construction.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/interval/
  python/pandas/tests/arrays/interval/test_astype.py
  python/pandas/tests/arrays/interval/test_interval.py
  python/pandas/tests/arrays/interval/test_ops.py
  python/pandas/tests/arrays/interval/__init__.py
  python/pandas/tests/arrays/interval/__pycache__/
  python/pandas/tests/arrays/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/interval/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/arrays/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/arrays/interval/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/
  python/pandas/tests/arrays/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_array.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_datetimes.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_numpy.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_timedeltas.cpython-37.pyc
  python/pandas/tests/generic/
  python/pandas/tests/generic/test_series.py
  python/pandas/tests/generic/test_frame.py
  python/pandas/tests/generic/test_duplicate_labels.py
  python/pandas/tests/generic/test_to_xarray.py
  python/pandas/tests/generic/__init__.py
  python/pandas/tests/generic/test_label_or_level_utils.py
  python/pandas/tests/generic/test_finalize.py
  python/pandas/tests/generic/test_generic.py
  python/pandas/tests/generic/methods/
  python/pandas/tests/generic/methods/test_reorder_levels.py
  python/pandas/tests/generic/methods/test_sample.py
  python/pandas/tests/generic/methods/test_first_valid_index.py
  python/pandas/tests/generic/methods/test_dot.py
  python/pandas/tests/generic/methods/test_pipe.py
  python/pandas/tests/generic/methods/__init__.py
  python/pandas/tests/generic/methods/test_set_axis.py
  python/pandas/tests/generic/methods/__pycache__/
  python/pandas/tests/generic/methods/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_dot.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_first_valid_index.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_pipe.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_reorder_levels.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_sample.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_set_axis.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/
  python/pandas/tests/generic/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_duplicate_labels.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_finalize.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_frame.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_generic.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_label_or_level_utils.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_series.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_to_xarray.cpython-37.pyc
  python/pandas/tests/resample/
  python/pandas/tests/resample/test_datetime_index.py
  python/pandas/tests/resample/test_deprecated.py
  python/pandas/tests/resample/test_resample_api.py
  python/pandas/tests/resample/test_time_grouper.py
  python/pandas/tests/resample/conftest.py
  python/pandas/tests/resample/test_period_index.py
  python/pandas/tests/resample/test_base.py
  python/pandas/tests/resample/__init__.py
  python/pandas/tests/resample/test_timedelta.py
  python/pandas/tests/resample/test_resampler_grouper.py
  python/pandas/tests/resample/__pycache__/
  python/pandas/tests/resample/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_base.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_datetime_index.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_deprecated.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_period_index.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_resample_api.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_resampler_grouper.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_time_grouper.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_timedelta.cpython-37.pyc
  python/pandas/tests/frame/
  python/pandas/tests/frame/test_subclass.py
  python/pandas/tests/frame/test_nonunique_indexes.py
  python/pandas/tests/frame/test_constructors.py
  python/pandas/tests/frame/test_logical_ops.py
  python/pandas/tests/frame/test_stack_unstack.py
  python/pandas/tests/frame/conftest.py
  python/pandas/tests/frame/common.py
  python/pandas/tests/frame/test_alter_axes.py
  python/pandas/tests/frame/test_reductions.py
  python/pandas/tests/frame/test_validate.py
  python/pandas/tests/frame/test_query_eval.py
  python/pandas/tests/frame/test_repr_info.py
  python/pandas/tests/frame/test_api.py
  python/pandas/tests/frame/test_block_internals.py
  python/pandas/tests/frame/test_npfuncs.py
  python/pandas/tests/frame/test_cumulative.py
  python/pandas/tests/frame/__init__.py
  python/pandas/tests/frame/test_arithmetic.py
  python/pandas/tests/frame/test_ufunc.py
  python/pandas/tests/frame/test_unary.py
  python/pandas/tests/frame/test_iteration.py
  python/pandas/tests/frame/indexing/
  python/pandas/tests/frame/indexing/test_where.py
  python/pandas/tests/frame/indexing/test_indexing.py
  python/pandas/tests/frame/indexing/test_take.py
  python/pandas/tests/frame/indexing/test_lookup.py
  python/pandas/tests/frame/indexing/test_set_value.py
  python/pandas/tests/frame/indexing/test_get_value.py
  python/pandas/tests/frame/indexing/test_xs.py
  python/pandas/tests/frame/indexing/test_getitem.py
  python/pandas/tests/frame/indexing/test_mask.py
  python/pandas/tests/frame/indexing/test_get.py
  python/pandas/tests/frame/indexing/test_delitem.py
  python/pandas/tests/frame/indexing/test_categorical.py
  python/pandas/tests/frame/indexing/__init__.py
  python/pandas/tests/frame/indexing/test_insert.py
  python/pandas/tests/frame/indexing/test_setitem.py
  python/pandas/tests/frame/indexing/__pycache__/
  python/pandas/tests/frame/indexing/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_delitem.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_get.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_get_value.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_getitem.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_lookup.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_mask.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_set_value.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_setitem.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_where.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_xs.cpython-37.pyc
  python/pandas/tests/frame/apply/
  python/pandas/tests/frame/apply/test_apply_relabeling.py
  python/pandas/tests/frame/apply/test_frame_transform.py
  python/pandas/tests/frame/apply/__init__.py
  python/pandas/tests/frame/apply/test_frame_apply.py
  python/pandas/tests/frame/apply/__pycache__/
  python/pandas/tests/frame/apply/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/apply/__pycache__/test_apply_relabeling.cpython-37.pyc
  python/pandas/tests/frame/apply/__pycache__/test_frame_apply.cpython-37.pyc
  python/pandas/tests/frame/apply/__pycache__/test_frame_transform.cpython-37.pyc
  python/pandas/tests/frame/methods/
  python/pandas/tests/frame/methods/test_to_csv.py
  python/pandas/tests/frame/methods/test_convert_dtypes.py
  python/pandas/tests/frame/methods/test_explode.py
  python/pandas/tests/frame/methods/test_reindex_like.py
  python/pandas/tests/frame/methods/test_combine.py
  python/pandas/tests/frame/methods/test_filter.py
  python/pandas/tests/frame/methods/test_fillna.py
  python/pandas/tests/frame/methods/test_first_and_last.py
  python/pandas/tests/frame/methods/test_swapaxes.py
  python/pandas/tests/frame/methods/test_quantile.py
  python/pandas/tests/frame/methods/test_sort_index.py
  python/pandas/tests/frame/methods/test_drop_duplicates.py
  python/pandas/tests/frame/methods/test_to_period.py
  python/pandas/tests/frame/methods/test_cov_corr.py
  python/pandas/tests/frame/methods/test_nlargest.py
  python/pandas/tests/frame/methods/test_dtypes.py
  python/pandas/tests/frame/methods/test_rename_axis.py
  python/pandas/tests/frame/methods/test_astype.py
  python/pandas/tests/frame/methods/test_interpolate.py
  python/pandas/tests/frame/methods/test_select_dtypes.py
  python/pandas/tests/frame/methods/test_is_homogeneous_dtype.py
  python/pandas/tests/frame/methods/test_describe.py
  python/pandas/tests/frame/methods/test_at_time.py
  python/pandas/tests/frame/methods/test_head_tail.py
  python/pandas/tests/frame/methods/test_value_counts.py
  python/pandas/tests/frame/methods/test_compare.py
  python/pandas/tests/frame/methods/test_tz_localize.py
  python/pandas/tests/frame/methods/test_between_time.py
  python/pandas/tests/frame/methods/test_set_index.py
  python/pandas/tests/frame/methods/test_align.py
  python/pandas/tests/frame/methods/test_transpose.py
  python/pandas/tests/frame/methods/test_values.py
  python/pandas/tests/frame/methods/test_join.py
  python/pandas/tests/frame/methods/test_rename.py
  python/pandas/tests/frame/methods/test_duplicated.py
  python/pandas/tests/frame/methods/test_update.py
  python/pandas/tests/frame/methods/test_tz_convert.py
  python/pandas/tests/frame/methods/test_dropna.py
  python/pandas/tests/frame/methods/test_to_numpy.py
  python/pandas/tests/frame/methods/test_get_numeric_data.py
  python/pandas/tests/frame/methods/test_append.py
  python/pandas/tests/frame/methods/test_isin.py
  python/pandas/tests/frame/methods/test_to_timestamp.py
  python/pandas/tests/frame/methods/test_diff.py
  python/pandas/tests/frame/methods/test_replace.py
  python/pandas/tests/frame/methods/test_copy.py
  python/pandas/tests/frame/methods/test_pct_change.py
  python/pandas/tests/frame/methods/test_to_records.py
  python/pandas/tests/frame/methods/test_infer_objects.py
  python/pandas/tests/frame/methods/test_clip.py
  python/pandas/tests/frame/methods/test_asof.py
  python/pandas/tests/frame/methods/test_drop.py
  python/pandas/tests/frame/methods/test_matmul.py
  python/pandas/tests/frame/methods/test_pop.py
  python/pandas/tests/frame/methods/test_truncate.py
  python/pandas/tests/frame/methods/test_combine_first.py
  python/pandas/tests/frame/methods/test_equals.py
  python/pandas/tests/frame/methods/__init__.py
  python/pandas/tests/frame/methods/test_shift.py
  python/pandas/tests/frame/methods/test_convert.py
  python/pandas/tests/frame/methods/test_swaplevel.py
  python/pandas/tests/frame/methods/test_to_dict.py
  python/pandas/tests/frame/methods/test_reset_index.py
  python/pandas/tests/frame/methods/test_round.py
  python/pandas/tests/frame/methods/test_to_dict_of_blocks.py
  python/pandas/tests/frame/methods/test_asfreq.py
  python/pandas/tests/frame/methods/test_rank.py
  python/pandas/tests/frame/methods/test_add_prefix_suffix.py
  python/pandas/tests/frame/methods/test_reindex.py
  python/pandas/tests/frame/methods/test_count.py
  python/pandas/tests/frame/methods/test_droplevel.py
  python/pandas/tests/frame/methods/test_sort_values.py
  python/pandas/tests/frame/methods/test_assign.py
  python/pandas/tests/frame/methods/__pycache__/
  python/pandas/tests/frame/methods/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_interpolate.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_add_prefix_suffix.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_reindex_like.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_align.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_rename.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_append.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_rename_axis.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_replace.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_asof.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_reset_index.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_assign.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_round.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_csv.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_at_time.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_is_homogeneous_dtype.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_between_time.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_dict.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_clip.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_dict_of_blocks.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_combine.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_isin.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_combine_first.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_numpy.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_compare.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_period.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_convert.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_convert_dtypes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_records.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_copy.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_timestamp.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_count.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_transpose.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_cov_corr.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_truncate.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_describe.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_tz_convert.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_diff.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_tz_localize.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_drop.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_matmul.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_drop_duplicates.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_nlargest.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_droplevel.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_update.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_dropna.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_pct_change.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_duplicated.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_values.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_explode.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_filter.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_pop.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_first_and_last.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_quantile.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_get_numeric_data.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_sort_values.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_head_tail.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_rank.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_infer_objects.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_select_dtypes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_swapaxes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_set_index.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_swaplevel.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_sort_index.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/
  python/pandas/tests/frame/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/common.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_alter_axes.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_block_internals.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_cumulative.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_iteration.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_logical_ops.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_nonunique_indexes.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_npfuncs.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_query_eval.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_reductions.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_repr_info.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_stack_unstack.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_subclass.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_ufunc.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_unary.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_validate.cpython-37.pyc
  python/pandas/tests/groupby/
  python/pandas/tests/groupby/test_groupby_shift_diff.py
  python/pandas/tests/groupby/test_grouping.py
  python/pandas/tests/groupby/test_function.py
  python/pandas/tests/groupby/test_missing.py
  python/pandas/tests/groupby/test_nunique.py
  python/pandas/tests/groupby/test_allowlist.py
  python/pandas/tests/groupby/test_quantile.py
  python/pandas/tests/groupby/test_index_as_string.py
  python/pandas/tests/groupby/test_apply_mutate.py
  python/pandas/tests/groupby/test_groupby_subclass.py
  python/pandas/tests/groupby/test_apply.py
  python/pandas/tests/groupby/test_value_counts.py
  python/pandas/tests/groupby/test_sample.py
  python/pandas/tests/groupby/test_size.py
  python/pandas/tests/groupby/conftest.py
  python/pandas/tests/groupby/test_filters.py
  python/pandas/tests/groupby/test_nth.py
  python/pandas/tests/groupby/test_groupby_dropna.py
  python/pandas/tests/groupby/test_libgroupby.py
  python/pandas/tests/groupby/test_pipe.py
  python/pandas/tests/groupby/test_categorical.py
  python/pandas/tests/groupby/__init__.py
  python/pandas/tests/groupby/test_timegrouper.py
  python/pandas/tests/groupby/test_counting.py
  python/pandas/tests/groupby/test_bin_groupby.py
  python/pandas/tests/groupby/test_rank.py
  python/pandas/tests/groupby/test_groupby.py
  python/pandas/tests/groupby/transform/
  python/pandas/tests/groupby/transform/test_numba.py
  python/pandas/tests/groupby/transform/test_transform.py
  python/pandas/tests/groupby/transform/__init__.py
  python/pandas/tests/groupby/transform/__pycache__/
  python/pandas/tests/groupby/transform/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/groupby/transform/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/groupby/transform/__pycache__/test_transform.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/
  python/pandas/tests/groupby/aggregate/test_other.py
  python/pandas/tests/groupby/aggregate/test_aggregate.py
  python/pandas/tests/groupby/aggregate/test_numba.py
  python/pandas/tests/groupby/aggregate/__init__.py
  python/pandas/tests/groupby/aggregate/test_cython.py
  python/pandas/tests/groupby/aggregate/__pycache__/
  python/pandas/tests/groupby/aggregate/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_aggregate.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_cython.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_other.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/
  python/pandas/tests/groupby/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_allowlist.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_apply.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_apply_mutate.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_bin_groupby.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_counting.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_filters.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby_dropna.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby_shift_diff.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby_subclass.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_grouping.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_index_as_string.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_libgroupby.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_nth.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_nunique.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_pipe.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_quantile.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_rank.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_sample.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_size.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_timegrouper.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/tslibs/
  python/pandas/tests/tslibs/test_ccalendar.py
  python/pandas/tests/tslibs/test_timedeltas.py
  python/pandas/tests/tslibs/test_libfrequencies.py
  python/pandas/tests/tslibs/test_parsing.py
  python/pandas/tests/tslibs/test_array_to_datetime.py
  python/pandas/tests/tslibs/test_parse_iso8601.py
  python/pandas/tests/tslibs/test_timezones.py
  python/pandas/tests/tslibs/test_conversion.py
  python/pandas/tests/tslibs/test_api.py
  python/pandas/tests/tslibs/test_liboffsets.py
  python/pandas/tests/tslibs/__init__.py
  python/pandas/tests/tslibs/test_to_offset.py
  python/pandas/tests/tslibs/test_period_asfreq.py
  python/pandas/tests/tslibs/test_fields.py
  python/pandas/tests/tslibs/__pycache__/
  python/pandas/tests/tslibs/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_array_to_datetime.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_ccalendar.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_conversion.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_fields.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_libfrequencies.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_liboffsets.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_parse_iso8601.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_parsing.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_period_asfreq.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_timedeltas.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_to_offset.cpython-37.pyc
  python/pandas/tests/internals/
  python/pandas/tests/internals/__init__.py
  python/pandas/tests/internals/test_internals.py
  python/pandas/tests/internals/__pycache__/
  python/pandas/tests/internals/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/internals/__pycache__/test_internals.cpython-37.pyc
  python/pandas/tests/extension/
  python/pandas/tests/extension/test_numpy.py
  python/pandas/tests/extension/test_boolean.py
  python/pandas/tests/extension/test_interval.py
  python/pandas/tests/extension/test_datetime.py
  python/pandas/tests/extension/conftest.py
  python/pandas/tests/extension/test_floating.py
  python/pandas/tests/extension/test_categorical.py
  python/pandas/tests/extension/test_external_block.py
  python/pandas/tests/extension/__init__.py
  python/pandas/tests/extension/test_string.py
  python/pandas/tests/extension/test_integer.py
  python/pandas/tests/extension/test_period.py
  python/pandas/tests/extension/test_sparse.py
  python/pandas/tests/extension/test_common.py
  python/pandas/tests/extension/decimal/
  python/pandas/tests/extension/decimal/test_decimal.py
  python/pandas/tests/extension/decimal/__init__.py
  python/pandas/tests/extension/decimal/array.py
  python/pandas/tests/extension/decimal/__pycache__/
  python/pandas/tests/extension/decimal/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/decimal/__pycache__/array.cpython-37.pyc
  python/pandas/tests/extension/decimal/__pycache__/test_decimal.cpython-37.pyc
  python/pandas/tests/extension/base/
  python/pandas/tests/extension/base/printing.py
  python/pandas/tests/extension/base/dtype.py
  python/pandas/tests/extension/base/interface.py
  python/pandas/tests/extension/base/ops.py
  python/pandas/tests/extension/base/base.py
  python/pandas/tests/extension/base/getitem.py
  python/pandas/tests/extension/base/io.py
  python/pandas/tests/extension/base/missing.py
  python/pandas/tests/extension/base/methods.py
  python/pandas/tests/extension/base/casting.py
  python/pandas/tests/extension/base/reshaping.py
  python/pandas/tests/extension/base/setitem.py
  python/pandas/tests/extension/base/groupby.py
  python/pandas/tests/extension/base/__init__.py
  python/pandas/tests/extension/base/constructors.py
  python/pandas/tests/extension/base/reduce.py
  python/pandas/tests/extension/base/__pycache__/
  python/pandas/tests/extension/base/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/base.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/casting.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/constructors.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/dtype.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/getitem.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/groupby.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/interface.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/io.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/methods.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/missing.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/ops.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/printing.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/reduce.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/reshaping.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/setitem.cpython-37.pyc
  python/pandas/tests/extension/list/
  python/pandas/tests/extension/list/__init__.py
  python/pandas/tests/extension/list/test_list.py
  python/pandas/tests/extension/list/array.py
  python/pandas/tests/extension/list/__pycache__/
  python/pandas/tests/extension/list/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/list/__pycache__/array.cpython-37.pyc
  python/pandas/tests/extension/list/__pycache__/test_list.cpython-37.pyc
  python/pandas/tests/extension/json/
  python/pandas/tests/extension/json/test_json.py
  python/pandas/tests/extension/json/__init__.py
  python/pandas/tests/extension/json/array.py
  python/pandas/tests/extension/json/__pycache__/
  python/pandas/tests/extension/json/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/json/__pycache__/array.cpython-37.pyc
  python/pandas/tests/extension/json/__pycache__/test_json.cpython-37.pyc
  python/pandas/tests/extension/arrow/
  python/pandas/tests/extension/arrow/arrays.py
  python/pandas/tests/extension/arrow/__init__.py
  python/pandas/tests/extension/arrow/test_string.py
  python/pandas/tests/extension/arrow/test_bool.py
  python/pandas/tests/extension/arrow/__pycache__/
  python/pandas/tests/extension/arrow/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/arrow/__pycache__/arrays.cpython-37.pyc
  python/pandas/tests/extension/arrow/__pycache__/test_bool.cpython-37.pyc
  python/pandas/tests/extension/arrow/__pycache__/test_string.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/
  python/pandas/tests/extension/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_boolean.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_external_block.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_floating.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_integer.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_numpy.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_sparse.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_string.cpython-37.pyc
  python/pandas/tests/tools/
  python/pandas/tests/tools/test_to_datetime.py
  python/pandas/tests/tools/test_to_time.py
  python/pandas/tests/tools/__init__.py
  python/pandas/tests/tools/test_to_numeric.py
  python/pandas/tests/tools/test_to_timedelta.py
  python/pandas/tests/tools/__pycache__/
  python/pandas/tests/tools/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_datetime.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_numeric.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_time.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_timedelta.cpython-37.pyc
  python/pandas/tests/util/
  python/pandas/tests/util/test_assert_produces_warning.py
  python/pandas/tests/util/test_assert_frame_equal.py
  python/pandas/tests/util/test_numba.py
  python/pandas/tests/util/test_util.py
  python/pandas/tests/util/test_assert_interval_array_equal.py
  python/pandas/tests/util/test_deprecate_nonkeyword_arguments.py
  python/pandas/tests/util/test_assert_index_equal.py
  python/pandas/tests/util/conftest.py
  python/pandas/tests/util/test_deprecate.py
  python/pandas/tests/util/test_validate_kwargs.py
  python/pandas/tests/util/test_assert_almost_equal.py
  python/pandas/tests/util/test_deprecate_kwarg.py
  python/pandas/tests/util/test_assert_extension_array_equal.py
  python/pandas/tests/util/__init__.py
  python/pandas/tests/util/test_validate_args_and_kwargs.py
  python/pandas/tests/util/test_assert_numpy_array_equal.py
  python/pandas/tests/util/test_assert_series_equal.py
  python/pandas/tests/util/test_assert_categorical_equal.py
  python/pandas/tests/util/test_safe_import.py
  python/pandas/tests/util/test_doc.py
  python/pandas/tests/util/test_show_versions.py
  python/pandas/tests/util/test_validate_args.py
  python/pandas/tests/util/test_hashing.py
  python/pandas/tests/util/__pycache__/
  python/pandas/tests/util/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/util/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_almost_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_categorical_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_extension_array_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_frame_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_index_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_interval_array_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_numpy_array_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_produces_warning.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_series_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_deprecate.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_deprecate_kwarg.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_deprecate_nonkeyword_arguments.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_doc.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_hashing.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_safe_import.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_show_versions.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_util.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_validate_args.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_validate_args_and_kwargs.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_validate_kwargs.cpython-37.pyc
  python/pandas/tests/__pycache__/
  python/pandas/tests/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/__pycache__/test_aggregation.cpython-37.pyc
  python/pandas/tests/__pycache__/test_algos.cpython-37.pyc
  python/pandas/tests/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/__pycache__/test_downstream.cpython-37.pyc
  python/pandas/tests/__pycache__/test_errors.cpython-37.pyc
  python/pandas/tests/__pycache__/test_expressions.cpython-37.pyc
  python/pandas/tests/__pycache__/test_flags.cpython-37.pyc
  python/pandas/tests/__pycache__/test_multilevel.cpython-37.pyc
  python/pandas/tests/__pycache__/test_nanops.cpython-37.pyc
  python/pandas/tests/__pycache__/test_optional_dependency.cpython-37.pyc
  python/pandas/tests/__pycache__/test_register_accessor.cpython-37.pyc
  python/pandas/tests/__pycache__/test_sorting.cpython-37.pyc
  python/pandas/tests/__pycache__/test_strings.cpython-37.pyc
  python/pandas/tests/__pycache__/test_take.cpython-37.pyc
  python/pandas/core/
  python/pandas/core/api.py
  python/pandas/core/aggregation.py
  python/pandas/core/frame.py
  python/pandas/core/config_init.py
  python/pandas/core/series.py
  python/pandas/core/construction.py
  python/pandas/core/generic.py
  python/pandas/core/nanops.py
  python/pandas/core/sorting.py
  python/pandas/core/common.py
  python/pandas/core/accessor.py
  python/pandas/core/base.py
  python/pandas/core/indexing.py
  python/pandas/core/index.py
  python/pandas/core/arraylike.py
  python/pandas/core/missing.py
  python/pandas/core/resample.py
  python/pandas/core/shared_docs.py
  python/pandas/core/__init__.py
  python/pandas/core/algorithms.py
  python/pandas/core/flags.py
  python/pandas/core/apply.py
  python/pandas/core/indexers.py
  python/pandas/core/window/
  python/pandas/core/window/numba_.py
  python/pandas/core/window/ewm.py
  python/pandas/core/window/common.py
  python/pandas/core/window/expanding.py
  python/pandas/core/window/__init__.py
  python/pandas/core/window/rolling.py
  python/pandas/core/window/indexers.py
  python/pandas/core/window/__pycache__/
  python/pandas/core/window/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/window/__pycache__/common.cpython-37.pyc
  python/pandas/core/window/__pycache__/ewm.cpython-37.pyc
  python/pandas/core/window/__pycache__/expanding.cpython-37.pyc
  python/pandas/core/window/__pycache__/indexers.cpython-37.pyc
  python/pandas/core/window/__pycache__/numba_.cpython-37.pyc
  python/pandas/core/window/__pycache__/rolling.cpython-37.pyc
  python/pandas/core/indexes/
  python/pandas/core/indexes/api.py
  python/pandas/core/indexes/category.py
  python/pandas/core/indexes/frozen.py
  python/pandas/core/indexes/range.py
  python/pandas/core/indexes/interval.py
  python/pandas/core/indexes/timedeltas.py
  python/pandas/core/indexes/base.py
  python/pandas/core/indexes/accessors.py
  python/pandas/core/indexes/extension.py
  python/pandas/core/indexes/period.py
  python/pandas/core/indexes/multi.py
  python/pandas/core/indexes/datetimelike.py
  python/pandas/core/indexes/__init__.py
  python/pandas/core/indexes/datetimes.py
  python/pandas/core/indexes/numeric.py
  python/pandas/core/indexes/__pycache__/
  python/pandas/core/indexes/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/accessors.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/api.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/base.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/category.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/datetimelike.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/datetimes.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/extension.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/frozen.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/interval.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/multi.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/numeric.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/period.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/range.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/timedeltas.cpython-37.pyc
  python/pandas/core/dtypes/
  python/pandas/core/dtypes/api.py
  python/pandas/core/dtypes/generic.py
  python/pandas/core/dtypes/dtypes.py
  python/pandas/core/dtypes/common.py
  python/pandas/core/dtypes/base.py
  python/pandas/core/dtypes/missing.py
  python/pandas/core/dtypes/cast.py
  python/pandas/core/dtypes/inference.py
  python/pandas/core/dtypes/__init__.py
  python/pandas/core/dtypes/concat.py
  python/pandas/core/dtypes/__pycache__/
  python/pandas/core/dtypes/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/api.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/base.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/cast.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/common.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/concat.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/dtypes.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/generic.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/inference.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/missing.cpython-37.pyc
  python/pandas/core/sparse/
  python/pandas/core/sparse/api.py
  python/pandas/core/sparse/__init__.py
  python/pandas/core/sparse/__pycache__/
  python/pandas/core/sparse/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/sparse/__pycache__/api.cpython-37.pyc
  python/pandas/core/computation/
  python/pandas/core/computation/api.py
  python/pandas/core/computation/parsing.py
  python/pandas/core/computation/expr.py
  python/pandas/core/computation/engines.py
  python/pandas/core/computation/ops.py
  python/pandas/core/computation/common.py
  python/pandas/core/computation/check.py
  python/pandas/core/computation/scope.py
  python/pandas/core/computation/expressions.py
  python/pandas/core/computation/align.py
  python/pandas/core/computation/__init__.py
  python/pandas/core/computation/eval.py
  python/pandas/core/computation/pytables.py
  python/pandas/core/computation/__pycache__/
  python/pandas/core/computation/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/computation/__pycache__/align.cpython-37.pyc
  python/pandas/core/computation/__pycache__/api.cpython-37.pyc
  python/pandas/core/computation/__pycache__/check.cpython-37.pyc
  python/pandas/core/computation/__pycache__/common.cpython-37.pyc
  python/pandas/core/computation/__pycache__/engines.cpython-37.pyc
  python/pandas/core/computation/__pycache__/eval.cpython-37.pyc
  python/pandas/core/computation/__pycache__/expr.cpython-37.pyc
  python/pandas/core/computation/__pycache__/expressions.cpython-37.pyc
  python/pandas/core/computation/__pycache__/ops.cpython-37.pyc
  python/pandas/core/computation/__pycache__/parsing.cpython-37.pyc
  python/pandas/core/computation/__pycache__/pytables.cpython-37.pyc
  python/pandas/core/computation/__pycache__/scope.cpython-37.pyc
  python/pandas/core/reshape/
  python/pandas/core/reshape/api.py
  python/pandas/core/reshape/tile.py
  python/pandas/core/reshape/util.py
  python/pandas/core/reshape/merge.py
  python/pandas/core/reshape/reshape.py
  python/pandas/core/reshape/pivot.py
  python/pandas/core/reshape/__init__.py
  python/pandas/core/reshape/melt.py
  python/pandas/core/reshape/concat.py
  python/pandas/core/reshape/__pycache__/
  python/pandas/core/reshape/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/api.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/concat.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/melt.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/merge.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/pivot.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/reshape.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/tile.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/util.cpython-37.pyc
  python/pandas/core/arrays/
  python/pandas/core/arrays/_mixins.py
  python/pandas/core/arrays/boolean.py
  python/pandas/core/arrays/interval.py
  python/pandas/core/arrays/_arrow_utils.py
  python/pandas/core/arrays/timedeltas.py
  python/pandas/core/arrays/base.py
  python/pandas/core/arrays/string_.py
  python/pandas/core/arrays/string_arrow.py
  python/pandas/core/arrays/integer.py
  python/pandas/core/arrays/masked.py
  python/pandas/core/arrays/period.py
  python/pandas/core/arrays/floating.py
  python/pandas/core/arrays/datetimelike.py
  python/pandas/core/arrays/_ranges.py
  python/pandas/core/arrays/__init__.py
  python/pandas/core/arrays/numpy_.py
  python/pandas/core/arrays/datetimes.py
  python/pandas/core/arrays/categorical.py
  python/pandas/core/arrays/numeric.py
  python/pandas/core/arrays/sparse/
  python/pandas/core/arrays/sparse/dtype.py
  python/pandas/core/arrays/sparse/scipy_sparse.py
  python/pandas/core/arrays/sparse/accessor.py
  python/pandas/core/arrays/sparse/__init__.py
  python/pandas/core/arrays/sparse/array.py
  python/pandas/core/arrays/sparse/__pycache__/
  python/pandas/core/arrays/sparse/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/accessor.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/array.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/dtype.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/scipy_sparse.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/
  python/pandas/core/arrays/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/_arrow_utils.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/_mixins.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/_ranges.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/base.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/boolean.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/categorical.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/datetimelike.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/datetimes.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/floating.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/integer.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/interval.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/masked.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/numeric.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/numpy_.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/period.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/string_.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/string_arrow.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/timedeltas.cpython-37.pyc
  python/pandas/core/ops/
  python/pandas/core/ops/mask_ops.py
  python/pandas/core/ops/roperator.py
  python/pandas/core/ops/docstrings.py
  python/pandas/core/ops/common.py
  python/pandas/core/ops/dispatch.py
  python/pandas/core/ops/missing.py
  python/pandas/core/ops/methods.py
  python/pandas/core/ops/__init__.py
  python/pandas/core/ops/invalid.py
  python/pandas/core/ops/array_ops.py
  python/pandas/core/ops/__pycache__/
  python/pandas/core/ops/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/ops/__pycache__/array_ops.cpython-37.pyc
  python/pandas/core/ops/__pycache__/common.cpython-37.pyc
  python/pandas/core/ops/__pycache__/dispatch.cpython-37.pyc
  python/pandas/core/ops/__pycache__/docstrings.cpython-37.pyc
  python/pandas/core/ops/__pycache__/invalid.cpython-37.pyc
  python/pandas/core/ops/__pycache__/mask_ops.cpython-37.pyc
  python/pandas/core/ops/__pycache__/methods.cpython-37.pyc
  python/pandas/core/ops/__pycache__/missing.cpython-37.pyc
  python/pandas/core/ops/__pycache__/roperator.cpython-37.pyc
  python/pandas/core/groupby/
  python/pandas/core/groupby/numba_.py
  python/pandas/core/groupby/generic.py
  python/pandas/core/groupby/ops.py
  python/pandas/core/groupby/base.py
  python/pandas/core/groupby/groupby.py
  python/pandas/core/groupby/__init__.py
  python/pandas/core/groupby/grouper.py
  python/pandas/core/groupby/categorical.py
  python/pandas/core/groupby/__pycache__/
  python/pandas/core/groupby/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/base.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/categorical.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/generic.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/groupby.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/grouper.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/numba_.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/ops.cpython-37.pyc
  python/pandas/core/strings/
  python/pandas/core/strings/accessor.py
  python/pandas/core/strings/base.py
  python/pandas/core/strings/object_array.py
  python/pandas/core/strings/__init__.py
  python/pandas/core/strings/__pycache__/
  python/pandas/core/strings/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/strings/__pycache__/accessor.cpython-37.pyc
  python/pandas/core/strings/__pycache__/base.cpython-37.pyc
  python/pandas/core/strings/__pycache__/object_array.cpython-37.pyc
  python/pandas/core/internals/
  python/pandas/core/internals/blocks.py
  python/pandas/core/internals/construction.py
  python/pandas/core/internals/ops.py
  python/pandas/core/internals/managers.py
  python/pandas/core/internals/__init__.py
  python/pandas/core/internals/concat.py
  python/pandas/core/internals/__pycache__/
  python/pandas/core/internals/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/internals/__pycache__/blocks.cpython-37.pyc
  python/pandas/core/internals/__pycache__/concat.cpython-37.pyc
  python/pandas/core/internals/__pycache__/construction.cpython-37.pyc
  python/pandas/core/internals/__pycache__/managers.cpython-37.pyc
  python/pandas/core/internals/__pycache__/ops.cpython-37.pyc
  python/pandas/core/array_algos/
  python/pandas/core/array_algos/masked_reductions.py
  python/pandas/core/array_algos/transforms.py
  python/pandas/core/array_algos/__init__.py
  python/pandas/core/array_algos/replace.py
  python/pandas/core/array_algos/__pycache__/
  python/pandas/core/array_algos/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/array_algos/__pycache__/masked_reductions.cpython-37.pyc
  python/pandas/core/array_algos/__pycache__/replace.cpython-37.pyc
  python/pandas/core/array_algos/__pycache__/transforms.cpython-37.pyc
  python/pandas/core/tools/
  python/pandas/core/tools/timedeltas.py
  python/pandas/core/tools/__init__.py
  python/pandas/core/tools/datetimes.py
  python/pandas/core/tools/times.py
  python/pandas/core/tools/numeric.py
  python/pandas/core/tools/__pycache__/
  python/pandas/core/tools/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/tools/__pycache__/datetimes.cpython-37.pyc
  python/pandas/core/tools/__pycache__/numeric.cpython-37.pyc
  python/pandas/core/tools/__pycache__/timedeltas.cpython-37.pyc
  python/pandas/core/tools/__pycache__/times.cpython-37.pyc
  python/pandas/core/util/
  python/pandas/core/util/hashing.py
  python/pandas/core/util/numba_.py
  python/pandas/core/util/__init__.py
  python/pandas/core/util/__pycache__/
  python/pandas/core/util/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/util/__pycache__/hashing.cpython-37.pyc
  python/pandas/core/util/__pycache__/numba_.cpython-37.pyc
  python/pandas/core/__pycache__/
  python/pandas/core/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/__pycache__/accessor.cpython-37.pyc
  python/pandas/core/__pycache__/aggregation.cpython-37.pyc
  python/pandas/core/__pycache__/algorithms.cpython-37.pyc
  python/pandas/core/__pycache__/api.cpython-37.pyc
  python/pandas/core/__pycache__/apply.cpython-37.pyc
  python/pandas/core/__pycache__/arraylike.cpython-37.pyc
  python/pandas/core/__pycache__/base.cpython-37.pyc
  python/pandas/core/__pycache__/common.cpython-37.pyc
  python/pandas/core/__pycache__/config_init.cpython-37.pyc
  python/pandas/core/__pycache__/construction.cpython-37.pyc
  python/pandas/core/__pycache__/flags.cpython-37.pyc
  python/pandas/core/__pycache__/frame.cpython-37.pyc
  python/pandas/core/__pycache__/generic.cpython-37.pyc
  python/pandas/core/__pycache__/index.cpython-37.pyc
  python/pandas/core/__pycache__/indexers.cpython-37.pyc
  python/pandas/core/__pycache__/indexing.cpython-37.pyc
  python/pandas/core/__pycache__/missing.cpython-37.pyc
  python/pandas/core/__pycache__/nanops.cpython-37.pyc
  python/pandas/core/__pycache__/resample.cpython-37.pyc
  python/pandas/core/__pycache__/series.cpython-37.pyc
  python/pandas/core/__pycache__/shared_docs.cpython-37.pyc
  python/pandas/core/__pycache__/sorting.cpython-37.pyc
  python/pandas/api/
  python/pandas/api/__init__.py
  python/pandas/api/types/
  python/pandas/api/types/__init__.py
  python/pandas/api/types/__pycache__/
  python/pandas/api/types/__pycache__/__init__.cpython-37.pyc
  python/pandas/api/extensions/
  python/pandas/api/extensions/__init__.py
  python/pandas/api/extensions/__pycache__/
  python/pandas/api/extensions/__pycache__/__init__.cpython-37.pyc
  python/pandas/api/indexers/
  python/pandas/api/indexers/__init__.py
  python/pandas/api/indexers/__pycache__/
  python/pandas/api/indexers/__pycache__/__init__.cpython-37.pyc
  python/pandas/api/__pycache__/
  python/pandas/api/__pycache__/__init__.cpython-37.pyc
  python/pandas/plotting/
  python/pandas/plotting/_misc.py
  python/pandas/plotting/__init__.py
  python/pandas/plotting/_core.py
  python/pandas/plotting/_matplotlib/
  python/pandas/plotting/_matplotlib/style.py
  python/pandas/plotting/_matplotlib/tools.py
  python/pandas/plotting/_matplotlib/boxplot.py
  python/pandas/plotting/_matplotlib/core.py
  python/pandas/plotting/_matplotlib/converter.py
  python/pandas/plotting/_matplotlib/__init__.py
  python/pandas/plotting/_matplotlib/timeseries.py
  python/pandas/plotting/_matplotlib/misc.py
  python/pandas/plotting/_matplotlib/hist.py
  python/pandas/plotting/_matplotlib/compat.py
  python/pandas/plotting/_matplotlib/__pycache__/
  python/pandas/plotting/_matplotlib/__pycache__/__init__.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/boxplot.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/compat.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/converter.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/core.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/hist.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/misc.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/style.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/timeseries.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/tools.cpython-37.pyc
  python/pandas/plotting/__pycache__/
  python/pandas/plotting/__pycache__/__init__.cpython-37.pyc
  python/pandas/plotting/__pycache__/_core.cpython-37.pyc
  python/pandas/plotting/__pycache__/_misc.cpython-37.pyc
  python/pandas/_libs/
  python/pandas/_libs/testing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/groupby.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/parsers.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/reduction.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/interval.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/reshape.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/hashing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/indexing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/writers.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/index.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/internals.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/hashtable.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/json.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/ops.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/algos.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/ops_dispatch.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/__init__.py
  python/pandas/_libs/sparse.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/properties.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/lib.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslib.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/join.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/missing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/window/
  python/pandas/_libs/window/aggregations.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/window/__init__.py
  python/pandas/_libs/window/indexers.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/window/__pycache__/
  python/pandas/_libs/window/__pycache__/__init__.cpython-37.pyc
  python/pandas/_libs/tslibs/
  python/pandas/_libs/tslibs/fields.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/dtypes.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/ccalendar.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/base.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/timezones.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/tzconversion.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/nattype.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/conversion.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/vectorized.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/strptime.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/period.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/parsing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/np_datetime.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/timedeltas.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/__init__.py
  python/pandas/_libs/tslibs/offsets.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/timestamps.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/__pycache__/
  python/pandas/_libs/tslibs/__pycache__/__init__.cpython-37.pyc
  python/pandas/_libs/__pycache__/
  python/pandas/_libs/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/
  python/pandas/io/api.py
  python/pandas/io/html.py
  python/pandas/io/feather_format.py
  python/pandas/io/date_converters.py
  python/pandas/io/clipboards.py
  python/pandas/io/common.py
  python/pandas/io/parquet.py
  python/pandas/io/pickle.py
  python/pandas/io/__init__.py
  python/pandas/io/sql.py
  python/pandas/io/orc.py
  python/pandas/io/gbq.py
  python/pandas/io/parsers.py
  python/pandas/io/pytables.py
  python/pandas/io/stata.py
  python/pandas/io/spss.py
  python/pandas/io/clipboard/
  python/pandas/io/clipboard/__init__.py
  python/pandas/io/clipboard/__pycache__/
  python/pandas/io/clipboard/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/formats/
  python/pandas/io/formats/console.py
  python/pandas/io/formats/style.py
  python/pandas/io/formats/_color_data.py
  python/pandas/io/formats/printing.py
  python/pandas/io/formats/latex.py
  python/pandas/io/formats/html.py
  python/pandas/io/formats/format.py
  python/pandas/io/formats/string.py
  python/pandas/io/formats/info.py
  python/pandas/io/formats/css.py
  python/pandas/io/formats/excel.py
  python/pandas/io/formats/__init__.py
  python/pandas/io/formats/csvs.py
  python/pandas/io/formats/templates/
  python/pandas/io/formats/templates/html.tpl
  python/pandas/io/formats/__pycache__/
  python/pandas/io/formats/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/formats/__pycache__/_color_data.cpython-37.pyc
  python/pandas/io/formats/__pycache__/console.cpython-37.pyc
  python/pandas/io/formats/__pycache__/css.cpython-37.pyc
  python/pandas/io/formats/__pycache__/csvs.cpython-37.pyc
  python/pandas/io/formats/__pycache__/excel.cpython-37.pyc
  python/pandas/io/formats/__pycache__/format.cpython-37.pyc
  python/pandas/io/formats/__pycache__/html.cpython-37.pyc
  python/pandas/io/formats/__pycache__/info.cpython-37.pyc
  python/pandas/io/formats/__pycache__/latex.cpython-37.pyc
  python/pandas/io/formats/__pycache__/printing.cpython-37.pyc
  python/pandas/io/formats/__pycache__/string.cpython-37.pyc
  python/pandas/io/formats/__pycache__/style.cpython-37.pyc
  python/pandas/io/excel/
  python/pandas/io/excel/_xlwt.py
  python/pandas/io/excel/_xlrd.py
  python/pandas/io/excel/_openpyxl.py
  python/pandas/io/excel/_base.py
  python/pandas/io/excel/_odswriter.py
  python/pandas/io/excel/_pyxlsb.py
  python/pandas/io/excel/_odfreader.py
  python/pandas/io/excel/_util.py
  python/pandas/io/excel/__init__.py
  python/pandas/io/excel/_xlsxwriter.py
  python/pandas/io/excel/__pycache__/
  python/pandas/io/excel/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_base.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_odfreader.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_odswriter.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_openpyxl.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_pyxlsb.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_util.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_xlrd.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_xlsxwriter.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_xlwt.cpython-37.pyc
  python/pandas/io/sas/
  python/pandas/io/sas/sas_xport.py
  python/pandas/io/sas/sas_constants.py
  python/pandas/io/sas/sasreader.py
  python/pandas/io/sas/sas7bdat.py
  python/pandas/io/sas/__init__.py
  python/pandas/io/sas/_sas.cpython-37m-x86_64-linux-gnu.so
  python/pandas/io/sas/__pycache__/
  python/pandas/io/sas/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sas7bdat.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sas_constants.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sas_xport.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sasreader.cpython-37.pyc
  python/pandas/io/json/
  python/pandas/io/json/_table_schema.py
  python/pandas/io/json/__init__.py
  python/pandas/io/json/_normalize.py
  python/pandas/io/json/_json.py
  python/pandas/io/json/__pycache__/
  python/pandas/io/json/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/json/__pycache__/_json.cpython-37.pyc
  python/pandas/io/json/__pycache__/_normalize.cpython-37.pyc
  python/pandas/io/json/__pycache__/_table_schema.cpython-37.pyc
  python/pandas/io/__pycache__/
  python/pandas/io/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/__pycache__/api.cpython-37.pyc
  python/pandas/io/__pycache__/clipboards.cpython-37.pyc
  python/pandas/io/__pycache__/common.cpython-37.pyc
  python/pandas/io/__pycache__/date_converters.cpython-37.pyc
  python/pandas/io/__pycache__/feather_format.cpython-37.pyc
  python/pandas/io/__pycache__/gbq.cpython-37.pyc
  python/pandas/io/__pycache__/html.cpython-37.pyc
  python/pandas/io/__pycache__/orc.cpython-37.pyc
  python/pandas/io/__pycache__/parquet.cpython-37.pyc
  python/pandas/io/__pycache__/parsers.cpython-37.pyc
  python/pandas/io/__pycache__/pickle.cpython-37.pyc
  python/pandas/io/__pycache__/pytables.cpython-37.pyc
  python/pandas/io/__pycache__/spss.cpython-37.pyc
  python/pandas/io/__pycache__/sql.cpython-37.pyc
  python/pandas/io/__pycache__/stata.cpython-37.pyc
  python/pandas/_config/
  python/pandas/_config/localization.py
  python/pandas/_config/display.py
  python/pandas/_config/config.py
  python/pandas/_config/dates.py
  python/pandas/_config/__init__.py
  python/pandas/_config/__pycache__/
  python/pandas/_config/__pycache__/__init__.cpython-37.pyc
  python/pandas/_config/__pycache__/config.cpython-37.pyc
  python/pandas/_config/__pycache__/dates.cpython-37.pyc
  python/pandas/_config/__pycache__/display.cpython-37.pyc
  python/pandas/_config/__pycache__/localization.cpython-37.pyc
  python/pandas/tseries/
  python/pandas/tseries/api.py
  python/pandas/tseries/frequencies.py
  python/pandas/tseries/offsets.py
  python/pandas/tseries/holiday.py
  python/pandas/tseries/__init__.py
  python/pandas/tseries/__pycache__/
  python/pandas/tseries/__pycache__/__init__.cpython-37.pyc
  python/pandas/tseries/__pycache__/api.cpython-37.pyc
  python/pandas/tseries/__pycache__/frequencies.cpython-37.pyc
  python/pandas/tseries/__pycache__/holiday.cpython-37.pyc
  python/pandas/tseries/__pycache__/offsets.cpython-37.pyc
  python/pandas/arrays/
  python/pandas/arrays/__init__.py
  python/pandas/arrays/__pycache__/
  python/pandas/arrays/__pycache__/__init__.cpython-37.pyc
  python/pandas/errors/
  python/pandas/errors/__init__.py
  python/pandas/errors/__pycache__/
  python/pandas/errors/__pycache__/__init__.cpython-37.pyc
  python/pandas/compat/
  python/pandas/compat/pickle_compat.py
  python/pandas/compat/_optional.py
  python/pandas/compat/__init__.py
  python/pandas/compat/chainmap.py
  python/pandas/compat/numpy/
  python/pandas/compat/numpy/__init__.py
  python/pandas/compat/numpy/function.py
  python/pandas/compat/numpy/__pycache__/
  python/pandas/compat/numpy/__pycache__/__init__.cpython-37.pyc
  python/pandas/compat/numpy/__pycache__/function.cpython-37.pyc
  python/pandas/compat/__pycache__/
  python/pandas/compat/__pycache__/__init__.cpython-37.pyc
  python/pandas/compat/__pycache__/_optional.cpython-37.pyc
  python/pandas/compat/__pycache__/chainmap.cpython-37.pyc
  python/pandas/compat/__pycache__/pickle_compat.cpython-37.pyc
  python/pandas/util/
  python/pandas/util/_depr_module.py
  python/pandas/util/_decorators.py
  python/pandas/util/_test_decorators.py
  python/pandas/util/testing.py
  python/pandas/util/_tester.py
  python/pandas/util/_exceptions.py
  python/pandas/util/_print_versions.py
  python/pandas/util/_doctools.py
  python/pandas/util/__init__.py
  python/pandas/util/_validators.py
  python/pandas/util/__pycache__/
  python/pandas/util/__pycache__/__init__.cpython-37.pyc
  python/pandas/util/__pycache__/_decorators.cpython-37.pyc
  python/pandas/util/__pycache__/_depr_module.cpython-37.pyc
  python/pandas/util/__pycache__/_doctools.cpython-37.pyc
  python/pandas/util/__pycache__/_exceptions.cpython-37.pyc
  python/pandas/util/__pycache__/_print_versions.cpython-37.pyc
  python/pandas/util/__pycache__/_test_decorators.cpython-37.pyc
  python/pandas/util/__pycache__/_tester.cpython-37.pyc
  python/pandas/util/__pycache__/_validators.cpython-37.pyc
  python/pandas/util/__pycache__/testing.cpython-37.pyc
  python/pandas/__pycache__/
  python/pandas/__pycache__/__init__.cpython-37.pyc
  python/pandas/__pycache__/_testing.cpython-37.pyc
  python/pandas/__pycache__/_typing.cpython-37.pyc
  python/pandas/__pycache__/_version.cpython-37.pyc
  python/pandas/__pycache__/conftest.cpython-37.pyc
  python/pandas/__pycache__/testing.cpython-37.pyc
  python/bin/
  python/bin/f2py
  python/bin/f2py3
  python/bin/f2py3.7
Total 4386 entries (107112473 bytes)
(env) [ec2-user@ip-172-24-121-11 lambda]$ tree -L 2
.
├── layer.zip
└── python
    ├── bin
    ├── dateutil
    ├── numpy
    ├── numpy.libs
    ├── pandas
    ├── pytz
    └── six.py

7 directories, 2 files
(env) [ec2-user@ip-172-24-121-11 lambda]$ du -sh layer.zip
33M	layer.zip
```

</details><br>

## Create Lambda function to use home-made python layer

***Download layer.zip from development box***

<details><summary><i>Click HERE to view work and command output</i></summary><br>

```bash
 $  ssm --list
i-0546db675efacbc30    ip-172-24-121-11                                dev-jscape-poc   172.24.121.11
i-0d8105e90abc17605    ip-10-92-1-48.ap-southeast-2.compute.internal   live-box         10.92.1.48 52.65.116.86
$  scp ec2-user@i-0546db675efacbc30:my_app/env/lambda/layer.zip .
layer.zip                                                                                                                      100%   32MB 875.0KB/s   00:37

$  du -sh layer.zip
33M	layer.zip
 jso  ubunu2004  ~  myob-work  work  aws-cf  resources  $  zip -sf layer.zip
Archive contains:
  python/
  python/six.py
  python/dateutil/
  python/dateutil/__init__.py
  python/dateutil/_common.py
  python/dateutil/_version.py
  python/dateutil/easter.py
  python/dateutil/relativedelta.py
  python/dateutil/rrule.py
  python/dateutil/tzwin.py
  python/dateutil/utils.py
  python/dateutil/parser/
  python/dateutil/parser/__init__.py
  python/dateutil/parser/_parser.py
  python/dateutil/parser/isoparser.py
  python/dateutil/parser/__pycache__/
  python/dateutil/parser/__pycache__/__init__.cpython-37.pyc
  python/dateutil/parser/__pycache__/_parser.cpython-37.pyc
  python/dateutil/parser/__pycache__/isoparser.cpython-37.pyc
  python/dateutil/tz/
  python/dateutil/tz/__init__.py
  python/dateutil/tz/_common.py
  python/dateutil/tz/_factories.py
  python/dateutil/tz/tz.py
  python/dateutil/tz/win.py
  python/dateutil/tz/__pycache__/
  python/dateutil/tz/__pycache__/__init__.cpython-37.pyc
  python/dateutil/tz/__pycache__/_common.cpython-37.pyc
  python/dateutil/tz/__pycache__/_factories.cpython-37.pyc
  python/dateutil/tz/__pycache__/tz.cpython-37.pyc
  python/dateutil/tz/__pycache__/win.cpython-37.pyc
  python/dateutil/zoneinfo/
  python/dateutil/zoneinfo/__init__.py
  python/dateutil/zoneinfo/dateutil-zoneinfo.tar.gz
  python/dateutil/zoneinfo/rebuild.py
  python/dateutil/zoneinfo/__pycache__/
  python/dateutil/zoneinfo/__pycache__/__init__.cpython-37.pyc
  python/dateutil/zoneinfo/__pycache__/rebuild.cpython-37.pyc
  python/dateutil/__pycache__/
  python/dateutil/__pycache__/__init__.cpython-37.pyc
  python/dateutil/__pycache__/_common.cpython-37.pyc
  python/dateutil/__pycache__/_version.cpython-37.pyc
  python/dateutil/__pycache__/easter.cpython-37.pyc
  python/dateutil/__pycache__/relativedelta.cpython-37.pyc
  python/dateutil/__pycache__/rrule.cpython-37.pyc
  python/dateutil/__pycache__/tzwin.cpython-37.pyc
  python/dateutil/__pycache__/utils.cpython-37.pyc
  python/pytz/
  python/pytz/__init__.py
  python/pytz/exceptions.py
  python/pytz/lazy.py
  python/pytz/reference.py
  python/pytz/tzfile.py
  python/pytz/tzinfo.py
  python/pytz/zoneinfo/
  python/pytz/zoneinfo/CET
  python/pytz/zoneinfo/CST6CDT
  python/pytz/zoneinfo/Cuba
  python/pytz/zoneinfo/EET
  python/pytz/zoneinfo/EST
  python/pytz/zoneinfo/EST5EDT
  python/pytz/zoneinfo/Egypt
  python/pytz/zoneinfo/Eire
  python/pytz/zoneinfo/Factory
  python/pytz/zoneinfo/GB
  python/pytz/zoneinfo/GB-Eire
  python/pytz/zoneinfo/GMT
  python/pytz/zoneinfo/GMT+0
  python/pytz/zoneinfo/GMT-0
  python/pytz/zoneinfo/GMT0
  python/pytz/zoneinfo/Greenwich
  python/pytz/zoneinfo/HST
  python/pytz/zoneinfo/Hongkong
  python/pytz/zoneinfo/Iceland
  python/pytz/zoneinfo/Iran
  python/pytz/zoneinfo/Israel
  python/pytz/zoneinfo/Jamaica
  python/pytz/zoneinfo/Japan
  python/pytz/zoneinfo/Kwajalein
  python/pytz/zoneinfo/Libya
  python/pytz/zoneinfo/MET
  python/pytz/zoneinfo/MST
  python/pytz/zoneinfo/MST7MDT
  python/pytz/zoneinfo/NZ
  python/pytz/zoneinfo/NZ-CHAT
  python/pytz/zoneinfo/Navajo
  python/pytz/zoneinfo/PRC
  python/pytz/zoneinfo/PST8PDT
  python/pytz/zoneinfo/Poland
  python/pytz/zoneinfo/Portugal
  python/pytz/zoneinfo/ROC
  python/pytz/zoneinfo/ROK
  python/pytz/zoneinfo/Singapore
  python/pytz/zoneinfo/Turkey
  python/pytz/zoneinfo/UCT
  python/pytz/zoneinfo/UTC
  python/pytz/zoneinfo/Universal
  python/pytz/zoneinfo/W-SU
  python/pytz/zoneinfo/WET
  python/pytz/zoneinfo/Zulu
  python/pytz/zoneinfo/iso3166.tab
  python/pytz/zoneinfo/leapseconds
  python/pytz/zoneinfo/tzdata.zi
  python/pytz/zoneinfo/zone.tab
  python/pytz/zoneinfo/zone1970.tab
  python/pytz/zoneinfo/Africa/
  python/pytz/zoneinfo/Africa/Abidjan
  python/pytz/zoneinfo/Africa/Accra
  python/pytz/zoneinfo/Africa/Addis_Ababa
  python/pytz/zoneinfo/Africa/Algiers
  python/pytz/zoneinfo/Africa/Asmara
  python/pytz/zoneinfo/Africa/Asmera
  python/pytz/zoneinfo/Africa/Bamako
  python/pytz/zoneinfo/Africa/Bangui
  python/pytz/zoneinfo/Africa/Banjul
  python/pytz/zoneinfo/Africa/Bissau
  python/pytz/zoneinfo/Africa/Blantyre
  python/pytz/zoneinfo/Africa/Brazzaville
  python/pytz/zoneinfo/Africa/Bujumbura
  python/pytz/zoneinfo/Africa/Cairo
  python/pytz/zoneinfo/Africa/Casablanca
  python/pytz/zoneinfo/Africa/Ceuta
  python/pytz/zoneinfo/Africa/Conakry
  python/pytz/zoneinfo/Africa/Dakar
  python/pytz/zoneinfo/Africa/Dar_es_Salaam
  python/pytz/zoneinfo/Africa/Djibouti
  python/pytz/zoneinfo/Africa/Douala
  python/pytz/zoneinfo/Africa/El_Aaiun
  python/pytz/zoneinfo/Africa/Freetown
  python/pytz/zoneinfo/Africa/Gaborone
  python/pytz/zoneinfo/Africa/Harare
  python/pytz/zoneinfo/Africa/Johannesburg
  python/pytz/zoneinfo/Africa/Juba
  python/pytz/zoneinfo/Africa/Kampala
  python/pytz/zoneinfo/Africa/Khartoum
  python/pytz/zoneinfo/Africa/Kigali
  python/pytz/zoneinfo/Africa/Kinshasa
  python/pytz/zoneinfo/Africa/Lagos
  python/pytz/zoneinfo/Africa/Libreville
  python/pytz/zoneinfo/Africa/Lome
  python/pytz/zoneinfo/Africa/Luanda
  python/pytz/zoneinfo/Africa/Lubumbashi
  python/pytz/zoneinfo/Africa/Lusaka
  python/pytz/zoneinfo/Africa/Malabo
  python/pytz/zoneinfo/Africa/Maputo
  python/pytz/zoneinfo/Africa/Maseru
  python/pytz/zoneinfo/Africa/Mbabane
  python/pytz/zoneinfo/Africa/Mogadishu
  python/pytz/zoneinfo/Africa/Monrovia
  python/pytz/zoneinfo/Africa/Nairobi
  python/pytz/zoneinfo/Africa/Ndjamena
  python/pytz/zoneinfo/Africa/Niamey
  python/pytz/zoneinfo/Africa/Nouakchott
  python/pytz/zoneinfo/Africa/Ouagadougou
  python/pytz/zoneinfo/Africa/Porto-Novo
  python/pytz/zoneinfo/Africa/Sao_Tome
  python/pytz/zoneinfo/Africa/Timbuktu
  python/pytz/zoneinfo/Africa/Tripoli
  python/pytz/zoneinfo/Africa/Tunis
  python/pytz/zoneinfo/Africa/Windhoek
  python/pytz/zoneinfo/America/
  python/pytz/zoneinfo/America/Adak
  python/pytz/zoneinfo/America/Anchorage
  python/pytz/zoneinfo/America/Anguilla
  python/pytz/zoneinfo/America/Antigua
  python/pytz/zoneinfo/America/Araguaina
  python/pytz/zoneinfo/America/Aruba
  python/pytz/zoneinfo/America/Asuncion
  python/pytz/zoneinfo/America/Atikokan
  python/pytz/zoneinfo/America/Atka
  python/pytz/zoneinfo/America/Bahia
  python/pytz/zoneinfo/America/Bahia_Banderas
  python/pytz/zoneinfo/America/Barbados
  python/pytz/zoneinfo/America/Belem
  python/pytz/zoneinfo/America/Belize
  python/pytz/zoneinfo/America/Blanc-Sablon
  python/pytz/zoneinfo/America/Boa_Vista
  python/pytz/zoneinfo/America/Bogota
  python/pytz/zoneinfo/America/Boise
  python/pytz/zoneinfo/America/Buenos_Aires
  python/pytz/zoneinfo/America/Cambridge_Bay
  python/pytz/zoneinfo/America/Campo_Grande
  python/pytz/zoneinfo/America/Cancun
  python/pytz/zoneinfo/America/Caracas
  python/pytz/zoneinfo/America/Catamarca
  python/pytz/zoneinfo/America/Cayenne
  python/pytz/zoneinfo/America/Cayman
  python/pytz/zoneinfo/America/Chicago
  python/pytz/zoneinfo/America/Chihuahua
  python/pytz/zoneinfo/America/Coral_Harbour
  python/pytz/zoneinfo/America/Cordoba
  python/pytz/zoneinfo/America/Costa_Rica
  python/pytz/zoneinfo/America/Creston
  python/pytz/zoneinfo/America/Cuiaba
  python/pytz/zoneinfo/America/Curacao
  python/pytz/zoneinfo/America/Danmarkshavn
  python/pytz/zoneinfo/America/Dawson
  python/pytz/zoneinfo/America/Dawson_Creek
  python/pytz/zoneinfo/America/Denver
  python/pytz/zoneinfo/America/Detroit
  python/pytz/zoneinfo/America/Dominica
  python/pytz/zoneinfo/America/Edmonton
  python/pytz/zoneinfo/America/Eirunepe
  python/pytz/zoneinfo/America/El_Salvador
  python/pytz/zoneinfo/America/Ensenada
  python/pytz/zoneinfo/America/Fort_Nelson
  python/pytz/zoneinfo/America/Fort_Wayne
  python/pytz/zoneinfo/America/Fortaleza
  python/pytz/zoneinfo/America/Glace_Bay
  python/pytz/zoneinfo/America/Godthab
  python/pytz/zoneinfo/America/Goose_Bay
  python/pytz/zoneinfo/America/Grand_Turk
  python/pytz/zoneinfo/America/Grenada
  python/pytz/zoneinfo/America/Guadeloupe
  python/pytz/zoneinfo/America/Guatemala
  python/pytz/zoneinfo/America/Guayaquil
  python/pytz/zoneinfo/America/Guyana
  python/pytz/zoneinfo/America/Halifax
  python/pytz/zoneinfo/America/Havana
  python/pytz/zoneinfo/America/Hermosillo
  python/pytz/zoneinfo/America/Indianapolis
  python/pytz/zoneinfo/America/Inuvik
  python/pytz/zoneinfo/America/Iqaluit
  python/pytz/zoneinfo/America/Jamaica
  python/pytz/zoneinfo/America/Jujuy
  python/pytz/zoneinfo/America/Juneau
  python/pytz/zoneinfo/America/Knox_IN
  python/pytz/zoneinfo/America/Kralendijk
  python/pytz/zoneinfo/America/La_Paz
  python/pytz/zoneinfo/America/Lima
  python/pytz/zoneinfo/America/Los_Angeles
  python/pytz/zoneinfo/America/Louisville
  python/pytz/zoneinfo/America/Lower_Princes
  python/pytz/zoneinfo/America/Maceio
  python/pytz/zoneinfo/America/Managua
  python/pytz/zoneinfo/America/Manaus
  python/pytz/zoneinfo/America/Marigot
  python/pytz/zoneinfo/America/Martinique
  python/pytz/zoneinfo/America/Matamoros
  python/pytz/zoneinfo/America/Mazatlan
  python/pytz/zoneinfo/America/Mendoza
  python/pytz/zoneinfo/America/Menominee
  python/pytz/zoneinfo/America/Merida
  python/pytz/zoneinfo/America/Metlakatla
  python/pytz/zoneinfo/America/Mexico_City
  python/pytz/zoneinfo/America/Miquelon
  python/pytz/zoneinfo/America/Moncton
  python/pytz/zoneinfo/America/Monterrey
  python/pytz/zoneinfo/America/Montevideo
  python/pytz/zoneinfo/America/Montreal
  python/pytz/zoneinfo/America/Montserrat
  python/pytz/zoneinfo/America/Nassau
  python/pytz/zoneinfo/America/New_York
  python/pytz/zoneinfo/America/Nipigon
  python/pytz/zoneinfo/America/Nome
  python/pytz/zoneinfo/America/Noronha
  python/pytz/zoneinfo/America/Nuuk
  python/pytz/zoneinfo/America/Ojinaga
  python/pytz/zoneinfo/America/Panama
  python/pytz/zoneinfo/America/Pangnirtung
  python/pytz/zoneinfo/America/Paramaribo
  python/pytz/zoneinfo/America/Phoenix
  python/pytz/zoneinfo/America/Port-au-Prince
  python/pytz/zoneinfo/America/Port_of_Spain
  python/pytz/zoneinfo/America/Porto_Acre
  python/pytz/zoneinfo/America/Porto_Velho
  python/pytz/zoneinfo/America/Puerto_Rico
  python/pytz/zoneinfo/America/Punta_Arenas
  python/pytz/zoneinfo/America/Rainy_River
  python/pytz/zoneinfo/America/Rankin_Inlet
  python/pytz/zoneinfo/America/Recife
  python/pytz/zoneinfo/America/Regina
  python/pytz/zoneinfo/America/Resolute
  python/pytz/zoneinfo/America/Rio_Branco
  python/pytz/zoneinfo/America/Rosario
  python/pytz/zoneinfo/America/Santa_Isabel
  python/pytz/zoneinfo/America/Santarem
  python/pytz/zoneinfo/America/Santiago
  python/pytz/zoneinfo/America/Santo_Domingo
  python/pytz/zoneinfo/America/Sao_Paulo
  python/pytz/zoneinfo/America/Scoresbysund
  python/pytz/zoneinfo/America/Shiprock
  python/pytz/zoneinfo/America/Sitka
  python/pytz/zoneinfo/America/St_Barthelemy
  python/pytz/zoneinfo/America/St_Johns
  python/pytz/zoneinfo/America/St_Kitts
  python/pytz/zoneinfo/America/St_Lucia
  python/pytz/zoneinfo/America/St_Thomas
  python/pytz/zoneinfo/America/St_Vincent
  python/pytz/zoneinfo/America/Swift_Current
  python/pytz/zoneinfo/America/Tegucigalpa
  python/pytz/zoneinfo/America/Thule
  python/pytz/zoneinfo/America/Thunder_Bay
  python/pytz/zoneinfo/America/Tijuana
  python/pytz/zoneinfo/America/Toronto
  python/pytz/zoneinfo/America/Tortola
  python/pytz/zoneinfo/America/Vancouver
  python/pytz/zoneinfo/America/Virgin
  python/pytz/zoneinfo/America/Whitehorse
  python/pytz/zoneinfo/America/Winnipeg
  python/pytz/zoneinfo/America/Yakutat
  python/pytz/zoneinfo/America/Yellowknife
  python/pytz/zoneinfo/America/Argentina/
  python/pytz/zoneinfo/America/Argentina/Buenos_Aires
  python/pytz/zoneinfo/America/Argentina/Catamarca
  python/pytz/zoneinfo/America/Argentina/ComodRivadavia
  python/pytz/zoneinfo/America/Argentina/Cordoba
  python/pytz/zoneinfo/America/Argentina/Jujuy
  python/pytz/zoneinfo/America/Argentina/La_Rioja
  python/pytz/zoneinfo/America/Argentina/Mendoza
  python/pytz/zoneinfo/America/Argentina/Rio_Gallegos
  python/pytz/zoneinfo/America/Argentina/Salta
  python/pytz/zoneinfo/America/Argentina/San_Juan
  python/pytz/zoneinfo/America/Argentina/San_Luis
  python/pytz/zoneinfo/America/Argentina/Tucuman
  python/pytz/zoneinfo/America/Argentina/Ushuaia
  python/pytz/zoneinfo/America/Indiana/
  python/pytz/zoneinfo/America/Indiana/Indianapolis
  python/pytz/zoneinfo/America/Indiana/Knox
  python/pytz/zoneinfo/America/Indiana/Marengo
  python/pytz/zoneinfo/America/Indiana/Petersburg
  python/pytz/zoneinfo/America/Indiana/Tell_City
  python/pytz/zoneinfo/America/Indiana/Vevay
  python/pytz/zoneinfo/America/Indiana/Vincennes
  python/pytz/zoneinfo/America/Indiana/Winamac
  python/pytz/zoneinfo/America/Kentucky/
  python/pytz/zoneinfo/America/Kentucky/Louisville
  python/pytz/zoneinfo/America/Kentucky/Monticello
  python/pytz/zoneinfo/America/North_Dakota/
  python/pytz/zoneinfo/America/North_Dakota/Beulah
  python/pytz/zoneinfo/America/North_Dakota/Center
  python/pytz/zoneinfo/America/North_Dakota/New_Salem
  python/pytz/zoneinfo/Antarctica/
  python/pytz/zoneinfo/Antarctica/Casey
  python/pytz/zoneinfo/Antarctica/Davis
  python/pytz/zoneinfo/Antarctica/DumontDUrville
  python/pytz/zoneinfo/Antarctica/Macquarie
  python/pytz/zoneinfo/Antarctica/Mawson
  python/pytz/zoneinfo/Antarctica/McMurdo
  python/pytz/zoneinfo/Antarctica/Palmer
  python/pytz/zoneinfo/Antarctica/Rothera
  python/pytz/zoneinfo/Antarctica/South_Pole
  python/pytz/zoneinfo/Antarctica/Syowa
  python/pytz/zoneinfo/Antarctica/Troll
  python/pytz/zoneinfo/Antarctica/Vostok
  python/pytz/zoneinfo/Arctic/
  python/pytz/zoneinfo/Arctic/Longyearbyen
  python/pytz/zoneinfo/Asia/
  python/pytz/zoneinfo/Asia/Aden
  python/pytz/zoneinfo/Asia/Almaty
  python/pytz/zoneinfo/Asia/Amman
  python/pytz/zoneinfo/Asia/Anadyr
  python/pytz/zoneinfo/Asia/Aqtau
  python/pytz/zoneinfo/Asia/Aqtobe
  python/pytz/zoneinfo/Asia/Ashgabat
  python/pytz/zoneinfo/Asia/Ashkhabad
  python/pytz/zoneinfo/Asia/Atyrau
  python/pytz/zoneinfo/Asia/Baghdad
  python/pytz/zoneinfo/Asia/Bahrain
  python/pytz/zoneinfo/Asia/Baku
  python/pytz/zoneinfo/Asia/Bangkok
  python/pytz/zoneinfo/Asia/Barnaul
  python/pytz/zoneinfo/Asia/Beirut
  python/pytz/zoneinfo/Asia/Bishkek
  python/pytz/zoneinfo/Asia/Brunei
  python/pytz/zoneinfo/Asia/Calcutta
  python/pytz/zoneinfo/Asia/Chita
  python/pytz/zoneinfo/Asia/Choibalsan
  python/pytz/zoneinfo/Asia/Chongqing
  python/pytz/zoneinfo/Asia/Chungking
  python/pytz/zoneinfo/Asia/Colombo
  python/pytz/zoneinfo/Asia/Dacca
  python/pytz/zoneinfo/Asia/Damascus
  python/pytz/zoneinfo/Asia/Dhaka
  python/pytz/zoneinfo/Asia/Dili
  python/pytz/zoneinfo/Asia/Dubai
  python/pytz/zoneinfo/Asia/Dushanbe
  python/pytz/zoneinfo/Asia/Famagusta
  python/pytz/zoneinfo/Asia/Gaza
  python/pytz/zoneinfo/Asia/Harbin
  python/pytz/zoneinfo/Asia/Hebron
  python/pytz/zoneinfo/Asia/Ho_Chi_Minh
  python/pytz/zoneinfo/Asia/Hong_Kong
  python/pytz/zoneinfo/Asia/Hovd
  python/pytz/zoneinfo/Asia/Irkutsk
  python/pytz/zoneinfo/Asia/Istanbul
  python/pytz/zoneinfo/Asia/Jakarta
  python/pytz/zoneinfo/Asia/Jayapura
  python/pytz/zoneinfo/Asia/Jerusalem
  python/pytz/zoneinfo/Asia/Kabul
  python/pytz/zoneinfo/Asia/Kamchatka
  python/pytz/zoneinfo/Asia/Karachi
  python/pytz/zoneinfo/Asia/Kashgar
  python/pytz/zoneinfo/Asia/Kathmandu
  python/pytz/zoneinfo/Asia/Katmandu
  python/pytz/zoneinfo/Asia/Khandyga
  python/pytz/zoneinfo/Asia/Kolkata
  python/pytz/zoneinfo/Asia/Krasnoyarsk
  python/pytz/zoneinfo/Asia/Kuala_Lumpur
  python/pytz/zoneinfo/Asia/Kuching
  python/pytz/zoneinfo/Asia/Kuwait
  python/pytz/zoneinfo/Asia/Macao
  python/pytz/zoneinfo/Asia/Macau
  python/pytz/zoneinfo/Asia/Magadan
  python/pytz/zoneinfo/Asia/Makassar
  python/pytz/zoneinfo/Asia/Manila
  python/pytz/zoneinfo/Asia/Muscat
  python/pytz/zoneinfo/Asia/Nicosia
  python/pytz/zoneinfo/Asia/Novokuznetsk
  python/pytz/zoneinfo/Asia/Novosibirsk
  python/pytz/zoneinfo/Asia/Omsk
  python/pytz/zoneinfo/Asia/Oral
  python/pytz/zoneinfo/Asia/Phnom_Penh
  python/pytz/zoneinfo/Asia/Pontianak
  python/pytz/zoneinfo/Asia/Pyongyang
  python/pytz/zoneinfo/Asia/Qatar
  python/pytz/zoneinfo/Asia/Qostanay
  python/pytz/zoneinfo/Asia/Qyzylorda
  python/pytz/zoneinfo/Asia/Rangoon
  python/pytz/zoneinfo/Asia/Riyadh
  python/pytz/zoneinfo/Asia/Saigon
  python/pytz/zoneinfo/Asia/Sakhalin
  python/pytz/zoneinfo/Asia/Samarkand
  python/pytz/zoneinfo/Asia/Seoul
  python/pytz/zoneinfo/Asia/Shanghai
  python/pytz/zoneinfo/Asia/Singapore
  python/pytz/zoneinfo/Asia/Srednekolymsk
  python/pytz/zoneinfo/Asia/Taipei
  python/pytz/zoneinfo/Asia/Tashkent
  python/pytz/zoneinfo/Asia/Tbilisi
  python/pytz/zoneinfo/Asia/Tehran
  python/pytz/zoneinfo/Asia/Tel_Aviv
  python/pytz/zoneinfo/Asia/Thimbu
  python/pytz/zoneinfo/Asia/Thimphu
  python/pytz/zoneinfo/Asia/Tokyo
  python/pytz/zoneinfo/Asia/Tomsk
  python/pytz/zoneinfo/Asia/Ujung_Pandang
  python/pytz/zoneinfo/Asia/Ulaanbaatar
  python/pytz/zoneinfo/Asia/Ulan_Bator
  python/pytz/zoneinfo/Asia/Urumqi
  python/pytz/zoneinfo/Asia/Ust-Nera
  python/pytz/zoneinfo/Asia/Vientiane
  python/pytz/zoneinfo/Asia/Vladivostok
  python/pytz/zoneinfo/Asia/Yakutsk
  python/pytz/zoneinfo/Asia/Yangon
  python/pytz/zoneinfo/Asia/Yekaterinburg
  python/pytz/zoneinfo/Asia/Yerevan
  python/pytz/zoneinfo/Atlantic/
  python/pytz/zoneinfo/Atlantic/Azores
  python/pytz/zoneinfo/Atlantic/Bermuda
  python/pytz/zoneinfo/Atlantic/Canary
  python/pytz/zoneinfo/Atlantic/Cape_Verde
  python/pytz/zoneinfo/Atlantic/Faeroe
  python/pytz/zoneinfo/Atlantic/Faroe
  python/pytz/zoneinfo/Atlantic/Jan_Mayen
  python/pytz/zoneinfo/Atlantic/Madeira
  python/pytz/zoneinfo/Atlantic/Reykjavik
  python/pytz/zoneinfo/Atlantic/South_Georgia
  python/pytz/zoneinfo/Atlantic/St_Helena
  python/pytz/zoneinfo/Atlantic/Stanley
  python/pytz/zoneinfo/Australia/
  python/pytz/zoneinfo/Australia/ACT
  python/pytz/zoneinfo/Australia/Adelaide
  python/pytz/zoneinfo/Australia/Brisbane
  python/pytz/zoneinfo/Australia/Broken_Hill
  python/pytz/zoneinfo/Australia/Canberra
  python/pytz/zoneinfo/Australia/Currie
  python/pytz/zoneinfo/Australia/Darwin
  python/pytz/zoneinfo/Australia/Eucla
  python/pytz/zoneinfo/Australia/Hobart
  python/pytz/zoneinfo/Australia/LHI
  python/pytz/zoneinfo/Australia/Lindeman
  python/pytz/zoneinfo/Australia/Lord_Howe
  python/pytz/zoneinfo/Australia/Melbourne
  python/pytz/zoneinfo/Australia/NSW
  python/pytz/zoneinfo/Australia/North
  python/pytz/zoneinfo/Australia/Perth
  python/pytz/zoneinfo/Australia/Queensland
  python/pytz/zoneinfo/Australia/South
  python/pytz/zoneinfo/Australia/Sydney
  python/pytz/zoneinfo/Australia/Tasmania
  python/pytz/zoneinfo/Australia/Victoria
  python/pytz/zoneinfo/Australia/West
  python/pytz/zoneinfo/Australia/Yancowinna
  python/pytz/zoneinfo/Brazil/
  python/pytz/zoneinfo/Brazil/Acre
  python/pytz/zoneinfo/Brazil/DeNoronha
  python/pytz/zoneinfo/Brazil/East
  python/pytz/zoneinfo/Brazil/West
  python/pytz/zoneinfo/Canada/
  python/pytz/zoneinfo/Canada/Atlantic
  python/pytz/zoneinfo/Canada/Central
  python/pytz/zoneinfo/Canada/Eastern
  python/pytz/zoneinfo/Canada/Mountain
  python/pytz/zoneinfo/Canada/Newfoundland
  python/pytz/zoneinfo/Canada/Pacific
  python/pytz/zoneinfo/Canada/Saskatchewan
  python/pytz/zoneinfo/Canada/Yukon
  python/pytz/zoneinfo/Chile/
  python/pytz/zoneinfo/Chile/Continental
  python/pytz/zoneinfo/Chile/EasterIsland
  python/pytz/zoneinfo/Etc/
  python/pytz/zoneinfo/Etc/GMT
  python/pytz/zoneinfo/Etc/GMT+0
  python/pytz/zoneinfo/Etc/GMT+1
  python/pytz/zoneinfo/Etc/GMT+10
  python/pytz/zoneinfo/Etc/GMT+11
  python/pytz/zoneinfo/Etc/GMT+12
  python/pytz/zoneinfo/Etc/GMT+2
  python/pytz/zoneinfo/Etc/GMT+3
  python/pytz/zoneinfo/Etc/GMT+4
  python/pytz/zoneinfo/Etc/GMT+5
  python/pytz/zoneinfo/Etc/GMT+6
  python/pytz/zoneinfo/Etc/GMT+7
  python/pytz/zoneinfo/Etc/GMT+8
  python/pytz/zoneinfo/Etc/GMT+9
  python/pytz/zoneinfo/Etc/GMT-0
  python/pytz/zoneinfo/Etc/GMT-1
  python/pytz/zoneinfo/Etc/GMT-10
  python/pytz/zoneinfo/Etc/GMT-11
  python/pytz/zoneinfo/Etc/GMT-12
  python/pytz/zoneinfo/Etc/GMT-13
  python/pytz/zoneinfo/Etc/GMT-14
  python/pytz/zoneinfo/Etc/GMT-2
  python/pytz/zoneinfo/Etc/GMT-3
  python/pytz/zoneinfo/Etc/GMT-4
  python/pytz/zoneinfo/Etc/GMT-5
  python/pytz/zoneinfo/Etc/GMT-6
  python/pytz/zoneinfo/Etc/GMT-7
  python/pytz/zoneinfo/Etc/GMT-8
  python/pytz/zoneinfo/Etc/GMT-9
  python/pytz/zoneinfo/Etc/GMT0
  python/pytz/zoneinfo/Etc/Greenwich
  python/pytz/zoneinfo/Etc/UCT
  python/pytz/zoneinfo/Etc/UTC
  python/pytz/zoneinfo/Etc/Universal
  python/pytz/zoneinfo/Etc/Zulu
  python/pytz/zoneinfo/Europe/
  python/pytz/zoneinfo/Europe/Amsterdam
  python/pytz/zoneinfo/Europe/Andorra
  python/pytz/zoneinfo/Europe/Astrakhan
  python/pytz/zoneinfo/Europe/Athens
  python/pytz/zoneinfo/Europe/Belfast
  python/pytz/zoneinfo/Europe/Belgrade
  python/pytz/zoneinfo/Europe/Berlin
  python/pytz/zoneinfo/Europe/Bratislava
  python/pytz/zoneinfo/Europe/Brussels
  python/pytz/zoneinfo/Europe/Bucharest
  python/pytz/zoneinfo/Europe/Budapest
  python/pytz/zoneinfo/Europe/Busingen
  python/pytz/zoneinfo/Europe/Chisinau
  python/pytz/zoneinfo/Europe/Copenhagen
  python/pytz/zoneinfo/Europe/Dublin
  python/pytz/zoneinfo/Europe/Gibraltar
  python/pytz/zoneinfo/Europe/Guernsey
  python/pytz/zoneinfo/Europe/Helsinki
  python/pytz/zoneinfo/Europe/Isle_of_Man
  python/pytz/zoneinfo/Europe/Istanbul
  python/pytz/zoneinfo/Europe/Jersey
  python/pytz/zoneinfo/Europe/Kaliningrad
  python/pytz/zoneinfo/Europe/Kiev
  python/pytz/zoneinfo/Europe/Kirov
  python/pytz/zoneinfo/Europe/Lisbon
  python/pytz/zoneinfo/Europe/Ljubljana
  python/pytz/zoneinfo/Europe/London
  python/pytz/zoneinfo/Europe/Luxembourg
  python/pytz/zoneinfo/Europe/Madrid
  python/pytz/zoneinfo/Europe/Malta
  python/pytz/zoneinfo/Europe/Mariehamn
  python/pytz/zoneinfo/Europe/Minsk
  python/pytz/zoneinfo/Europe/Monaco
  python/pytz/zoneinfo/Europe/Moscow
  python/pytz/zoneinfo/Europe/Nicosia
  python/pytz/zoneinfo/Europe/Oslo
  python/pytz/zoneinfo/Europe/Paris
  python/pytz/zoneinfo/Europe/Podgorica
  python/pytz/zoneinfo/Europe/Prague
  python/pytz/zoneinfo/Europe/Riga
  python/pytz/zoneinfo/Europe/Rome
  python/pytz/zoneinfo/Europe/Samara
  python/pytz/zoneinfo/Europe/San_Marino
  python/pytz/zoneinfo/Europe/Sarajevo
  python/pytz/zoneinfo/Europe/Saratov
  python/pytz/zoneinfo/Europe/Simferopol
  python/pytz/zoneinfo/Europe/Skopje
  python/pytz/zoneinfo/Europe/Sofia
  python/pytz/zoneinfo/Europe/Stockholm
  python/pytz/zoneinfo/Europe/Tallinn
  python/pytz/zoneinfo/Europe/Tirane
  python/pytz/zoneinfo/Europe/Tiraspol
  python/pytz/zoneinfo/Europe/Ulyanovsk
  python/pytz/zoneinfo/Europe/Uzhgorod
  python/pytz/zoneinfo/Europe/Vaduz
  python/pytz/zoneinfo/Europe/Vatican
  python/pytz/zoneinfo/Europe/Vienna
  python/pytz/zoneinfo/Europe/Vilnius
  python/pytz/zoneinfo/Europe/Volgograd
  python/pytz/zoneinfo/Europe/Warsaw
  python/pytz/zoneinfo/Europe/Zagreb
  python/pytz/zoneinfo/Europe/Zaporozhye
  python/pytz/zoneinfo/Europe/Zurich
  python/pytz/zoneinfo/Indian/
  python/pytz/zoneinfo/Indian/Antananarivo
  python/pytz/zoneinfo/Indian/Chagos
  python/pytz/zoneinfo/Indian/Christmas
  python/pytz/zoneinfo/Indian/Cocos
  python/pytz/zoneinfo/Indian/Comoro
  python/pytz/zoneinfo/Indian/Kerguelen
  python/pytz/zoneinfo/Indian/Mahe
  python/pytz/zoneinfo/Indian/Maldives
  python/pytz/zoneinfo/Indian/Mauritius
  python/pytz/zoneinfo/Indian/Mayotte
  python/pytz/zoneinfo/Indian/Reunion
  python/pytz/zoneinfo/Mexico/
  python/pytz/zoneinfo/Mexico/BajaNorte
  python/pytz/zoneinfo/Mexico/BajaSur
  python/pytz/zoneinfo/Mexico/General
  python/pytz/zoneinfo/Pacific/
  python/pytz/zoneinfo/Pacific/Apia
  python/pytz/zoneinfo/Pacific/Auckland
  python/pytz/zoneinfo/Pacific/Bougainville
  python/pytz/zoneinfo/Pacific/Chatham
  python/pytz/zoneinfo/Pacific/Chuuk
  python/pytz/zoneinfo/Pacific/Easter
  python/pytz/zoneinfo/Pacific/Efate
  python/pytz/zoneinfo/Pacific/Enderbury
  python/pytz/zoneinfo/Pacific/Fakaofo
  python/pytz/zoneinfo/Pacific/Fiji
  python/pytz/zoneinfo/Pacific/Funafuti
  python/pytz/zoneinfo/Pacific/Galapagos
  python/pytz/zoneinfo/Pacific/Gambier
  python/pytz/zoneinfo/Pacific/Guadalcanal
  python/pytz/zoneinfo/Pacific/Guam
  python/pytz/zoneinfo/Pacific/Honolulu
  python/pytz/zoneinfo/Pacific/Johnston
  python/pytz/zoneinfo/Pacific/Kiritimati
  python/pytz/zoneinfo/Pacific/Kosrae
  python/pytz/zoneinfo/Pacific/Kwajalein
  python/pytz/zoneinfo/Pacific/Majuro
  python/pytz/zoneinfo/Pacific/Marquesas
  python/pytz/zoneinfo/Pacific/Midway
  python/pytz/zoneinfo/Pacific/Nauru
  python/pytz/zoneinfo/Pacific/Niue
  python/pytz/zoneinfo/Pacific/Norfolk
  python/pytz/zoneinfo/Pacific/Noumea
  python/pytz/zoneinfo/Pacific/Pago_Pago
  python/pytz/zoneinfo/Pacific/Palau
  python/pytz/zoneinfo/Pacific/Pitcairn
  python/pytz/zoneinfo/Pacific/Pohnpei
  python/pytz/zoneinfo/Pacific/Ponape
  python/pytz/zoneinfo/Pacific/Port_Moresby
  python/pytz/zoneinfo/Pacific/Rarotonga
  python/pytz/zoneinfo/Pacific/Saipan
  python/pytz/zoneinfo/Pacific/Samoa
  python/pytz/zoneinfo/Pacific/Tahiti
  python/pytz/zoneinfo/Pacific/Tarawa
  python/pytz/zoneinfo/Pacific/Tongatapu
  python/pytz/zoneinfo/Pacific/Truk
  python/pytz/zoneinfo/Pacific/Wake
  python/pytz/zoneinfo/Pacific/Wallis
  python/pytz/zoneinfo/Pacific/Yap
  python/pytz/zoneinfo/US/
  python/pytz/zoneinfo/US/Alaska
  python/pytz/zoneinfo/US/Aleutian
  python/pytz/zoneinfo/US/Arizona
  python/pytz/zoneinfo/US/Central
  python/pytz/zoneinfo/US/East-Indiana
  python/pytz/zoneinfo/US/Eastern
  python/pytz/zoneinfo/US/Hawaii
  python/pytz/zoneinfo/US/Indiana-Starke
  python/pytz/zoneinfo/US/Michigan
  python/pytz/zoneinfo/US/Mountain
  python/pytz/zoneinfo/US/Pacific
  python/pytz/zoneinfo/US/Samoa
  python/pytz/__pycache__/
  python/pytz/__pycache__/__init__.cpython-37.pyc
  python/pytz/__pycache__/exceptions.cpython-37.pyc
  python/pytz/__pycache__/lazy.cpython-37.pyc
  python/pytz/__pycache__/reference.cpython-37.pyc
  python/pytz/__pycache__/tzfile.cpython-37.pyc
  python/pytz/__pycache__/tzinfo.cpython-37.pyc
  python/numpy.libs/
  python/numpy.libs/libquadmath-2d0c479f.so.0.0.0
  python/numpy.libs/libz-eb09ad1d.so.1.2.3
  python/numpy.libs/libopenblasp-r0-5bebc122.3.13.dev.so
  python/numpy.libs/libgfortran-2e0d59d6.so.5.0.0
  python/numpy/
  python/numpy/char.pyi
  python/numpy/_globals.py
  python/numpy/setup.py
  python/numpy/__init__.py
  python/numpy/version.py
  python/numpy/conftest.py
  python/numpy/__init__.pyi
  python/numpy/__init__.pxd
  python/numpy/_distributor_init.py
  python/numpy/__init__.cython-30.pxd
  python/numpy/emath.pyi
  python/numpy/__config__.py
  python/numpy/ctypeslib.py
  python/numpy/ctypeslib.pyi
  python/numpy/LICENSE.txt
  python/numpy/rec.pyi
  python/numpy/_pytesttester.py
  python/numpy/matlib.py
  python/numpy/dual.py
  python/numpy/py.typed
  python/numpy/tests/
  python/numpy/tests/__init__.py
  python/numpy/tests/test_warnings.py
  python/numpy/tests/test_reloading.py
  python/numpy/tests/test_numpy_version.py
  python/numpy/tests/test_ctypeslib.py
  python/numpy/tests/test_scripts.py
  python/numpy/tests/test_public_api.py
  python/numpy/tests/test_matlib.py
  python/numpy/tests/__pycache__/
  python/numpy/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/tests/__pycache__/test_ctypeslib.cpython-37.pyc
  python/numpy/tests/__pycache__/test_matlib.cpython-37.pyc
  python/numpy/tests/__pycache__/test_numpy_version.cpython-37.pyc
  python/numpy/tests/__pycache__/test_public_api.cpython-37.pyc
  python/numpy/tests/__pycache__/test_reloading.cpython-37.pyc
  python/numpy/tests/__pycache__/test_scripts.cpython-37.pyc
  python/numpy/tests/__pycache__/test_warnings.cpython-37.pyc
  python/numpy/random/
  python/numpy/random/setup.py
  python/numpy/random/__init__.py
  python/numpy/random/_mt19937.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/bit_generator.pxd
  python/numpy/random/bit_generator.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/__init__.pyi
  python/numpy/random/_common.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/c_distributions.pxd
  python/numpy/random/__init__.pxd
  python/numpy/random/_sfc64.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_bounded_integers.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_bounded_integers.pxd
  python/numpy/random/_philox.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_generator.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_pcg64.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/mtrand.cpython-37m-x86_64-linux-gnu.so
  python/numpy/random/_common.pxd
  python/numpy/random/_pickle.py
  python/numpy/random/_examples/
  python/numpy/random/_examples/numba/
  python/numpy/random/_examples/numba/extending.py
  python/numpy/random/_examples/numba/extending_distributions.py
  python/numpy/random/_examples/numba/__pycache__/
  python/numpy/random/_examples/numba/__pycache__/extending.cpython-37.pyc
  python/numpy/random/_examples/numba/__pycache__/extending_distributions.cpython-37.pyc
  python/numpy/random/_examples/cython/
  python/numpy/random/_examples/cython/setup.py
  python/numpy/random/_examples/cython/extending_distributions.pyx
  python/numpy/random/_examples/cython/extending.pyx
  python/numpy/random/_examples/cython/__pycache__/
  python/numpy/random/_examples/cython/__pycache__/setup.cpython-37.pyc
  python/numpy/random/_examples/cffi/
  python/numpy/random/_examples/cffi/extending.py
  python/numpy/random/_examples/cffi/parse.py
  python/numpy/random/_examples/cffi/__pycache__/
  python/numpy/random/_examples/cffi/__pycache__/extending.cpython-37.pyc
  python/numpy/random/_examples/cffi/__pycache__/parse.cpython-37.pyc
  python/numpy/random/tests/
  python/numpy/random/tests/test_generator_mt19937_regressions.py
  python/numpy/random/tests/__init__.py
  python/numpy/random/tests/test_generator_mt19937.py
  python/numpy/random/tests/test_smoke.py
  python/numpy/random/tests/test_random.py
  python/numpy/random/tests/test_direct.py
  python/numpy/random/tests/test_randomstate.py
  python/numpy/random/tests/test_regression.py
  python/numpy/random/tests/test_extending.py
  python/numpy/random/tests/test_randomstate_regression.py
  python/numpy/random/tests/test_seed_sequence.py
  python/numpy/random/tests/data/
  python/numpy/random/tests/data/mt19937-testset-1.csv
  python/numpy/random/tests/data/philox-testset-2.csv
  python/numpy/random/tests/data/__init__.py
  python/numpy/random/tests/data/pcg64-testset-2.csv
  python/numpy/random/tests/data/sfc64-testset-2.csv
  python/numpy/random/tests/data/pcg64-testset-1.csv
  python/numpy/random/tests/data/philox-testset-1.csv
  python/numpy/random/tests/data/sfc64-testset-1.csv
  python/numpy/random/tests/data/mt19937-testset-2.csv
  python/numpy/random/tests/data/__pycache__/
  python/numpy/random/tests/data/__pycache__/__init__.cpython-37.pyc
  python/numpy/random/tests/__pycache__/
  python/numpy/random/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_direct.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_extending.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_generator_mt19937.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_generator_mt19937_regressions.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_random.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_randomstate.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_randomstate_regression.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_seed_sequence.cpython-37.pyc
  python/numpy/random/tests/__pycache__/test_smoke.cpython-37.pyc
  python/numpy/random/lib/
  python/numpy/random/lib/libnpyrandom.a
  python/numpy/random/__pycache__/
  python/numpy/random/__pycache__/__init__.cpython-37.pyc
  python/numpy/random/__pycache__/_pickle.cpython-37.pyc
  python/numpy/random/__pycache__/setup.cpython-37.pyc
  python/numpy/fft/
  python/numpy/fft/_pocketfft.py
  python/numpy/fft/setup.py
  python/numpy/fft/__init__.py
  python/numpy/fft/helper.py
  python/numpy/fft/__init__.pyi
  python/numpy/fft/_pocketfft_internal.cpython-37m-x86_64-linux-gnu.so
  python/numpy/fft/tests/
  python/numpy/fft/tests/test_pocketfft.py
  python/numpy/fft/tests/__init__.py
  python/numpy/fft/tests/test_helper.py
  python/numpy/fft/tests/__pycache__/
  python/numpy/fft/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/fft/tests/__pycache__/test_helper.cpython-37.pyc
  python/numpy/fft/tests/__pycache__/test_pocketfft.cpython-37.pyc
  python/numpy/fft/__pycache__/
  python/numpy/fft/__pycache__/__init__.cpython-37.pyc
  python/numpy/fft/__pycache__/_pocketfft.cpython-37.pyc
  python/numpy/fft/__pycache__/helper.cpython-37.pyc
  python/numpy/fft/__pycache__/setup.cpython-37.pyc
  python/numpy/typing/
  python/numpy/typing/_array_like.py
  python/numpy/typing/setup.py
  python/numpy/typing/__init__.py
  python/numpy/typing/_add_docstring.py
  python/numpy/typing/_callable.py
  python/numpy/typing/_dtype_like.py
  python/numpy/typing/_shape.py
  python/numpy/typing/_scalars.py
  python/numpy/typing/tests/
  python/numpy/typing/tests/__init__.py
  python/numpy/typing/tests/test_typing.py
  python/numpy/typing/tests/test_isfile.py
  python/numpy/typing/tests/data/
  python/numpy/typing/tests/data/mypy.ini
  python/numpy/typing/tests/data/pass/
  python/numpy/typing/tests/data/pass/numerictypes.py
  python/numpy/typing/tests/data/pass/bitwise_ops.py
  python/numpy/typing/tests/data/pass/numeric.py
  python/numpy/typing/tests/data/pass/array_constructors.py
  python/numpy/typing/tests/data/pass/warnings_and_errors.py
  python/numpy/typing/tests/data/pass/ndarray_misc.py
  python/numpy/typing/tests/data/pass/simple.py
  python/numpy/typing/tests/data/pass/fromnumeric.py
  python/numpy/typing/tests/data/pass/ndarray_conversion.py
  python/numpy/typing/tests/data/pass/ndarray_shape_manipulation.py
  python/numpy/typing/tests/data/pass/arithmetic.py
  python/numpy/typing/tests/data/pass/modules.py
  python/numpy/typing/tests/data/pass/simple_py3.py
  python/numpy/typing/tests/data/pass/mod.py
  python/numpy/typing/tests/data/pass/dtype.py
  python/numpy/typing/tests/data/pass/ufunc_config.py
  python/numpy/typing/tests/data/pass/ufuncs.py
  python/numpy/typing/tests/data/pass/scalars.py
  python/numpy/typing/tests/data/pass/flatiter.py
  python/numpy/typing/tests/data/pass/array_like.py
  python/numpy/typing/tests/data/pass/literal.py
  python/numpy/typing/tests/data/pass/__pycache__/
  python/numpy/typing/tests/data/pass/__pycache__/arithmetic.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/array_constructors.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/array_like.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/bitwise_ops.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/dtype.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/flatiter.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/literal.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/mod.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/modules.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ndarray_conversion.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ndarray_misc.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ndarray_shape_manipulation.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/numeric.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/scalars.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/simple.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/simple_py3.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ufunc_config.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/ufuncs.cpython-37.pyc
  python/numpy/typing/tests/data/pass/__pycache__/warnings_and_errors.cpython-37.pyc
  python/numpy/typing/tests/data/fail/
  python/numpy/typing/tests/data/fail/numerictypes.py
  python/numpy/typing/tests/data/fail/bitwise_ops.py
  python/numpy/typing/tests/data/fail/array_constructors.py
  python/numpy/typing/tests/data/fail/warnings_and_errors.py
  python/numpy/typing/tests/data/fail/ndarray_misc.py
  python/numpy/typing/tests/data/fail/fromnumeric.py
  python/numpy/typing/tests/data/fail/arithmetic.py
  python/numpy/typing/tests/data/fail/modules.py
  python/numpy/typing/tests/data/fail/constants.py
  python/numpy/typing/tests/data/fail/ndarray.py
  python/numpy/typing/tests/data/fail/dtype.py
  python/numpy/typing/tests/data/fail/ufunc_config.py
  python/numpy/typing/tests/data/fail/ufuncs.py
  python/numpy/typing/tests/data/fail/scalars.py
  python/numpy/typing/tests/data/fail/flatiter.py
  python/numpy/typing/tests/data/fail/array_like.py
  python/numpy/typing/tests/data/fail/__pycache__/
  python/numpy/typing/tests/data/fail/__pycache__/arithmetic.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/array_constructors.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/array_like.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/bitwise_ops.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/constants.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/dtype.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/flatiter.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/modules.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ndarray.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ndarray_misc.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/scalars.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ufunc_config.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/ufuncs.cpython-37.pyc
  python/numpy/typing/tests/data/fail/__pycache__/warnings_and_errors.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/
  python/numpy/typing/tests/data/reveal/numerictypes.py
  python/numpy/typing/tests/data/reveal/bitwise_ops.py
  python/numpy/typing/tests/data/reveal/numeric.py
  python/numpy/typing/tests/data/reveal/array_constructors.py
  python/numpy/typing/tests/data/reveal/warnings_and_errors.py
  python/numpy/typing/tests/data/reveal/ndarray_misc.py
  python/numpy/typing/tests/data/reveal/fromnumeric.py
  python/numpy/typing/tests/data/reveal/ndarray_conversion.py
  python/numpy/typing/tests/data/reveal/ndarray_shape_manipulation.py
  python/numpy/typing/tests/data/reveal/arithmetic.py
  python/numpy/typing/tests/data/reveal/nbit_base_example.py
  python/numpy/typing/tests/data/reveal/modules.py
  python/numpy/typing/tests/data/reveal/constants.py
  python/numpy/typing/tests/data/reveal/mod.py
  python/numpy/typing/tests/data/reveal/dtype.py
  python/numpy/typing/tests/data/reveal/ufunc_config.py
  python/numpy/typing/tests/data/reveal/scalars.py
  python/numpy/typing/tests/data/reveal/flatiter.py
  python/numpy/typing/tests/data/reveal/__pycache__/
  python/numpy/typing/tests/data/reveal/__pycache__/arithmetic.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/array_constructors.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/bitwise_ops.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/constants.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/dtype.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/flatiter.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/mod.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/modules.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/nbit_base_example.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ndarray_conversion.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ndarray_misc.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ndarray_shape_manipulation.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/numeric.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/scalars.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/ufunc_config.cpython-37.pyc
  python/numpy/typing/tests/data/reveal/__pycache__/warnings_and_errors.cpython-37.pyc
  python/numpy/typing/tests/__pycache__/
  python/numpy/typing/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/typing/tests/__pycache__/test_isfile.cpython-37.pyc
  python/numpy/typing/tests/__pycache__/test_typing.cpython-37.pyc
  python/numpy/typing/__pycache__/
  python/numpy/typing/__pycache__/__init__.cpython-37.pyc
  python/numpy/typing/__pycache__/_add_docstring.cpython-37.pyc
  python/numpy/typing/__pycache__/_array_like.cpython-37.pyc
  python/numpy/typing/__pycache__/_callable.cpython-37.pyc
  python/numpy/typing/__pycache__/_dtype_like.cpython-37.pyc
  python/numpy/typing/__pycache__/_scalars.cpython-37.pyc
  python/numpy/typing/__pycache__/_shape.cpython-37.pyc
  python/numpy/typing/__pycache__/setup.cpython-37.pyc
  python/numpy/polynomial/
  python/numpy/polynomial/setup.py
  python/numpy/polynomial/__init__.py
  python/numpy/polynomial/chebyshev.py
  python/numpy/polynomial/_polybase.py
  python/numpy/polynomial/hermite.py
  python/numpy/polynomial/laguerre.py
  python/numpy/polynomial/__init__.pyi
  python/numpy/polynomial/polynomial.py
  python/numpy/polynomial/hermite_e.py
  python/numpy/polynomial/legendre.py
  python/numpy/polynomial/polyutils.py
  python/numpy/polynomial/tests/
  python/numpy/polynomial/tests/test_hermite.py
  python/numpy/polynomial/tests/test_printing.py
  python/numpy/polynomial/tests/test_laguerre.py
  python/numpy/polynomial/tests/test_polyutils.py
  python/numpy/polynomial/tests/__init__.py
  python/numpy/polynomial/tests/test_legendre.py
  python/numpy/polynomial/tests/test_polynomial.py
  python/numpy/polynomial/tests/test_chebyshev.py
  python/numpy/polynomial/tests/test_classes.py
  python/numpy/polynomial/tests/test_hermite_e.py
  python/numpy/polynomial/tests/__pycache__/
  python/numpy/polynomial/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_chebyshev.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_classes.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_hermite.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_hermite_e.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_laguerre.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_legendre.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_polynomial.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_polyutils.cpython-37.pyc
  python/numpy/polynomial/tests/__pycache__/test_printing.cpython-37.pyc
  python/numpy/polynomial/__pycache__/
  python/numpy/polynomial/__pycache__/__init__.cpython-37.pyc
  python/numpy/polynomial/__pycache__/_polybase.cpython-37.pyc
  python/numpy/polynomial/__pycache__/chebyshev.cpython-37.pyc
  python/numpy/polynomial/__pycache__/hermite.cpython-37.pyc
  python/numpy/polynomial/__pycache__/hermite_e.cpython-37.pyc
  python/numpy/polynomial/__pycache__/laguerre.cpython-37.pyc
  python/numpy/polynomial/__pycache__/legendre.cpython-37.pyc
  python/numpy/polynomial/__pycache__/polynomial.cpython-37.pyc
  python/numpy/polynomial/__pycache__/polyutils.cpython-37.pyc
  python/numpy/polynomial/__pycache__/setup.cpython-37.pyc
  python/numpy/ma/
  python/numpy/ma/core.py
  python/numpy/ma/setup.py
  python/numpy/ma/__init__.py
  python/numpy/ma/testutils.py
  python/numpy/ma/timer_comparison.py
  python/numpy/ma/mrecords.py
  python/numpy/ma/__init__.pyi
  python/numpy/ma/bench.py
  python/numpy/ma/extras.py
  python/numpy/ma/tests/
  python/numpy/ma/tests/test_old_ma.py
  python/numpy/ma/tests/test_subclassing.py
  python/numpy/ma/tests/__init__.py
  python/numpy/ma/tests/test_extras.py
  python/numpy/ma/tests/test_mrecords.py
  python/numpy/ma/tests/test_deprecations.py
  python/numpy/ma/tests/test_core.py
  python/numpy/ma/tests/test_regression.py
  python/numpy/ma/tests/__pycache__/
  python/numpy/ma/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_core.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_deprecations.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_extras.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_mrecords.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_old_ma.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/ma/tests/__pycache__/test_subclassing.cpython-37.pyc
  python/numpy/ma/__pycache__/
  python/numpy/ma/__pycache__/__init__.cpython-37.pyc
  python/numpy/ma/__pycache__/bench.cpython-37.pyc
  python/numpy/ma/__pycache__/core.cpython-37.pyc
  python/numpy/ma/__pycache__/extras.cpython-37.pyc
  python/numpy/ma/__pycache__/mrecords.cpython-37.pyc
  python/numpy/ma/__pycache__/setup.cpython-37.pyc
  python/numpy/ma/__pycache__/testutils.cpython-37.pyc
  python/numpy/ma/__pycache__/timer_comparison.cpython-37.pyc
  python/numpy/doc/
  python/numpy/doc/__init__.py
  python/numpy/doc/constants.py
  python/numpy/doc/ufuncs.py
  python/numpy/doc/__pycache__/
  python/numpy/doc/__pycache__/__init__.cpython-37.pyc
  python/numpy/doc/__pycache__/constants.cpython-37.pyc
  python/numpy/doc/__pycache__/ufuncs.cpython-37.pyc
  python/numpy/testing/
  python/numpy/testing/setup.py
  python/numpy/testing/__init__.py
  python/numpy/testing/utils.py
  python/numpy/testing/__init__.pyi
  python/numpy/testing/print_coercion_tables.py
  python/numpy/testing/tests/
  python/numpy/testing/tests/__init__.py
  python/numpy/testing/tests/test_utils.py
  python/numpy/testing/tests/test_doctesting.py
  python/numpy/testing/tests/test_decorators.py
  python/numpy/testing/tests/__pycache__/
  python/numpy/testing/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/testing/tests/__pycache__/test_decorators.cpython-37.pyc
  python/numpy/testing/tests/__pycache__/test_doctesting.cpython-37.pyc
  python/numpy/testing/tests/__pycache__/test_utils.cpython-37.pyc
  python/numpy/testing/_private/
  python/numpy/testing/_private/noseclasses.py
  python/numpy/testing/_private/__init__.py
  python/numpy/testing/_private/parameterized.py
  python/numpy/testing/_private/utils.py
  python/numpy/testing/_private/nosetester.py
  python/numpy/testing/_private/decorators.py
  python/numpy/testing/_private/__pycache__/
  python/numpy/testing/_private/__pycache__/__init__.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/decorators.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/noseclasses.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/nosetester.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/parameterized.cpython-37.pyc
  python/numpy/testing/_private/__pycache__/utils.cpython-37.pyc
  python/numpy/testing/__pycache__/
  python/numpy/testing/__pycache__/__init__.cpython-37.pyc
  python/numpy/testing/__pycache__/print_coercion_tables.cpython-37.pyc
  python/numpy/testing/__pycache__/setup.cpython-37.pyc
  python/numpy/testing/__pycache__/utils.cpython-37.pyc
  python/numpy/linalg/
  python/numpy/linalg/setup.py
  python/numpy/linalg/__init__.py
  python/numpy/linalg/linalg.py
  python/numpy/linalg/__init__.pyi
  python/numpy/linalg/lapack_lite.cpython-37m-x86_64-linux-gnu.so
  python/numpy/linalg/_umath_linalg.cpython-37m-x86_64-linux-gnu.so
  python/numpy/linalg/tests/
  python/numpy/linalg/tests/__init__.py
  python/numpy/linalg/tests/test_linalg.py
  python/numpy/linalg/tests/test_deprecations.py
  python/numpy/linalg/tests/test_build.py
  python/numpy/linalg/tests/test_regression.py
  python/numpy/linalg/tests/__pycache__/
  python/numpy/linalg/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_build.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_deprecations.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_linalg.cpython-37.pyc
  python/numpy/linalg/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/linalg/__pycache__/
  python/numpy/linalg/__pycache__/__init__.cpython-37.pyc
  python/numpy/linalg/__pycache__/linalg.cpython-37.pyc
  python/numpy/linalg/__pycache__/setup.cpython-37.pyc
  python/numpy/core/
  python/numpy/core/numerictypes.py
  python/numpy/core/memmap.py
  python/numpy/core/_multiarray_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/numeric.pyi
  python/numpy/core/_ufunc_config.pyi
  python/numpy/core/setup_common.py
  python/numpy/core/numeric.py
  python/numpy/core/setup.py
  python/numpy/core/__init__.py
  python/numpy/core/numerictypes.pyi
  python/numpy/core/umath.py
  python/numpy/core/_type_aliases.py
  python/numpy/core/function_base.pyi
  python/numpy/core/fromnumeric.py
  python/numpy/core/multiarray.py
  python/numpy/core/_umath_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/function_base.py
  python/numpy/core/records.py
  python/numpy/core/_simd.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/generate_numpy_api.py
  python/numpy/core/_multiarray_umath.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/_exceptions.py
  python/numpy/core/getlimits.py
  python/numpy/core/_internal.pyi
  python/numpy/core/_dtype_ctypes.py
  python/numpy/core/_ufunc_config.py
  python/numpy/core/_internal.py
  python/numpy/core/_rational_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/_dtype.py
  python/numpy/core/__init__.pyi
  python/numpy/core/arrayprint.py
  python/numpy/core/_type_aliases.pyi
  python/numpy/core/shape_base.pyi
  python/numpy/core/_struct_ufunc_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/fromnumeric.pyi
  python/numpy/core/overrides.py
  python/numpy/core/cversions.py
  python/numpy/core/machar.py
  python/numpy/core/_asarray.py
  python/numpy/core/_add_newdocs.py
  python/numpy/core/_operand_flag_tests.cpython-37m-x86_64-linux-gnu.so
  python/numpy/core/_string_helpers.py
  python/numpy/core/_methods.py
  python/numpy/core/umath_tests.py
  python/numpy/core/_add_newdocs_scalars.py
  python/numpy/core/shape_base.py
  python/numpy/core/_asarray.pyi
  python/numpy/core/einsumfunc.py
  python/numpy/core/defchararray.py
  python/numpy/core/tests/
  python/numpy/core/tests/test_umath_complex.py
  python/numpy/core/tests/test__exceptions.py
  python/numpy/core/tests/test_api.py
  python/numpy/core/tests/test_unicode.py
  python/numpy/core/tests/test_indexing.py
  python/numpy/core/tests/test_scalar_methods.py
  python/numpy/core/tests/test_simd.py
  python/numpy/core/tests/test_getlimits.py
  python/numpy/core/tests/test_longdouble.py
  python/numpy/core/tests/test_numerictypes.py
  python/numpy/core/tests/__init__.py
  python/numpy/core/tests/test_umath_accuracy.py
  python/numpy/core/tests/test_abc.py
  python/numpy/core/tests/test_scalar_ctors.py
  python/numpy/core/tests/test_shape_base.py
  python/numpy/core/tests/test_multiarray.py
  python/numpy/core/tests/test_mem_overlap.py
  python/numpy/core/tests/test_overrides.py
  python/numpy/core/tests/test_umath.py
  python/numpy/core/tests/test_extint128.py
  python/numpy/core/tests/test_einsum.py
  python/numpy/core/tests/test_scalarprint.py
  python/numpy/core/tests/test_conversion_utils.py
  python/numpy/core/tests/test_defchararray.py
  python/numpy/core/tests/test_records.py
  python/numpy/core/tests/test_numeric.py
  python/numpy/core/tests/test_cython.py
  python/numpy/core/tests/test_deprecations.py
  python/numpy/core/tests/test_scalarinherit.py
  python/numpy/core/tests/test_machar.py
  python/numpy/core/tests/test_print.py
  python/numpy/core/tests/_locales.py
  python/numpy/core/tests/test_array_coercion.py
  python/numpy/core/tests/test_half.py
  python/numpy/core/tests/test_datetime.py
  python/numpy/core/tests/test_cpu_features.py
  python/numpy/core/tests/test_cpu_dispatcher.py
  python/numpy/core/tests/test_errstate.py
  python/numpy/core/tests/test_casting_unittests.py
  python/numpy/core/tests/test_scalarbuffer.py
  python/numpy/core/tests/test_nditer.py
  python/numpy/core/tests/test_item_selection.py
  python/numpy/core/tests/test_regression.py
  python/numpy/core/tests/test_memmap.py
  python/numpy/core/tests/test_scalarmath.py
  python/numpy/core/tests/test_protocols.py
  python/numpy/core/tests/test_ufunc.py
  python/numpy/core/tests/test_arrayprint.py
  python/numpy/core/tests/test_function_base.py
  python/numpy/core/tests/test_indexerrors.py
  python/numpy/core/tests/test_simd_module.py
  python/numpy/core/tests/test_dtype.py
  python/numpy/core/tests/examples/
  python/numpy/core/tests/examples/setup.py
  python/numpy/core/tests/examples/checks.pyx
  python/numpy/core/tests/examples/__pycache__/
  python/numpy/core/tests/examples/__pycache__/setup.cpython-37.pyc
  python/numpy/core/tests/data/
  python/numpy/core/tests/data/umath-validation-set-exp
  python/numpy/core/tests/data/umath-validation-set-sin
  python/numpy/core/tests/data/umath-validation-set-cos
  python/numpy/core/tests/data/umath-validation-set-log
  python/numpy/core/tests/data/astype_copy.pkl
  python/numpy/core/tests/data/umath-validation-set-README
  python/numpy/core/tests/data/recarray_from_file.fits
  python/numpy/core/tests/__pycache__/
  python/numpy/core/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/core/tests/__pycache__/_locales.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_protocols.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test__exceptions.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_abc.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_api.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_records.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_array_coercion.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_arrayprint.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_print.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_casting_unittests.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalar_ctors.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_conversion_utils.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalar_methods.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_cpu_dispatcher.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarinherit.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_cpu_features.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_cython.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_datetime.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarbuffer.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_defchararray.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarmath.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_deprecations.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_dtype.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_einsum.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_errstate.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_scalarprint.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_extint128.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_shape_base.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_function_base.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_simd.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_getlimits.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_half.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_simd_module.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_indexerrors.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_indexing.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_ufunc.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_item_selection.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_longdouble.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_machar.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_mem_overlap.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_memmap.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_multiarray.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_nditer.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_numeric.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_numerictypes.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_overrides.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_umath.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_umath_accuracy.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_umath_complex.cpython-37.pyc
  python/numpy/core/tests/__pycache__/test_unicode.cpython-37.pyc
  python/numpy/core/include/
  python/numpy/core/include/numpy/
  python/numpy/core/include/numpy/__multiarray_api.h
  python/numpy/core/include/numpy/utils.h
  python/numpy/core/include/numpy/_neighborhood_iterator_imp.h
  python/numpy/core/include/numpy/arrayobject.h
  python/numpy/core/include/numpy/_numpyconfig.h
  python/numpy/core/include/numpy/ndarraytypes.h
  python/numpy/core/include/numpy/arrayscalars.h
  python/numpy/core/include/numpy/halffloat.h
  python/numpy/core/include/numpy/npy_interrupt.h
  python/numpy/core/include/numpy/npy_cpu.h
  python/numpy/core/include/numpy/npy_no_deprecated_api.h
  python/numpy/core/include/numpy/multiarray_api.txt
  python/numpy/core/include/numpy/old_defines.h
  python/numpy/core/include/numpy/npy_os.h
  python/numpy/core/include/numpy/npy_common.h
  python/numpy/core/include/numpy/ndarrayobject.h
  python/numpy/core/include/numpy/ufunc_api.txt
  python/numpy/core/include/numpy/oldnumeric.h
  python/numpy/core/include/numpy/npy_3kcompat.h
  python/numpy/core/include/numpy/ufuncobject.h
  python/numpy/core/include/numpy/__ufunc_api.h
  python/numpy/core/include/numpy/npy_math.h
  python/numpy/core/include/numpy/noprefix.h
  python/numpy/core/include/numpy/numpyconfig.h
  python/numpy/core/include/numpy/npy_endian.h
  python/numpy/core/include/numpy/npy_1_7_deprecated_api.h
  python/numpy/core/include/numpy/random/
  python/numpy/core/include/numpy/random/distributions.h
  python/numpy/core/include/numpy/random/bitgen.h
  python/numpy/core/lib/
  python/numpy/core/lib/libnpymath.a
  python/numpy/core/lib/npy-pkg-config/
  python/numpy/core/lib/npy-pkg-config/mlib.ini
  python/numpy/core/lib/npy-pkg-config/npymath.ini
  python/numpy/core/__pycache__/
  python/numpy/core/__pycache__/__init__.cpython-37.pyc
  python/numpy/core/__pycache__/_add_newdocs.cpython-37.pyc
  python/numpy/core/__pycache__/_add_newdocs_scalars.cpython-37.pyc
  python/numpy/core/__pycache__/_asarray.cpython-37.pyc
  python/numpy/core/__pycache__/_dtype.cpython-37.pyc
  python/numpy/core/__pycache__/_dtype_ctypes.cpython-37.pyc
  python/numpy/core/__pycache__/_exceptions.cpython-37.pyc
  python/numpy/core/__pycache__/_internal.cpython-37.pyc
  python/numpy/core/__pycache__/_methods.cpython-37.pyc
  python/numpy/core/__pycache__/_string_helpers.cpython-37.pyc
  python/numpy/core/__pycache__/_type_aliases.cpython-37.pyc
  python/numpy/core/__pycache__/_ufunc_config.cpython-37.pyc
  python/numpy/core/__pycache__/arrayprint.cpython-37.pyc
  python/numpy/core/__pycache__/cversions.cpython-37.pyc
  python/numpy/core/__pycache__/defchararray.cpython-37.pyc
  python/numpy/core/__pycache__/einsumfunc.cpython-37.pyc
  python/numpy/core/__pycache__/fromnumeric.cpython-37.pyc
  python/numpy/core/__pycache__/function_base.cpython-37.pyc
  python/numpy/core/__pycache__/generate_numpy_api.cpython-37.pyc
  python/numpy/core/__pycache__/getlimits.cpython-37.pyc
  python/numpy/core/__pycache__/machar.cpython-37.pyc
  python/numpy/core/__pycache__/memmap.cpython-37.pyc
  python/numpy/core/__pycache__/multiarray.cpython-37.pyc
  python/numpy/core/__pycache__/numeric.cpython-37.pyc
  python/numpy/core/__pycache__/numerictypes.cpython-37.pyc
  python/numpy/core/__pycache__/overrides.cpython-37.pyc
  python/numpy/core/__pycache__/records.cpython-37.pyc
  python/numpy/core/__pycache__/setup.cpython-37.pyc
  python/numpy/core/__pycache__/setup_common.cpython-37.pyc
  python/numpy/core/__pycache__/shape_base.cpython-37.pyc
  python/numpy/core/__pycache__/umath.cpython-37.pyc
  python/numpy/core/__pycache__/umath_tests.cpython-37.pyc
  python/numpy/f2py/
  python/numpy/f2py/common_rules.py
  python/numpy/f2py/use_rules.py
  python/numpy/f2py/f2py_testing.py
  python/numpy/f2py/setup.py
  python/numpy/f2py/__init__.py
  python/numpy/f2py/f90mod_rules.py
  python/numpy/f2py/__version__.py
  python/numpy/f2py/__main__.py
  python/numpy/f2py/capi_maps.py
  python/numpy/f2py/__init__.pyi
  python/numpy/f2py/f2py2e.py
  python/numpy/f2py/diagnose.py
  python/numpy/f2py/crackfortran.py
  python/numpy/f2py/rules.py
  python/numpy/f2py/auxfuncs.py
  python/numpy/f2py/cfuncs.py
  python/numpy/f2py/cb_rules.py
  python/numpy/f2py/func2subr.py
  python/numpy/f2py/tests/
  python/numpy/f2py/tests/test_return_logical.py
  python/numpy/f2py/tests/test_callback.py
  python/numpy/f2py/tests/test_module_doc.py
  python/numpy/f2py/tests/test_quoted_character.py
  python/numpy/f2py/tests/__init__.py
  python/numpy/f2py/tests/test_compile_function.py
  python/numpy/f2py/tests/util.py
  python/numpy/f2py/tests/test_return_character.py
  python/numpy/f2py/tests/test_return_integer.py
  python/numpy/f2py/tests/test_array_from_pyobj.py
  python/numpy/f2py/tests/test_string.py
  python/numpy/f2py/tests/test_crackfortran.py
  python/numpy/f2py/tests/test_parameter.py
  python/numpy/f2py/tests/test_kind.py
  python/numpy/f2py/tests/test_regression.py
  python/numpy/f2py/tests/test_mixed.py
  python/numpy/f2py/tests/test_block_docstring.py
  python/numpy/f2py/tests/test_common.py
  python/numpy/f2py/tests/test_return_real.py
  python/numpy/f2py/tests/test_return_complex.py
  python/numpy/f2py/tests/test_size.py
  python/numpy/f2py/tests/test_semicolon_split.py
  python/numpy/f2py/tests/test_assumed_shape.py
  python/numpy/f2py/tests/src/
  python/numpy/f2py/tests/src/parameter/
  python/numpy/f2py/tests/src/parameter/constant_both.f90
  python/numpy/f2py/tests/src/parameter/constant_compound.f90
  python/numpy/f2py/tests/src/parameter/constant_real.f90
  python/numpy/f2py/tests/src/parameter/constant_integer.f90
  python/numpy/f2py/tests/src/parameter/constant_non_compound.f90
  python/numpy/f2py/tests/src/mixed/
  python/numpy/f2py/tests/src/mixed/foo_free.f90
  python/numpy/f2py/tests/src/mixed/foo.f
  python/numpy/f2py/tests/src/mixed/foo_fixed.f90
  python/numpy/f2py/tests/src/size/
  python/numpy/f2py/tests/src/size/foo.f90
  python/numpy/f2py/tests/src/common/
  python/numpy/f2py/tests/src/common/block.f
  python/numpy/f2py/tests/src/regression/
  python/numpy/f2py/tests/src/regression/inout.f90
  python/numpy/f2py/tests/src/string/
  python/numpy/f2py/tests/src/string/char.f90
  python/numpy/f2py/tests/src/kind/
  python/numpy/f2py/tests/src/kind/foo.f90
  python/numpy/f2py/tests/src/assumed_shape/
  python/numpy/f2py/tests/src/assumed_shape/precision.f90
  python/numpy/f2py/tests/src/assumed_shape/foo_use.f90
  python/numpy/f2py/tests/src/assumed_shape/foo_mod.f90
  python/numpy/f2py/tests/src/assumed_shape/foo_free.f90
  python/numpy/f2py/tests/src/assumed_shape/.f2py_f2cmap
  python/numpy/f2py/tests/src/array_from_pyobj/
  python/numpy/f2py/tests/src/array_from_pyobj/wrapmodule.c
  python/numpy/f2py/tests/src/module_data/
  python/numpy/f2py/tests/src/module_data/mod.mod
  python/numpy/f2py/tests/src/module_data/module_data_docstring.f90
  python/numpy/f2py/tests/__pycache__/
  python/numpy/f2py/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_array_from_pyobj.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_assumed_shape.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_block_docstring.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_callback.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_common.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_compile_function.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_crackfortran.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_kind.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_mixed.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_module_doc.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_parameter.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_quoted_character.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_character.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_complex.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_integer.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_logical.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_return_real.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_semicolon_split.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_size.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/test_string.cpython-37.pyc
  python/numpy/f2py/tests/__pycache__/util.cpython-37.pyc
  python/numpy/f2py/src/
  python/numpy/f2py/src/fortranobject.c
  python/numpy/f2py/src/fortranobject.h
  python/numpy/f2py/__pycache__/
  python/numpy/f2py/__pycache__/__init__.cpython-37.pyc
  python/numpy/f2py/__pycache__/__main__.cpython-37.pyc
  python/numpy/f2py/__pycache__/__version__.cpython-37.pyc
  python/numpy/f2py/__pycache__/auxfuncs.cpython-37.pyc
  python/numpy/f2py/__pycache__/capi_maps.cpython-37.pyc
  python/numpy/f2py/__pycache__/cb_rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/cfuncs.cpython-37.pyc
  python/numpy/f2py/__pycache__/common_rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/crackfortran.cpython-37.pyc
  python/numpy/f2py/__pycache__/diagnose.cpython-37.pyc
  python/numpy/f2py/__pycache__/f2py2e.cpython-37.pyc
  python/numpy/f2py/__pycache__/f2py_testing.cpython-37.pyc
  python/numpy/f2py/__pycache__/f90mod_rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/func2subr.cpython-37.pyc
  python/numpy/f2py/__pycache__/rules.cpython-37.pyc
  python/numpy/f2py/__pycache__/setup.cpython-37.pyc
  python/numpy/f2py/__pycache__/use_rules.cpython-37.pyc
  python/numpy/matrixlib/
  python/numpy/matrixlib/setup.py
  python/numpy/matrixlib/__init__.py
  python/numpy/matrixlib/__init__.pyi
  python/numpy/matrixlib/defmatrix.py
  python/numpy/matrixlib/tests/
  python/numpy/matrixlib/tests/test_masked_matrix.py
  python/numpy/matrixlib/tests/__init__.py
  python/numpy/matrixlib/tests/test_multiarray.py
  python/numpy/matrixlib/tests/test_numeric.py
  python/numpy/matrixlib/tests/test_matrix_linalg.py
  python/numpy/matrixlib/tests/test_interaction.py
  python/numpy/matrixlib/tests/test_regression.py
  python/numpy/matrixlib/tests/test_defmatrix.py
  python/numpy/matrixlib/tests/__pycache__/
  python/numpy/matrixlib/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_defmatrix.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_interaction.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_masked_matrix.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_matrix_linalg.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_multiarray.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_numeric.cpython-37.pyc
  python/numpy/matrixlib/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/matrixlib/__pycache__/
  python/numpy/matrixlib/__pycache__/__init__.cpython-37.pyc
  python/numpy/matrixlib/__pycache__/defmatrix.cpython-37.pyc
  python/numpy/matrixlib/__pycache__/setup.cpython-37.pyc
  python/numpy/distutils/
  python/numpy/distutils/ccompiler_opt.py
  python/numpy/distutils/core.py
  python/numpy/distutils/setup.py
  python/numpy/distutils/__init__.py
  python/numpy/distutils/conv_template.py
  python/numpy/distutils/exec_command.py
  python/numpy/distutils/pathccompiler.py
  python/numpy/distutils/extension.py
  python/numpy/distutils/from_template.py
  python/numpy/distutils/__init__.pyi
  python/numpy/distutils/_shell_utils.py
  python/numpy/distutils/msvccompiler.py
  python/numpy/distutils/line_endings.py
  python/numpy/distutils/numpy_distribution.py
  python/numpy/distutils/log.py
  python/numpy/distutils/msvc9compiler.py
  python/numpy/distutils/intelccompiler.py
  python/numpy/distutils/system_info.py
  python/numpy/distutils/mingw32ccompiler.py
  python/numpy/distutils/__config__.py
  python/numpy/distutils/npy_pkg_config.py
  python/numpy/distutils/lib2def.py
  python/numpy/distutils/ccompiler.py
  python/numpy/distutils/unixccompiler.py
  python/numpy/distutils/cpuinfo.py
  python/numpy/distutils/misc_util.py
  python/numpy/distutils/mingw/
  python/numpy/distutils/mingw/gfortran_vs2003_hack.c
  python/numpy/distutils/tests/
  python/numpy/distutils/tests/__init__.py
  python/numpy/distutils/tests/test_system_info.py
  python/numpy/distutils/tests/test_mingw32ccompiler.py
  python/numpy/distutils/tests/test_fcompiler_nagfor.py
  python/numpy/distutils/tests/test_build_ext.py
  python/numpy/distutils/tests/test_ccompiler_opt.py
  python/numpy/distutils/tests/test_misc_util.py
  python/numpy/distutils/tests/test_exec_command.py
  python/numpy/distutils/tests/test_npy_pkg_config.py
  python/numpy/distutils/tests/test_ccompiler_opt_conf.py
  python/numpy/distutils/tests/test_fcompiler_intel.py
  python/numpy/distutils/tests/test_fcompiler_gnu.py
  python/numpy/distutils/tests/test_fcompiler.py
  python/numpy/distutils/tests/test_from_template.py
  python/numpy/distutils/tests/test_shell_utils.py
  python/numpy/distutils/tests/__pycache__/
  python/numpy/distutils/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_build_ext.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_ccompiler_opt.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_ccompiler_opt_conf.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_exec_command.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler_gnu.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler_intel.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_fcompiler_nagfor.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_from_template.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_mingw32ccompiler.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_misc_util.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_npy_pkg_config.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_shell_utils.cpython-37.pyc
  python/numpy/distutils/tests/__pycache__/test_system_info.cpython-37.pyc
  python/numpy/distutils/checks/
  python/numpy/distutils/checks/cpu_neon_fp16.c
  python/numpy/distutils/checks/cpu_neon_vfpv4.c
  python/numpy/distutils/checks/cpu_sse.c
  python/numpy/distutils/checks/cpu_vsx2.c
  python/numpy/distutils/checks/cpu_avx512_icl.c
  python/numpy/distutils/checks/cpu_fma3.c
  python/numpy/distutils/checks/cpu_f16c.c
  python/numpy/distutils/checks/cpu_avx512_clx.c
  python/numpy/distutils/checks/cpu_avx512f.c
  python/numpy/distutils/checks/cpu_vsx3.c
  python/numpy/distutils/checks/cpu_avx512cd.c
  python/numpy/distutils/checks/cpu_xop.c
  python/numpy/distutils/checks/cpu_avx512_cnl.c
  python/numpy/distutils/checks/cpu_fma4.c
  python/numpy/distutils/checks/cpu_asimddp.c
  python/numpy/distutils/checks/cpu_avx.c
  python/numpy/distutils/checks/cpu_asimdhp.c
  python/numpy/distutils/checks/cpu_avx512_knm.c
  python/numpy/distutils/checks/cpu_ssse3.c
  python/numpy/distutils/checks/cpu_sse2.c
  python/numpy/distutils/checks/cpu_neon.c
  python/numpy/distutils/checks/cpu_sse3.c
  python/numpy/distutils/checks/cpu_asimdfhm.c
  python/numpy/distutils/checks/cpu_avx512_knl.c
  python/numpy/distutils/checks/extra_avx512bw_mask.c
  python/numpy/distutils/checks/cpu_avx512_skx.c
  python/numpy/distutils/checks/extra_avx512f_reduce.c
  python/numpy/distutils/checks/cpu_sse42.c
  python/numpy/distutils/checks/cpu_vsx.c
  python/numpy/distutils/checks/extra_avx512dq_mask.c
  python/numpy/distutils/checks/cpu_avx2.c
  python/numpy/distutils/checks/cpu_popcnt.c
  python/numpy/distutils/checks/test_flags.c
  python/numpy/distutils/checks/cpu_sse41.c
  python/numpy/distutils/checks/cpu_asimd.c
  python/numpy/distutils/fcompiler/
  python/numpy/distutils/fcompiler/compaq.py
  python/numpy/distutils/fcompiler/__init__.py
  python/numpy/distutils/fcompiler/hpux.py
  python/numpy/distutils/fcompiler/gnu.py
  python/numpy/distutils/fcompiler/vast.py
  python/numpy/distutils/fcompiler/mips.py
  python/numpy/distutils/fcompiler/sun.py
  python/numpy/distutils/fcompiler/ibm.py
  python/numpy/distutils/fcompiler/lahey.py
  python/numpy/distutils/fcompiler/intel.py
  python/numpy/distutils/fcompiler/g95.py
  python/numpy/distutils/fcompiler/environment.py
  python/numpy/distutils/fcompiler/absoft.py
  python/numpy/distutils/fcompiler/pg.py
  python/numpy/distutils/fcompiler/nv.py
  python/numpy/distutils/fcompiler/none.py
  python/numpy/distutils/fcompiler/pathf95.py
  python/numpy/distutils/fcompiler/fujitsu.py
  python/numpy/distutils/fcompiler/nag.py
  python/numpy/distutils/fcompiler/__pycache__/
  python/numpy/distutils/fcompiler/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/absoft.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/compaq.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/environment.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/fujitsu.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/g95.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/gnu.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/hpux.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/ibm.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/intel.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/lahey.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/mips.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/nag.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/none.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/nv.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/pathf95.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/pg.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/sun.cpython-37.pyc
  python/numpy/distutils/fcompiler/__pycache__/vast.cpython-37.pyc
  python/numpy/distutils/command/
  python/numpy/distutils/command/build_scripts.py
  python/numpy/distutils/command/install_clib.py
  python/numpy/distutils/command/__init__.py
  python/numpy/distutils/command/build_clib.py
  python/numpy/distutils/command/install_data.py
  python/numpy/distutils/command/config.py
  python/numpy/distutils/command/install_headers.py
  python/numpy/distutils/command/develop.py
  python/numpy/distutils/command/bdist_rpm.py
  python/numpy/distutils/command/build_py.py
  python/numpy/distutils/command/sdist.py
  python/numpy/distutils/command/egg_info.py
  python/numpy/distutils/command/build_ext.py
  python/numpy/distutils/command/build_src.py
  python/numpy/distutils/command/build.py
  python/numpy/distutils/command/install.py
  python/numpy/distutils/command/autodist.py
  python/numpy/distutils/command/config_compiler.py
  python/numpy/distutils/command/__pycache__/
  python/numpy/distutils/command/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/autodist.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/bdist_rpm.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_clib.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_ext.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_py.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_scripts.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/build_src.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/config.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/config_compiler.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/develop.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/egg_info.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install_clib.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install_data.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/install_headers.cpython-37.pyc
  python/numpy/distutils/command/__pycache__/sdist.cpython-37.pyc
  python/numpy/distutils/__pycache__/
  python/numpy/distutils/__pycache__/__config__.cpython-37.pyc
  python/numpy/distutils/__pycache__/__init__.cpython-37.pyc
  python/numpy/distutils/__pycache__/_shell_utils.cpython-37.pyc
  python/numpy/distutils/__pycache__/ccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/ccompiler_opt.cpython-37.pyc
  python/numpy/distutils/__pycache__/conv_template.cpython-37.pyc
  python/numpy/distutils/__pycache__/core.cpython-37.pyc
  python/numpy/distutils/__pycache__/cpuinfo.cpython-37.pyc
  python/numpy/distutils/__pycache__/exec_command.cpython-37.pyc
  python/numpy/distutils/__pycache__/extension.cpython-37.pyc
  python/numpy/distutils/__pycache__/from_template.cpython-37.pyc
  python/numpy/distutils/__pycache__/intelccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/lib2def.cpython-37.pyc
  python/numpy/distutils/__pycache__/line_endings.cpython-37.pyc
  python/numpy/distutils/__pycache__/log.cpython-37.pyc
  python/numpy/distutils/__pycache__/mingw32ccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/misc_util.cpython-37.pyc
  python/numpy/distutils/__pycache__/msvc9compiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/msvccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/npy_pkg_config.cpython-37.pyc
  python/numpy/distutils/__pycache__/numpy_distribution.cpython-37.pyc
  python/numpy/distutils/__pycache__/pathccompiler.cpython-37.pyc
  python/numpy/distutils/__pycache__/setup.cpython-37.pyc
  python/numpy/distutils/__pycache__/system_info.cpython-37.pyc
  python/numpy/distutils/__pycache__/unixccompiler.cpython-37.pyc
  python/numpy/lib/
  python/numpy/lib/npyio.py
  python/numpy/lib/arrayterator.py
  python/numpy/lib/setup.py
  python/numpy/lib/type_check.py
  python/numpy/lib/__init__.py
  python/numpy/lib/arraysetops.py
  python/numpy/lib/histograms.py
  python/numpy/lib/index_tricks.py
  python/numpy/lib/function_base.py
  python/numpy/lib/format.py
  python/numpy/lib/recfunctions.py
  python/numpy/lib/utils.py
  python/numpy/lib/__init__.pyi
  python/numpy/lib/_version.py
  python/numpy/lib/ufunclike.py
  python/numpy/lib/twodim_base.py
  python/numpy/lib/polynomial.py
  python/numpy/lib/_iotools.py
  python/numpy/lib/_datasource.py
  python/numpy/lib/scimath.py
  python/numpy/lib/mixins.py
  python/numpy/lib/nanfunctions.py
  python/numpy/lib/arraypad.py
  python/numpy/lib/user_array.py
  python/numpy/lib/stride_tricks.py
  python/numpy/lib/shape_base.py
  python/numpy/lib/tests/
  python/numpy/lib/tests/test_recfunctions.py
  python/numpy/lib/tests/test_stride_tricks.py
  python/numpy/lib/tests/__init__.py
  python/numpy/lib/tests/test_arrayterator.py
  python/numpy/lib/tests/test__version.py
  python/numpy/lib/tests/test_shape_base.py
  python/numpy/lib/tests/test__iotools.py
  python/numpy/lib/tests/test_format.py
  python/numpy/lib/tests/test_index_tricks.py
  python/numpy/lib/tests/test_io.py
  python/numpy/lib/tests/test_arraypad.py
  python/numpy/lib/tests/test_financial_expired.py
  python/numpy/lib/tests/test__datasource.py
  python/numpy/lib/tests/test_packbits.py
  python/numpy/lib/tests/test_nanfunctions.py
  python/numpy/lib/tests/test_utils.py
  python/numpy/lib/tests/test_twodim_base.py
  python/numpy/lib/tests/test_polynomial.py
  python/numpy/lib/tests/test_regression.py
  python/numpy/lib/tests/test_ufunclike.py
  python/numpy/lib/tests/test_arraysetops.py
  python/numpy/lib/tests/test_function_base.py
  python/numpy/lib/tests/test_mixins.py
  python/numpy/lib/tests/test_type_check.py
  python/numpy/lib/tests/test_histograms.py
  python/numpy/lib/tests/data/
  python/numpy/lib/tests/data/win64python2.npy
  python/numpy/lib/tests/data/py2-objarr.npz
  python/numpy/lib/tests/data/python3.npy
  python/numpy/lib/tests/data/py3-objarr.npz
  python/numpy/lib/tests/data/py3-objarr.npy
  python/numpy/lib/tests/data/py2-objarr.npy
  python/numpy/lib/tests/__pycache__/
  python/numpy/lib/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test__datasource.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test__iotools.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test__version.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_arraypad.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_arraysetops.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_arrayterator.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_financial_expired.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_format.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_function_base.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_histograms.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_index_tricks.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_io.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_mixins.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_nanfunctions.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_packbits.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_polynomial.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_recfunctions.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_regression.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_shape_base.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_stride_tricks.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_twodim_base.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_type_check.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_ufunclike.cpython-37.pyc
  python/numpy/lib/tests/__pycache__/test_utils.cpython-37.pyc
  python/numpy/lib/__pycache__/
  python/numpy/lib/__pycache__/__init__.cpython-37.pyc
  python/numpy/lib/__pycache__/_datasource.cpython-37.pyc
  python/numpy/lib/__pycache__/_iotools.cpython-37.pyc
  python/numpy/lib/__pycache__/_version.cpython-37.pyc
  python/numpy/lib/__pycache__/arraypad.cpython-37.pyc
  python/numpy/lib/__pycache__/arraysetops.cpython-37.pyc
  python/numpy/lib/__pycache__/arrayterator.cpython-37.pyc
  python/numpy/lib/__pycache__/format.cpython-37.pyc
  python/numpy/lib/__pycache__/function_base.cpython-37.pyc
  python/numpy/lib/__pycache__/histograms.cpython-37.pyc
  python/numpy/lib/__pycache__/index_tricks.cpython-37.pyc
  python/numpy/lib/__pycache__/mixins.cpython-37.pyc
  python/numpy/lib/__pycache__/nanfunctions.cpython-37.pyc
  python/numpy/lib/__pycache__/npyio.cpython-37.pyc
  python/numpy/lib/__pycache__/polynomial.cpython-37.pyc
  python/numpy/lib/__pycache__/recfunctions.cpython-37.pyc
  python/numpy/lib/__pycache__/scimath.cpython-37.pyc
  python/numpy/lib/__pycache__/setup.cpython-37.pyc
  python/numpy/lib/__pycache__/shape_base.cpython-37.pyc
  python/numpy/lib/__pycache__/stride_tricks.cpython-37.pyc
  python/numpy/lib/__pycache__/twodim_base.cpython-37.pyc
  python/numpy/lib/__pycache__/type_check.cpython-37.pyc
  python/numpy/lib/__pycache__/ufunclike.cpython-37.pyc
  python/numpy/lib/__pycache__/user_array.cpython-37.pyc
  python/numpy/lib/__pycache__/utils.cpython-37.pyc
  python/numpy/compat/
  python/numpy/compat/setup.py
  python/numpy/compat/__init__.py
  python/numpy/compat/py3k.py
  python/numpy/compat/_inspect.py
  python/numpy/compat/tests/
  python/numpy/compat/tests/test_compat.py
  python/numpy/compat/tests/__init__.py
  python/numpy/compat/tests/__pycache__/
  python/numpy/compat/tests/__pycache__/__init__.cpython-37.pyc
  python/numpy/compat/tests/__pycache__/test_compat.cpython-37.pyc
  python/numpy/compat/__pycache__/
  python/numpy/compat/__pycache__/__init__.cpython-37.pyc
  python/numpy/compat/__pycache__/_inspect.cpython-37.pyc
  python/numpy/compat/__pycache__/py3k.cpython-37.pyc
  python/numpy/compat/__pycache__/setup.cpython-37.pyc
  python/numpy/__pycache__/
  python/numpy/__pycache__/__config__.cpython-37.pyc
  python/numpy/__pycache__/__init__.cpython-37.pyc
  python/numpy/__pycache__/_distributor_init.cpython-37.pyc
  python/numpy/__pycache__/_globals.cpython-37.pyc
  python/numpy/__pycache__/_pytesttester.cpython-37.pyc
  python/numpy/__pycache__/conftest.cpython-37.pyc
  python/numpy/__pycache__/ctypeslib.cpython-37.pyc
  python/numpy/__pycache__/dual.cpython-37.pyc
  python/numpy/__pycache__/matlib.cpython-37.pyc
  python/numpy/__pycache__/setup.cpython-37.pyc
  python/numpy/__pycache__/version.cpython-37.pyc
  python/pandas/
  python/pandas/_version.py
  python/pandas/_testing.py
  python/pandas/conftest.py
  python/pandas/testing.py
  python/pandas/__init__.py
  python/pandas/_typing.py
  python/pandas/tests/
  python/pandas/tests/test_take.py
  python/pandas/tests/test_aggregation.py
  python/pandas/tests/test_downstream.py
  python/pandas/tests/test_algos.py
  python/pandas/tests/test_nanops.py
  python/pandas/tests/test_optional_dependency.py
  python/pandas/tests/__init__.py
  python/pandas/tests/test_sorting.py
  python/pandas/tests/test_register_accessor.py
  python/pandas/tests/test_strings.py
  python/pandas/tests/test_errors.py
  python/pandas/tests/test_common.py
  python/pandas/tests/test_multilevel.py
  python/pandas/tests/test_flags.py
  python/pandas/tests/test_expressions.py
  python/pandas/tests/window/
  python/pandas/tests/window/test_dtypes.py
  python/pandas/tests/window/test_numba.py
  python/pandas/tests/window/test_rolling.py
  python/pandas/tests/window/test_pairwise.py
  python/pandas/tests/window/test_timeseries_window.py
  python/pandas/tests/window/test_apply.py
  python/pandas/tests/window/test_ewm.py
  python/pandas/tests/window/conftest.py
  python/pandas/tests/window/test_api.py
  python/pandas/tests/window/test_expanding.py
  python/pandas/tests/window/__init__.py
  python/pandas/tests/window/test_win_type.py
  python/pandas/tests/window/test_base_indexer.py
  python/pandas/tests/window/test_groupby.py
  python/pandas/tests/window/moments/
  python/pandas/tests/window/moments/test_moments_rolling_skew_kurt.py
  python/pandas/tests/window/moments/test_moments_rolling.py
  python/pandas/tests/window/moments/test_moments_consistency_expanding.py
  python/pandas/tests/window/moments/test_moments_rolling_quantile.py
  python/pandas/tests/window/moments/test_moments_consistency_rolling.py
  python/pandas/tests/window/moments/test_moments_consistency_ewm.py
  python/pandas/tests/window/moments/test_moments_ewm.py
  python/pandas/tests/window/moments/test_moments_rolling_apply.py
  python/pandas/tests/window/moments/__init__.py
  python/pandas/tests/window/moments/test_moments_rolling_functions.py
  python/pandas/tests/window/moments/__pycache__/
  python/pandas/tests/window/moments/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_consistency_ewm.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_consistency_expanding.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_consistency_rolling.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_ewm.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_apply.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_functions.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_quantile.cpython-37.pyc
  python/pandas/tests/window/moments/__pycache__/test_moments_rolling_skew_kurt.cpython-37.pyc
  python/pandas/tests/window/__pycache__/
  python/pandas/tests/window/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/window/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_apply.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_base_indexer.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_ewm.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_expanding.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_groupby.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_pairwise.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_rolling.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_timeseries_window.cpython-37.pyc
  python/pandas/tests/window/__pycache__/test_win_type.cpython-37.pyc
  python/pandas/tests/scalar/
  python/pandas/tests/scalar/test_nat.py
  python/pandas/tests/scalar/__init__.py
  python/pandas/tests/scalar/test_na_scalar.py
  python/pandas/tests/scalar/timestamp/
  python/pandas/tests/scalar/timestamp/test_constructors.py
  python/pandas/tests/scalar/timestamp/test_rendering.py
  python/pandas/tests/scalar/timestamp/test_timezones.py
  python/pandas/tests/scalar/timestamp/test_unary_ops.py
  python/pandas/tests/scalar/timestamp/test_timestamp.py
  python/pandas/tests/scalar/timestamp/test_comparisons.py
  python/pandas/tests/scalar/timestamp/__init__.py
  python/pandas/tests/scalar/timestamp/test_arithmetic.py
  python/pandas/tests/scalar/timestamp/__pycache__/
  python/pandas/tests/scalar/timestamp/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_comparisons.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_rendering.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_timestamp.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/scalar/timestamp/__pycache__/test_unary_ops.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/
  python/pandas/tests/scalar/timedelta/test_formats.py
  python/pandas/tests/scalar/timedelta/test_constructors.py
  python/pandas/tests/scalar/timedelta/__init__.py
  python/pandas/tests/scalar/timedelta/test_arithmetic.py
  python/pandas/tests/scalar/timedelta/test_timedelta.py
  python/pandas/tests/scalar/timedelta/__pycache__/
  python/pandas/tests/scalar/timedelta/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/scalar/timedelta/__pycache__/test_timedelta.cpython-37.pyc
  python/pandas/tests/scalar/period/
  python/pandas/tests/scalar/period/__init__.py
  python/pandas/tests/scalar/period/test_period.py
  python/pandas/tests/scalar/period/test_asfreq.py
  python/pandas/tests/scalar/period/__pycache__/
  python/pandas/tests/scalar/period/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/period/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/scalar/period/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/scalar/interval/
  python/pandas/tests/scalar/interval/test_interval.py
  python/pandas/tests/scalar/interval/test_ops.py
  python/pandas/tests/scalar/interval/__init__.py
  python/pandas/tests/scalar/interval/test_arithmetic.py
  python/pandas/tests/scalar/interval/__pycache__/
  python/pandas/tests/scalar/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/interval/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/scalar/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/scalar/interval/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/scalar/__pycache__/
  python/pandas/tests/scalar/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/scalar/__pycache__/test_na_scalar.cpython-37.pyc
  python/pandas/tests/scalar/__pycache__/test_nat.cpython-37.pyc
  python/pandas/tests/indexes/
  python/pandas/tests/indexes/test_index_new.py
  python/pandas/tests/indexes/test_any_index.py
  python/pandas/tests/indexes/test_indexing.py
  python/pandas/tests/indexes/test_numpy_compat.py
  python/pandas/tests/indexes/test_datetimelike.py
  python/pandas/tests/indexes/test_frozen.py
  python/pandas/tests/indexes/conftest.py
  python/pandas/tests/indexes/common.py
  python/pandas/tests/indexes/test_numeric.py
  python/pandas/tests/indexes/test_base.py
  python/pandas/tests/indexes/datetimelike.py
  python/pandas/tests/indexes/__init__.py
  python/pandas/tests/indexes/test_setops.py
  python/pandas/tests/indexes/test_common.py
  python/pandas/tests/indexes/test_engines.py
  python/pandas/tests/indexes/base_class/
  python/pandas/tests/indexes/base_class/test_formats.py
  python/pandas/tests/indexes/base_class/test_where.py
  python/pandas/tests/indexes/base_class/test_constructors.py
  python/pandas/tests/indexes/base_class/test_indexing.py
  python/pandas/tests/indexes/base_class/test_reshape.py
  python/pandas/tests/indexes/base_class/__init__.py
  python/pandas/tests/indexes/base_class/test_setops.py
  python/pandas/tests/indexes/base_class/__pycache__/
  python/pandas/tests/indexes/base_class/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_reshape.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/base_class/__pycache__/test_where.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/
  python/pandas/tests/indexes/datetimes/test_formats.py
  python/pandas/tests/indexes/datetimes/test_fillna.py
  python/pandas/tests/indexes/datetimes/test_constructors.py
  python/pandas/tests/indexes/datetimes/test_indexing.py
  python/pandas/tests/indexes/datetimes/test_to_period.py
  python/pandas/tests/indexes/datetimes/test_delete.py
  python/pandas/tests/indexes/datetimes/test_astype.py
  python/pandas/tests/indexes/datetimes/test_date_range.py
  python/pandas/tests/indexes/datetimes/test_pickle.py
  python/pandas/tests/indexes/datetimes/test_timezones.py
  python/pandas/tests/indexes/datetimes/test_misc.py
  python/pandas/tests/indexes/datetimes/test_datetimelike.py
  python/pandas/tests/indexes/datetimes/test_scalar_compat.py
  python/pandas/tests/indexes/datetimes/test_map.py
  python/pandas/tests/indexes/datetimes/test_partial_slicing.py
  python/pandas/tests/indexes/datetimes/test_datetime.py
  python/pandas/tests/indexes/datetimes/test_join.py
  python/pandas/tests/indexes/datetimes/test_ops.py
  python/pandas/tests/indexes/datetimes/__init__.py
  python/pandas/tests/indexes/datetimes/test_shift.py
  python/pandas/tests/indexes/datetimes/test_setops.py
  python/pandas/tests/indexes/datetimes/test_snap.py
  python/pandas/tests/indexes/datetimes/test_insert.py
  python/pandas/tests/indexes/datetimes/__pycache__/
  python/pandas/tests/indexes/datetimes/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_date_range.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_delete.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_map.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_misc.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_partial_slicing.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_pickle.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_scalar_compat.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_snap.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/indexes/datetimes/__pycache__/test_to_period.cpython-37.pyc
  python/pandas/tests/indexes/ranges/
  python/pandas/tests/indexes/ranges/test_constructors.py
  python/pandas/tests/indexes/ranges/test_indexing.py
  python/pandas/tests/indexes/ranges/test_join.py
  python/pandas/tests/indexes/ranges/test_range.py
  python/pandas/tests/indexes/ranges/__init__.py
  python/pandas/tests/indexes/ranges/test_setops.py
  python/pandas/tests/indexes/ranges/__pycache__/
  python/pandas/tests/indexes/ranges/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_range.cpython-37.pyc
  python/pandas/tests/indexes/ranges/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/
  python/pandas/tests/indexes/timedeltas/test_formats.py
  python/pandas/tests/indexes/timedeltas/test_fillna.py
  python/pandas/tests/indexes/timedeltas/test_constructors.py
  python/pandas/tests/indexes/timedeltas/test_indexing.py
  python/pandas/tests/indexes/timedeltas/test_delete.py
  python/pandas/tests/indexes/timedeltas/test_astype.py
  python/pandas/tests/indexes/timedeltas/test_searchsorted.py
  python/pandas/tests/indexes/timedeltas/test_scalar_compat.py
  python/pandas/tests/indexes/timedeltas/test_partial_slicing.py
  python/pandas/tests/indexes/timedeltas/test_join.py
  python/pandas/tests/indexes/timedeltas/test_ops.py
  python/pandas/tests/indexes/timedeltas/test_timedelta_range.py
  python/pandas/tests/indexes/timedeltas/__init__.py
  python/pandas/tests/indexes/timedeltas/test_shift.py
  python/pandas/tests/indexes/timedeltas/test_setops.py
  python/pandas/tests/indexes/timedeltas/test_insert.py
  python/pandas/tests/indexes/timedeltas/test_timedelta.py
  python/pandas/tests/indexes/timedeltas/__pycache__/
  python/pandas/tests/indexes/timedeltas/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_delete.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_partial_slicing.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_scalar_compat.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_searchsorted.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_timedelta.cpython-37.pyc
  python/pandas/tests/indexes/timedeltas/__pycache__/test_timedelta_range.cpython-37.pyc
  python/pandas/tests/indexes/categorical/
  python/pandas/tests/indexes/categorical/test_formats.py
  python/pandas/tests/indexes/categorical/test_fillna.py
  python/pandas/tests/indexes/categorical/test_constructors.py
  python/pandas/tests/indexes/categorical/test_indexing.py
  python/pandas/tests/indexes/categorical/test_astype.py
  python/pandas/tests/indexes/categorical/test_map.py
  python/pandas/tests/indexes/categorical/test_equals.py
  python/pandas/tests/indexes/categorical/__init__.py
  python/pandas/tests/indexes/categorical/test_category.py
  python/pandas/tests/indexes/categorical/test_reindex.py
  python/pandas/tests/indexes/categorical/__pycache__/
  python/pandas/tests/indexes/categorical/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_category.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_map.cpython-37.pyc
  python/pandas/tests/indexes/categorical/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/indexes/numeric/
  python/pandas/tests/indexes/numeric/test_indexing.py
  python/pandas/tests/indexes/numeric/test_astype.py
  python/pandas/tests/indexes/numeric/test_join.py
  python/pandas/tests/indexes/numeric/__init__.py
  python/pandas/tests/indexes/numeric/test_setops.py
  python/pandas/tests/indexes/numeric/__pycache__/
  python/pandas/tests/indexes/numeric/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/numeric/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/period/
  python/pandas/tests/indexes/period/test_formats.py
  python/pandas/tests/indexes/period/test_fillna.py
  python/pandas/tests/indexes/period/test_period_range.py
  python/pandas/tests/indexes/period/test_constructors.py
  python/pandas/tests/indexes/period/test_indexing.py
  python/pandas/tests/indexes/period/test_astype.py
  python/pandas/tests/indexes/period/test_searchsorted.py
  python/pandas/tests/indexes/period/test_scalar_compat.py
  python/pandas/tests/indexes/period/test_partial_slicing.py
  python/pandas/tests/indexes/period/test_join.py
  python/pandas/tests/indexes/period/test_to_timestamp.py
  python/pandas/tests/indexes/period/test_ops.py
  python/pandas/tests/indexes/period/test_factorize.py
  python/pandas/tests/indexes/period/__init__.py
  python/pandas/tests/indexes/period/test_shift.py
  python/pandas/tests/indexes/period/test_monotonic.py
  python/pandas/tests/indexes/period/test_tools.py
  python/pandas/tests/indexes/period/test_setops.py
  python/pandas/tests/indexes/period/test_period.py
  python/pandas/tests/indexes/period/test_asfreq.py
  python/pandas/tests/indexes/period/__pycache__/
  python/pandas/tests/indexes/period/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_factorize.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_monotonic.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_partial_slicing.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_period_range.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_scalar_compat.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_searchsorted.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_to_timestamp.cpython-37.pyc
  python/pandas/tests/indexes/period/__pycache__/test_tools.cpython-37.pyc
  python/pandas/tests/indexes/interval/
  python/pandas/tests/indexes/interval/test_formats.py
  python/pandas/tests/indexes/interval/test_constructors.py
  python/pandas/tests/indexes/interval/test_indexing.py
  python/pandas/tests/indexes/interval/test_interval_range.py
  python/pandas/tests/indexes/interval/test_astype.py
  python/pandas/tests/indexes/interval/test_interval_tree.py
  python/pandas/tests/indexes/interval/test_interval.py
  python/pandas/tests/indexes/interval/test_base.py
  python/pandas/tests/indexes/interval/test_equals.py
  python/pandas/tests/indexes/interval/__init__.py
  python/pandas/tests/indexes/interval/test_setops.py
  python/pandas/tests/indexes/interval/__pycache__/
  python/pandas/tests/indexes/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_base.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_interval_range.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_interval_tree.cpython-37.pyc
  python/pandas/tests/indexes/interval/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/multi/
  python/pandas/tests/indexes/multi/test_formats.py
  python/pandas/tests/indexes/multi/test_compat.py
  python/pandas/tests/indexes/multi/test_missing.py
  python/pandas/tests/indexes/multi/test_constructors.py
  python/pandas/tests/indexes/multi/test_get_set.py
  python/pandas/tests/indexes/multi/test_get_level_values.py
  python/pandas/tests/indexes/multi/test_indexing.py
  python/pandas/tests/indexes/multi/test_take.py
  python/pandas/tests/indexes/multi/test_astype.py
  python/pandas/tests/indexes/multi/test_conversion.py
  python/pandas/tests/indexes/multi/test_lexsort.py
  python/pandas/tests/indexes/multi/conftest.py
  python/pandas/tests/indexes/multi/test_join.py
  python/pandas/tests/indexes/multi/test_equivalence.py
  python/pandas/tests/indexes/multi/test_isin.py
  python/pandas/tests/indexes/multi/test_partial_indexing.py
  python/pandas/tests/indexes/multi/test_copy.py
  python/pandas/tests/indexes/multi/test_duplicates.py
  python/pandas/tests/indexes/multi/test_reshape.py
  python/pandas/tests/indexes/multi/test_drop.py
  python/pandas/tests/indexes/multi/test_analytics.py
  python/pandas/tests/indexes/multi/__init__.py
  python/pandas/tests/indexes/multi/test_monotonic.py
  python/pandas/tests/indexes/multi/test_sorting.py
  python/pandas/tests/indexes/multi/test_setops.py
  python/pandas/tests/indexes/multi/test_names.py
  python/pandas/tests/indexes/multi/test_integrity.py
  python/pandas/tests/indexes/multi/test_reindex.py
  python/pandas/tests/indexes/multi/__pycache__/
  python/pandas/tests/indexes/multi/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_analytics.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_compat.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_conversion.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_copy.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_drop.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_duplicates.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_equivalence.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_formats.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_get_level_values.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_get_set.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_integrity.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_isin.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_lexsort.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_monotonic.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_names.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_partial_indexing.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_reshape.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_sorting.cpython-37.pyc
  python/pandas/tests/indexes/multi/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/
  python/pandas/tests/indexes/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/common.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/datetimelike.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_any_index.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_base.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_engines.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_frozen.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_index_new.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_numeric.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_numpy_compat.cpython-37.pyc
  python/pandas/tests/indexes/__pycache__/test_setops.cpython-37.pyc
  python/pandas/tests/arithmetic/
  python/pandas/tests/arithmetic/test_array_ops.py
  python/pandas/tests/arithmetic/test_datetime64.py
  python/pandas/tests/arithmetic/test_interval.py
  python/pandas/tests/arithmetic/conftest.py
  python/pandas/tests/arithmetic/common.py
  python/pandas/tests/arithmetic/test_object.py
  python/pandas/tests/arithmetic/test_numeric.py
  python/pandas/tests/arithmetic/test_categorical.py
  python/pandas/tests/arithmetic/__init__.py
  python/pandas/tests/arithmetic/test_period.py
  python/pandas/tests/arithmetic/test_timedelta64.py
  python/pandas/tests/arithmetic/__pycache__/
  python/pandas/tests/arithmetic/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/common.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_array_ops.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_datetime64.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_numeric.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_object.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/arithmetic/__pycache__/test_timedelta64.cpython-37.pyc
  python/pandas/tests/dtypes/
  python/pandas/tests/dtypes/test_missing.py
  python/pandas/tests/dtypes/test_dtypes.py
  python/pandas/tests/dtypes/test_inference.py
  python/pandas/tests/dtypes/test_concat.py
  python/pandas/tests/dtypes/__init__.py
  python/pandas/tests/dtypes/test_common.py
  python/pandas/tests/dtypes/test_generic.py
  python/pandas/tests/dtypes/cast/
  python/pandas/tests/dtypes/cast/test_construct_from_scalar.py
  python/pandas/tests/dtypes/cast/test_downcast.py
  python/pandas/tests/dtypes/cast/test_infer_dtype.py
  python/pandas/tests/dtypes/cast/test_upcast.py
  python/pandas/tests/dtypes/cast/test_construct_object_arr.py
  python/pandas/tests/dtypes/cast/test_promote.py
  python/pandas/tests/dtypes/cast/test_construct_ndarray.py
  python/pandas/tests/dtypes/cast/test_dict_compat.py
  python/pandas/tests/dtypes/cast/__init__.py
  python/pandas/tests/dtypes/cast/test_infer_datetimelike.py
  python/pandas/tests/dtypes/cast/test_find_common_type.py
  python/pandas/tests/dtypes/cast/__pycache__/
  python/pandas/tests/dtypes/cast/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_construct_from_scalar.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_construct_ndarray.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_construct_object_arr.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_dict_compat.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_downcast.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_find_common_type.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_infer_datetimelike.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_infer_dtype.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_promote.cpython-37.pyc
  python/pandas/tests/dtypes/cast/__pycache__/test_upcast.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/
  python/pandas/tests/dtypes/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_generic.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_inference.cpython-37.pyc
  python/pandas/tests/dtypes/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/series/
  python/pandas/tests/series/test_subclass.py
  python/pandas/tests/series/test_missing.py
  python/pandas/tests/series/test_constructors.py
  python/pandas/tests/series/test_dtypes.py
  python/pandas/tests/series/test_logical_ops.py
  python/pandas/tests/series/test_reductions.py
  python/pandas/tests/series/test_validate.py
  python/pandas/tests/series/test_api.py
  python/pandas/tests/series/test_repr.py
  python/pandas/tests/series/test_npfuncs.py
  python/pandas/tests/series/test_duplicates.py
  python/pandas/tests/series/test_cumulative.py
  python/pandas/tests/series/__init__.py
  python/pandas/tests/series/test_arithmetic.py
  python/pandas/tests/series/test_ufunc.py
  python/pandas/tests/series/test_unary.py
  python/pandas/tests/series/test_iteration.py
  python/pandas/tests/series/indexing/
  python/pandas/tests/series/indexing/test_where.py
  python/pandas/tests/series/indexing/test_indexing.py
  python/pandas/tests/series/indexing/test_take.py
  python/pandas/tests/series/indexing/test_set_value.py
  python/pandas/tests/series/indexing/test_xs.py
  python/pandas/tests/series/indexing/test_getitem.py
  python/pandas/tests/series/indexing/test_datetime.py
  python/pandas/tests/series/indexing/test_mask.py
  python/pandas/tests/series/indexing/test_numeric.py
  python/pandas/tests/series/indexing/test_get.py
  python/pandas/tests/series/indexing/test_delitem.py
  python/pandas/tests/series/indexing/__init__.py
  python/pandas/tests/series/indexing/test_setitem.py
  python/pandas/tests/series/indexing/__pycache__/
  python/pandas/tests/series/indexing/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_delitem.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_get.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_getitem.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_mask.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_numeric.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_set_value.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_setitem.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_where.cpython-37.pyc
  python/pandas/tests/series/indexing/__pycache__/test_xs.cpython-37.pyc
  python/pandas/tests/series/apply/
  python/pandas/tests/series/apply/test_apply_relabeling.py
  python/pandas/tests/series/apply/test_series_transform.py
  python/pandas/tests/series/apply/test_series_apply.py
  python/pandas/tests/series/apply/__init__.py
  python/pandas/tests/series/apply/__pycache__/
  python/pandas/tests/series/apply/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/apply/__pycache__/test_apply_relabeling.cpython-37.pyc
  python/pandas/tests/series/apply/__pycache__/test_series_apply.cpython-37.pyc
  python/pandas/tests/series/apply/__pycache__/test_series_transform.cpython-37.pyc
  python/pandas/tests/series/methods/
  python/pandas/tests/series/methods/test_to_csv.py
  python/pandas/tests/series/methods/test_is_monotonic.py
  python/pandas/tests/series/methods/test_convert_dtypes.py
  python/pandas/tests/series/methods/test_explode.py
  python/pandas/tests/series/methods/test_between.py
  python/pandas/tests/series/methods/test_reindex_like.py
  python/pandas/tests/series/methods/test_combine.py
  python/pandas/tests/series/methods/test_fillna.py
  python/pandas/tests/series/methods/test_autocorr.py
  python/pandas/tests/series/methods/test_quantile.py
  python/pandas/tests/series/methods/test_sort_index.py
  python/pandas/tests/series/methods/test_view.py
  python/pandas/tests/series/methods/test_drop_duplicates.py
  python/pandas/tests/series/methods/test_repeat.py
  python/pandas/tests/series/methods/test_cov_corr.py
  python/pandas/tests/series/methods/test_nlargest.py
  python/pandas/tests/series/methods/test_rename_axis.py
  python/pandas/tests/series/methods/test_astype.py
  python/pandas/tests/series/methods/test_interpolate.py
  python/pandas/tests/series/methods/test_describe.py
  python/pandas/tests/series/methods/test_searchsorted.py
  python/pandas/tests/series/methods/test_head_tail.py
  python/pandas/tests/series/methods/test_value_counts.py
  python/pandas/tests/series/methods/test_compare.py
  python/pandas/tests/series/methods/test_tz_localize.py
  python/pandas/tests/series/methods/test_align.py
  python/pandas/tests/series/methods/test_values.py
  python/pandas/tests/series/methods/test_argsort.py
  python/pandas/tests/series/methods/test_rename.py
  python/pandas/tests/series/methods/test_duplicated.py
  python/pandas/tests/series/methods/test_update.py
  python/pandas/tests/series/methods/test_tz_convert.py
  python/pandas/tests/series/methods/test_dropna.py
  python/pandas/tests/series/methods/test_get_numeric_data.py
  python/pandas/tests/series/methods/test_append.py
  python/pandas/tests/series/methods/test_isin.py
  python/pandas/tests/series/methods/test_unstack.py
  python/pandas/tests/series/methods/test_item.py
  python/pandas/tests/series/methods/test_diff.py
  python/pandas/tests/series/methods/test_replace.py
  python/pandas/tests/series/methods/test_copy.py
  python/pandas/tests/series/methods/test_pct_change.py
  python/pandas/tests/series/methods/test_infer_objects.py
  python/pandas/tests/series/methods/test_clip.py
  python/pandas/tests/series/methods/test_asof.py
  python/pandas/tests/series/methods/test_drop.py
  python/pandas/tests/series/methods/test_matmul.py
  python/pandas/tests/series/methods/test_pop.py
  python/pandas/tests/series/methods/test_truncate.py
  python/pandas/tests/series/methods/test_to_frame.py
  python/pandas/tests/series/methods/test_combine_first.py
  python/pandas/tests/series/methods/test_equals.py
  python/pandas/tests/series/methods/__init__.py
  python/pandas/tests/series/methods/test_shift.py
  python/pandas/tests/series/methods/test_convert.py
  python/pandas/tests/series/methods/test_to_dict.py
  python/pandas/tests/series/methods/test_isna.py
  python/pandas/tests/series/methods/test_reset_index.py
  python/pandas/tests/series/methods/test_round.py
  python/pandas/tests/series/methods/test_asfreq.py
  python/pandas/tests/series/methods/test_rank.py
  python/pandas/tests/series/methods/test_reindex.py
  python/pandas/tests/series/methods/test_count.py
  python/pandas/tests/series/methods/test_sort_values.py
  python/pandas/tests/series/methods/test_set_name.py
  python/pandas/tests/series/methods/__pycache__/
  python/pandas/tests/series/methods/__pycache__/test_rename_axis.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_repeat.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_align.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_sort_index.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_append.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_sort_values.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_argsort.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_to_csv.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_to_dict.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_asof.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_to_frame.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_truncate.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_autocorr.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_tz_convert.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_between.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_tz_localize.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_clip.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_unstack.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_combine.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_nlargest.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_combine_first.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_update.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_compare.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_convert.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_pct_change.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_convert_dtypes.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_values.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_copy.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_view.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_count.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_cov_corr.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_describe.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_diff.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_drop.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_quantile.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_drop_duplicates.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_dropna.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_pop.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_duplicated.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_explode.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_rank.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_get_numeric_data.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_head_tail.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_rename.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_infer_objects.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_reindex_like.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_interpolate.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_is_monotonic.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_isin.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_isna.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_item.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_matmul.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_replace.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_set_name.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_reset_index.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_round.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/series/methods/__pycache__/test_searchsorted.cpython-37.pyc
  python/pandas/tests/series/accessors/
  python/pandas/tests/series/accessors/test_sparse_accessor.py
  python/pandas/tests/series/accessors/test_cat_accessor.py
  python/pandas/tests/series/accessors/test_dt_accessor.py
  python/pandas/tests/series/accessors/__init__.py
  python/pandas/tests/series/accessors/test_str_accessor.py
  python/pandas/tests/series/accessors/__pycache__/
  python/pandas/tests/series/accessors/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_cat_accessor.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_dt_accessor.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_sparse_accessor.cpython-37.pyc
  python/pandas/tests/series/accessors/__pycache__/test_str_accessor.cpython-37.pyc
  python/pandas/tests/series/__pycache__/
  python/pandas/tests/series/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_cumulative.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_duplicates.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_iteration.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_logical_ops.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_npfuncs.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_reductions.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_subclass.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_ufunc.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_unary.cpython-37.pyc
  python/pandas/tests/series/__pycache__/test_validate.cpython-37.pyc
  python/pandas/tests/computation/
  python/pandas/tests/computation/test_compat.py
  python/pandas/tests/computation/__init__.py
  python/pandas/tests/computation/test_eval.py
  python/pandas/tests/computation/__pycache__/
  python/pandas/tests/computation/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/computation/__pycache__/test_compat.cpython-37.pyc
  python/pandas/tests/computation/__pycache__/test_eval.cpython-37.pyc
  python/pandas/tests/api/
  python/pandas/tests/api/test_api.py
  python/pandas/tests/api/__init__.py
  python/pandas/tests/api/test_types.py
  python/pandas/tests/api/__pycache__/
  python/pandas/tests/api/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/api/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/api/__pycache__/test_types.cpython-37.pyc
  python/pandas/tests/indexing/
  python/pandas/tests/indexing/test_indexing.py
  python/pandas/tests/indexing/test_iat.py
  python/pandas/tests/indexing/test_datetime.py
  python/pandas/tests/indexing/common.py
  python/pandas/tests/indexing/test_chaining_and_caching.py
  python/pandas/tests/indexing/test_coercion.py
  python/pandas/tests/indexing/test_indexers.py
  python/pandas/tests/indexing/test_categorical.py
  python/pandas/tests/indexing/test_na_indexing.py
  python/pandas/tests/indexing/test_check_indexer.py
  python/pandas/tests/indexing/test_partial.py
  python/pandas/tests/indexing/__init__.py
  python/pandas/tests/indexing/test_floats.py
  python/pandas/tests/indexing/test_iloc.py
  python/pandas/tests/indexing/test_scalar.py
  python/pandas/tests/indexing/test_at.py
  python/pandas/tests/indexing/test_loc.py
  python/pandas/tests/indexing/multiindex/
  python/pandas/tests/indexing/multiindex/test_ix.py
  python/pandas/tests/indexing/multiindex/test_slice.py
  python/pandas/tests/indexing/multiindex/test_multiindex.py
  python/pandas/tests/indexing/multiindex/test_getitem.py
  python/pandas/tests/indexing/multiindex/test_datetime.py
  python/pandas/tests/indexing/multiindex/test_chaining_and_caching.py
  python/pandas/tests/indexing/multiindex/test_partial.py
  python/pandas/tests/indexing/multiindex/__init__.py
  python/pandas/tests/indexing/multiindex/test_sorted.py
  python/pandas/tests/indexing/multiindex/test_insert.py
  python/pandas/tests/indexing/multiindex/test_iloc.py
  python/pandas/tests/indexing/multiindex/test_indexing_slow.py
  python/pandas/tests/indexing/multiindex/test_loc.py
  python/pandas/tests/indexing/multiindex/test_setitem.py
  python/pandas/tests/indexing/multiindex/__pycache__/
  python/pandas/tests/indexing/multiindex/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_chaining_and_caching.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_getitem.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_iloc.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_indexing_slow.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_ix.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_loc.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_multiindex.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_partial.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_setitem.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_slice.cpython-37.pyc
  python/pandas/tests/indexing/multiindex/__pycache__/test_sorted.cpython-37.pyc
  python/pandas/tests/indexing/interval/
  python/pandas/tests/indexing/interval/test_interval.py
  python/pandas/tests/indexing/interval/test_interval_new.py
  python/pandas/tests/indexing/interval/__init__.py
  python/pandas/tests/indexing/interval/__pycache__/
  python/pandas/tests/indexing/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexing/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/indexing/interval/__pycache__/test_interval_new.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/
  python/pandas/tests/indexing/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/common.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_at.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_chaining_and_caching.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_check_indexer.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_coercion.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_floats.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_iat.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_iloc.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_indexers.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_loc.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_na_indexing.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_partial.cpython-37.pyc
  python/pandas/tests/indexing/__pycache__/test_scalar.cpython-37.pyc
  python/pandas/tests/base/
  python/pandas/tests/base/test_fillna.py
  python/pandas/tests/base/test_constructors.py
  python/pandas/tests/base/test_misc.py
  python/pandas/tests/base/test_unique.py
  python/pandas/tests/base/test_value_counts.py
  python/pandas/tests/base/test_conversion.py
  python/pandas/tests/base/test_transpose.py
  python/pandas/tests/base/common.py
  python/pandas/tests/base/__init__.py
  python/pandas/tests/base/__pycache__/
  python/pandas/tests/base/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/base/__pycache__/common.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_conversion.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_misc.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_transpose.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_unique.cpython-37.pyc
  python/pandas/tests/base/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/libs/
  python/pandas/tests/libs/test_join.py
  python/pandas/tests/libs/test_lib.py
  python/pandas/tests/libs/test_hashtable.py
  python/pandas/tests/libs/__init__.py
  python/pandas/tests/libs/__pycache__/
  python/pandas/tests/libs/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/libs/__pycache__/test_hashtable.cpython-37.pyc
  python/pandas/tests/libs/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/libs/__pycache__/test_lib.cpython-37.pyc
  python/pandas/tests/plotting/
  python/pandas/tests/plotting/test_converter.py
  python/pandas/tests/plotting/test_series.py
  python/pandas/tests/plotting/test_boxplot_method.py
  python/pandas/tests/plotting/test_misc.py
  python/pandas/tests/plotting/test_datetimelike.py
  python/pandas/tests/plotting/common.py
  python/pandas/tests/plotting/test_style.py
  python/pandas/tests/plotting/__init__.py
  python/pandas/tests/plotting/test_hist_method.py
  python/pandas/tests/plotting/test_backend.py
  python/pandas/tests/plotting/test_common.py
  python/pandas/tests/plotting/test_groupby.py
  python/pandas/tests/plotting/frame/
  python/pandas/tests/plotting/frame/test_frame.py
  python/pandas/tests/plotting/frame/test_frame_groupby.py
  python/pandas/tests/plotting/frame/test_frame_color.py
  python/pandas/tests/plotting/frame/test_frame_subplots.py
  python/pandas/tests/plotting/frame/__init__.py
  python/pandas/tests/plotting/frame/__pycache__/
  python/pandas/tests/plotting/frame/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame_color.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame_groupby.cpython-37.pyc
  python/pandas/tests/plotting/frame/__pycache__/test_frame_subplots.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/
  python/pandas/tests/plotting/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/common.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_backend.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_boxplot_method.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_converter.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_groupby.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_hist_method.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_misc.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_series.cpython-37.pyc
  python/pandas/tests/plotting/__pycache__/test_style.cpython-37.pyc
  python/pandas/tests/reductions/
  python/pandas/tests/reductions/test_reductions.py
  python/pandas/tests/reductions/__init__.py
  python/pandas/tests/reductions/test_stat_reductions.py
  python/pandas/tests/reductions/__pycache__/
  python/pandas/tests/reductions/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reductions/__pycache__/test_reductions.cpython-37.pyc
  python/pandas/tests/reductions/__pycache__/test_stat_reductions.cpython-37.pyc
  python/pandas/tests/io/
  python/pandas/tests/io/test_orc.py
  python/pandas/tests/io/test_html.py
  python/pandas/tests/io/test_clipboard.py
  python/pandas/tests/io/test_parquet.py
  python/pandas/tests/io/test_pickle.py
  python/pandas/tests/io/test_feather.py
  python/pandas/tests/io/test_gcs.py
  python/pandas/tests/io/conftest.py
  python/pandas/tests/io/test_spss.py
  python/pandas/tests/io/generate_legacy_storage_files.py
  python/pandas/tests/io/test_stata.py
  python/pandas/tests/io/test_gbq.py
  python/pandas/tests/io/__init__.py
  python/pandas/tests/io/test_date_converters.py
  python/pandas/tests/io/test_fsspec.py
  python/pandas/tests/io/test_s3.py
  python/pandas/tests/io/test_sql.py
  python/pandas/tests/io/test_common.py
  python/pandas/tests/io/test_compression.py
  python/pandas/tests/io/pytables/
  python/pandas/tests/io/pytables/test_compat.py
  python/pandas/tests/io/pytables/test_complex.py
  python/pandas/tests/io/pytables/test_timezones.py
  python/pandas/tests/io/pytables/test_pytables_missing.py
  python/pandas/tests/io/pytables/conftest.py
  python/pandas/tests/io/pytables/common.py
  python/pandas/tests/io/pytables/test_store.py
  python/pandas/tests/io/pytables/__init__.py
  python/pandas/tests/io/pytables/__pycache__/
  python/pandas/tests/io/pytables/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/common.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_compat.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_complex.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_pytables_missing.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_store.cpython-37.pyc
  python/pandas/tests/io/pytables/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/io/formats/
  python/pandas/tests/io/formats/test_info.py
  python/pandas/tests/io/formats/test_to_csv.py
  python/pandas/tests/io/formats/test_console.py
  python/pandas/tests/io/formats/test_to_latex.py
  python/pandas/tests/io/formats/test_format.py
  python/pandas/tests/io/formats/test_to_string.py
  python/pandas/tests/io/formats/test_eng_formatting.py
  python/pandas/tests/io/formats/test_to_excel.py
  python/pandas/tests/io/formats/test_to_markdown.py
  python/pandas/tests/io/formats/test_style.py
  python/pandas/tests/io/formats/test_css.py
  python/pandas/tests/io/formats/test_to_html.py
  python/pandas/tests/io/formats/__init__.py
  python/pandas/tests/io/formats/test_printing.py
  python/pandas/tests/io/formats/__pycache__/
  python/pandas/tests/io/formats/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_console.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_css.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_eng_formatting.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_format.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_info.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_printing.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_style.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_csv.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_excel.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_html.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_latex.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_markdown.cpython-37.pyc
  python/pandas/tests/io/formats/__pycache__/test_to_string.cpython-37.pyc
  python/pandas/tests/io/excel/
  python/pandas/tests/io/excel/test_xlwt.py
  python/pandas/tests/io/excel/test_xlsxwriter.py
  python/pandas/tests/io/excel/test_odf.py
  python/pandas/tests/io/excel/test_xlrd.py
  python/pandas/tests/io/excel/test_openpyxl.py
  python/pandas/tests/io/excel/conftest.py
  python/pandas/tests/io/excel/test_odswriter.py
  python/pandas/tests/io/excel/test_writers.py
  python/pandas/tests/io/excel/test_style.py
  python/pandas/tests/io/excel/__init__.py
  python/pandas/tests/io/excel/test_readers.py
  python/pandas/tests/io/excel/__pycache__/
  python/pandas/tests/io/excel/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_odf.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_odswriter.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_openpyxl.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_readers.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_style.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_writers.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_xlrd.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_xlsxwriter.cpython-37.pyc
  python/pandas/tests/io/excel/__pycache__/test_xlwt.cpython-37.pyc
  python/pandas/tests/io/parser/
  python/pandas/tests/io/parser/test_c_parser_only.py
  python/pandas/tests/io/parser/test_multi_thread.py
  python/pandas/tests/io/parser/test_dtypes.py
  python/pandas/tests/io/parser/test_read_fwf.py
  python/pandas/tests/io/parser/test_na_values.py
  python/pandas/tests/io/parser/conftest.py
  python/pandas/tests/io/parser/test_dialect.py
  python/pandas/tests/io/parser/test_encoding.py
  python/pandas/tests/io/parser/test_skiprows.py
  python/pandas/tests/io/parser/test_comment.py
  python/pandas/tests/io/parser/test_index_col.py
  python/pandas/tests/io/parser/test_quoting.py
  python/pandas/tests/io/parser/test_parse_dates.py
  python/pandas/tests/io/parser/__init__.py
  python/pandas/tests/io/parser/test_usecols.py
  python/pandas/tests/io/parser/test_python_parser_only.py
  python/pandas/tests/io/parser/test_textreader.py
  python/pandas/tests/io/parser/test_unsupported.py
  python/pandas/tests/io/parser/test_header.py
  python/pandas/tests/io/parser/test_mangle_dupes.py
  python/pandas/tests/io/parser/test_common.py
  python/pandas/tests/io/parser/test_network.py
  python/pandas/tests/io/parser/test_compression.py
  python/pandas/tests/io/parser/test_converters.py
  python/pandas/tests/io/parser/__pycache__/
  python/pandas/tests/io/parser/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_c_parser_only.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_comment.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_compression.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_converters.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_dialect.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_encoding.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_header.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_index_col.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_mangle_dupes.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_multi_thread.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_na_values.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_network.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_parse_dates.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_python_parser_only.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_quoting.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_read_fwf.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_skiprows.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_textreader.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_unsupported.cpython-37.pyc
  python/pandas/tests/io/parser/__pycache__/test_usecols.cpython-37.pyc
  python/pandas/tests/io/sas/
  python/pandas/tests/io/sas/test_sas.py
  python/pandas/tests/io/sas/test_sas7bdat.py
  python/pandas/tests/io/sas/test_xport.py
  python/pandas/tests/io/sas/__init__.py
  python/pandas/tests/io/sas/__pycache__/
  python/pandas/tests/io/sas/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/sas/__pycache__/test_sas.cpython-37.pyc
  python/pandas/tests/io/sas/__pycache__/test_sas7bdat.cpython-37.pyc
  python/pandas/tests/io/sas/__pycache__/test_xport.cpython-37.pyc
  python/pandas/tests/io/json/
  python/pandas/tests/io/json/test_readlines.py
  python/pandas/tests/io/json/test_json_table_schema.py
  python/pandas/tests/io/json/test_ujson.py
  python/pandas/tests/io/json/test_pandas.py
  python/pandas/tests/io/json/conftest.py
  python/pandas/tests/io/json/test_normalize.py
  python/pandas/tests/io/json/test_deprecated_kwargs.py
  python/pandas/tests/io/json/__init__.py
  python/pandas/tests/io/json/test_compression.py
  python/pandas/tests/io/json/__pycache__/
  python/pandas/tests/io/json/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_compression.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_deprecated_kwargs.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_json_table_schema.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_normalize.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_pandas.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_readlines.cpython-37.pyc
  python/pandas/tests/io/json/__pycache__/test_ujson.cpython-37.pyc
  python/pandas/tests/io/__pycache__/
  python/pandas/tests/io/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/io/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/io/__pycache__/generate_legacy_storage_files.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_clipboard.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_compression.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_date_converters.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_feather.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_fsspec.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_gbq.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_gcs.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_html.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_orc.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_parquet.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_pickle.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_s3.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_spss.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_sql.cpython-37.pyc
  python/pandas/tests/io/__pycache__/test_stata.cpython-37.pyc
  python/pandas/tests/config/
  python/pandas/tests/config/test_config.py
  python/pandas/tests/config/test_localization.py
  python/pandas/tests/config/__init__.py
  python/pandas/tests/config/__pycache__/
  python/pandas/tests/config/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/config/__pycache__/test_config.cpython-37.pyc
  python/pandas/tests/config/__pycache__/test_localization.cpython-37.pyc
  python/pandas/tests/reshape/
  python/pandas/tests/reshape/test_pivot_multilevel.py
  python/pandas/tests/reshape/test_util.py
  python/pandas/tests/reshape/test_pivot.py
  python/pandas/tests/reshape/test_get_dummies.py
  python/pandas/tests/reshape/test_melt.py
  python/pandas/tests/reshape/test_crosstab.py
  python/pandas/tests/reshape/test_qcut.py
  python/pandas/tests/reshape/test_union_categoricals.py
  python/pandas/tests/reshape/__init__.py
  python/pandas/tests/reshape/test_cut.py
  python/pandas/tests/reshape/merge/
  python/pandas/tests/reshape/merge/test_merge_asof.py
  python/pandas/tests/reshape/merge/test_merge_cross.py
  python/pandas/tests/reshape/merge/test_join.py
  python/pandas/tests/reshape/merge/test_merge_index_as_string.py
  python/pandas/tests/reshape/merge/test_merge.py
  python/pandas/tests/reshape/merge/__init__.py
  python/pandas/tests/reshape/merge/test_multi.py
  python/pandas/tests/reshape/merge/test_merge_ordered.py
  python/pandas/tests/reshape/merge/__pycache__/
  python/pandas/tests/reshape/merge/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_asof.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_cross.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_index_as_string.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_merge_ordered.cpython-37.pyc
  python/pandas/tests/reshape/merge/__pycache__/test_multi.cpython-37.pyc
  python/pandas/tests/reshape/concat/
  python/pandas/tests/reshape/concat/test_series.py
  python/pandas/tests/reshape/concat/conftest.py
  python/pandas/tests/reshape/concat/test_invalid.py
  python/pandas/tests/reshape/concat/test_sort.py
  python/pandas/tests/reshape/concat/test_concat.py
  python/pandas/tests/reshape/concat/test_append.py
  python/pandas/tests/reshape/concat/test_index.py
  python/pandas/tests/reshape/concat/test_categorical.py
  python/pandas/tests/reshape/concat/test_datetimes.py
  python/pandas/tests/reshape/concat/__init__.py
  python/pandas/tests/reshape/concat/test_append_common.py
  python/pandas/tests/reshape/concat/test_empty.py
  python/pandas/tests/reshape/concat/test_dataframe.py
  python/pandas/tests/reshape/concat/__pycache__/
  python/pandas/tests/reshape/concat/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_append.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_append_common.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_dataframe.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_datetimes.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_empty.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_index.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_invalid.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_series.cpython-37.pyc
  python/pandas/tests/reshape/concat/__pycache__/test_sort.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/
  python/pandas/tests/reshape/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_crosstab.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_cut.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_get_dummies.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_melt.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_pivot.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_pivot_multilevel.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_qcut.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_union_categoricals.cpython-37.pyc
  python/pandas/tests/reshape/__pycache__/test_util.cpython-37.pyc
  python/pandas/tests/tseries/
  python/pandas/tests/tseries/__init__.py
  python/pandas/tests/tseries/offsets/
  python/pandas/tests/tseries/offsets/test_offsets.py
  python/pandas/tests/tseries/offsets/test_ticks.py
  python/pandas/tests/tseries/offsets/conftest.py
  python/pandas/tests/tseries/offsets/common.py
  python/pandas/tests/tseries/offsets/test_offsets_properties.py
  python/pandas/tests/tseries/offsets/__init__.py
  python/pandas/tests/tseries/offsets/test_fiscal.py
  python/pandas/tests/tseries/offsets/test_yqm_offsets.py
  python/pandas/tests/tseries/offsets/__pycache__/
  python/pandas/tests/tseries/offsets/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/common.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_fiscal.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_offsets.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_offsets_properties.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_ticks.cpython-37.pyc
  python/pandas/tests/tseries/offsets/__pycache__/test_yqm_offsets.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/
  python/pandas/tests/tseries/frequencies/test_freq_code.py
  python/pandas/tests/tseries/frequencies/test_inference.py
  python/pandas/tests/tseries/frequencies/test_frequencies.py
  python/pandas/tests/tseries/frequencies/__init__.py
  python/pandas/tests/tseries/frequencies/__pycache__/
  python/pandas/tests/tseries/frequencies/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/__pycache__/test_freq_code.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/__pycache__/test_frequencies.cpython-37.pyc
  python/pandas/tests/tseries/frequencies/__pycache__/test_inference.cpython-37.pyc
  python/pandas/tests/tseries/holiday/
  python/pandas/tests/tseries/holiday/test_observance.py
  python/pandas/tests/tseries/holiday/test_holiday.py
  python/pandas/tests/tseries/holiday/__init__.py
  python/pandas/tests/tseries/holiday/test_federal.py
  python/pandas/tests/tseries/holiday/test_calendar.py
  python/pandas/tests/tseries/holiday/__pycache__/
  python/pandas/tests/tseries/holiday/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_calendar.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_federal.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_holiday.cpython-37.pyc
  python/pandas/tests/tseries/holiday/__pycache__/test_observance.cpython-37.pyc
  python/pandas/tests/tseries/__pycache__/
  python/pandas/tests/tseries/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/
  python/pandas/tests/arrays/test_numpy.py
  python/pandas/tests/arrays/test_timedeltas.py
  python/pandas/tests/arrays/test_array.py
  python/pandas/tests/arrays/test_datetimelike.py
  python/pandas/tests/arrays/test_datetimes.py
  python/pandas/tests/arrays/__init__.py
  python/pandas/tests/arrays/test_period.py
  python/pandas/tests/arrays/sparse/
  python/pandas/tests/arrays/sparse/test_array.py
  python/pandas/tests/arrays/sparse/test_arithmetics.py
  python/pandas/tests/arrays/sparse/test_combine_concat.py
  python/pandas/tests/arrays/sparse/__init__.py
  python/pandas/tests/arrays/sparse/test_accessor.py
  python/pandas/tests/arrays/sparse/test_libsparse.py
  python/pandas/tests/arrays/sparse/test_dtype.py
  python/pandas/tests/arrays/sparse/__pycache__/
  python/pandas/tests/arrays/sparse/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_accessor.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_arithmetics.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_array.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_combine_concat.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_dtype.cpython-37.pyc
  python/pandas/tests/arrays/sparse/__pycache__/test_libsparse.cpython-37.pyc
  python/pandas/tests/arrays/floating/
  python/pandas/tests/arrays/floating/test_construction.py
  python/pandas/tests/arrays/floating/test_function.py
  python/pandas/tests/arrays/floating/test_astype.py
  python/pandas/tests/arrays/floating/conftest.py
  python/pandas/tests/arrays/floating/test_comparison.py
  python/pandas/tests/arrays/floating/test_concat.py
  python/pandas/tests/arrays/floating/test_to_numpy.py
  python/pandas/tests/arrays/floating/test_repr.py
  python/pandas/tests/arrays/floating/__init__.py
  python/pandas/tests/arrays/floating/test_arithmetic.py
  python/pandas/tests/arrays/floating/__pycache__/
  python/pandas/tests/arrays/floating/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_comparison.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_construction.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/floating/__pycache__/test_to_numpy.cpython-37.pyc
  python/pandas/tests/arrays/boolean/
  python/pandas/tests/arrays/boolean/test_construction.py
  python/pandas/tests/arrays/boolean/test_function.py
  python/pandas/tests/arrays/boolean/test_indexing.py
  python/pandas/tests/arrays/boolean/test_logical.py
  python/pandas/tests/arrays/boolean/test_astype.py
  python/pandas/tests/arrays/boolean/test_comparison.py
  python/pandas/tests/arrays/boolean/test_repr.py
  python/pandas/tests/arrays/boolean/test_ops.py
  python/pandas/tests/arrays/boolean/__init__.py
  python/pandas/tests/arrays/boolean/test_arithmetic.py
  python/pandas/tests/arrays/boolean/test_reduction.py
  python/pandas/tests/arrays/boolean/__pycache__/
  python/pandas/tests/arrays/boolean/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_comparison.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_construction.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_logical.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_reduction.cpython-37.pyc
  python/pandas/tests/arrays/boolean/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/masked/
  python/pandas/tests/arrays/masked/test_arrow_compat.py
  python/pandas/tests/arrays/masked/__init__.py
  python/pandas/tests/arrays/masked/test_arithmetic.py
  python/pandas/tests/arrays/masked/__pycache__/
  python/pandas/tests/arrays/masked/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/masked/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/masked/__pycache__/test_arrow_compat.cpython-37.pyc
  python/pandas/tests/arrays/string_/
  python/pandas/tests/arrays/string_/__init__.py
  python/pandas/tests/arrays/string_/test_string.py
  python/pandas/tests/arrays/string_/test_string_arrow.py
  python/pandas/tests/arrays/string_/__pycache__/
  python/pandas/tests/arrays/string_/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/string_/__pycache__/test_string.cpython-37.pyc
  python/pandas/tests/arrays/string_/__pycache__/test_string_arrow.cpython-37.pyc
  python/pandas/tests/arrays/categorical/
  python/pandas/tests/arrays/categorical/test_subclass.py
  python/pandas/tests/arrays/categorical/test_missing.py
  python/pandas/tests/arrays/categorical/test_constructors.py
  python/pandas/tests/arrays/categorical/test_indexing.py
  python/pandas/tests/arrays/categorical/test_take.py
  python/pandas/tests/arrays/categorical/test_dtypes.py
  python/pandas/tests/arrays/categorical/test_warnings.py
  python/pandas/tests/arrays/categorical/conftest.py
  python/pandas/tests/arrays/categorical/common.py
  python/pandas/tests/arrays/categorical/test_algos.py
  python/pandas/tests/arrays/categorical/test_operators.py
  python/pandas/tests/arrays/categorical/test_api.py
  python/pandas/tests/arrays/categorical/test_repr.py
  python/pandas/tests/arrays/categorical/test_replace.py
  python/pandas/tests/arrays/categorical/test_analytics.py
  python/pandas/tests/arrays/categorical/__init__.py
  python/pandas/tests/arrays/categorical/test_sorting.py
  python/pandas/tests/arrays/categorical/__pycache__/
  python/pandas/tests/arrays/categorical/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/common.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_algos.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_analytics.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_operators.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_replace.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_sorting.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_subclass.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/arrays/categorical/__pycache__/test_warnings.cpython-37.pyc
  python/pandas/tests/arrays/integer/
  python/pandas/tests/arrays/integer/test_construction.py
  python/pandas/tests/arrays/integer/test_function.py
  python/pandas/tests/arrays/integer/test_indexing.py
  python/pandas/tests/arrays/integer/test_dtypes.py
  python/pandas/tests/arrays/integer/conftest.py
  python/pandas/tests/arrays/integer/test_comparison.py
  python/pandas/tests/arrays/integer/test_concat.py
  python/pandas/tests/arrays/integer/test_repr.py
  python/pandas/tests/arrays/integer/__init__.py
  python/pandas/tests/arrays/integer/test_arithmetic.py
  python/pandas/tests/arrays/integer/__pycache__/
  python/pandas/tests/arrays/integer/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_comparison.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_concat.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_construction.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/arrays/integer/__pycache__/test_repr.cpython-37.pyc
  python/pandas/tests/arrays/interval/
  python/pandas/tests/arrays/interval/test_astype.py
  python/pandas/tests/arrays/interval/test_interval.py
  python/pandas/tests/arrays/interval/test_ops.py
  python/pandas/tests/arrays/interval/__init__.py
  python/pandas/tests/arrays/interval/__pycache__/
  python/pandas/tests/arrays/interval/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/interval/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/arrays/interval/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/arrays/interval/__pycache__/test_ops.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/
  python/pandas/tests/arrays/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_array.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_datetimelike.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_datetimes.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_numpy.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/arrays/__pycache__/test_timedeltas.cpython-37.pyc
  python/pandas/tests/generic/
  python/pandas/tests/generic/test_series.py
  python/pandas/tests/generic/test_frame.py
  python/pandas/tests/generic/test_duplicate_labels.py
  python/pandas/tests/generic/test_to_xarray.py
  python/pandas/tests/generic/__init__.py
  python/pandas/tests/generic/test_label_or_level_utils.py
  python/pandas/tests/generic/test_finalize.py
  python/pandas/tests/generic/test_generic.py
  python/pandas/tests/generic/methods/
  python/pandas/tests/generic/methods/test_reorder_levels.py
  python/pandas/tests/generic/methods/test_sample.py
  python/pandas/tests/generic/methods/test_first_valid_index.py
  python/pandas/tests/generic/methods/test_dot.py
  python/pandas/tests/generic/methods/test_pipe.py
  python/pandas/tests/generic/methods/__init__.py
  python/pandas/tests/generic/methods/test_set_axis.py
  python/pandas/tests/generic/methods/__pycache__/
  python/pandas/tests/generic/methods/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_dot.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_first_valid_index.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_pipe.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_reorder_levels.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_sample.cpython-37.pyc
  python/pandas/tests/generic/methods/__pycache__/test_set_axis.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/
  python/pandas/tests/generic/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_duplicate_labels.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_finalize.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_frame.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_generic.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_label_or_level_utils.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_series.cpython-37.pyc
  python/pandas/tests/generic/__pycache__/test_to_xarray.cpython-37.pyc
  python/pandas/tests/resample/
  python/pandas/tests/resample/test_datetime_index.py
  python/pandas/tests/resample/test_deprecated.py
  python/pandas/tests/resample/test_resample_api.py
  python/pandas/tests/resample/test_time_grouper.py
  python/pandas/tests/resample/conftest.py
  python/pandas/tests/resample/test_period_index.py
  python/pandas/tests/resample/test_base.py
  python/pandas/tests/resample/__init__.py
  python/pandas/tests/resample/test_timedelta.py
  python/pandas/tests/resample/test_resampler_grouper.py
  python/pandas/tests/resample/__pycache__/
  python/pandas/tests/resample/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_base.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_datetime_index.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_deprecated.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_period_index.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_resample_api.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_resampler_grouper.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_time_grouper.cpython-37.pyc
  python/pandas/tests/resample/__pycache__/test_timedelta.cpython-37.pyc
  python/pandas/tests/frame/
  python/pandas/tests/frame/test_subclass.py
  python/pandas/tests/frame/test_nonunique_indexes.py
  python/pandas/tests/frame/test_constructors.py
  python/pandas/tests/frame/test_logical_ops.py
  python/pandas/tests/frame/test_stack_unstack.py
  python/pandas/tests/frame/conftest.py
  python/pandas/tests/frame/common.py
  python/pandas/tests/frame/test_alter_axes.py
  python/pandas/tests/frame/test_reductions.py
  python/pandas/tests/frame/test_validate.py
  python/pandas/tests/frame/test_query_eval.py
  python/pandas/tests/frame/test_repr_info.py
  python/pandas/tests/frame/test_api.py
  python/pandas/tests/frame/test_block_internals.py
  python/pandas/tests/frame/test_npfuncs.py
  python/pandas/tests/frame/test_cumulative.py
  python/pandas/tests/frame/__init__.py
  python/pandas/tests/frame/test_arithmetic.py
  python/pandas/tests/frame/test_ufunc.py
  python/pandas/tests/frame/test_unary.py
  python/pandas/tests/frame/test_iteration.py
  python/pandas/tests/frame/indexing/
  python/pandas/tests/frame/indexing/test_where.py
  python/pandas/tests/frame/indexing/test_indexing.py
  python/pandas/tests/frame/indexing/test_take.py
  python/pandas/tests/frame/indexing/test_lookup.py
  python/pandas/tests/frame/indexing/test_set_value.py
  python/pandas/tests/frame/indexing/test_get_value.py
  python/pandas/tests/frame/indexing/test_xs.py
  python/pandas/tests/frame/indexing/test_getitem.py
  python/pandas/tests/frame/indexing/test_mask.py
  python/pandas/tests/frame/indexing/test_get.py
  python/pandas/tests/frame/indexing/test_delitem.py
  python/pandas/tests/frame/indexing/test_categorical.py
  python/pandas/tests/frame/indexing/__init__.py
  python/pandas/tests/frame/indexing/test_insert.py
  python/pandas/tests/frame/indexing/test_setitem.py
  python/pandas/tests/frame/indexing/__pycache__/
  python/pandas/tests/frame/indexing/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_delitem.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_get.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_get_value.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_getitem.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_indexing.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_insert.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_lookup.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_mask.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_set_value.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_setitem.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_take.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_where.cpython-37.pyc
  python/pandas/tests/frame/indexing/__pycache__/test_xs.cpython-37.pyc
  python/pandas/tests/frame/apply/
  python/pandas/tests/frame/apply/test_apply_relabeling.py
  python/pandas/tests/frame/apply/test_frame_transform.py
  python/pandas/tests/frame/apply/__init__.py
  python/pandas/tests/frame/apply/test_frame_apply.py
  python/pandas/tests/frame/apply/__pycache__/
  python/pandas/tests/frame/apply/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/apply/__pycache__/test_apply_relabeling.cpython-37.pyc
  python/pandas/tests/frame/apply/__pycache__/test_frame_apply.cpython-37.pyc
  python/pandas/tests/frame/apply/__pycache__/test_frame_transform.cpython-37.pyc
  python/pandas/tests/frame/methods/
  python/pandas/tests/frame/methods/test_to_csv.py
  python/pandas/tests/frame/methods/test_convert_dtypes.py
  python/pandas/tests/frame/methods/test_explode.py
  python/pandas/tests/frame/methods/test_reindex_like.py
  python/pandas/tests/frame/methods/test_combine.py
  python/pandas/tests/frame/methods/test_filter.py
  python/pandas/tests/frame/methods/test_fillna.py
  python/pandas/tests/frame/methods/test_first_and_last.py
  python/pandas/tests/frame/methods/test_swapaxes.py
  python/pandas/tests/frame/methods/test_quantile.py
  python/pandas/tests/frame/methods/test_sort_index.py
  python/pandas/tests/frame/methods/test_drop_duplicates.py
  python/pandas/tests/frame/methods/test_to_period.py
  python/pandas/tests/frame/methods/test_cov_corr.py
  python/pandas/tests/frame/methods/test_nlargest.py
  python/pandas/tests/frame/methods/test_dtypes.py
  python/pandas/tests/frame/methods/test_rename_axis.py
  python/pandas/tests/frame/methods/test_astype.py
  python/pandas/tests/frame/methods/test_interpolate.py
  python/pandas/tests/frame/methods/test_select_dtypes.py
  python/pandas/tests/frame/methods/test_is_homogeneous_dtype.py
  python/pandas/tests/frame/methods/test_describe.py
  python/pandas/tests/frame/methods/test_at_time.py
  python/pandas/tests/frame/methods/test_head_tail.py
  python/pandas/tests/frame/methods/test_value_counts.py
  python/pandas/tests/frame/methods/test_compare.py
  python/pandas/tests/frame/methods/test_tz_localize.py
  python/pandas/tests/frame/methods/test_between_time.py
  python/pandas/tests/frame/methods/test_set_index.py
  python/pandas/tests/frame/methods/test_align.py
  python/pandas/tests/frame/methods/test_transpose.py
  python/pandas/tests/frame/methods/test_values.py
  python/pandas/tests/frame/methods/test_join.py
  python/pandas/tests/frame/methods/test_rename.py
  python/pandas/tests/frame/methods/test_duplicated.py
  python/pandas/tests/frame/methods/test_update.py
  python/pandas/tests/frame/methods/test_tz_convert.py
  python/pandas/tests/frame/methods/test_dropna.py
  python/pandas/tests/frame/methods/test_to_numpy.py
  python/pandas/tests/frame/methods/test_get_numeric_data.py
  python/pandas/tests/frame/methods/test_append.py
  python/pandas/tests/frame/methods/test_isin.py
  python/pandas/tests/frame/methods/test_to_timestamp.py
  python/pandas/tests/frame/methods/test_diff.py
  python/pandas/tests/frame/methods/test_replace.py
  python/pandas/tests/frame/methods/test_copy.py
  python/pandas/tests/frame/methods/test_pct_change.py
  python/pandas/tests/frame/methods/test_to_records.py
  python/pandas/tests/frame/methods/test_infer_objects.py
  python/pandas/tests/frame/methods/test_clip.py
  python/pandas/tests/frame/methods/test_asof.py
  python/pandas/tests/frame/methods/test_drop.py
  python/pandas/tests/frame/methods/test_matmul.py
  python/pandas/tests/frame/methods/test_pop.py
  python/pandas/tests/frame/methods/test_truncate.py
  python/pandas/tests/frame/methods/test_combine_first.py
  python/pandas/tests/frame/methods/test_equals.py
  python/pandas/tests/frame/methods/__init__.py
  python/pandas/tests/frame/methods/test_shift.py
  python/pandas/tests/frame/methods/test_convert.py
  python/pandas/tests/frame/methods/test_swaplevel.py
  python/pandas/tests/frame/methods/test_to_dict.py
  python/pandas/tests/frame/methods/test_reset_index.py
  python/pandas/tests/frame/methods/test_round.py
  python/pandas/tests/frame/methods/test_to_dict_of_blocks.py
  python/pandas/tests/frame/methods/test_asfreq.py
  python/pandas/tests/frame/methods/test_rank.py
  python/pandas/tests/frame/methods/test_add_prefix_suffix.py
  python/pandas/tests/frame/methods/test_reindex.py
  python/pandas/tests/frame/methods/test_count.py
  python/pandas/tests/frame/methods/test_droplevel.py
  python/pandas/tests/frame/methods/test_sort_values.py
  python/pandas/tests/frame/methods/test_assign.py
  python/pandas/tests/frame/methods/__pycache__/
  python/pandas/tests/frame/methods/__pycache__/test_reindex.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_interpolate.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_add_prefix_suffix.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_reindex_like.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_align.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_rename.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_append.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_rename_axis.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_asfreq.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_replace.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_asof.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_reset_index.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_assign.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_round.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_astype.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_csv.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_at_time.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_is_homogeneous_dtype.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_between_time.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_dict.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_clip.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_dict_of_blocks.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_combine.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_isin.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_combine_first.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_numpy.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_compare.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_period.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_convert.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_join.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_convert_dtypes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_records.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_copy.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_to_timestamp.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_count.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_transpose.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_cov_corr.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_truncate.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_describe.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_tz_convert.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_diff.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_tz_localize.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_drop.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_matmul.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_drop_duplicates.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_nlargest.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_droplevel.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_update.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_dropna.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_dtypes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_pct_change.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_duplicated.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_values.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_equals.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_explode.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_fillna.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_filter.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_pop.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_first_and_last.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_quantile.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_get_numeric_data.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_sort_values.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_head_tail.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_rank.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_infer_objects.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_select_dtypes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_swapaxes.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_set_index.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_shift.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_swaplevel.cpython-37.pyc
  python/pandas/tests/frame/methods/__pycache__/test_sort_index.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/
  python/pandas/tests/frame/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/common.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_alter_axes.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_arithmetic.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_block_internals.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_constructors.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_cumulative.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_iteration.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_logical_ops.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_nonunique_indexes.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_npfuncs.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_query_eval.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_reductions.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_repr_info.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_stack_unstack.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_subclass.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_ufunc.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_unary.cpython-37.pyc
  python/pandas/tests/frame/__pycache__/test_validate.cpython-37.pyc
  python/pandas/tests/groupby/
  python/pandas/tests/groupby/test_groupby_shift_diff.py
  python/pandas/tests/groupby/test_grouping.py
  python/pandas/tests/groupby/test_function.py
  python/pandas/tests/groupby/test_missing.py
  python/pandas/tests/groupby/test_nunique.py
  python/pandas/tests/groupby/test_allowlist.py
  python/pandas/tests/groupby/test_quantile.py
  python/pandas/tests/groupby/test_index_as_string.py
  python/pandas/tests/groupby/test_apply_mutate.py
  python/pandas/tests/groupby/test_groupby_subclass.py
  python/pandas/tests/groupby/test_apply.py
  python/pandas/tests/groupby/test_value_counts.py
  python/pandas/tests/groupby/test_sample.py
  python/pandas/tests/groupby/test_size.py
  python/pandas/tests/groupby/conftest.py
  python/pandas/tests/groupby/test_filters.py
  python/pandas/tests/groupby/test_nth.py
  python/pandas/tests/groupby/test_groupby_dropna.py
  python/pandas/tests/groupby/test_libgroupby.py
  python/pandas/tests/groupby/test_pipe.py
  python/pandas/tests/groupby/test_categorical.py
  python/pandas/tests/groupby/__init__.py
  python/pandas/tests/groupby/test_timegrouper.py
  python/pandas/tests/groupby/test_counting.py
  python/pandas/tests/groupby/test_bin_groupby.py
  python/pandas/tests/groupby/test_rank.py
  python/pandas/tests/groupby/test_groupby.py
  python/pandas/tests/groupby/transform/
  python/pandas/tests/groupby/transform/test_numba.py
  python/pandas/tests/groupby/transform/test_transform.py
  python/pandas/tests/groupby/transform/__init__.py
  python/pandas/tests/groupby/transform/__pycache__/
  python/pandas/tests/groupby/transform/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/groupby/transform/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/groupby/transform/__pycache__/test_transform.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/
  python/pandas/tests/groupby/aggregate/test_other.py
  python/pandas/tests/groupby/aggregate/test_aggregate.py
  python/pandas/tests/groupby/aggregate/test_numba.py
  python/pandas/tests/groupby/aggregate/__init__.py
  python/pandas/tests/groupby/aggregate/test_cython.py
  python/pandas/tests/groupby/aggregate/__pycache__/
  python/pandas/tests/groupby/aggregate/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_aggregate.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_cython.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/groupby/aggregate/__pycache__/test_other.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/
  python/pandas/tests/groupby/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_allowlist.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_apply.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_apply_mutate.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_bin_groupby.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_counting.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_filters.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_function.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby_dropna.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby_shift_diff.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_groupby_subclass.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_grouping.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_index_as_string.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_libgroupby.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_missing.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_nth.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_nunique.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_pipe.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_quantile.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_rank.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_sample.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_size.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_timegrouper.cpython-37.pyc
  python/pandas/tests/groupby/__pycache__/test_value_counts.cpython-37.pyc
  python/pandas/tests/tslibs/
  python/pandas/tests/tslibs/test_ccalendar.py
  python/pandas/tests/tslibs/test_timedeltas.py
  python/pandas/tests/tslibs/test_libfrequencies.py
  python/pandas/tests/tslibs/test_parsing.py
  python/pandas/tests/tslibs/test_array_to_datetime.py
  python/pandas/tests/tslibs/test_parse_iso8601.py
  python/pandas/tests/tslibs/test_timezones.py
  python/pandas/tests/tslibs/test_conversion.py
  python/pandas/tests/tslibs/test_api.py
  python/pandas/tests/tslibs/test_liboffsets.py
  python/pandas/tests/tslibs/__init__.py
  python/pandas/tests/tslibs/test_to_offset.py
  python/pandas/tests/tslibs/test_period_asfreq.py
  python/pandas/tests/tslibs/test_fields.py
  python/pandas/tests/tslibs/__pycache__/
  python/pandas/tests/tslibs/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_api.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_array_to_datetime.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_ccalendar.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_conversion.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_fields.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_libfrequencies.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_liboffsets.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_parse_iso8601.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_parsing.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_period_asfreq.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_timedeltas.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_timezones.cpython-37.pyc
  python/pandas/tests/tslibs/__pycache__/test_to_offset.cpython-37.pyc
  python/pandas/tests/internals/
  python/pandas/tests/internals/__init__.py
  python/pandas/tests/internals/test_internals.py
  python/pandas/tests/internals/__pycache__/
  python/pandas/tests/internals/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/internals/__pycache__/test_internals.cpython-37.pyc
  python/pandas/tests/extension/
  python/pandas/tests/extension/test_numpy.py
  python/pandas/tests/extension/test_boolean.py
  python/pandas/tests/extension/test_interval.py
  python/pandas/tests/extension/test_datetime.py
  python/pandas/tests/extension/conftest.py
  python/pandas/tests/extension/test_floating.py
  python/pandas/tests/extension/test_categorical.py
  python/pandas/tests/extension/test_external_block.py
  python/pandas/tests/extension/__init__.py
  python/pandas/tests/extension/test_string.py
  python/pandas/tests/extension/test_integer.py
  python/pandas/tests/extension/test_period.py
  python/pandas/tests/extension/test_sparse.py
  python/pandas/tests/extension/test_common.py
  python/pandas/tests/extension/decimal/
  python/pandas/tests/extension/decimal/test_decimal.py
  python/pandas/tests/extension/decimal/__init__.py
  python/pandas/tests/extension/decimal/array.py
  python/pandas/tests/extension/decimal/__pycache__/
  python/pandas/tests/extension/decimal/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/decimal/__pycache__/array.cpython-37.pyc
  python/pandas/tests/extension/decimal/__pycache__/test_decimal.cpython-37.pyc
  python/pandas/tests/extension/base/
  python/pandas/tests/extension/base/printing.py
  python/pandas/tests/extension/base/dtype.py
  python/pandas/tests/extension/base/interface.py
  python/pandas/tests/extension/base/ops.py
  python/pandas/tests/extension/base/base.py
  python/pandas/tests/extension/base/getitem.py
  python/pandas/tests/extension/base/io.py
  python/pandas/tests/extension/base/missing.py
  python/pandas/tests/extension/base/methods.py
  python/pandas/tests/extension/base/casting.py
  python/pandas/tests/extension/base/reshaping.py
  python/pandas/tests/extension/base/setitem.py
  python/pandas/tests/extension/base/groupby.py
  python/pandas/tests/extension/base/__init__.py
  python/pandas/tests/extension/base/constructors.py
  python/pandas/tests/extension/base/reduce.py
  python/pandas/tests/extension/base/__pycache__/
  python/pandas/tests/extension/base/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/base.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/casting.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/constructors.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/dtype.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/getitem.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/groupby.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/interface.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/io.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/methods.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/missing.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/ops.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/printing.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/reduce.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/reshaping.cpython-37.pyc
  python/pandas/tests/extension/base/__pycache__/setitem.cpython-37.pyc
  python/pandas/tests/extension/list/
  python/pandas/tests/extension/list/__init__.py
  python/pandas/tests/extension/list/test_list.py
  python/pandas/tests/extension/list/array.py
  python/pandas/tests/extension/list/__pycache__/
  python/pandas/tests/extension/list/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/list/__pycache__/array.cpython-37.pyc
  python/pandas/tests/extension/list/__pycache__/test_list.cpython-37.pyc
  python/pandas/tests/extension/json/
  python/pandas/tests/extension/json/test_json.py
  python/pandas/tests/extension/json/__init__.py
  python/pandas/tests/extension/json/array.py
  python/pandas/tests/extension/json/__pycache__/
  python/pandas/tests/extension/json/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/json/__pycache__/array.cpython-37.pyc
  python/pandas/tests/extension/json/__pycache__/test_json.cpython-37.pyc
  python/pandas/tests/extension/arrow/
  python/pandas/tests/extension/arrow/arrays.py
  python/pandas/tests/extension/arrow/__init__.py
  python/pandas/tests/extension/arrow/test_string.py
  python/pandas/tests/extension/arrow/test_bool.py
  python/pandas/tests/extension/arrow/__pycache__/
  python/pandas/tests/extension/arrow/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/arrow/__pycache__/arrays.cpython-37.pyc
  python/pandas/tests/extension/arrow/__pycache__/test_bool.cpython-37.pyc
  python/pandas/tests/extension/arrow/__pycache__/test_string.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/
  python/pandas/tests/extension/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_boolean.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_categorical.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_datetime.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_external_block.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_floating.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_integer.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_interval.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_numpy.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_period.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_sparse.cpython-37.pyc
  python/pandas/tests/extension/__pycache__/test_string.cpython-37.pyc
  python/pandas/tests/tools/
  python/pandas/tests/tools/test_to_datetime.py
  python/pandas/tests/tools/test_to_time.py
  python/pandas/tests/tools/__init__.py
  python/pandas/tests/tools/test_to_numeric.py
  python/pandas/tests/tools/test_to_timedelta.py
  python/pandas/tests/tools/__pycache__/
  python/pandas/tests/tools/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_datetime.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_numeric.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_time.cpython-37.pyc
  python/pandas/tests/tools/__pycache__/test_to_timedelta.cpython-37.pyc
  python/pandas/tests/util/
  python/pandas/tests/util/test_assert_produces_warning.py
  python/pandas/tests/util/test_assert_frame_equal.py
  python/pandas/tests/util/test_numba.py
  python/pandas/tests/util/test_util.py
  python/pandas/tests/util/test_assert_interval_array_equal.py
  python/pandas/tests/util/test_deprecate_nonkeyword_arguments.py
  python/pandas/tests/util/test_assert_index_equal.py
  python/pandas/tests/util/conftest.py
  python/pandas/tests/util/test_deprecate.py
  python/pandas/tests/util/test_validate_kwargs.py
  python/pandas/tests/util/test_assert_almost_equal.py
  python/pandas/tests/util/test_deprecate_kwarg.py
  python/pandas/tests/util/test_assert_extension_array_equal.py
  python/pandas/tests/util/__init__.py
  python/pandas/tests/util/test_validate_args_and_kwargs.py
  python/pandas/tests/util/test_assert_numpy_array_equal.py
  python/pandas/tests/util/test_assert_series_equal.py
  python/pandas/tests/util/test_assert_categorical_equal.py
  python/pandas/tests/util/test_safe_import.py
  python/pandas/tests/util/test_doc.py
  python/pandas/tests/util/test_show_versions.py
  python/pandas/tests/util/test_validate_args.py
  python/pandas/tests/util/test_hashing.py
  python/pandas/tests/util/__pycache__/
  python/pandas/tests/util/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/util/__pycache__/conftest.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_almost_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_categorical_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_extension_array_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_frame_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_index_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_interval_array_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_numpy_array_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_produces_warning.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_assert_series_equal.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_deprecate.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_deprecate_kwarg.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_deprecate_nonkeyword_arguments.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_doc.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_hashing.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_numba.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_safe_import.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_show_versions.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_util.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_validate_args.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_validate_args_and_kwargs.cpython-37.pyc
  python/pandas/tests/util/__pycache__/test_validate_kwargs.cpython-37.pyc
  python/pandas/tests/__pycache__/
  python/pandas/tests/__pycache__/__init__.cpython-37.pyc
  python/pandas/tests/__pycache__/test_aggregation.cpython-37.pyc
  python/pandas/tests/__pycache__/test_algos.cpython-37.pyc
  python/pandas/tests/__pycache__/test_common.cpython-37.pyc
  python/pandas/tests/__pycache__/test_downstream.cpython-37.pyc
  python/pandas/tests/__pycache__/test_errors.cpython-37.pyc
  python/pandas/tests/__pycache__/test_expressions.cpython-37.pyc
  python/pandas/tests/__pycache__/test_flags.cpython-37.pyc
  python/pandas/tests/__pycache__/test_multilevel.cpython-37.pyc
  python/pandas/tests/__pycache__/test_nanops.cpython-37.pyc
  python/pandas/tests/__pycache__/test_optional_dependency.cpython-37.pyc
  python/pandas/tests/__pycache__/test_register_accessor.cpython-37.pyc
  python/pandas/tests/__pycache__/test_sorting.cpython-37.pyc
  python/pandas/tests/__pycache__/test_strings.cpython-37.pyc
  python/pandas/tests/__pycache__/test_take.cpython-37.pyc
  python/pandas/core/
  python/pandas/core/api.py
  python/pandas/core/aggregation.py
  python/pandas/core/frame.py
  python/pandas/core/config_init.py
  python/pandas/core/series.py
  python/pandas/core/construction.py
  python/pandas/core/generic.py
  python/pandas/core/nanops.py
  python/pandas/core/sorting.py
  python/pandas/core/common.py
  python/pandas/core/accessor.py
  python/pandas/core/base.py
  python/pandas/core/indexing.py
  python/pandas/core/index.py
  python/pandas/core/arraylike.py
  python/pandas/core/missing.py
  python/pandas/core/resample.py
  python/pandas/core/shared_docs.py
  python/pandas/core/__init__.py
  python/pandas/core/algorithms.py
  python/pandas/core/flags.py
  python/pandas/core/apply.py
  python/pandas/core/indexers.py
  python/pandas/core/window/
  python/pandas/core/window/numba_.py
  python/pandas/core/window/ewm.py
  python/pandas/core/window/common.py
  python/pandas/core/window/expanding.py
  python/pandas/core/window/__init__.py
  python/pandas/core/window/rolling.py
  python/pandas/core/window/indexers.py
  python/pandas/core/window/__pycache__/
  python/pandas/core/window/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/window/__pycache__/common.cpython-37.pyc
  python/pandas/core/window/__pycache__/ewm.cpython-37.pyc
  python/pandas/core/window/__pycache__/expanding.cpython-37.pyc
  python/pandas/core/window/__pycache__/indexers.cpython-37.pyc
  python/pandas/core/window/__pycache__/numba_.cpython-37.pyc
  python/pandas/core/window/__pycache__/rolling.cpython-37.pyc
  python/pandas/core/indexes/
  python/pandas/core/indexes/api.py
  python/pandas/core/indexes/category.py
  python/pandas/core/indexes/frozen.py
  python/pandas/core/indexes/range.py
  python/pandas/core/indexes/interval.py
  python/pandas/core/indexes/timedeltas.py
  python/pandas/core/indexes/base.py
  python/pandas/core/indexes/accessors.py
  python/pandas/core/indexes/extension.py
  python/pandas/core/indexes/period.py
  python/pandas/core/indexes/multi.py
  python/pandas/core/indexes/datetimelike.py
  python/pandas/core/indexes/__init__.py
  python/pandas/core/indexes/datetimes.py
  python/pandas/core/indexes/numeric.py
  python/pandas/core/indexes/__pycache__/
  python/pandas/core/indexes/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/accessors.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/api.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/base.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/category.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/datetimelike.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/datetimes.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/extension.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/frozen.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/interval.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/multi.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/numeric.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/period.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/range.cpython-37.pyc
  python/pandas/core/indexes/__pycache__/timedeltas.cpython-37.pyc
  python/pandas/core/dtypes/
  python/pandas/core/dtypes/api.py
  python/pandas/core/dtypes/generic.py
  python/pandas/core/dtypes/dtypes.py
  python/pandas/core/dtypes/common.py
  python/pandas/core/dtypes/base.py
  python/pandas/core/dtypes/missing.py
  python/pandas/core/dtypes/cast.py
  python/pandas/core/dtypes/inference.py
  python/pandas/core/dtypes/__init__.py
  python/pandas/core/dtypes/concat.py
  python/pandas/core/dtypes/__pycache__/
  python/pandas/core/dtypes/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/api.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/base.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/cast.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/common.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/concat.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/dtypes.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/generic.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/inference.cpython-37.pyc
  python/pandas/core/dtypes/__pycache__/missing.cpython-37.pyc
  python/pandas/core/sparse/
  python/pandas/core/sparse/api.py
  python/pandas/core/sparse/__init__.py
  python/pandas/core/sparse/__pycache__/
  python/pandas/core/sparse/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/sparse/__pycache__/api.cpython-37.pyc
  python/pandas/core/computation/
  python/pandas/core/computation/api.py
  python/pandas/core/computation/parsing.py
  python/pandas/core/computation/expr.py
  python/pandas/core/computation/engines.py
  python/pandas/core/computation/ops.py
  python/pandas/core/computation/common.py
  python/pandas/core/computation/check.py
  python/pandas/core/computation/scope.py
  python/pandas/core/computation/expressions.py
  python/pandas/core/computation/align.py
  python/pandas/core/computation/__init__.py
  python/pandas/core/computation/eval.py
  python/pandas/core/computation/pytables.py
  python/pandas/core/computation/__pycache__/
  python/pandas/core/computation/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/computation/__pycache__/align.cpython-37.pyc
  python/pandas/core/computation/__pycache__/api.cpython-37.pyc
  python/pandas/core/computation/__pycache__/check.cpython-37.pyc
  python/pandas/core/computation/__pycache__/common.cpython-37.pyc
  python/pandas/core/computation/__pycache__/engines.cpython-37.pyc
  python/pandas/core/computation/__pycache__/eval.cpython-37.pyc
  python/pandas/core/computation/__pycache__/expr.cpython-37.pyc
  python/pandas/core/computation/__pycache__/expressions.cpython-37.pyc
  python/pandas/core/computation/__pycache__/ops.cpython-37.pyc
  python/pandas/core/computation/__pycache__/parsing.cpython-37.pyc
  python/pandas/core/computation/__pycache__/pytables.cpython-37.pyc
  python/pandas/core/computation/__pycache__/scope.cpython-37.pyc
  python/pandas/core/reshape/
  python/pandas/core/reshape/api.py
  python/pandas/core/reshape/tile.py
  python/pandas/core/reshape/util.py
  python/pandas/core/reshape/merge.py
  python/pandas/core/reshape/reshape.py
  python/pandas/core/reshape/pivot.py
  python/pandas/core/reshape/__init__.py
  python/pandas/core/reshape/melt.py
  python/pandas/core/reshape/concat.py
  python/pandas/core/reshape/__pycache__/
  python/pandas/core/reshape/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/api.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/concat.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/melt.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/merge.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/pivot.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/reshape.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/tile.cpython-37.pyc
  python/pandas/core/reshape/__pycache__/util.cpython-37.pyc
  python/pandas/core/arrays/
  python/pandas/core/arrays/_mixins.py
  python/pandas/core/arrays/boolean.py
  python/pandas/core/arrays/interval.py
  python/pandas/core/arrays/_arrow_utils.py
  python/pandas/core/arrays/timedeltas.py
  python/pandas/core/arrays/base.py
  python/pandas/core/arrays/string_.py
  python/pandas/core/arrays/string_arrow.py
  python/pandas/core/arrays/integer.py
  python/pandas/core/arrays/masked.py
  python/pandas/core/arrays/period.py
  python/pandas/core/arrays/floating.py
  python/pandas/core/arrays/datetimelike.py
  python/pandas/core/arrays/_ranges.py
  python/pandas/core/arrays/__init__.py
  python/pandas/core/arrays/numpy_.py
  python/pandas/core/arrays/datetimes.py
  python/pandas/core/arrays/categorical.py
  python/pandas/core/arrays/numeric.py
  python/pandas/core/arrays/sparse/
  python/pandas/core/arrays/sparse/dtype.py
  python/pandas/core/arrays/sparse/scipy_sparse.py
  python/pandas/core/arrays/sparse/accessor.py
  python/pandas/core/arrays/sparse/__init__.py
  python/pandas/core/arrays/sparse/array.py
  python/pandas/core/arrays/sparse/__pycache__/
  python/pandas/core/arrays/sparse/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/accessor.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/array.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/dtype.cpython-37.pyc
  python/pandas/core/arrays/sparse/__pycache__/scipy_sparse.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/
  python/pandas/core/arrays/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/_arrow_utils.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/_mixins.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/_ranges.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/base.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/boolean.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/categorical.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/datetimelike.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/datetimes.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/floating.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/integer.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/interval.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/masked.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/numeric.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/numpy_.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/period.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/string_.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/string_arrow.cpython-37.pyc
  python/pandas/core/arrays/__pycache__/timedeltas.cpython-37.pyc
  python/pandas/core/ops/
  python/pandas/core/ops/mask_ops.py
  python/pandas/core/ops/roperator.py
  python/pandas/core/ops/docstrings.py
  python/pandas/core/ops/common.py
  python/pandas/core/ops/dispatch.py
  python/pandas/core/ops/missing.py
  python/pandas/core/ops/methods.py
  python/pandas/core/ops/__init__.py
  python/pandas/core/ops/invalid.py
  python/pandas/core/ops/array_ops.py
  python/pandas/core/ops/__pycache__/
  python/pandas/core/ops/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/ops/__pycache__/array_ops.cpython-37.pyc
  python/pandas/core/ops/__pycache__/common.cpython-37.pyc
  python/pandas/core/ops/__pycache__/dispatch.cpython-37.pyc
  python/pandas/core/ops/__pycache__/docstrings.cpython-37.pyc
  python/pandas/core/ops/__pycache__/invalid.cpython-37.pyc
  python/pandas/core/ops/__pycache__/mask_ops.cpython-37.pyc
  python/pandas/core/ops/__pycache__/methods.cpython-37.pyc
  python/pandas/core/ops/__pycache__/missing.cpython-37.pyc
  python/pandas/core/ops/__pycache__/roperator.cpython-37.pyc
  python/pandas/core/groupby/
  python/pandas/core/groupby/numba_.py
  python/pandas/core/groupby/generic.py
  python/pandas/core/groupby/ops.py
  python/pandas/core/groupby/base.py
  python/pandas/core/groupby/groupby.py
  python/pandas/core/groupby/__init__.py
  python/pandas/core/groupby/grouper.py
  python/pandas/core/groupby/categorical.py
  python/pandas/core/groupby/__pycache__/
  python/pandas/core/groupby/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/base.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/categorical.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/generic.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/groupby.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/grouper.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/numba_.cpython-37.pyc
  python/pandas/core/groupby/__pycache__/ops.cpython-37.pyc
  python/pandas/core/strings/
  python/pandas/core/strings/accessor.py
  python/pandas/core/strings/base.py
  python/pandas/core/strings/object_array.py
  python/pandas/core/strings/__init__.py
  python/pandas/core/strings/__pycache__/
  python/pandas/core/strings/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/strings/__pycache__/accessor.cpython-37.pyc
  python/pandas/core/strings/__pycache__/base.cpython-37.pyc
  python/pandas/core/strings/__pycache__/object_array.cpython-37.pyc
  python/pandas/core/internals/
  python/pandas/core/internals/blocks.py
  python/pandas/core/internals/construction.py
  python/pandas/core/internals/ops.py
  python/pandas/core/internals/managers.py
  python/pandas/core/internals/__init__.py
  python/pandas/core/internals/concat.py
  python/pandas/core/internals/__pycache__/
  python/pandas/core/internals/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/internals/__pycache__/blocks.cpython-37.pyc
  python/pandas/core/internals/__pycache__/concat.cpython-37.pyc
  python/pandas/core/internals/__pycache__/construction.cpython-37.pyc
  python/pandas/core/internals/__pycache__/managers.cpython-37.pyc
  python/pandas/core/internals/__pycache__/ops.cpython-37.pyc
  python/pandas/core/array_algos/
  python/pandas/core/array_algos/masked_reductions.py
  python/pandas/core/array_algos/transforms.py
  python/pandas/core/array_algos/__init__.py
  python/pandas/core/array_algos/replace.py
  python/pandas/core/array_algos/__pycache__/
  python/pandas/core/array_algos/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/array_algos/__pycache__/masked_reductions.cpython-37.pyc
  python/pandas/core/array_algos/__pycache__/replace.cpython-37.pyc
  python/pandas/core/array_algos/__pycache__/transforms.cpython-37.pyc
  python/pandas/core/tools/
  python/pandas/core/tools/timedeltas.py
  python/pandas/core/tools/__init__.py
  python/pandas/core/tools/datetimes.py
  python/pandas/core/tools/times.py
  python/pandas/core/tools/numeric.py
  python/pandas/core/tools/__pycache__/
  python/pandas/core/tools/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/tools/__pycache__/datetimes.cpython-37.pyc
  python/pandas/core/tools/__pycache__/numeric.cpython-37.pyc
  python/pandas/core/tools/__pycache__/timedeltas.cpython-37.pyc
  python/pandas/core/tools/__pycache__/times.cpython-37.pyc
  python/pandas/core/util/
  python/pandas/core/util/hashing.py
  python/pandas/core/util/numba_.py
  python/pandas/core/util/__init__.py
  python/pandas/core/util/__pycache__/
  python/pandas/core/util/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/util/__pycache__/hashing.cpython-37.pyc
  python/pandas/core/util/__pycache__/numba_.cpython-37.pyc
  python/pandas/core/__pycache__/
  python/pandas/core/__pycache__/__init__.cpython-37.pyc
  python/pandas/core/__pycache__/accessor.cpython-37.pyc
  python/pandas/core/__pycache__/aggregation.cpython-37.pyc
  python/pandas/core/__pycache__/algorithms.cpython-37.pyc
  python/pandas/core/__pycache__/api.cpython-37.pyc
  python/pandas/core/__pycache__/apply.cpython-37.pyc
  python/pandas/core/__pycache__/arraylike.cpython-37.pyc
  python/pandas/core/__pycache__/base.cpython-37.pyc
  python/pandas/core/__pycache__/common.cpython-37.pyc
  python/pandas/core/__pycache__/config_init.cpython-37.pyc
  python/pandas/core/__pycache__/construction.cpython-37.pyc
  python/pandas/core/__pycache__/flags.cpython-37.pyc
  python/pandas/core/__pycache__/frame.cpython-37.pyc
  python/pandas/core/__pycache__/generic.cpython-37.pyc
  python/pandas/core/__pycache__/index.cpython-37.pyc
  python/pandas/core/__pycache__/indexers.cpython-37.pyc
  python/pandas/core/__pycache__/indexing.cpython-37.pyc
  python/pandas/core/__pycache__/missing.cpython-37.pyc
  python/pandas/core/__pycache__/nanops.cpython-37.pyc
  python/pandas/core/__pycache__/resample.cpython-37.pyc
  python/pandas/core/__pycache__/series.cpython-37.pyc
  python/pandas/core/__pycache__/shared_docs.cpython-37.pyc
  python/pandas/core/__pycache__/sorting.cpython-37.pyc
  python/pandas/api/
  python/pandas/api/__init__.py
  python/pandas/api/types/
  python/pandas/api/types/__init__.py
  python/pandas/api/types/__pycache__/
  python/pandas/api/types/__pycache__/__init__.cpython-37.pyc
  python/pandas/api/extensions/
  python/pandas/api/extensions/__init__.py
  python/pandas/api/extensions/__pycache__/
  python/pandas/api/extensions/__pycache__/__init__.cpython-37.pyc
  python/pandas/api/indexers/
  python/pandas/api/indexers/__init__.py
  python/pandas/api/indexers/__pycache__/
  python/pandas/api/indexers/__pycache__/__init__.cpython-37.pyc
  python/pandas/api/__pycache__/
  python/pandas/api/__pycache__/__init__.cpython-37.pyc
  python/pandas/plotting/
  python/pandas/plotting/_misc.py
  python/pandas/plotting/__init__.py
  python/pandas/plotting/_core.py
  python/pandas/plotting/_matplotlib/
  python/pandas/plotting/_matplotlib/style.py
  python/pandas/plotting/_matplotlib/tools.py
  python/pandas/plotting/_matplotlib/boxplot.py
  python/pandas/plotting/_matplotlib/core.py
  python/pandas/plotting/_matplotlib/converter.py
  python/pandas/plotting/_matplotlib/__init__.py
  python/pandas/plotting/_matplotlib/timeseries.py
  python/pandas/plotting/_matplotlib/misc.py
  python/pandas/plotting/_matplotlib/hist.py
  python/pandas/plotting/_matplotlib/compat.py
  python/pandas/plotting/_matplotlib/__pycache__/
  python/pandas/plotting/_matplotlib/__pycache__/__init__.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/boxplot.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/compat.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/converter.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/core.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/hist.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/misc.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/style.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/timeseries.cpython-37.pyc
  python/pandas/plotting/_matplotlib/__pycache__/tools.cpython-37.pyc
  python/pandas/plotting/__pycache__/
  python/pandas/plotting/__pycache__/__init__.cpython-37.pyc
  python/pandas/plotting/__pycache__/_core.cpython-37.pyc
  python/pandas/plotting/__pycache__/_misc.cpython-37.pyc
  python/pandas/_libs/
  python/pandas/_libs/testing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/groupby.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/parsers.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/reduction.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/interval.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/reshape.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/hashing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/indexing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/writers.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/index.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/internals.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/hashtable.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/json.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/ops.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/algos.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/ops_dispatch.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/__init__.py
  python/pandas/_libs/sparse.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/properties.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/lib.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslib.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/join.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/missing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/window/
  python/pandas/_libs/window/aggregations.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/window/__init__.py
  python/pandas/_libs/window/indexers.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/window/__pycache__/
  python/pandas/_libs/window/__pycache__/__init__.cpython-37.pyc
  python/pandas/_libs/tslibs/
  python/pandas/_libs/tslibs/fields.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/dtypes.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/ccalendar.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/base.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/timezones.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/tzconversion.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/nattype.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/conversion.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/vectorized.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/strptime.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/period.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/parsing.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/np_datetime.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/timedeltas.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/__init__.py
  python/pandas/_libs/tslibs/offsets.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/timestamps.cpython-37m-x86_64-linux-gnu.so
  python/pandas/_libs/tslibs/__pycache__/
  python/pandas/_libs/tslibs/__pycache__/__init__.cpython-37.pyc
  python/pandas/_libs/__pycache__/
  python/pandas/_libs/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/
  python/pandas/io/api.py
  python/pandas/io/html.py
  python/pandas/io/feather_format.py
  python/pandas/io/date_converters.py
  python/pandas/io/clipboards.py
  python/pandas/io/common.py
  python/pandas/io/parquet.py
  python/pandas/io/pickle.py
  python/pandas/io/__init__.py
  python/pandas/io/sql.py
  python/pandas/io/orc.py
  python/pandas/io/gbq.py
  python/pandas/io/parsers.py
  python/pandas/io/pytables.py
  python/pandas/io/stata.py
  python/pandas/io/spss.py
  python/pandas/io/clipboard/
  python/pandas/io/clipboard/__init__.py
  python/pandas/io/clipboard/__pycache__/
  python/pandas/io/clipboard/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/formats/
  python/pandas/io/formats/console.py
  python/pandas/io/formats/style.py
  python/pandas/io/formats/_color_data.py
  python/pandas/io/formats/printing.py
  python/pandas/io/formats/latex.py
  python/pandas/io/formats/html.py
  python/pandas/io/formats/format.py
  python/pandas/io/formats/string.py
  python/pandas/io/formats/info.py
  python/pandas/io/formats/css.py
  python/pandas/io/formats/excel.py
  python/pandas/io/formats/__init__.py
  python/pandas/io/formats/csvs.py
  python/pandas/io/formats/templates/
  python/pandas/io/formats/templates/html.tpl
  python/pandas/io/formats/__pycache__/
  python/pandas/io/formats/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/formats/__pycache__/_color_data.cpython-37.pyc
  python/pandas/io/formats/__pycache__/console.cpython-37.pyc
  python/pandas/io/formats/__pycache__/css.cpython-37.pyc
  python/pandas/io/formats/__pycache__/csvs.cpython-37.pyc
  python/pandas/io/formats/__pycache__/excel.cpython-37.pyc
  python/pandas/io/formats/__pycache__/format.cpython-37.pyc
  python/pandas/io/formats/__pycache__/html.cpython-37.pyc
  python/pandas/io/formats/__pycache__/info.cpython-37.pyc
  python/pandas/io/formats/__pycache__/latex.cpython-37.pyc
  python/pandas/io/formats/__pycache__/printing.cpython-37.pyc
  python/pandas/io/formats/__pycache__/string.cpython-37.pyc
  python/pandas/io/formats/__pycache__/style.cpython-37.pyc
  python/pandas/io/excel/
  python/pandas/io/excel/_xlwt.py
  python/pandas/io/excel/_xlrd.py
  python/pandas/io/excel/_openpyxl.py
  python/pandas/io/excel/_base.py
  python/pandas/io/excel/_odswriter.py
  python/pandas/io/excel/_pyxlsb.py
  python/pandas/io/excel/_odfreader.py
  python/pandas/io/excel/_util.py
  python/pandas/io/excel/__init__.py
  python/pandas/io/excel/_xlsxwriter.py
  python/pandas/io/excel/__pycache__/
  python/pandas/io/excel/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_base.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_odfreader.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_odswriter.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_openpyxl.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_pyxlsb.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_util.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_xlrd.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_xlsxwriter.cpython-37.pyc
  python/pandas/io/excel/__pycache__/_xlwt.cpython-37.pyc
  python/pandas/io/sas/
  python/pandas/io/sas/sas_xport.py
  python/pandas/io/sas/sas_constants.py
  python/pandas/io/sas/sasreader.py
  python/pandas/io/sas/sas7bdat.py
  python/pandas/io/sas/__init__.py
  python/pandas/io/sas/_sas.cpython-37m-x86_64-linux-gnu.so
  python/pandas/io/sas/__pycache__/
  python/pandas/io/sas/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sas7bdat.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sas_constants.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sas_xport.cpython-37.pyc
  python/pandas/io/sas/__pycache__/sasreader.cpython-37.pyc
  python/pandas/io/json/
  python/pandas/io/json/_table_schema.py
  python/pandas/io/json/__init__.py
  python/pandas/io/json/_normalize.py
  python/pandas/io/json/_json.py
  python/pandas/io/json/__pycache__/
  python/pandas/io/json/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/json/__pycache__/_json.cpython-37.pyc
  python/pandas/io/json/__pycache__/_normalize.cpython-37.pyc
  python/pandas/io/json/__pycache__/_table_schema.cpython-37.pyc
  python/pandas/io/__pycache__/
  python/pandas/io/__pycache__/__init__.cpython-37.pyc
  python/pandas/io/__pycache__/api.cpython-37.pyc
  python/pandas/io/__pycache__/clipboards.cpython-37.pyc
  python/pandas/io/__pycache__/common.cpython-37.pyc
  python/pandas/io/__pycache__/date_converters.cpython-37.pyc
  python/pandas/io/__pycache__/feather_format.cpython-37.pyc
  python/pandas/io/__pycache__/gbq.cpython-37.pyc
  python/pandas/io/__pycache__/html.cpython-37.pyc
  python/pandas/io/__pycache__/orc.cpython-37.pyc
  python/pandas/io/__pycache__/parquet.cpython-37.pyc
  python/pandas/io/__pycache__/parsers.cpython-37.pyc
  python/pandas/io/__pycache__/pickle.cpython-37.pyc
  python/pandas/io/__pycache__/pytables.cpython-37.pyc
  python/pandas/io/__pycache__/spss.cpython-37.pyc
  python/pandas/io/__pycache__/sql.cpython-37.pyc
  python/pandas/io/__pycache__/stata.cpython-37.pyc
  python/pandas/_config/
  python/pandas/_config/localization.py
  python/pandas/_config/display.py
  python/pandas/_config/config.py
  python/pandas/_config/dates.py
  python/pandas/_config/__init__.py
  python/pandas/_config/__pycache__/
  python/pandas/_config/__pycache__/__init__.cpython-37.pyc
  python/pandas/_config/__pycache__/config.cpython-37.pyc
  python/pandas/_config/__pycache__/dates.cpython-37.pyc
  python/pandas/_config/__pycache__/display.cpython-37.pyc
  python/pandas/_config/__pycache__/localization.cpython-37.pyc
  python/pandas/tseries/
  python/pandas/tseries/api.py
  python/pandas/tseries/frequencies.py
  python/pandas/tseries/offsets.py
  python/pandas/tseries/holiday.py
  python/pandas/tseries/__init__.py
  python/pandas/tseries/__pycache__/
  python/pandas/tseries/__pycache__/__init__.cpython-37.pyc
  python/pandas/tseries/__pycache__/api.cpython-37.pyc
  python/pandas/tseries/__pycache__/frequencies.cpython-37.pyc
  python/pandas/tseries/__pycache__/holiday.cpython-37.pyc
  python/pandas/tseries/__pycache__/offsets.cpython-37.pyc
  python/pandas/arrays/
  python/pandas/arrays/__init__.py
  python/pandas/arrays/__pycache__/
  python/pandas/arrays/__pycache__/__init__.cpython-37.pyc
  python/pandas/errors/
  python/pandas/errors/__init__.py
  python/pandas/errors/__pycache__/
  python/pandas/errors/__pycache__/__init__.cpython-37.pyc
  python/pandas/compat/
  python/pandas/compat/pickle_compat.py
  python/pandas/compat/_optional.py
  python/pandas/compat/__init__.py
  python/pandas/compat/chainmap.py
  python/pandas/compat/numpy/
  python/pandas/compat/numpy/__init__.py
  python/pandas/compat/numpy/function.py
  python/pandas/compat/numpy/__pycache__/
  python/pandas/compat/numpy/__pycache__/__init__.cpython-37.pyc
  python/pandas/compat/numpy/__pycache__/function.cpython-37.pyc
  python/pandas/compat/__pycache__/
  python/pandas/compat/__pycache__/__init__.cpython-37.pyc
  python/pandas/compat/__pycache__/_optional.cpython-37.pyc
  python/pandas/compat/__pycache__/chainmap.cpython-37.pyc
  python/pandas/compat/__pycache__/pickle_compat.cpython-37.pyc
  python/pandas/util/
  python/pandas/util/_depr_module.py
  python/pandas/util/_decorators.py
  python/pandas/util/_test_decorators.py
  python/pandas/util/testing.py
  python/pandas/util/_tester.py
  python/pandas/util/_exceptions.py
  python/pandas/util/_print_versions.py
  python/pandas/util/_doctools.py
  python/pandas/util/__init__.py
  python/pandas/util/_validators.py
  python/pandas/util/__pycache__/
  python/pandas/util/__pycache__/__init__.cpython-37.pyc
  python/pandas/util/__pycache__/_decorators.cpython-37.pyc
  python/pandas/util/__pycache__/_depr_module.cpython-37.pyc
  python/pandas/util/__pycache__/_doctools.cpython-37.pyc
  python/pandas/util/__pycache__/_exceptions.cpython-37.pyc
  python/pandas/util/__pycache__/_print_versions.cpython-37.pyc
  python/pandas/util/__pycache__/_test_decorators.cpython-37.pyc
  python/pandas/util/__pycache__/_tester.cpython-37.pyc
  python/pandas/util/__pycache__/_validators.cpython-37.pyc
  python/pandas/util/__pycache__/testing.cpython-37.pyc
  python/pandas/__pycache__/
  python/pandas/__pycache__/__init__.cpython-37.pyc
  python/pandas/__pycache__/_testing.cpython-37.pyc
  python/pandas/__pycache__/_typing.cpython-37.pyc
  python/pandas/__pycache__/_version.cpython-37.pyc
  python/pandas/__pycache__/conftest.cpython-37.pyc
  python/pandas/__pycache__/testing.cpython-37.pyc
  python/bin/
  python/bin/f2py
  python/bin/f2py3
  python/bin/f2py3.7
Total 4386 entries (107112473 bytes)
```

</details><br>

***Create Lambda function***

> Simple lambda function which just import panda and return successful message

```python
import json
import pandas as pd

def lambda_hander(event, context):
	return "Successfully import pandas!"

```

> Create lambda layer

```bash

# Upload layer.zip to S3 bucket
$  aws s3 cp layer.zip s3://lambda-bucket-246280/
upload: ./layer.zip to s3://lambda-bucket-246280/layer.zip

$  aws s3 ls s3://lambda-bucket-246280/
2021-04-30 12:50:51   33939339 layer.zip

# Create lambda layer

$  aws lambda publish-layer-version --layer-name demo-python-layer --description "Demonstration lambda layer" \
--license-info "MIT" --content S3Bucket=lambda-bucket-246280,,S3Key=layer.zip \
--compatible-runtimes python3.6 python3.7 python3.8
{
    "Content": {
        "Location": "https://awslambda-ap-se-2-layers.s3.ap-southeast-2.amazonaws.com/snapshots/037675027950/demo-python-layer-129ec918-6a0d-4402-a03f-56924899db33?versionId=7qOkmVp7KSE1E5.Opb_YVOe4ySLZifn0&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEAoaDmFwLXNvdXRoZWFzdC0yIkcwRQIhAIhA4gTLNqqias8Wkjb%2B2E6QfH%2FRDbMBzclzwaDu%2FBDnAiAa4jyviNDVofsG%2Fd0DXZXME39IVSfI0%2FcrW%2F1YrwRUPyrHAwiD%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F8BEAIaDDU4NzIyNzI3Mjk1OCIM2ih3MTUeAEzbVwBhKpsDCL9mz4Anz71pvKp4l7k1K3ZNqRlDSb6nyVgV4YcqE5i1ChCGepVSHeSRDwolSVTnBz%2BCQlJueJiHrC5YG6WskJRW82I7CLNJwyuZgH7K%2Bd%2F6jMt0ID4r7gh82tthnXjJU6cciSd4ifmmcWmdfoMrPlzB0RXoQ1ZrreuNrZ0%2Bu7EFvJJHMy4qsexXqWyUVJ7fgqoIs4Ci%2FaTzmOLHNnBfT2HuwuDn5DMDc5S%2Bz4rY10Y9vVyzla9N4xTZakXQLWp6XZh57XL3XDagQ2EWPojg8beKGglRiMeSyIx5Wy0WerCRxl2B%2F07l6phbEsmZ35nGFnymA0b7wLAg4R1bYXQqCFUWSZhx8xkoxm%2FliiEtI6S3vfCB18uT5htGUtB4D1Mq54TIRtnS5GALgPOMpNItOzxiSvipNLD1VN9aOk6JJ5sQmzzvCoFzwq2wQII2xRtS6jXfHDGbSLhKgBe4E5sYGVaWWyYQG52DM4bQH76psegVczYjR7qno%2BQB8VTV7vZUfwqicNGuV3sF5rNXDXAc9SqDbSi%2FUSJ9wcYCMPLArYQGOusBckWlitO2pqxIFuVTEm6fOWJ1ILJpdiZMduxHeD8jJdI8%2Fd2jH7VWoS1OEiB4KBGqZMPaIaaoWqRT%2FHtuDGo7mQU2Yv%2FkjZu31hOXf1WRb5QbS9ApZAes%2B0PikfIwh7qFoMxrlEUBUNJefsDxhLytr%2FENODOJKlkLird2HhJ%2FqfaAId0C1tfIHsG3dRm2cLetTta8ZXZp93GtWhvxuZoq%2BORJI89b5a0LmOhqXa4Trd%2FUbxeD0m3Wnaxdn6uzZQNP0RBqjA%2BLMDDKNqI2qhhHYIKrB9kr9CsOizBhbaW9H%2B5g0%2BVUwoZukmJ3wg%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20210430T025431Z&X-Amz-SignedHeaders=host&X-Amz-Expires=600&X-Amz-Credential=ASIAYROLZC37IYY6MG7Z%2F20210430%2Fap-southeast-2%2Fs3%2Faws4_request&X-Amz-Signature=444d22dbd9e49067b410fc986db522ed3a8275c27d55318996256539bcc0134f",
        "CodeSha256": "e4zUqwgs5jtd55BXPXToY3a3pN9jDhzHvLjJfHTmLfw=",
        "CodeSize": 33939339
    },
    "LayerArn": "arn:aws:lambda:ap-southeast-2:037675027950:layer:demo-python-layer",
    "LayerVersionArn": "arn:aws:lambda:ap-southeast-2:037675027950:layer:demo-python-layer:1",
    "Description": "Demonstration lambda layer",
    "CreatedDate": "2021-04-30T02:54:38.202+0000",
    "Version": 1,
    "CompatibleRuntimes": [
        "python3.6",
        "python3.7",
        "python3.8"
    ],
    "LicenseInfo": "MIT"
}

# List lambda layers by runtime

$  aws lambda list-layers --compatible-runtime python3.8
{
    "Layers": [
        {
            "LayerName": "demo-python-layer",
            "LayerArn": "arn:aws:lambda:ap-southeast-2:037675027950:layer:demo-python-layer",
            "LatestMatchingVersion": {
                "LayerVersionArn": "arn:aws:lambda:ap-southeast-2:037675027950:layer:demo-python-layer:1",
                "Version": 1,
                "Description": "Demonstration lambda layer",
                "CreatedDate": "2021-04-30T02:54:38.202+0000",
                "CompatibleRuntimes": [
                    "python3.6",
                    "python3.7",
                    "python3.8"
                ],
                "LicenseInfo": "MIT"
            }
        }
    ]
}

# List lambda layer by name and version

$  aws lambda get-layer-version --layer-name demo-python-layer --version-number 1
{
    "Content": {
        "Location": "https://awslambda-ap-se-2-layers.s3.ap-southeast-2.amazonaws.com/snapshots/037675027950/demo-python-layer-129ec918-6a0d-4402-a03f-56924899db33?versionId=7qOkmVp7KSE1E5.Opb_YVOe4ySLZifn0&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEAoaDmFwLXNvdXRoZWFzdC0yIkgwRgIhAMipm9CvSJMfM%2B92ZsD60jv4fSyHFNbySS5tHb1TN9g1AiEA4ERkacKBhafL8ZBn0x7EPqGAI2XdYzkMmqRF1bvvhfEqxwMIgv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARACGgw1ODcyMjcyNzI5NTgiDC%2BcLg6zmG9jUeY9GiqbA3lFEh0kyYOi%2BmD7w9ddDmwguDBPLDnZBMb6NeNCi2xFJn9c%2FM1DFyX6amWz9BMmrZz64koQz4YO12%2FX3%2FxHPT4HXXhwwEO3snyab%2BGLYwMzyqlmIHnVNoubVHcOQwUw04SbcXvJcTQErzmyYFgkuM2cqOaWjyBPvYPa2ZBV71HiD53T4Ybak9evLDCFSjamXbv62ERZpRAC4GZvKCTVVAbcT5FoPamQ54Drb3KKgq9pnqOsjpuz5tLGVDbc0R6hSFO5bjH76I%2Bjhz8sWourwbLEu6rhAnB0WzVroU%2F3tEWbQXii3LI7zOMAGJNs6fy7yVYhtJozraBFLJxvUGlzPDMTUoyMJ4Nn7MZsUCggSrQCD0ojkY30qD0z6Qp2Sb48o57JcWmLy1nmMhWYYCyr9F%2FKFo5EGDWvOAV023w1%2BfYPVH8B1Ua04dKDvn%2FFgnzp4yBUVk9P1eNjQDSlznDhFyt5zXAVFOF5FURF5oNrchQALgsjUlfqEDCj26obx2GPKPBTOBSWgvdzh4ZGF9tHr7OJ04ht7GJK%2BEvokzDuuq2EBjrqAYRIj54FYBklSW%2BqIkLAtaztONZyQ872W515xJ8r80W4%2FTVunEv8zDOhBZO4EC3%2BohIW1Dudu3LN92lHglamwcuVNMoeEkQjm6Ej6ZtR2A20IuqDXqlmCphYy5JBQ7SuEkQxUUYwGLdhzuhV%2F%2FtzU4e8MgV1LYEamU32yJNtSF9j1OW%2B8k%2B%2Br1xDJp9w%2FGqT3ZDv06tJ4LkkWI%2B%2BAefrT53Qt3F%2FVMkV55HQ0vmE5%2BL20oSDh3cGmGjl5%2Bh45Ir%2FboYKzhvRE0Z%2F3985HPLz%2FZtid7EQLKJQcb2%2Bg8gJAWtK2zg2tDbgxcoAqA%3D%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20210430T025712Z&X-Amz-SignedHeaders=host&X-Amz-Expires=600&X-Amz-Credential=ASIAYROLZC37L4DX64HD%2F20210430%2Fap-southeast-2%2Fs3%2Faws4_request&X-Amz-Signature=9c57822e4de6ea8d1ac48118cc115c4a24070ff5af6d24004219e186a3a29a4e",
        "CodeSha256": "e4zUqwgs5jtd55BXPXToY3a3pN9jDhzHvLjJfHTmLfw=",
        "CodeSize": 33939339
    },
    "LayerArn": "arn:aws:lambda:ap-southeast-2:037675027950:layer:demo-python-layer",
    "LayerVersionArn": "arn:aws:lambda:ap-southeast-2:037675027950:layer:demo-python-layer:1",
    "Description": "Demonstration lambda layer",
    "CreatedDate": "2021-04-30T02:54:38.202+0000",
    "Version": 1,
    "CompatibleRuntimes": [
        "python3.6",
        "python3.7",
        "python3.8"
    ],
    "LicenseInfo": "MIT"
}

```

***Create lambda function and add layer***

> Optionally, you need extra permission to run Lambda - trust-policy.json 

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::lambda-bucket-246280/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::lambda-bucket-246280/*"
        }
    ]
}
```

> Create Role for lambda execution

```bash
$ aws iam create-role --role-name lambda_s3_ops --assume-role-policy-document file://trust-policy.json
```

> Create Lamdba function

```bash
# Prepare zip file
$ zip function.zip lambda_function.py

# Create lambda function
$ aws lambda create-function --function-name import-panda \
--zip-file fileb://function.zip --handler lambda_function.lambda_handler --runtime python3.8 \
--timeout 10 \
--role arn:aws:iam::123456789012:role/lambda_s3_ops

# List and get details of created lambda function
$ aws lambda list-functions

$ aws lambda get-function --function-name import-panda
```

> Add published layer:version to Lamdba function

```bash
$ aws lambda update-function-configuration --function-name import-panda \
--layers arn:aws:lambda:ap-southeast-2:037675027950:layer:demo-python-layer:1
```


[Create lambda layer for Python Runtime]: https://aws.plainenglish.io/creating-aws-lambda-layer-for-python-runtime-1d1bc6c5148d
[Python package]: https://aws.amazon.com/premiumsupport/knowledge-center/lambda-python-package-compatible/
[AWS lambda layer]: https://dashbird.io/knowledge-base/aws-lambda/lambda-layers/
