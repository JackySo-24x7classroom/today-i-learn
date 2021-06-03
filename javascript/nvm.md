# Node version manager

> Initial `nvm` journey

```bash
$  make nvm
No nvm installed in /home1/jso/.pyenv/plugins/pyenv-virtualenv/shims:/home1/jso/.pyenv/shims:/home1/jso/.pyenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:.:/home1/jso:/usr/local/go/bin:/home1/jso/.local/bin, Installing now...
=> Downloading nvm from git to '/home1/jso/.nvm'
=> Cloning into '/home1/jso/.nvm'...
remote: Enumerating objects: 347, done.
remote: Counting objects: 100% (347/347), done.
remote: Compressing objects: 100% (295/295), done.
remote: Total 347 (delta 39), reused 163 (delta 27), pack-reused 0
Receiving objects: 100% (347/347), 203.77 KiB | 3.00 MiB/s, done.
Resolving deltas: 100% (39/39), done.
* (HEAD detached at FETCH_HEAD)
  master
=> Compressing and cleaning up git repository

=> Appending nvm source string to /home1/jso/.bashrc
=> Appending bash_completion source string to /home1/jso/.bashrc
=> You currently have modules installed globally with `npm`. These will no
=> longer be linked to the active version of Node when you install a new node
=> with `nvm`; and they may (depending on how you construct your `$PATH`)
=> override the binaries of modules installed with `nvm`:

/usr/local/lib
+-- @mhlabs/cfn-diagram@1.1.24
+-- actions-cli@0.0.36
+-- aws-cdk@1.63.0
+-- console-stamp@3.0.2
+-- pageres-cli@6.0.0
+-- pen@2.2.0
+-- puppeteer@8.0.0
+-- serverless@2.30.3
`-- tldr@3.3.7
=> If you wish to uninstall them at a later point (or re-install them under your
=> `nvm` Nodes), you can remove them from the system Node as follows:

     $ nvm use system
     $ npm uninstall -g a_module

=> Close and reopen your terminal to start using nvm or run the following to use it now:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

$  which nvm

$  source ~/.basrc
$  which nvm

$  command -v nvm
nvm

$  nvm ls
->       system
iojs -> N/A (default)
node -> stable (-> N/A) (default)
unstable -> N/A (default)

