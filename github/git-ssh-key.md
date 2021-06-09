# Github - how to use various SSH keys to operate git commands

![git ssh key cover image](ssh-key-cover-1.jpg)

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [GIT_SSH_COMMAND environment variable](#git_ssh_command-environment-variable)
	- [Use Alias](#use-alias)
- [Use SSH configuration way to hook key to reach github repository](#use-ssh-configuration-way-to-hook-key-to-reach-github-repository)
- [Configuration core sshCommand](#configuration-core-sshcommand)
- [SSH configuration to reach multiple github accounts](#ssh-configuration-to-reach-multiple-github-accounts)
- [Use git configuration ssh identity to setup various repositories to use SSH keys](#use-git-configuration-ssh-identity-to-setup-various-repositories-to-use-ssh-keys)

<!-- vim-markdown-toc -->

## GIT_SSH_COMMAND environment variable

```bash
$  GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa" git pull
ERROR: Repository not found.
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

> You don't have permission to reach

> Ooh, you have another SSH key configured in this `github` account - JackySo-24x7classroom

* Check up your correct SSH key under `$HOME/.ssh`

	```bash
	$  ls -al ~/.ssh/*classroom*
	-rw------- 1 jso jso 2602 Mar 30 10:50 /home1/jso/.ssh/24x7classroom
	-rw-r--r-- 1 jso jso  567 Mar 30 10:50 /home1/jso/.ssh/24x7classroom.pub
	```

* Use `GIT_SSH_COMMAND` variable and associate correct SSH key to make it

	```bash
	$  GIT_SSH_COMMAND="ssh -i ~/.ssh/24x7classroom" git pull
	Already up to date.
	```

### Use Alias

> Hey, you can use standard Unix and Linux shell technique to alias

```bash
$  alias gitp
alias gitp='GIT_SSH_COMMAND='\''ssh -i ~/.ssh/24x7classroom -o IdentitiesOnly=yes'\'' git'
$  gitp pull
Already up to date.
```

## Use SSH configuration way to hook key to reach github repository

* Test before configuration

	```bash
	$  git pull
	ERROR: Repository not found.
	fatal: Could not read from remote repository.
	
	Please make sure you have the correct access rights
	and the repository exists.
	```

* Add `Host` section into your SSH configuration

	```
	Host github.com
	    HostName github.com
	    User git
	    IdentityFile ~/.ssh/24x7classroom
	    IdentitiesOnly yes
	```

* Test after configuration made

	```bash
	$  git pull
	Already up to date.
	```

## Configuration core sshCommand

> From Git version 2.10.0, you can configure this per repo or globally, so you don't have to set the environment variable any more

* Test before working this solution

	```bash
	$  git pull
	ERROR: Repository not found.
	fatal: Could not read from remote repository.
	
	Please make sure you have the correct access rights
	and the repository exists.
	```

* Check git client version
	```bash
	$  git version
	git version 2.25.1
	```

* Setup `core.sshCommand` into your git repository

	```bash
	$  git config --local core.sshCommand "ssh -i ~/.ssh/24x7classroom -F /dev/null"
	
	$  git config --local --get core.sshCommand
	ssh -i ~/.ssh/24x7classroom -F /dev/null
	
	$  git info | grep core
	core.repositoryformatversion=0
	core.filemode=true
	core.bare=false
	core.logallrefupdates=true
	core.sshcommand=ssh -i ~/.ssh/24x7classroom -F /dev/null
	```

* Test after configuration ran

	```bash
	$  git pull
	Already up to date.
	```

## SSH configuration to reach multiple github accounts

> Hey, you can configure various SSH reaching hosts with corresponding SSH key

* Setup SSH configuration in your work environment

	```
	Host github.com
	    HostName github.com
	    User git
	    IdentityFile ~/.ssh/id_rsa
	    IdentitiesOnly yes
	    
	Host 24x7classroom
	    HostName github.com
	    User git
	    IdentityFile ~/.ssh/24x7classroom
	    IdentitiesOnly yes
	```

* Test for github account #1 - `JackySo-MYOB`

	```bash
	$  git clone git@github.com:MYOB-Technology/t4-ops-ci.git
	Cloning into 't4-ops-ci'...
	remote: Enumerating objects: 252, done.
	remote: Counting objects: 100% (252/252), done.
	remote: Compressing objects: 100% (172/172), done.
	remote: Total 252 (delta 101), reused 200 (delta 54), pack-reused 0
	Receiving objects: 100% (252/252), 497.89 KiB | 252.00 KiB/s, done.
	Resolving deltas: 100% (101/101), done.
	
	$  git info 
	origin	git@github.com:MYOB-Technology/t4-ops-ci.git (fetch)
	origin	git@github.com:MYOB-Technology/t4-ops-ci.git (push)
	remote.origin.url=git@github.com:MYOB-Technology/t4-ops-ci.git
	
	$  git pull
	Already up to date.
	```

* Test for github account #2 - `JackySo-24x7classroom`

	```bash
	$  git clone git@github.com:JackySo-24x7classroom/useful-resources.git
	Cloning into 'useful-resources'...
	ERROR: Repository not found.
	fatal: Could not read from remote repository.
	
	Please make sure you have the correct access rights
	and the repository exists.
	```

* Use declared `Host` in SSH configuration to fetch from github account `JackySo-24x7classroom`

	```bash
	$  git clone git@24x7classroom:JackySo-24x7classroom/useful-resources.git
	Cloning into 'useful-resources'...
	remote: Enumerating objects: 999, done.
	remote: Counting objects: 100% (999/999), done.
	remote: Compressing objects: 100% (662/662), done.
	remote: Total 999 (delta 165), reused 980 (delta 146), pack-reused 0
	Receiving objects: 100% (999/999), 3.22 MiB | 1.40 MiB/s, done.
	Resolving deltas: 100% (165/165), done.
	$  cd useful-resources/
	$  git info | grep JackySo-24x7classroom/useful-resources.git
	origin	git@24x7classroom:JackySo-24x7classroom/useful-resources.git (fetch)
	origin	git@24x7classroom:JackySo-24x7classroom/useful-resources.git (push)
	remote.origin.url=git@24x7classroom:JackySo-24x7classroom/useful-resources.git
	$  git pull
	Already up to date.
	```

## Use git configuration ssh identity to setup various repositories to use SSH keys

* Setup ssh identity in repo

	```bash
	$  git info | grep identity
	
	$  git config --local ssh.identity ${HOME}/.ssh/24x7classroom
	
	$  git config --local --get ssh.identity
	/home1/jso/.ssh/24x7classroom
	
	$  git info | grep identity
	ssh.identity=/home1/jso/.ssh/24x7classroom
	```

* Test it without SSH key configured

	```
	$  git pull
	ERROR: Repository not found.
	fatal: Could not read from remote repository.
	
	Please make sure you have the correct access rights
	and the repository exists.
	```

* Test it with SSH key configured by `GIT_SSH_COMMAND`

	```bash
	$  GIT_SSH_COMMAND="ssh -i $(git config --local --get ssh.identity)" git pull
	Already up to date.
	```

`Note:` This solution is for multiple repositories those are using different SSH keys and no need to hard-code key into `GIT_SSH_COMMAND`. Instead, you simply to use single environment setting `IT_SSH_COMMAND="ssh -i $(git config --local --get ssh.identity)"` to make it. This technique give you imspiration to use git configuration parameter to automate your run routines


[Tips]: https://superuser.com/questions/232373/how-to-tell-git-which-private-key-to-use
