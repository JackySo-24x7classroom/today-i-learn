# Useful dependency management tips for Golang

<!-- vim-markdown-toc GFM -->

- [List](#list)
- [Download](#download)
- [Install](#install)
- [Cleanup](#cleanup)
- [Update](#update)

<!-- vim-markdown-toc -->
## List

> `Listing dependencies`

```bash
$ go list -m all
example.com/lab/greeter-server
github.com/gorilla/mux v1.8.0
github.com/lib/pq v1.10.0

$ go list -m -versions github.com/gorilla/mux
github.com/gorilla/mux v1.2.0 v1.3.0 v1.4.0 v1.5.0 v1.6.0 v1.6.1 v1.6.2 v1.7.0 v1.7.1 v1.7.2 v1.7.3 v1.7.4 v1.8.0

$ go list -m -versions github.com/lib/pq
github.com/lib/pq v1.0.0 v1.1.0 v1.1.1 v1.2.0 v1.3.0 v1.4.0 v1.5.0 v1.5.1 v1.5.2 v1.6.0 v1.7.0 v1.7.1 v1.8.0 v1.9.0 v1.10.0
```

> `List imported packages`

```bash
$ go list -f '{{ join .Imports "\n" }}'

database/sql
encoding/json
fmt
github.com/gorilla/mux
github.com/lib/pq
log
net/http
time
```

> `List all subdependencies`

```bash
$ go list -f '{{ join .Deps "\n" }}'
```

<details><summary><i>Show command output</i></summary>

```
bufio
bytes
compress/flate
compress/gzip
container/list
context
crypto
crypto/aes
crypto/cipher
crypto/des
crypto/dsa
crypto/ecdsa
crypto/ed25519
crypto/ed25519/internal/edwards25519
crypto/elliptic
crypto/hmac
crypto/internal/randutil
crypto/internal/subtle
crypto/md5
crypto/rand
crypto/rc4
crypto/rsa
crypto/sha1
crypto/sha256
crypto/sha512
crypto/subtle
crypto/tls
crypto/x509
crypto/x509/pkix
database/sql
database/sql/driver
encoding
encoding/asn1
encoding/base64
encoding/binary
encoding/hex
encoding/json
encoding/pem
errors
fmt
github.com/gorilla/mux
github.com/lib/pq
github.com/lib/pq/oid
github.com/lib/pq/scram
hash
hash/crc32
internal/bytealg
internal/cpu
internal/fmtsort
internal/nettrace
internal/oserror
internal/poll
internal/race
internal/reflectlite
internal/singleflight
internal/syscall/unix
internal/testlog
io
io/ioutil
log
math
math/big
math/bits
math/rand
mime
mime/multipart
mime/quotedprintable
net
net/http
net/http/httptrace
net/http/internal
net/textproto
net/url
os
os/user
path
path/filepath
reflect
regexp
regexp/syntax
runtime
runtime/cgo
runtime/internal/atomic
runtime/internal/math
runtime/internal/sys
sort
strconv
strings
sync
sync/atomic
syscall
time
unicode
unicode/utf16
unicode/utf8
unsafe
vendor/golang.org/x/crypto/chacha20
vendor/golang.org/x/crypto/chacha20poly1305
vendor/golang.org/x/crypto/cryptobyte
vendor/golang.org/x/crypto/cryptobyte/asn1
vendor/golang.org/x/crypto/curve25519
vendor/golang.org/x/crypto/hkdf
vendor/golang.org/x/crypto/internal/subtle
vendor/golang.org/x/crypto/poly1305
vendor/golang.org/x/net/dns/dnsmessage
vendor/golang.org/x/net/http/httpguts
vendor/golang.org/x/net/http/httpproxy
vendor/golang.org/x/net/http2/hpack
vendor/golang.org/x/net/idna
vendor/golang.org/x/sys/cpu
vendor/golang.org/x/text/secure/bidirule
vendor/golang.org/x/text/transform
vendor/golang.org/x/text/unicode/bidi
vendor/golang.org/x/text/unicode/norm
```

</details><br>

## Download

> `Download package`

```bash
$ go get -u github.com/gorilla/mux
```

> `Download all packages`

```bash
go get -u ./...
```

## Install

> `Install dependencies`

```bash
$ go get github.com/lib/pq

$ go get github.com/lib/pq@master

$ go get github.com/lib/pq@v1.8.0
```
> Authenticating dependencies
> Installing a dependency will also generate a go.sum file in your project’s root. While it’s not a lock file, like package-lock.json in Node.js, the file comes with the expected cryptographic hashes of the content of particular module versions. 

> The go.sum file acts as a dependency checker that authenticates your modules against unexpected or malicious changes that may break your entire codebase. Also, if you stop using a module, the recorded checksum information will allow you to resume using it as-is in the future.

## Cleanup

> `Remove unused dependencies

```bash
$ go mod tidy
```

## Update

> `Update to latest dependency version
> you may update a dependency and all its transitive dependencies to the latest version by running the following command (the -u flag implies that the latest minor or patch releases are to be used):

```bash
$ go get -u github.com/lib/pq
```

[Golang dependency management]: https://www.whitesourcesoftware.com/free-developer-tools/blog/golang-dependency-management/