$  nvm ls-remote
        v0.1.14
        v0.1.15
        v0.1.16
        v0.1.17
        v0.1.18
        v0.1.19
        v0.1.20
        v0.1.21
        v0.1.22
        v0.1.23
        v0.1.24
        v0.1.25
        v0.1.26
        v0.1.27
        v0.1.28
        v0.1.29
        v0.1.30
        v0.1.31
        v0.1.32
        v0.1.33
        v0.1.90
        v0.1.91
        v0.1.92
        v0.1.93
        v0.1.94
        v0.1.95
        v0.1.96
        v0.1.97
        v0.1.98
        v0.1.99
       v0.1.100
       v0.1.101
       v0.1.102
       v0.1.103
       v0.1.104
         v0.2.0
         v0.2.1
         v0.2.2
         v0.2.3
         v0.2.4
         v0.2.5
         v0.2.6
         v0.3.0
         v0.3.1
         v0.3.2
         v0.3.3
         v0.3.4
         v0.3.5
         v0.3.6
         v0.3.7
         v0.3.8
         v0.4.0
         v0.4.1
         v0.4.2
         v0.4.3
         v0.4.4
         v0.4.5
         v0.4.6
         v0.4.7
         v0.4.8
         v0.4.9
        v0.4.10
        v0.4.11
        v0.4.12
         v0.5.0
         v0.5.1
         v0.5.2
         v0.5.3
         v0.5.4
         v0.5.5
         v0.5.6
         v0.5.7
         v0.5.8
         v0.5.9
        v0.5.10
         v0.6.0
         v0.6.1
         v0.6.2
         v0.6.3
         v0.6.4
         v0.6.5
         v0.6.6
         v0.6.7
         v0.6.8
         v0.6.9
        v0.6.10
        v0.6.11
        v0.6.12
        v0.6.13
        v0.6.14
        v0.6.15
        v0.6.16
        v0.6.17
        v0.6.18
        v0.6.19
        v0.6.20
        v0.6.21
         v0.7.0
         v0.7.1
         v0.7.2
         v0.7.3
         v0.7.4
         v0.7.5
         v0.7.6
         v0.7.7
         v0.7.8
         v0.7.9
        v0.7.10
        v0.7.11
        v0.7.12
         v0.8.0
         v0.8.1
         v0.8.2
         v0.8.3
         v0.8.4
         v0.8.5
         v0.8.6
         v0.8.7
         v0.8.8
         v0.8.9
        v0.8.10
        v0.8.11
        v0.8.12
        v0.8.13
        v0.8.14
        v0.8.15
        v0.8.16
        v0.8.17
        v0.8.18
        v0.8.19
        v0.8.20
        v0.8.21
        v0.8.22
        v0.8.23
        v0.8.24
        v0.8.25
        v0.8.26
        v0.8.27
        v0.8.28
         v0.9.0
         v0.9.1
         v0.9.2
         v0.9.3
         v0.9.4
         v0.9.5
         v0.9.6
         v0.9.7
         v0.9.8
         v0.9.9
        v0.9.10
        v0.9.11
        v0.9.12
        v0.10.0
        v0.10.1
        v0.10.2
        v0.10.3
        v0.10.4
        v0.10.5
        v0.10.6
        v0.10.7
        v0.10.8
        v0.10.9
       v0.10.10
       v0.10.11
       v0.10.12
       v0.10.13
       v0.10.14
       v0.10.15
       v0.10.16
       v0.10.17
       v0.10.18
       v0.10.19
       v0.10.20
       v0.10.21
       v0.10.22
       v0.10.23
       v0.10.24
       v0.10.25
       v0.10.26
       v0.10.27
       v0.10.28
       v0.10.29
       v0.10.30
       v0.10.31
       v0.10.32
       v0.10.33
       v0.10.34
       v0.10.35
       v0.10.36
       v0.10.37
       v0.10.38
       v0.10.39
       v0.10.40
       v0.10.41
       v0.10.42
       v0.10.43
       v0.10.44
       v0.10.45
       v0.10.46
       v0.10.47
       v0.10.48
        v0.11.0
        v0.11.1
        v0.11.2
        v0.11.3
        v0.11.4
        v0.11.5
        v0.11.6
        v0.11.7
        v0.11.8
        v0.11.9
       v0.11.10
       v0.11.11
       v0.11.12
       v0.11.13
       v0.11.14
       v0.11.15
       v0.11.16
        v0.12.0
        v0.12.1
        v0.12.2
        v0.12.3
        v0.12.4
        v0.12.5
        v0.12.6
        v0.12.7
        v0.12.8
        v0.12.9
       v0.12.10
       v0.12.11
       v0.12.12
       v0.12.13
       v0.12.14
       v0.12.15
       v0.12.16
       v0.12.17
       v0.12.18
    iojs-v1.0.0
    iojs-v1.0.1
    iojs-v1.0.2
    iojs-v1.0.3
    iojs-v1.0.4
    iojs-v1.1.0
    iojs-v1.2.0
    iojs-v1.3.0
    iojs-v1.4.1
    iojs-v1.4.2
    iojs-v1.4.3
    iojs-v1.5.0
    iojs-v1.5.1
    iojs-v1.6.0
    iojs-v1.6.1
    iojs-v1.6.2
    iojs-v1.6.3
    iojs-v1.6.4
    iojs-v1.7.1
    iojs-v1.8.1
    iojs-v1.8.2
    iojs-v1.8.3
    iojs-v1.8.4
    iojs-v2.0.0
    iojs-v2.0.1
    iojs-v2.0.2
    iojs-v2.1.0
    iojs-v2.2.0
    iojs-v2.2.1
    iojs-v2.3.0
    iojs-v2.3.1
    iojs-v2.3.2
    iojs-v2.3.3
    iojs-v2.3.4
    iojs-v2.4.0
    iojs-v2.5.0
    iojs-v3.0.0
    iojs-v3.1.0
    iojs-v3.2.0
    iojs-v3.3.0
    iojs-v3.3.1
         v4.0.0
         v4.1.0
         v4.1.1
         v4.1.2
         v4.2.0   (LTS: Argon)
         v4.2.1   (LTS: Argon)
         v4.2.2   (LTS: Argon)
         v4.2.3   (LTS: Argon)
         v4.2.4   (LTS: Argon)
         v4.2.5   (LTS: Argon)
         v4.2.6   (LTS: Argon)
         v4.3.0   (LTS: Argon)
         v4.3.1   (LTS: Argon)
         v4.3.2   (LTS: Argon)
         v4.4.0   (LTS: Argon)
         v4.4.1   (LTS: Argon)
         v4.4.2   (LTS: Argon)
         v4.4.3   (LTS: Argon)
         v4.4.4   (LTS: Argon)
         v4.4.5   (LTS: Argon)
         v4.4.6   (LTS: Argon)
         v4.4.7   (LTS: Argon)
         v4.5.0   (LTS: Argon)
         v4.6.0   (LTS: Argon)
         v4.6.1   (LTS: Argon)
         v4.6.2   (LTS: Argon)
         v4.7.0   (LTS: Argon)
         v4.7.1   (LTS: Argon)
         v4.7.2   (LTS: Argon)
         v4.7.3   (LTS: Argon)
         v4.8.0   (LTS: Argon)
         v4.8.1   (LTS: Argon)
         v4.8.2   (LTS: Argon)
         v4.8.3   (LTS: Argon)
         v4.8.4   (LTS: Argon)
         v4.8.5   (LTS: Argon)
         v4.8.6   (LTS: Argon)
         v4.8.7   (LTS: Argon)
         v4.9.0   (LTS: Argon)
         v4.9.1   (Latest LTS: Argon)
         v5.0.0
         v5.1.0
         v5.1.1
         v5.2.0
         v5.3.0
         v5.4.0
         v5.4.1
         v5.5.0
         v5.6.0
         v5.7.0
         v5.7.1
         v5.8.0
         v5.9.0
         v5.9.1
        v5.10.0
        v5.10.1
        v5.11.0
        v5.11.1
        v5.12.0
         v6.0.0
         v6.1.0
         v6.2.0
         v6.2.1
         v6.2.2
         v6.3.0
         v6.3.1
         v6.4.0
         v6.5.0
         v6.6.0
         v6.7.0
         v6.8.0
         v6.8.1
         v6.9.0   (LTS: Boron)
         v6.9.1   (LTS: Boron)
         v6.9.2   (LTS: Boron)
         v6.9.3   (LTS: Boron)
         v6.9.4   (LTS: Boron)
         v6.9.5   (LTS: Boron)
        v6.10.0   (LTS: Boron)
        v6.10.1   (LTS: Boron)
        v6.10.2   (LTS: Boron)
        v6.10.3   (LTS: Boron)
        v6.11.0   (LTS: Boron)
        v6.11.1   (LTS: Boron)
        v6.11.2   (LTS: Boron)
        v6.11.3   (LTS: Boron)
        v6.11.4   (LTS: Boron)
        v6.11.5   (LTS: Boron)
        v6.12.0   (LTS: Boron)
        v6.12.1   (LTS: Boron)
        v6.12.2   (LTS: Boron)
        v6.12.3   (LTS: Boron)
        v6.13.0   (LTS: Boron)
        v6.13.1   (LTS: Boron)
        v6.14.0   (LTS: Boron)
        v6.14.1   (LTS: Boron)
        v6.14.2   (LTS: Boron)
        v6.14.3   (LTS: Boron)
        v6.14.4   (LTS: Boron)
        v6.15.0   (LTS: Boron)
        v6.15.1   (LTS: Boron)
        v6.16.0   (LTS: Boron)
        v6.17.0   (LTS: Boron)
        v6.17.1   (Latest LTS: Boron)
         v7.0.0
         v7.1.0
         v7.2.0
         v7.2.1
         v7.3.0
         v7.4.0
         v7.5.0
         v7.6.0
         v7.7.0
         v7.7.1
         v7.7.2
         v7.7.3
         v7.7.4
         v7.8.0
         v7.9.0
        v7.10.0
        v7.10.1
         v8.0.0
         v8.1.0
         v8.1.1
         v8.1.2
         v8.1.3
         v8.1.4
         v8.2.0
         v8.2.1
         v8.3.0
         v8.4.0
         v8.5.0
         v8.6.0
         v8.7.0
         v8.8.0
         v8.8.1
         v8.9.0   (LTS: Carbon)
         v8.9.1   (LTS: Carbon)
         v8.9.2   (LTS: Carbon)
         v8.9.3   (LTS: Carbon)
         v8.9.4   (LTS: Carbon)
        v8.10.0   (LTS: Carbon)
        v8.11.0   (LTS: Carbon)
        v8.11.1   (LTS: Carbon)
        v8.11.2   (LTS: Carbon)
        v8.11.3   (LTS: Carbon)
        v8.11.4   (LTS: Carbon)
        v8.12.0   (LTS: Carbon)
        v8.13.0   (LTS: Carbon)
        v8.14.0   (LTS: Carbon)
        v8.14.1   (LTS: Carbon)
        v8.15.0   (LTS: Carbon)
        v8.15.1   (LTS: Carbon)
        v8.16.0   (LTS: Carbon)
        v8.16.1   (LTS: Carbon)
        v8.16.2   (LTS: Carbon)
        v8.17.0   (Latest LTS: Carbon)
         v9.0.0
         v9.1.0
         v9.2.0
         v9.2.1
         v9.3.0
         v9.4.0
         v9.5.0
         v9.6.0
         v9.6.1
         v9.7.0
         v9.7.1
         v9.8.0
         v9.9.0
        v9.10.0
        v9.10.1
        v9.11.0
        v9.11.1
        v9.11.2
        v10.0.0
        v10.1.0
        v10.2.0
        v10.2.1
        v10.3.0
        v10.4.0
        v10.4.1
        v10.5.0
        v10.6.0
        v10.7.0
        v10.8.0
        v10.9.0
       v10.10.0
       v10.11.0
       v10.12.0
       v10.13.0   (LTS: Dubnium)
       v10.14.0   (LTS: Dubnium)
       v10.14.1   (LTS: Dubnium)
       v10.14.2   (LTS: Dubnium)
       v10.15.0   (LTS: Dubnium)
       v10.15.1   (LTS: Dubnium)
       v10.15.2   (LTS: Dubnium)
       v10.15.3   (LTS: Dubnium)
       v10.16.0   (LTS: Dubnium)
       v10.16.1   (LTS: Dubnium)
       v10.16.2   (LTS: Dubnium)
       v10.16.3   (LTS: Dubnium)
       v10.17.0   (LTS: Dubnium)
       v10.18.0   (LTS: Dubnium)
       v10.18.1   (LTS: Dubnium)
       v10.19.0   (LTS: Dubnium)
       v10.20.0   (LTS: Dubnium)
       v10.20.1   (LTS: Dubnium)
       v10.21.0   (LTS: Dubnium)
       v10.22.0   (LTS: Dubnium)
       v10.22.1   (LTS: Dubnium)
       v10.23.0   (LTS: Dubnium)
       v10.23.1   (LTS: Dubnium)
       v10.23.2   (LTS: Dubnium)
       v10.23.3   (LTS: Dubnium)
       v10.24.0   (LTS: Dubnium)
       v10.24.1   (Latest LTS: Dubnium)
        v11.0.0
        v11.1.0
        v11.2.0
        v11.3.0
        v11.4.0
        v11.5.0
        v11.6.0
        v11.7.0
        v11.8.0
        v11.9.0
       v11.10.0
       v11.10.1
       v11.11.0
       v11.12.0
       v11.13.0
       v11.14.0
       v11.15.0
        v12.0.0
        v12.1.0
        v12.2.0
        v12.3.0
        v12.3.1
        v12.4.0
        v12.5.0
        v12.6.0
        v12.7.0
        v12.8.0
        v12.8.1
        v12.9.0
        v12.9.1
       v12.10.0
       v12.11.0
       v12.11.1
       v12.12.0
       v12.13.0   (LTS: Erbium)
       v12.13.1   (LTS: Erbium)
       v12.14.0   (LTS: Erbium)
       v12.14.1   (LTS: Erbium)
       v12.15.0   (LTS: Erbium)
       v12.16.0   (LTS: Erbium)
       v12.16.1   (LTS: Erbium)
       v12.16.2   (LTS: Erbium)
       v12.16.3   (LTS: Erbium)
       v12.17.0   (LTS: Erbium)
       v12.18.0   (LTS: Erbium)
       v12.18.1   (LTS: Erbium)
       v12.18.2   (LTS: Erbium)
       v12.18.3   (LTS: Erbium)
       v12.18.4   (LTS: Erbium)
       v12.19.0   (LTS: Erbium)
       v12.19.1   (LTS: Erbium)
       v12.20.0   (LTS: Erbium)
       v12.20.1   (LTS: Erbium)
       v12.20.2   (LTS: Erbium)
       v12.21.0   (LTS: Erbium)
       v12.22.0   (LTS: Erbium)
       v12.22.1   (Latest LTS: Erbium)
        v13.0.0
        v13.0.1
        v13.1.0
        v13.2.0
        v13.3.0
        v13.4.0
        v13.5.0
        v13.6.0
        v13.7.0
        v13.8.0
        v13.9.0
       v13.10.0
       v13.10.1
       v13.11.0
       v13.12.0
       v13.13.0
       v13.14.0
        v14.0.0
        v14.1.0
        v14.2.0
        v14.3.0
        v14.4.0
        v14.5.0
        v14.6.0
        v14.7.0
        v14.8.0
        v14.9.0
       v14.10.0
       v14.10.1
       v14.11.0
       v14.12.0
       v14.13.0
       v14.13.1
       v14.14.0
       v14.15.0   (LTS: Fermium)
       v14.15.1   (LTS: Fermium)
       v14.15.2   (LTS: Fermium)
       v14.15.3   (LTS: Fermium)
       v14.15.4   (LTS: Fermium)
       v14.15.5   (LTS: Fermium)
       v14.16.0   (LTS: Fermium)
       v14.16.1   (LTS: Fermium)
       v14.17.0   (Latest LTS: Fermium)
        v15.0.0
        v15.0.1
        v15.1.0
        v15.2.0
        v15.2.1
        v15.3.0
        v15.4.0
        v15.5.0
        v15.5.1
        v15.6.0
        v15.7.0
        v15.8.0
        v15.9.0
       v15.10.0
       v15.11.0
       v15.12.0
       v15.13.0
       v15.14.0
        v16.0.0
        v16.1.0
        v16.2.0

