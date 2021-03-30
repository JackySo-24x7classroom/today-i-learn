# etcd-backup

**Script-based etcd backup**

It runs a recursive get on the etcd keys and outputs a properties-style
format of key/values.

    ps. empty directories are ignored

## Installation
---

```bash
curl https://raw.githubusercontent.com/harbur/etcd-backup/master/etcd-
backup.sh > etcd-backup.sh
curl https://raw.githubusercontent.com/harbur/etcd-backup/master/etcd-
restore.sh > etcd-restore.sh
chmod +x etcd-backup.sh etcd-restore.sh
```

## Backup routine
---
```bash
#!/bin/bash

KEYS=$(etcdctl ls --recursive -p)
KEYS+=$(etcdctl ls --recursive -p _coreos.com)

for KEY in $KEYS; do
  # Skip etcd directories
  if [ "${KEY: -1}" == "/" ]; then continue; fi

  echo $KEY=$(etcdctl get $KEY)
done
```

## Restore routine
---
```bash
#!/bin/bash

while read line; do
  KEY=$(echo $line| awk -F'=' '{print $1}')
  VALUE=$(echo $line| awk -F'=' '{print $2}')

  echo -n $KEY=
  etcdctl set $KEY "$VALUE"
done < "${1:-/dev/stdin}"
```

## Usage
---

### In order to backup your etcd key/values:

```bash
./etcd-backup.sh > etcd.properties
```

### In order to restore your etcd key/values:

```bash
./etcd-restore.sh etcd.properties
```

### or you can pass them using pipeline:

```bash
cat etcd.properties | ./etcd-restore.sh
```

## Credits
---
* github/harbur
