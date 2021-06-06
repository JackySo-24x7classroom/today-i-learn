# Ansible tutorial - Journey to use Ansible version manager avm and AWS SSM session plugin

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Install Ansible version manager avm](#install-ansible-version-manager-avm)
- [Run ansible using AWS SSM connection plugin](#run-ansible-using-aws-ssm-connection-plugin)
- [Tips and Learnt](#tips-and-learnt)

<!-- vim-markdown-toc -->

## Install Ansible version manager avm

> Clone from github repo `https://github.com/ahelal/avm`

> Install avm from local cloned copy

<details><summary><b>Click to view Installation output</b></summary><br>

```bash
$ cd avm
$ AVM_VERSION=local AVM_VERBOSE=vvv ./setup.sh
⚠️   verbosity level 3 ⚠️
+ AVM_VERSION=local
+ SETUP_USER=jso
+ eval echo ~jso
+ echo /home1/jso
+ SETUP_USER_HOME=/home1/jso
+ print_verbose Setup SETUP_USER=jso and SETUP_USER_HOME=/home1/jso
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Setup SETUP_USER=jso and SETUP_USER_HOME=/home1/jso
💻  Setup SETUP_USER=jso and SETUP_USER_HOME=/home1/jso
+ AVM_IGNORE_SUDO=0
+ AVM_BASEDIR=/home1/jso/.avm
+ DEFAULT_INSTALL_TYPE=pip
+ AVM_UPDATE_VENV='no'
+ ANSIBLE_BIN_PATH=/usr/local/bin
+ avm_dir_setup
+ print_status Setting AVM version 'local' directory
+ date +%H:%M:%S
+ printf [%s] %s ...  19:11:42 Setting AVM version 'local' directory
[19:11:42] Setting AVM version 'local' directory ... + [ -z vvv ]
+ printf \n

+ MSG_STATUS=1
+ is_installed git
+ command -v git
+ fail=0
+ [ -z  ]
+ [ 0 = 1 ]
+ [ local = local ]
+ dirname ./setup.sh
+ MY_PATH=.
+ cd .
+ pwd
+ DIR=/tmp/avm
+ avm_dir=/tmp/avm
+ print_done
+ [ -z vvv ]
+ INCLUDE_FILE /tmp/avm/avm/main.sh
+ print_verbose Sourcing file '/tmp/avm/avm/main.sh'
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Sourcing file '/tmp/avm/avm/main.sh'
💻  Sourcing file '/tmp/avm/avm/main.sh'
+ [ -f /tmp/avm/avm/main.sh ]
+ . /tmp/avm/avm/main.sh
+ print_status Checking general system has minumum requirements
+ date +%H:%M:%S
+ printf [%s] %s ...  19:11:42 Checking general system has minumum requirements
[19:11:42] Checking general system has minumum requirements ... + [ -z vvv ]
+ printf \n

+ MSG_STATUS=1
+ INCLUDE_FILE /tmp/avm/avm/checks_general.sh
+ print_verbose Sourcing file '/tmp/avm/avm/checks_general.sh'
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Sourcing file '/tmp/avm/avm/checks_general.sh'
💻  Sourcing file '/tmp/avm/avm/checks_general.sh'
+ [ -f /tmp/avm/avm/checks_general.sh ]
+ . /tmp/avm/avm/checks_general.sh
+ general_check
+ whoami
+ [ jso = root ]
+ set +e
+ sudo_check
+ grep load -c
+ sudo -n uptime
+ CAN_I_RUN_SUDO=1
+ [ 1 = 0 ]
+ set -e
+ [ ! -d /home1/jso ]
+ print_done
+ [ -z vvv ]
+ INCLUDE_FILE /tmp/avm/avm/_distro.sh
+ print_verbose Sourcing file '/tmp/avm/avm/_distro.sh'
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Sourcing file '/tmp/avm/avm/_distro.sh'
💻  Sourcing file '/tmp/avm/avm/_distro.sh'
+ [ -f /tmp/avm/avm/_distro.sh ]
+ . /tmp/avm/avm/_distro.sh
+ supported_distro
+ uname
+ system=Linux
+ [ Linux = Linux ]
+ [ -f /etc/os-release ]
+ . /etc/os-release
+ NAME=Ubuntu
+ VERSION=20.04.2 LTS (Focal Fossa)
+ ID=ubuntu
+ ID_LIKE=debian
+ PRETTY_NAME=Ubuntu 20.04.2 LTS
+ VERSION_ID=20.04
+ HOME_URL=https://www.ubuntu.com/
+ SUPPORT_URL=https://help.ubuntu.com/
+ BUG_REPORT_URL=https://bugs.launchpad.net/ubuntu/
+ PRIVACY_POLICY_URL=https://www.ubuntu.com/legal/terms-and-policies/privacy-policy
+ VERSION_CODENAME=focal
+ UBUNTU_CODENAME=focal
+ [ -f /etc/redhat-release ]
+ [ -f /etc/lsb-release ]
+ print_verbose Your system is Ubuntu
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Your system is Ubuntu
💻  Your system is Ubuntu
+ INCLUDE_FILE /tmp/avm/avm/_distro_ubuntu.sh
+ print_verbose Sourcing file '/tmp/avm/avm/_distro_ubuntu.sh'
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Sourcing file '/tmp/avm/avm/_distro_ubuntu.sh'
💻  Sourcing file '/tmp/avm/avm/_distro_ubuntu.sh'
+ [ -f /tmp/avm/avm/_distro_ubuntu.sh ]
+ . /tmp/avm/avm/_distro_ubuntu.sh
+ setup_ubuntu
+ lsb_release -sr
+ VER=20.04
+ print_status Ubuntu-20.04 apt package update (might take some time)
+ date +%H:%M:%S
+ printf [%s] %s ...  19:11:43 Ubuntu-20.04 apt package update (might take some time)
[19:11:43] Ubuntu-20.04 apt package update (might take some time) ... + [ -z vvv ]
+ printf \n

+ MSG_STATUS=1
+ print_done
+ [ -z vvv ]
+ [ 20.04 = 14.04 ]
+ [ 20.04 = 16.04 ]
+ print_warning Your Ubuntu linux version was not tested. It might work
+ tput bold
+ tput setaf 1
+ tput sgr0
+ echo ⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
+ INCLUDE_FILE /tmp/avm/avm/checks_post.sh
+ print_verbose Sourcing file '/tmp/avm/avm/checks_post.sh'
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Sourcing file '/tmp/avm/avm/checks_post.sh'
💻  Sourcing file '/tmp/avm/avm/checks_post.sh'
+ [ -f /tmp/avm/avm/checks_post.sh ]
+ . /tmp/avm/avm/checks_post.sh
+ checks_post
+ print_status Installing/upgrading virtualenv
+ date +%H:%M:%S
+ printf [%s] %s ...  19:11:43 Installing/upgrading virtualenv
[19:11:43] Installing/upgrading virtualenv ... + [ -z vvv ]
+ printf \n

+ MSG_STATUS=1
+ which pip
+ [ -z /home1/jso/.pyenv/shims/pip ]
+ sudo -H pip install -q --upgrade virtualenv
WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
+ print_done
+ [ -z vvv ]
+ print_status Checking packages on your system has minumum requirements
+ date +%H:%M:%S
+ printf [%s] %s ...  19:11:44 Checking packages on your system has minumum requirements
[19:11:44] Checking packages on your system has minumum requirements ... + [ -z vvv ]
+ printf \n

+ MSG_STATUS=1
+ INCLUDE_FILE /tmp/avm/avm/checks_packages.sh
+ print_verbose Sourcing file '/tmp/avm/avm/checks_packages.sh'
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Sourcing file '/tmp/avm/avm/checks_packages.sh'
💻  Sourcing file '/tmp/avm/avm/checks_packages.sh'
+ [ -f /tmp/avm/avm/checks_packages.sh ]
+ . /tmp/avm/avm/checks_packages.sh
+ general_packages
+ is_installed sed
+ command -v sed
+ fail=0
+ [ -z  ]
+ [ 0 = 1 ]
+ is_installed grep
+ command -v grep
+ fail=0
+ [ -z  ]
+ [ 0 = 1 ]
+ is_installed wc
+ command -v wc
+ fail=0
+ [ -z  ]
+ [ 0 = 1 ]
+ is_installed curl
+ command -v curl
+ fail=0
+ [ -z  ]
+ [ 0 = 1 ]
+ is_installed python
+ command -v python
+ fail=0
+ [ -z  ]
+ [ 0 = 1 ]
+ is_installed pip 1
+ command -v pip
+ fail=0
+ [ -z 1 ]
+ echo 0
+ pip_bin=0
+ is_installed easy_install 1
+ command -v easy_install
+ fail=0
+ [ -z 1 ]
+ echo 0
+ easy_install_bin=0
+ [ 0 = 1 ]
+ print_done
+ [ -z vvv ]
+ INCLUDE_FILE /tmp/avm/avm/ansible_install.sh
+ print_verbose Sourcing file '/tmp/avm/avm/ansible_install.sh'
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Sourcing file '/tmp/avm/avm/ansible_install.sh'
💻  Sourcing file '/tmp/avm/avm/ansible_install.sh'
+ [ -f /tmp/avm/avm/ansible_install.sh ]
+ . /tmp/avm/avm/ansible_install.sh
+ ansible_install_venv
+ RUN_COMMAND_AS mkdir -p /home1/jso/.avm
+ [ jso = jso ]
+ command_2_run=mkdir -p /home1/jso/.avm
+ print_verbose Executing mkdir -p /home1/jso/.avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing mkdir -p /home1/jso/.avm
💻  Executing mkdir -p /home1/jso/.avm
+ eval mkdir -p /home1/jso/.avm
+ mkdir -p /home1/jso/.avm
+ RUN_COMMAND_AS chmod 0755 /home1/jso/.avm
+ [ jso = jso ]
+ command_2_run=chmod 0755 /home1/jso/.avm
+ print_verbose Executing chmod 0755 /home1/jso/.avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing chmod 0755 /home1/jso/.avm
💻  Executing chmod 0755 /home1/jso/.avm
+ eval chmod 0755 /home1/jso/.avm
+ chmod 0755 /home1/jso/.avm
+ RUN_COMMAND_AS mkdir -p /home1/jso/.avm/bin
+ [ jso = jso ]
+ command_2_run=mkdir -p /home1/jso/.avm/bin
+ print_verbose Executing mkdir -p /home1/jso/.avm/bin
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing mkdir -p /home1/jso/.avm/bin
💻  Executing mkdir -p /home1/jso/.avm/bin
+ eval mkdir -p /home1/jso/.avm/bin
+ mkdir -p /home1/jso/.avm/bin
+ RUN_COMMAND_AS chmod 0755 /home1/jso/.avm/bin
+ [ jso = jso ]
+ command_2_run=chmod 0755 /home1/jso/.avm/bin
+ print_verbose Executing chmod 0755 /home1/jso/.avm/bin
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing chmod 0755 /home1/jso/.avm/bin
💻  Executing chmod 0755 /home1/jso/.avm/bin
+ eval chmod 0755 /home1/jso/.avm/bin
+ chmod 0755 /home1/jso/.avm/bin
+ + tr -d
wc -l
+ sed s/=.*//
+ grep ANSIBLE_VERSIONS_
+ sort
+ printenv
+ count_ansible_version=0
+ [ 0 = 0 ]
+ print_warning You have not specified any ANSIBLE_VERSIONS_X to install :( so no ansible will be installed.
+ tput bold
+ tput setaf 1
+ tput sgr0
+ echo ⚠️  You have not specified any ANSIBLE_VERSIONS_X to install :( so no ansible will be installed. ⚠️
⚠️  You have not specified any ANSIBLE_VERSIONS_X to install :( so no ansible will be installed. ⚠️
+ read -r item
+ sed s/=.*//
+ grep ANSIBLE_VERSIONS_
+ sort
+ printenv
+ setup_version_bin
+ print_status Setting up avm cli command & symlink to ansible binaries.
+ date +%H:%M:%S
+ printf [%s] %s ...  19:11:44 Setting up avm cli command & symlink to ansible binaries.
[19:11:44] Setting up avm cli command & symlink to ansible binaries. ... + [ -z vvv ]
+ printf \n

+ MSG_STATUS=1
+ print_verbose Templating avm cli in /home1/jso/.avm/avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Templating avm cli in /home1/jso/.avm/avm
💻  Templating avm cli in /home1/jso/.avm/avm
+ RUN_COMMAND_AS sed -e "s%{{ AVM_BASEDIR }}%$AVM_BASEDIR%" -e "s%{{ ANSIBLE_SELECTED_VERSION }}%$ANSIBLE_DEFAULT_VERSION%" "${avm_dir}/avm/avm.sh" > ${AVM_BASEDIR}/avm
+ [ jso = jso ]
+ command_2_run=sed -e "s%{{ AVM_BASEDIR }}%$AVM_BASEDIR%" -e "s%{{ ANSIBLE_SELECTED_VERSION }}%$ANSIBLE_DEFAULT_VERSION%" "${avm_dir}/avm/avm.sh" > ${AVM_BASEDIR}/avm
+ print_verbose Executing sed -e "s%{{ AVM_BASEDIR }}%$AVM_BASEDIR%" -e "s%{{ ANSIBLE_SELECTED_VERSION }}%$ANSIBLE_DEFAULT_VERSION%" "${avm_dir}/avm/avm.sh" > ${AVM_BASEDIR}/avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sed -e "s%{{ AVM_BASEDIR }}%$AVM_BASEDIR%" -e "s%{{ ANSIBLE_SELECTED_VERSION }}%$ANSIBLE_DEFAULT_VERSION%" "${avm_dir}/avm/avm.sh" > ${AVM_BASEDIR}/avm
💻  Executing sed -e "s%{{ AVM_BASEDIR }}%$AVM_BASEDIR%" -e "s%{{ ANSIBLE_SELECTED_VERSION }}%$ANSIBLE_DEFAULT_VERSION%" "${avm_dir}/avm/avm.sh" > ${AVM_BASEDIR}/avm
+ eval sed -e "s%{{ AVM_BASEDIR }}%$AVM_BASEDIR%" -e "s%{{ ANSIBLE_SELECTED_VERSION }}%$ANSIBLE_DEFAULT_VERSION%" "${avm_dir}/avm/avm.sh" > ${AVM_BASEDIR}/avm
+ sed -e s%{{ AVM_BASEDIR }}%/home1/jso/.avm% -e s%{{ ANSIBLE_SELECTED_VERSION }}%% /tmp/avm/avm/avm.sh
+ RUN_COMMAND_AS sudo chmod 0755 /home1/jso/.avm/avm
+ [ jso = jso ]
+ command_2_run=sudo chmod 0755 /home1/jso/.avm/avm
+ print_verbose Executing sudo chmod 0755 /home1/jso/.avm/avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo chmod 0755 /home1/jso/.avm/avm
💻  Executing sudo chmod 0755 /home1/jso/.avm/avm
+ eval sudo chmod 0755 /home1/jso/.avm/avm
+ sudo chmod 0755 /home1/jso/.avm/avm
+ RUN_COMMAND_AS sudo chown jso /home1/jso/.avm/avm
+ [ jso = jso ]
+ command_2_run=sudo chown jso /home1/jso/.avm/avm
+ print_verbose Executing sudo chown jso /home1/jso/.avm/avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo chown jso /home1/jso/.avm/avm
💻  Executing sudo chown jso /home1/jso/.avm/avm
+ eval sudo chown jso /home1/jso/.avm/avm
+ sudo chown jso /home1/jso/.avm/avm
+ manage_symlink /home1/jso/.avm/avm /usr/local/bin/avm
+ set +e
+ readlink /usr/local/bin/avm
+ actual_dest=/home1/jso/.avm/avm
+ [ /home1/jso/.avm/avm != /home1/jso/.avm/avm ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/avm /usr/local/bin/avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/avm /usr/local/bin/avm
💻  Creating symlink to /home1/jso/.avm/avm /usr/local/bin/avm
+ [ -z  ]
+ run_sudo=sudo
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/avm /usr/local/bin/avm
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/avm /usr/local/bin/avm
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/avm /usr/local/bin/avm
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/avm /usr/local/bin/avm
💻  Executing sudo ln -sf /home1/jso/.avm/avm /usr/local/bin/avm
+ eval sudo ln -sf /home1/jso/.avm/avm /usr/local/bin/avm
+ sudo ln -sf /home1/jso/.avm/avm /usr/local/bin/avm
+ print_verbose Creating global symlink /home1/jso/.avm/bin/ansible is pointing to /usr/local/bin/ansible
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating global symlink /home1/jso/.avm/bin/ansible is pointing to /usr/local/bin/ansible
💻  Creating global symlink /home1/jso/.avm/bin/ansible is pointing to /usr/local/bin/ansible
+ manage_symlink /home1/jso/.avm/bin/ansible /usr/local/bin/ansible RUN_SUDO
+ set +e
+ readlink /usr/local/bin/ansible
+ actual_dest=/home1/jso/.avm/bin/ansible
+ [ /home1/jso/.avm/bin/ansible != /home1/jso/.avm/bin/ansible ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
💻  Creating symlink to /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ [ -z RUN_SUDO ]
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ eval sudo ln -sf /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ sudo ln -sf /home1/jso/.avm/bin/ansible /usr/local/bin/ansible
+ print_verbose Creating global symlink /home1/jso/.avm/bin/ansible-doc is pointing to /usr/local/bin/ansible-doc
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating global symlink /home1/jso/.avm/bin/ansible-doc is pointing to /usr/local/bin/ansible-doc
💻  Creating global symlink /home1/jso/.avm/bin/ansible-doc is pointing to /usr/local/bin/ansible-doc
+ manage_symlink /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc RUN_SUDO
+ set +e
+ readlink /usr/local/bin/ansible-doc
+ actual_dest=/home1/jso/.avm/bin/ansible-doc
+ [ /home1/jso/.avm/bin/ansible-doc != /home1/jso/.avm/bin/ansible-doc ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
💻  Creating symlink to /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ [ -z RUN_SUDO ]
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ eval sudo ln -sf /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ sudo ln -sf /home1/jso/.avm/bin/ansible-doc /usr/local/bin/ansible-doc
+ print_verbose Creating global symlink /home1/jso/.avm/bin/ansible-galaxy is pointing to /usr/local/bin/ansible-galaxy
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating global symlink /home1/jso/.avm/bin/ansible-galaxy is pointing to /usr/local/bin/ansible-galaxy
💻  Creating global symlink /home1/jso/.avm/bin/ansible-galaxy is pointing to /usr/local/bin/ansible-galaxy
+ manage_symlink /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy RUN_SUDO
+ set +e
+ readlink /usr/local/bin/ansible-galaxy
+ actual_dest=/home1/jso/.avm/bin/ansible-galaxy
+ [ /home1/jso/.avm/bin/ansible-galaxy != /home1/jso/.avm/bin/ansible-galaxy ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
💻  Creating symlink to /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ [ -z RUN_SUDO ]
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ eval sudo ln -sf /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ sudo ln -sf /home1/jso/.avm/bin/ansible-galaxy /usr/local/bin/ansible-galaxy
+ print_verbose Creating global symlink /home1/jso/.avm/bin/ansible-playbook is pointing to /usr/local/bin/ansible-playbook
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating global symlink /home1/jso/.avm/bin/ansible-playbook is pointing to /usr/local/bin/ansible-playbook
💻  Creating global symlink /home1/jso/.avm/bin/ansible-playbook is pointing to /usr/local/bin/ansible-playbook
+ manage_symlink /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook RUN_SUDO
+ set +e
+ readlink /usr/local/bin/ansible-playbook
+ actual_dest=/home1/jso/.avm/bin/ansible-playbook
+ [ /home1/jso/.avm/bin/ansible-playbook != /home1/jso/.avm/bin/ansible-playbook ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
💻  Creating symlink to /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ [ -z RUN_SUDO ]
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ eval sudo ln -sf /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ sudo ln -sf /home1/jso/.avm/bin/ansible-playbook /usr/local/bin/ansible-playbook
+ print_verbose Creating global symlink /home1/jso/.avm/bin/ansible-pull is pointing to /usr/local/bin/ansible-pull
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating global symlink /home1/jso/.avm/bin/ansible-pull is pointing to /usr/local/bin/ansible-pull
💻  Creating global symlink /home1/jso/.avm/bin/ansible-pull is pointing to /usr/local/bin/ansible-pull
+ manage_symlink /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull RUN_SUDO
+ set +e
+ readlink /usr/local/bin/ansible-pull
+ actual_dest=/home1/jso/.avm/bin/ansible-pull
+ [ /home1/jso/.avm/bin/ansible-pull != /home1/jso/.avm/bin/ansible-pull ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
💻  Creating symlink to /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ [ -z RUN_SUDO ]
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ eval sudo ln -sf /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ sudo ln -sf /home1/jso/.avm/bin/ansible-pull /usr/local/bin/ansible-pull
+ print_verbose Creating global symlink /home1/jso/.avm/bin/ansible-vault is pointing to /usr/local/bin/ansible-vault
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating global symlink /home1/jso/.avm/bin/ansible-vault is pointing to /usr/local/bin/ansible-vault
💻  Creating global symlink /home1/jso/.avm/bin/ansible-vault is pointing to /usr/local/bin/ansible-vault
+ manage_symlink /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault RUN_SUDO
+ set +e
+ readlink /usr/local/bin/ansible-vault
+ actual_dest=/home1/jso/.avm/bin/ansible-vault
+ [ /home1/jso/.avm/bin/ansible-vault != /home1/jso/.avm/bin/ansible-vault ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
💻  Creating symlink to /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ [ -z RUN_SUDO ]
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ eval sudo ln -sf /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ sudo ln -sf /home1/jso/.avm/bin/ansible-vault /usr/local/bin/ansible-vault
+ print_verbose Creating global symlink /home1/jso/.avm/bin/ansible-console is pointing to /usr/local/bin/ansible-console
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating global symlink /home1/jso/.avm/bin/ansible-console is pointing to /usr/local/bin/ansible-console
💻  Creating global symlink /home1/jso/.avm/bin/ansible-console is pointing to /usr/local/bin/ansible-console
+ manage_symlink /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console RUN_SUDO
+ set +e
+ readlink /usr/local/bin/ansible-console
+ actual_dest=/home1/jso/.avm/bin/ansible-console
+ [ /home1/jso/.avm/bin/ansible-console != /home1/jso/.avm/bin/ansible-console ]
+ set -e
+ print_verbose Creating symlink to /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Creating symlink to /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
💻  Creating symlink to /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ [ -z RUN_SUDO ]
+ RUN_COMMAND_AS sudo ln -sf /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ [ jso = jso ]
+ command_2_run=sudo ln -sf /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ print_verbose Executing sudo ln -sf /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
💻  Executing sudo ln -sf /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ eval sudo ln -sf /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ sudo ln -sf /home1/jso/.avm/bin/ansible-console /usr/local/bin/ansible-console
+ print_done
+ [ -z vvv ]
+ setup_default_version
+ [ -z  ]
+ head -1
+ sed s/=.*//
+ grep ANSIBLE_VERSIONS_
+ sort
+ printenv
+ first_item=
+ get_variable
+ python -c import os; print(os.environ.get("",""))
+ ansible_version=
+ ANSIBLE_DEFAULT_VERSION=
+ [ -z  ]
+ print_verbose No default version set and no fallback.
+ [ -z vvv ]
+ tput bold
+ tput sgr0
+ echo 💻  No default version set and no fallback.
💻  No default version set and no fallback.
+ exit 0
+ setup_exit
+ ret=0
+ [ 0 = 0 ]
+ setup_done
+ tput bold
+ tput setaf 2
+ tput sgr0
+ printf \n%s%s🎆 🎇 🎆 🎇  Happy Ansibleing%s 🎆 🎇 🎆 🎇\n
```

```bash
$  AVM_VERSION=local ./setup.sh
[22:00:10] Setting AVM version 'local' directory ... ✅
[22:00:10] Checking general system has minumum requirements ... ✅
[22:00:10] Ubuntu-20.04 apt package update (might take some time) ... ✅
⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
[22:00:10] Installing/upgrading virtualenv ... WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
✅
[22:00:12] Checking packages on your system has minumum requirements ... ✅
⚠️  You have not specified any ANSIBLE_VERSIONS_X to install :( so no ansible will be installed. ⚠️
[22:00:12] Setting up avm cli command & symlink to ansible binaries. ... ✅

🎆 🎇 🎆 🎇  Happy Ansibleing 🎆 🎇 🎆 🎇
```

</details><br>

`Note` - You need to fix some python `print` function syntax when in Python version `3.x`

> Install Ansible versions

```bash
$  avm install --version 2.9.6 --label 2.9.6
> You might be asked for your sudo password :
[19:19:07] Setting AVM version 'local' directory ... ✅
[19:19:07] Checking general system has minumum requirements ... ✅
[19:19:07] Ubuntu-20.04 apt package update (might take some time) ... ✅
⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
[19:19:07] Installing/upgrading virtualenv ... WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
✅
[19:19:08] Checking packages on your system has minumum requirements ... ✅
[19:19:08] 2.9.6 | Creating/updating venv for ansible ... ✅
[19:19:09] 2.9.6 | Running pip install ... ✅
[19:19:48] Setting up avm cli command & symlink to ansible binaries. ... ✅
[19:19:48] Setting up default version to 2.9.6 ... ✅

🎆 🎇 🎆 🎇  Happy Ansibleing 🎆 🎇 🎆 🎇
$  avm list
installed versions:  '2.9.6'

$  avm use 2.9.6
Updated to use 2.9.6

$  which ansible
/usr/local/bin/ansible

$  ls -al /usr/local/bin/ansible
lrwxrwxrwx 1 root root 27 Jun  6 19:19 /usr/local/bin/ansible -> /home1/jso/.avm/bin/ansible

$  ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home1/jso/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home1/jso/.avm/2.9.6/venv/lib/python3.8/site-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.8.5 (default, May 27 2021, 13:30:53) [GCC 9.3.0]
```


> 

```bash
$  which avm
/usr/local/bin/avm

$  ls -al /usr/local/bin/avm
lrwxrwxrwx 1 root root 19 Jun  6 22:00 /usr/local/bin/avm -> /home1/jso/.avm/avm

$  ls -l ~/.avm
total 28
drwxrwxr-x 3 jso jso 4096 Jun  6 19:19 2.9.6
-rwxr-xr-x 1 jso jso 5877 Jun  6 22:00 avm
drwxr-xr-x 2 jso jso 4096 Jun  6 21:51 bin
drwxrwxr-x 3 jso jso 4096 Jun  6 19:32 stable-2.10
drwxrwxr-x 3 jso jso 4096 Jun  6 19:29 stable-2.11
drwxrwxr-x 3 jso jso 4096 Jun  6 21:51 stable-2.9
$  avm
avm
Usage:
    avm  info
    avm  list
    avm  path <version>
    avm  use <version>
    avm  activate <version>
    avm  install (-v version) [-t type] [-l label] [-r requirements]

Options:
    info                        Show ansible version in use
    list                        List installed versions
    path <version>              Print binary path of specific version
    use  <version>              Use a <version> of ansible
    activate <version>          Activate virtualenv for <version>

$  avm info
current version: "stable-2.9"
```

## Run ansible using AWS SSM connection plugin

```bash
$  avm list
installed versions:  '2.9.6' 'stable-2.10' 'stable-2.11' 'stable-2.9'

$  avm use stable-2.10
Updated to use stable-2.10

$  avm info
current version: "stable-2.10"

$  ansible --version
ansible 2.10.10.post0
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home1/jso/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home1/jso/.avm/stable-2.10/venv/lib/python3.8/site-packages/ansible_base-2.10.10.post0-py3.8.egg/ansible
  executable location = /usr/local/bin/ansible
  python version = 3.8.5 (default, May 27 2021, 13:30:53) [GCC 9.3.0]
```

* Ansible inventory `aws-ec2.yml`

```yaml
# Execution: ansible-playbook linux.yaml -i aws-ec2.yml
# The playbook tasks will get executed on the instance ids returned from the dynamic inventory plugin using ssm connection.
# =====================================================
# aws_ec2.yml (Dynamic Inventory - Linux)
[host]
i-0d8105e90abc17605
```

* Ansible playbook `ssm.yml`

```yaml
- name: ssm connection testing
  hosts: all
  gather_facts: false
  vars:
    ansible_aws_ssm_access_key_id: "<KEY>"
    ansible_aws_ssm_secret_access_key: "<KEY>"
    ansible_aws_ssm_session_token: "<TOKEN>"
    ansible_aws_ssm_bucket_name: "<BUCKET>"
    ansible_aws_ssm_region: "<REGION>"
  tasks:
  - name: run hostname
    raw: hostname
    register: results

  - name: List registered results
    debug: msg="{{ results.stdout_lines }}"
```

> Run playbook

```bash
$  ansible-playbook -i aws-ec2.yml ssm.yml

PLAY [ssm connection testing] ****************************************************************************************************************************************

TASK [awscli] ********************************************************************************************************************************************************
fatal: [i-0d8105e90abc17605]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: kex_exchange_identification: Connection closed by remote host", "unreachable": true}

PLAY RECAP ***********************************************************************************************************************************************************
i-0d8105e90abc17605        : ok=0    changed=0    unreachable=1    failed=0    skipped=0    rescued=0    ignored=0
```

> Install and Run Ansible playbook with SSM connection plugin - 3 ways

0. Installation - `ansible-galaxy collection install community.aws`

	* `${HOME}/.ansible/collections/ansible_collections/community/aws/plugins/connection/aws_ssm.py`

1. Run playbook with connection type `community.aws.aws_ssm` or `aws_ssm`

```bash
$  ansible-playbook -i aws-ec2.yml -c community.aws.aws_ssm ssm.yml

PLAY [ssm connection testing] ****************************************************************************************************************************************

TASK [awscli] ********************************************************************************************************************************************************
changed: [i-0d8105e90abc17605]

TASK [List results] **************************************************************************************************************************************************
ok: [i-0d8105e90abc17605] => {
    "msg": [
        "ip-10-92-1-48",
        ""
    ]
}

PLAY RECAP ***********************************************************************************************************************************************************
i-0d8105e90abc17605        : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$  ansible-playbook -i aws-ec2.yml -c aws_ssm ssm.yml

PLAY [ssm connection testing] ****************************************************************************************************************************************

TASK [awscli] ********************************************************************************************************************************************************
changed: [i-0d8105e90abc17605]

TASK [List results] **************************************************************************************************************************************************
ok: [i-0d8105e90abc17605] => {
    "msg": [
        "ip-10-92-1-48",
        ""
    ]
}

PLAY RECAP ***********************************************************************************************************************************************************
i-0d8105e90abc17605        : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

2. Connection type per host declaring in `Ansible Inventory`

`aws-ssm.yml`

```yaml
# Execution: ansible-playbook linux.yaml -i aws-ec2.yml
# The playbook tasks will get executed on the instance ids returned from the dynamic inventory plugin using ssm connection.
# =====================================================
# aws_ec2.yml (Dynamic Inventory - Linux)
[host]
i-0d8105e90abc17605 ansible_connection=aws_ssm
```

```bash
$  ansible-playbook -i aws-ec2.yml ssm.yml

PLAY [ssm connection testing] ****************************************************************************************************************************************

TASK [awscli] ********************************************************************************************************************************************************
changed: [i-0d8105e90abc17605]

TASK [List results] **************************************************************************************************************************************************
ok: [i-0d8105e90abc17605] => {
    "msg": [
        "ip-10-92-1-48",
        ""
    ]
}

PLAY RECAP ***********************************************************************************************************************************************************
i-0d8105e90abc17605        : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

3. Connection type declaring in `Ansible playbook`

`ssm.yml`

```yaml
- name: ssm connection testing
  hosts: all
  gather_facts: false
  vars:
    ansible_connection: aws_ssm
    ansible_aws_ssm_access_key_id: "<KEY>"
    ansible_aws_ssm_secret_access_key: "<KEY>"
    ansible_aws_ssm_session_token: "<TOKEN>"
    ansible_aws_ssm_bucket_name: "<BUCKET>"
    ansible_aws_ssm_region: "<REGION>"
  tasks:
  - name: run hostname
    raw: hostname
    register: results

  - name: List registered results
    debug: msg="{{ results.stdout_lines }}"
```

```bash
$  ansible-playbook -i aws-ec2.yml ssm.yml

PLAY [ssm connection testing] ****************************************************************************************************************************************

TASK [Run command hostname] ******************************************************************************************************************************************
changed: [i-0d8105e90abc17605]

TASK [List results] **************************************************************************************************************************************************
ok: [i-0d8105e90abc17605] => {
    "msg": [
        "ip-10-92-1-48",
        ""
    ]
}

PLAY RECAP ***********************************************************************************************************************************************************
i-0d8105e90abc17605        : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

## Tips and Learnt

* `aws_ssm.py` patching

```diff
425,476d424
+         # No windows setup for now
+         if self.is_windows:
+             return
+
+         # *_complete variables are 3 valued:
+         #   - None: not started
+         #   - False: started
+         #   - True: complete
+
+         startup_complete = False
+         disable_echo_complete = None
+         disable_echo_cmd = to_bytes("stty -echo\n", errors="surrogate_or_strict")
+
+         disable_prompt_complete = None
+         end_mark = "".join(
+             [random.choice(string.ascii_letters) for i in xrange(self.MARK_LENGTH)]
+         )
+         disable_prompt_cmd = to_bytes(
+             "PS1='' ; printf '\\n%s\\n' '" + end_mark + "'\n",
+             errors="surrogate_or_strict",
+         )
+         disable_prompt_reply = re.compile(
+             r"\r\r\n" + re.escape(end_mark) + r"\r\r\n", re.MULTILINE
+         )
+
+         stdout = ""
+         # Custom command execution for when we're waiting for startup
+         stop_time = int(round(time.time())) + self.get_option("ssm_timeout")
+         while (not disable_prompt_complete) and (self._session.poll() is None):
+             remaining = stop_time - int(round(time.time()))
+             if remaining < 1:
+                 self._timeout = True
+                 display.vvvv(
+                     "PRE timeout stdout: {0}".format(to_bytes(stdout)), host=self.host
+                 )
+                 raise AnsibleConnectionFailure(
+                     "SSM start_session timeout on host: %s" % self.instance_id
+                 )
+             if self._poll_stdout.poll(1000):
+                 stdout += to_text(self._stdout.read(1024))
+                 display.vvvv(
+                     "PRE stdout line: {0}".format(to_bytes(stdout)), host=self.host
+                 )
+             else:
+                 display.vvvv("PRE remaining: {0}".format(remaining), host=self.host)
+
+             # wait til prompt is ready
+             if startup_complete is False:
+                 match = str(stdout).find("Starting session with SessionId")
+                 if match != -1:
+                     display.vvvv("PRE startup output received", host=self.host)
+                     startup_complete = True
478,512c426,429
+             # disable echo
+             if startup_complete and (disable_echo_complete is None):
+                 display.vvvv(
+                     "PRE Disabling Echo: {0}".format(disable_echo_cmd), host=self.host
+                 )
+                 self._session.stdin.write(disable_echo_cmd)
+                 disable_echo_complete = False
+
+             if disable_echo_complete is False:
+                 match = str(stdout).find("stty -echo")
+                 if match != -1:
+                     disable_echo_complete = True
+
+             # disable prompt
+             if disable_echo_complete and disable_prompt_complete is None:
+                 display.vvvv(
+                     "PRE Disabling Prompt: {0}".format(disable_prompt_cmd),
+                     host=self.host,
+                 )
+                 self._session.stdin.write(disable_prompt_cmd)
+                 disable_prompt_complete = False
+
+             if disable_prompt_complete is False:
+                 match = disable_prompt_reply.search(stdout)
+                 if match:
+                     stdout = stdout[match.end() :]
+                     disable_prompt_complete = True
+
+         if not disable_prompt_complete:
+             raise AnsibleConnectionFailure(
+                 "SSM process closed during _prepare_terminal on host: %s"
+                 % self.instance_id
+             )
+         else:
+             display.vvv("PRE Terminal configured", host=self.host)
---
-         if not self.is_windows:
-             cmd = "stty -echo\n" + "PS1=''\n"
-             cmd = to_bytes(cmd, errors='surrogate_or_strict')
-             self._session.stdin.write(cmd)
524,528c441
+             cmd = (
+                 f"printf '%s\\n' '{mark_start}';\n"
+                 f"echo | {cmd};\n"
+                 f"printf '\\n%s\\n%s\\n' \"$?\" '{mark_end}';\n"
+             )
---
-             cmd = "echo " + mark_start + "\n" + cmd + "\necho $'\\n'$?\n" + "echo " + mark_end + "\n"
```

* `avm` Error when installing `Ansible versions`

```bash
$  avm install --version stable-2.11 --label stable-2.11 --type git
> You might be asked for your sudo password :
[19:27:20] Setting AVM version 'local' directory ... ✅
[19:27:20] Checking general system has minumum requirements ... ✅
[19:27:21] Ubuntu-20.04 apt package update (might take some time) ... ✅
⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
[19:27:21] Installing/upgrading virtualenv ... WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
✅
[19:27:22] Checking packages on your system has minumum requirements ... ✅
  File "<string>", line 1
    import os; print os.environ.get("ANSIBLE_VERSIONS_0","")
                     ^
SyntaxError: invalid syntax

Setup failed 😢. You can try the folloiwng
1. Running the setup again.
2. Increase verbosity level by populating 'AVM_VERBOSE=v' supports '', 'v', 'vv' or 'vvv'
3. Open an issue and paste the out REMOVE any sensitve data
```

`Note` - `avm` are developed and coded with `Python 2.x`. 

> Workaround: Use Python 2.x to install Ansible versions

```bash
$  pyenv activate testing
pyenv-virtualenv: prompt changing will be removed from future release. configure `export PYENV_VIRTUALENV_DISABLE_PROMPT=1' to simulate the behavior.

testing $  avm install --version stable-2.11 --label stable-2.11 --type git
> You might be asked for your sudo password :
[19:27:54] Setting AVM version 'local' directory ... ✅
[19:27:54] Checking general system has minumum requirements ... ✅
[19:27:54] Ubuntu-20.04 apt package update (might take some time) ... ✅
⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
[19:27:54] Installing/upgrading virtualenv ... WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
✅
[19:27:55] Checking packages on your system has minumum requirements ... ✅
[19:27:55] stable-2.11 | Creating/updating venv for ansible ... ✅
[19:27:56] stable-2.11 | Running git clone/checkout ... ✅
[19:29:40] stable-2.11 | Running setup from git  ... ✅
[19:29:56] Setting up avm cli command & symlink to ansible binaries. ... ✅
[19:29:56] Setting up default version to stable-2.11 ... ✅

🎆 🎇 🎆 🎇  Happy Ansibleing 🎆 🎇 🎆 🎇

testing $  avm install --version stable-2.9 --label stable-2.9 --type git
> You might be asked for your sudo password :
[19:30:44] Setting AVM version 'local' directory ... ✅
[19:30:44] Checking general system has minumum requirements ... ✅
[19:30:44] Ubuntu-20.04 apt package update (might take some time) ... ✅
⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
[19:30:44] Installing/upgrading virtualenv ... WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
✅
[19:30:45] Checking packages on your system has minumum requirements ... ✅
[19:30:46] stable-2.9 | Creating/updating venv for ansible ... ✅
[19:30:46] stable-2.9 | Running git clone/checkout ... ✅
[19:30:51] stable-2.9 | Running setup from git  ... ✅
[19:31:26] Setting up avm cli command & symlink to ansible binaries. ... ✅
[19:31:26] Setting up default version to stable-2.9 ... ✅

🎆 🎇 🎆 🎇  Happy Ansibleing 🎆 🎇 🎆 🎇

$  avm install --version stable-2.10 --label stable-2.10 --type git
> You might be asked for your sudo password :
[19:31:49] Setting AVM version 'local' directory ... ✅
[19:31:49] Checking general system has minumum requirements ... ✅
[19:31:49] Ubuntu-20.04 apt package update (might take some time) ... ✅
⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
[19:31:49] Installing/upgrading virtualenv ... WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
✅
[19:31:50] Checking packages on your system has minumum requirements ... ✅
[19:31:50] stable-2.10 | Creating/updating venv for ansible ... ✅
[19:31:51] stable-2.10 | Running git clone/checkout ... ✅
[19:31:55] stable-2.10 | Running setup from git  ... ✅
[19:32:27] Setting up avm cli command & symlink to ansible binaries. ... ✅
[19:32:27] Setting up default version to stable-2.10 ... ✅

🎆 🎇 🎆 🎇  Happy Ansibleing 🎆 🎇 🎆 🎇

testing $  avm list
installed versions:  '2.9.6' 'stable-2.10' 'stable-2.11' 'stable-2.9'

testing $  avm use stable-2.11
Updated to use stable-2.11

testing $  ansible --version
ansible [core 2.11.1.post0]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home1/jso/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home1/jso/.avm/stable-2.11/venv/lib/python3.8/site-packages/ansible_core-2.11.1.post0-py3.8.egg/ansible
  ansible collection location = /home1/jso/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.8.5 (default, May 27 2021, 13:30:53) [GCC 9.3.0]
  jinja version = 3.0.1
  libyaml = True
```

> `Fix Solution` - Fix print function syntax to support your current python version run

* Dig out the problem script

	```bash
	$  ag --hidden "os.environ" | grep print
	.source_git/avm/avm/ansible_install.sh:4:  python -c "import os; print os.environ.get(\"${1}\",\"${2}\")"
	.source_git/ansible/contrib/inventory/apstra_aos.py:492:                self.aos_blueprint = os.environ['AOS_BLUEPRINT']
	.source_git/ansible/lib/ansible/modules/cloud/centurylink/clc_blueprint_package.py:254:        env = os.environ
	```

* Fix code syntax to fit into your python version

	<pre>
	.source_git/avm/avm/ansible_install.sh:4:  python -c "import os; <span style="color:blue">print(os.environ.get(\"${1}\",\"${2}\"))</span>"
	</pre>


* Next, you run `avm install` successfully without error

	```bash
	$  avm install -v stable-2.8 -l stable-2.8 -t git
	> You might be asked for your sudo password :
	[23:22:06] Setting AVM version 'local' directory ... ✅
	[23:22:06] Checking general system has minumum requirements ... ✅
	[23:22:07] Ubuntu-20.04 apt package update (might take some time) ... ✅
	⚠️  Your Ubuntu linux version was not tested. It might work ⚠️
	[23:22:07] Installing/upgrading virtualenv ... WARNING: Running pip as root will break packages and permissions. You should install packages reliably by using venv: https://pip.pypa.io/warnings/venv
	✅
	[23:22:08] Checking packages on your system has minumum requirements ... ✅
	[23:22:08] stable-2.8 | Creating/updating venv for ansible ... ✅
	[23:22:09] stable-2.8 | Running git clone/checkout ... ✅
	[23:22:14] stable-2.8 | Running setup from git  ... ✅
	[23:22:46] Setting up avm cli command & symlink to ansible binaries. ... ✅
	[23:22:46] Setting up default version to stable-2.8 ... ✅
	
	🎆 🎇 🎆 🎇  Happy Ansibleing 🎆 🎇 🎆 🎇
	 jso  ubunu2004  ~  .avm  .source_git  $  avm info
	current version: "stable-2.8"
	 jso  ubunu2004  ~  .avm  .source_git  $  avm list
	installed versions:  '2.9.6' 'stable-2.10' 'stable-2.11' 'stable-2.8' 'stable-2.9'
	```
