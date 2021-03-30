# Use private key to run git command

**Requirements List**
- [x] Linux/Unix
  - [x] Shell
- [x] Utility
  - [x] git version 2.3.0+

### Usage

`GIT_SSH_COMMAND='ssh -i private_key_file -o IdentitiesOnly=yes'` git ....

#### Example

```bash
$  git --version
git version 2.25.1

$  GIT_SSH_COMMAND='ssh -i ~/.ssh/example -o IdentitiesOnly=yes'

$  git clone git@github.com:JackySo-example/today-i-learn.git
Cloning into 'today-i-learn'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 3 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.
```
