# Setup shell command alias

**Requirements List**
- [x] Environment
  - [x] Unix/Linux
  - [x] Shell
- [x] Configuration
  - [x] .bashrc

### Usage

Add `alias gitp="GIT_SSH_COMMAND='ssh -i private_key_file -o IdentitiesOnly=yes' git"` into $(HOME)/.bashrc

### Example

```bash
$  alias gitp
alias gitp='GIT_SSH_COMMAND='\''ssh -i ~/.ssh/example -o IdentitiesOnly=yes'\'' git'

$  gitp status
On branch main
Your branch is ahead of 'origin/main' by 1 commit.
  (use "git push" to publish your local commits)
nothing to commit, working tree clean

$  gitp push
Enumerating objects: 10, done.
Counting objects: 100% (10/10), done.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (8/8), 3.30 KiB | 1.10 MiB/s, done.
Total 8 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To github.com:JackySo-24x7classroom/today-i-learn.git
   78b74c3..695e709  main -> main
```