$  node --version
v10.19.0

$  nvm use node
N/A: version "node -> N/A" is not yet installed.

You need to run "nvm install node" to install it before using it.

$  nvm ls
->       system
iojs -> N/A (default)
node -> stable (-> N/A) (default)
unstable -> N/A (default)
lts/* -> lts/fermium (-> N/A)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1 (-> N/A)
lts/erbium -> v12.22.1 (-> N/A)
lts/fermium -> v14.17.0 (-> N/A)

$  nvm use node
N/A: version "node -> N/A" is not yet installed.

You need to run "nvm install node" to install it before using it.

$  node --version
v10.19.0

$  nvm install node
Downloading and installing node v16.2.0...
Downloading https://nodejs.org/dist/v16.2.0/node-v16.2.0-linux-x64.tar.xz...
############################################################################################################################################################### 100.0%
Computing checksum with sha256sum
Checksums matched!
Now using node v16.2.0 (npm v7.13.0)
Creating default alias: default -> node (-> v16.2.0)

$  node --version
v16.2.0

$  nvm use node
Now using node v16.2.0 (npm v7.13.0)
$  node --version
v16.2.0

$  nvm ls
->      v16.2.0
         system
default -> node (-> v16.2.0)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v16.2.0) (default)
stable -> 16.2 (-> v16.2.0) (default)
lts/* -> lts/fermium (-> N/A)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1 (-> N/A)
lts/erbium -> v12.22.1 (-> N/A)
lts/fermium -> v14.17.0 (-> N/A)

$  nvm install v10.19.0
Downloading and installing node v10.19.0...
Downloading https://nodejs.org/dist/v10.19.0/node-v10.19.0-linux-x64.tar.xz...
############################################################################################################################################################### 100.0%
Computing checksum with sha256sum
Checksums matched!
Now using node v10.19.0 (npm v6.13.4)

$  nvm ls
->     v10.19.0
        v16.2.0
         system
default -> node (-> v16.2.0)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v16.2.0) (default)
stable -> 16.2 (-> v16.2.0) (default)
lts/* -> lts/fermium (-> N/A)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1 (-> N/A)
lts/erbium -> v12.22.1 (-> N/A)
lts/fermium -> v14.17.0 (-> N/A)

$  nvm use node
Now using node v16.2.0 (npm v7.13.0)

$  node --version
v16.2.0

$  nvm use 10
Now using node v10.19.0 (npm v6.13.4)

$  node --version
v10.19.0
```

> `nvm` management to debug version related issue

```bash
# List installed nodejs versions and current one
$  nvm ls
        v9.11.2
       v10.19.0
        v12.7.0
->      v16.2.0
         system
default -> node (-> v16.2.0)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v16.2.0) (default)
stable -> 16.2 (-> v16.2.0) (default)
lts/* -> lts/fermium (-> N/A)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1 (-> N/A)
lts/erbium -> v12.22.1 (-> N/A)
lts/fermium -> v14.17.0 (-> N/A)

# Use version 10
$  nvm use 10
Now using node v10.19.0 (npm v6.13.4)

$  node --version
v10.19.0

$  node url-explorer.js
URL is: https://www.someserver.com/not/a/path?param1=value1&param2=value2
Hostname: www.someserver.com
Path: /not/a/path
Query string is: ?param1=value1&param2=value2
Query parameters:
	- param1 = value1
	- param2 = value2

# Try version 9
$  nvm use 9
Now using node v9.11.2 (npm v5.6.0)

$  node --version
v9.11.2

$  node url-explorer.js
/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/projects-staging/pirple-projects/staging/nodejs/url-explorer.js:10
const url = new URL('https://www.someserver.com/not/a/path?param1=value1&param2=value2');
            ^

ReferenceError: URL is not defined
    at Object.<anonymous> (/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/projects-staging/pirple-projects/staging/nodejs/url-explorer.js:10:13)
    at Module._compile (internal/modules/cjs/loader.js:654:30)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:665:10)
    at Module.load (internal/modules/cjs/loader.js:566:32)
    at tryModuleLoad (internal/modules/cjs/loader.js:506:12)
    at Function.Module._load (internal/modules/cjs/loader.js:498:3)
    at Function.Module.runMain (internal/modules/cjs/loader.js:695:10)
    at startup (internal/bootstrap/node.js:201:19)
    at bootstrapNodeJSCore (internal/bootstrap/node.js:516:3)

# Retry version 10
$  nvm use 10
Now using node v10.19.0 (npm v6.13.4)

$  node url-explorer.js
URL is: https://www.someserver.com/not/a/path?param1=value1&param2=value2
Hostname: www.someserver.com
Path: /not/a/path
Query string is: ?param1=value1&param2=value2
Query parameters:
	- param1 = value1
	- param2 = value2

# Try latest version
$  nvm ls
        v9.11.2
       v10.19.0
->      v12.7.0
        v16.2.0
         system
default -> node (-> v16.2.0)
iojs -> N/A (default)
unstable -> N/A (default)
node -> stable (-> v16.2.0) (default)
stable -> 16.2 (-> v16.2.0) (default)
lts/* -> lts/fermium (-> N/A)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.17.1 (-> N/A)
lts/carbon -> v8.17.0 (-> N/A)
lts/dubnium -> v10.24.1 (-> N/A)
lts/erbium -> v12.22.1 (-> N/A)
lts/fermium -> v14.17.0 (-> N/A)

$  nvm use default
Now using node v16.2.0 (npm v7.13.0)

$  node --version
v16.2.0

$  node url-explorer.js
URL is: https://www.someserver.com/not/a/path?param1=value1&param2=value2
Hostname: www.someserver.com
Path: /not/a/path
Query string is: ?param1=value1&param2=value2
Query parameters:
	- param1 = value1
	- param2 = value2
```

> `url-explorer.js` code

```javascript

/*
 * Explore URL
 *
 */

// version < 10 
// var uri = require('url');
// var url = uri.parse('https://www.packt.com/not/a/path?param1=value1&param2=value2');
// version > 10 - url is global
const url = new URL('https://www.someserver.com/not/a/path?param1=value1&param2=value2');

console.log(`URL is: ${url.href}`);
console.log(`Hostname: ${url.hostname}`);
console.log(`Path: ${url.pathname}`);
console.log(`Query string is: ${url.search}`);
console.log(`Query parameters:`)
Array.from(url.searchParams.entries())
	.forEach((entry) => console.log(`\t- ${entry[0]} = ${entry[1]}`));
```

[nvm github]: https://github.com/nvm-sh/nvm
