# Docker scan images

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Usages and examples](#usages-and-examples)
	- [Scan images](#scan-images)

<!-- vim-markdown-toc -->

## Installation

* Source [github](https://github.com/docker/scan-cli-plugin)

* Install via GNU make

```bash
$  make -f Makefile-tools

 Choose a command run:

docker-scan                              Install docker scan cli and plugin

$  make -f Makefile-tools docker-scan

Version:    v0.8.0
Git commit: 35651ca
Provider:   Snyk (1.563.0 (standalone))

$  docker scan --version
Version:    v0.8.0
Git commit: 35651ca
Provider:   Snyk (1.563.0 (standalone))
```

* `Makefile:`

```cmake

docker-scan: ## Install docker scan cli and plugin
        @mkdir -p $(HOME)/.docker/cli-plugins && curl https://github.com/docker/scan-cli-plugin/releases/download/$(DOCKER-SCAN)/docker-scan_linux_amd64 -L -s -S -o $(HOME)/.docker/cli-plugins/docker-scan && chmod +x $(HOME)/.docker/cli-plugins/docker-scan && docker scan --version || true

```

## Usages and examples

* List local docker images

```bash
$  docker images
REPOSITORY                          TAG            IMAGE ID       CREATED         SIZE
nginx                               latest         d1a364dc548d   3 weeks ago     133MB
snyk/snyk                           <none>         0f6d8486c45c   8 weeks ago     337MB
```

* Help page

```bash
$  docker scan --help

Usage:	docker scan [OPTIONS] IMAGE

A tool to scan your images

Options:
      --accept-license    Accept using a third party scanning provider
      --dependency-tree   Show dependency tree with scan results
      --exclude-base      Exclude base image from vulnerability scanning (requires --file)
  -f, --file string       Dockerfile associated with image, provides more detailed results
      --group-issues      Aggregate duplicated vulnerabilities and group them to a single one (requires --json)
      --json              Output results in JSON format
      --login             Authenticate to the scan provider using an optional token (with --token), or web base token if empty
      --reject-license    Reject using a third party scanning provider
      --severity string   Only report vulnerabilities of provided level or higher (low|medium|high)
      --token string      Authentication token to login to the third party scanning provider
      --version           Display version of the scan plugin
 jso  ubunu2004  ~  myob-work  …  projects  JackySo-24x7classroom  Rapid-docker-on-aws  main  $  docker scan --version
Version:    v0.8.0
Git commit: 35651ca
Provider:   Snyk (1.563.0 (standalone))
```

* Login to Synk.io

```bash
$  docker scan --login

To authenticate your account, open the below URL in your browser.
After your authentication is complete, return to this prompt to start using Snyk.

https://snyk.io/login?token=c3092298-9eee-4b81-ad6a-9ba7a3ea9a6b&utm_medium=Partner&utm_source=Docker&utm_campaign=Docker-Desktop-2020&os=linux&docker=true

Your account has been authenticated. Snyk is now ready to be used.
```

### Scan images

1. Scan pulled image `nginx`

```bash
$  docker scan --dependency-tree nginx:latest
```

<details><summary><i>Click to view vulnerabilities found</i></summary><br>

```
docker-image|nginx @ latest
   ├─ apt @ 1.8.2.3
   │  ├─ adduser @ 3.118
   │  ├─ apt/libapt-pkg5.0 @ 1.8.2.3
   │  │  ├─ gcc-8/libstdc++6 @ 8.3.0-6
   │  │  ├─ libzstd/libzstd1 @ 1.3.8+dfsg-3+deb10u2
   │  │  ├─ lz4/liblz4-1 @ 1.8.3-1
   │  │  ├─ systemd/libsystemd0 @ 241-7~deb10u7
   │  │  │  ├─ libgcrypt20 @ 1.8.4-5
   │  │  │  └─ lz4/liblz4-1 @ 1.8.3-1
   │  │  └─ systemd/libudev1 @ 241-7~deb10u7
   │  ├─ debian-archive-keyring @ 2019.1+deb10u1
   │  ├─ gcc-8/libstdc++6 @ 8.3.0-6
   │  ├─ gnupg2/gpgv @ 2.2.12-1+deb10u1
   │  │  ├─ libgcrypt20 @ 1.8.4-5
   │  │  └─ libgpg-error/libgpg-error0 @ 1.35-1
   │  ├─ gnutls28/libgnutls30 @ 3.6.7-4+deb10u6
   │  └─ libseccomp/libseccomp2 @ 2.3.3-4
   ├─ apt/libapt-pkg5.0 @ 1.8.2.3
   ├─ base-files @ 10.3+deb10u9
   │  └─ mawk/mawk @ 1.3.3-17+b3
   ├─ base-passwd @ 3.5.46
   │  └─ cdebconf/libdebconfclient0 @ 0.249
   ├─ bash @ 5.0-4
   │  ├─ base-files @ 10.3+deb10u9
   │  ├─ debianutils @ 4.8.6.1
   │  └─ ncurses/libtinfo6 @ 6.1+20181013-2+deb10u2
   ├─ ca-certificates @ 20200601~deb10u2
   │  └─ openssl @ 1.1.1d-0+deb10u6
   │     └─ openssl/libssl1.1 @ 1.1.1d-0+deb10u6
   ├─ cdebconf/libdebconfclient0 @ 0.249
   ├─ curl @ 7.64.0-4+deb10u2
   │  └─ curl/libcurl4 @ 7.64.0-4+deb10u2
   │     ├─ e2fsprogs/libcom-err2 @ 1.44.5-1+deb10u3
   │     ├─ krb5/libgssapi-krb5-2 @ 1.17-3+deb10u1
   │     │  ├─ e2fsprogs/libcom-err2 @ 1.44.5-1+deb10u3
   │     │  ├─ keyutils/libkeyutils1 @ 1.6-6
   │     │  ├─ krb5/libk5crypto3 @ 1.17-3+deb10u1
   │     │  │  ├─ keyutils/libkeyutils1 @ 1.6-6
   │     │  │  └─ krb5/libkrb5support0 @ 1.17-3+deb10u1
   │     │  │     └─ keyutils/libkeyutils1 @ 1.6-6
   │     │  ├─ krb5/libkrb5-3 @ 1.17-3+deb10u1
   │     │  │  ├─ e2fsprogs/libcom-err2 @ 1.44.5-1+deb10u3
   │     │  │  ├─ keyutils/libkeyutils1 @ 1.6-6
   │     │  │  ├─ krb5/libk5crypto3 @ 1.17-3+deb10u1
   │     │  │  ├─ krb5/libkrb5support0 @ 1.17-3+deb10u1
   │     │  │  └─ openssl/libssl1.1 @ 1.1.1d-0+deb10u6
   │     │  └─ krb5/libkrb5support0 @ 1.17-3+deb10u1
   │     ├─ krb5/libk5crypto3 @ 1.17-3+deb10u1
   │     ├─ krb5/libkrb5-3 @ 1.17-3+deb10u1
   │     ├─ libidn2/libidn2-0 @ 2.0.5-1+deb10u1
   │     │  └─ libunistring/libunistring2 @ 0.9.10-1
   │     ├─ libpsl/libpsl5 @ 0.20.2-2
   │     │  ├─ libidn2/libidn2-0 @ 2.0.5-1+deb10u1
   │     │  └─ libunistring/libunistring2 @ 0.9.10-1
   │     ├─ libssh2/libssh2-1 @ 1.8.0-2.1
   │     │  └─ libgcrypt20 @ 1.8.4-5
   │     │     └─ libgpg-error/libgpg-error0 @ 1.35-1
   │     ├─ nghttp2/libnghttp2-14 @ 1.36.0-2+deb10u1
   │     ├─ openldap/libldap-2.4-2 @ 2.4.47+dfsg-3+deb10u6
   │     │  ├─ cyrus-sasl2/libsasl2-2 @ 2.1.27+dfsg-1+deb10u1
   │     │  │  └─ cyrus-sasl2/libsasl2-modules-db @ 2.1.27+dfsg-1+deb10u1
   │     │  │     └─ db5.3/libdb5.3 @ 5.3.28+dfsg1-0.5
   │     │  ├─ gnutls28/libgnutls30 @ 3.6.7-4+deb10u6
   │     │  │  ├─ gmp/libgmp10 @ 2:6.1.2+dfsg-4
   │     │  │  ├─ libidn2/libidn2-0 @ 2.0.5-1+deb10u1
   │     │  │  ├─ libtasn1-6 @ 4.13-3
   │     │  │  ├─ libunistring/libunistring2 @ 0.9.10-1
   │     │  │  ├─ nettle/libhogweed4 @ 3.4.1-1
   │     │  │  │  ├─ gmp/libgmp10 @ 2:6.1.2+dfsg-4
   │     │  │  │  └─ nettle/libnettle6 @ 3.4.1-1
   │     │  │  ├─ nettle/libnettle6 @ 3.4.1-1
   │     │  │  └─ p11-kit/libp11-kit0 @ 0.23.15-2+deb10u1
   │     │  │     └─ libffi/libffi6 @ 3.2.1-9
   │     │  └─ openldap/libldap-common @ 2.4.47+dfsg-3+deb10u6
   │     ├─ openssl/libssl1.1 @ 1.1.1d-0+deb10u6
   │     └─ rtmpdump/librtmp1 @ 2.4+20151223.gitfa8646d.1-2
   │        ├─ gmp/libgmp10 @ 2:6.1.2+dfsg-4
   │        ├─ gnutls28/libgnutls30 @ 3.6.7-4+deb10u6
   │        ├─ nettle/libhogweed4 @ 3.4.1-1
   │        └─ nettle/libnettle6 @ 3.4.1-1
   ├─ dash @ 0.5.10.2-5
   │  └─ debianutils @ 4.8.6.1
   ├─ debian-archive-keyring @ 2019.1+deb10u1
   ├─ debianutils @ 4.8.6.1
   ├─ diffutils @ 1:3.7-3
   ├─ e2fsprogs @ 1.44.5-1+deb10u3
   │  ├─ e2fsprogs/libcom-err2 @ 1.44.5-1+deb10u3
   │  ├─ e2fsprogs/libext2fs2 @ 1.44.5-1+deb10u3
   │  ├─ e2fsprogs/libss2 @ 1.44.5-1+deb10u3
   │  │  └─ e2fsprogs/libcom-err2 @ 1.44.5-1+deb10u3
   │  ├─ util-linux/libblkid1 @ 2.33.1-0.1
   │  │  └─ util-linux/libuuid1 @ 2.33.1-0.1
   │  └─ util-linux/libuuid1 @ 2.33.1-0.1
   ├─ e2fsprogs/libext2fs2 @ 1.44.5-1+deb10u3
   ├─ e2fsprogs/libss2 @ 1.44.5-1+deb10u3
   ├─ findutils @ 4.6.0+git+20190209-2
   ├─ gettext/gettext-base @ 0.19.8.1-9
   ├─ glibc/libc-bin @ 2.28-10
   ├─ gnupg2/gpgv @ 2.2.12-1+deb10u1
   ├─ grep @ 3.3-1
   ├─ gzip @ 1.9-3
   ├─ hostname @ 3.21
   ├─ init-system-helpers @ 1.56+nmu1
   ├─ libseccomp/libseccomp2 @ 2.3.3-4
   ├─ lz4/liblz4-1 @ 1.8.3-1
   ├─ mawk/mawk @ 1.3.3-17+b3
   ├─ meta-common-packages @ meta
   │  ├─ acl/libacl1 @ 2.2.53-4
   │  ├─ attr/libattr1 @ 1:2.4.48-4
   │  ├─ audit/libaudit-common @ 1:2.8.4-3
   │  ├─ audit/libaudit1 @ 1:2.8.4-3
   │  ├─ bzip2/libbz2-1.0 @ 1.0.6-9.2~deb10u1
   │  ├─ debconf @ 1.5.71
   │  ├─ dpkg @ 1.19.7
   │  ├─ gcc-8/gcc-8-base @ 8.3.0-6
   │  ├─ gcc-8/libgcc1 @ 1:8.3.0-6
   │  ├─ glibc/libc6 @ 2.28-10
   │  ├─ libcap-ng/libcap-ng0 @ 0.7.9-2
   │  ├─ libselinux/libselinux1 @ 2.8-1+b1
   │  ├─ pcre3/libpcre3 @ 2:8.39-12
   │  ├─ perl/perl-base @ 5.28.1-6+deb10u1
   │  ├─ tar @ 1.30+dfsg-6
   │  ├─ xz-utils/liblzma5 @ 5.2.4-1
   │  └─ zlib/zlib1g @ 1:1.2.11.dfsg-1
   ├─ ncurses/libncursesw6 @ 6.1+20181013-2+deb10u2
   ├─ ncurses/ncurses-base @ 6.1+20181013-2+deb10u2
   ├─ ncurses/ncurses-bin @ 6.1+20181013-2+deb10u2
   │  └─ ncurses/libtinfo6 @ 6.1+20181013-2+deb10u2
   ├─ nginx @ 1.21.0-1~buster
   │  ├─ adduser @ 3.118
   │  │  └─ shadow/passwd @ 1:4.5-1.1
   │  │     ├─ libsemanage/libsemanage1 @ 2.8-2
   │  │     │  ├─ libsemanage/libsemanage-common @ 2.8-2
   │  │     │  └─ libsepol/libsepol1 @ 2.8-1
   │  │     ├─ pam/libpam-modules @ 1.3.1-5
   │  │     │  ├─ db5.3/libdb5.3 @ 5.3.28+dfsg1-0.5
   │  │     │  ├─ pam/libpam-modules-bin @ 1.3.1-5
   │  │     │  │  └─ pam/libpam0g @ 1.3.1-5
   │  │     │  └─ pam/libpam0g @ 1.3.1-5
   │  │     └─ pam/libpam0g @ 1.3.1-5
   │  ├─ lsb/lsb-base @ 10.2019051400
   │  └─ openssl/libssl1.1 @ 1.1.1d-0+deb10u6
   ├─ nginx-module-geoip @ 1.21.0-1~buster
   │  ├─ geoip/libgeoip1 @ 1.6.12-1
   │  └─ nginx @ 1.21.0-1~buster
   ├─ nginx-module-image-filter @ 1.21.0-1~buster
   │  ├─ libgd2/libgd3 @ 2.2.5-5.2
   │  │  ├─ fontconfig/libfontconfig1 @ 2.13.1-2
   │  │  │  ├─ expat/libexpat1 @ 2.2.6-2+deb10u1
   │  │  │  ├─ fontconfig/fontconfig-config @ 2.13.1-2
   │  │  │  │  ├─ fonts-dejavu/fonts-dejavu-core @ 2.37-1
   │  │  │  │  └─ ucf @ 3.0038+nmu1
   │  │  │  │     ├─ coreutils @ 8.30-3
   │  │  │  │     └─ sensible-utils @ 0.0.12
   │  │  │  ├─ freetype/libfreetype6 @ 2.9.1-3+deb10u2
   │  │  │  │  └─ libpng1.6/libpng16-16 @ 1.6.36-6
   │  │  │  └─ util-linux/libuuid1 @ 2.33.1-0.1
   │  │  ├─ freetype/libfreetype6 @ 2.9.1-3+deb10u2
   │  │  ├─ libjpeg-turbo/libjpeg62-turbo @ 1:1.5.2-2+deb10u1
   │  │  ├─ libpng1.6/libpng16-16 @ 1.6.36-6
   │  │  ├─ libwebp/libwebp6 @ 0.6.1-2
   │  │  ├─ libxpm/libxpm4 @ 1:3.5.12-1
   │  │  │  └─ libx11/libx11-6 @ 2:1.6.7-1+deb10u2
   │  │  │     ├─ libx11/libx11-data @ 2:1.6.7-1+deb10u2
   │  │  │     └─ libxcb/libxcb1 @ 1.13.1-2
   │  │  │        ├─ libxau/libxau6 @ 1:1.0.8-1+b2
   │  │  │        └─ libxdmcp/libxdmcp6 @ 1:1.1.2-3
   │  │  │           └─ libbsd/libbsd0 @ 0.9.1-2+deb10u1
   │  │  └─ tiff/libtiff5 @ 4.1.0+git191117-2~deb10u2
   │  │     ├─ jbigkit/libjbig0 @ 2.1-3.1+b2
   │  │     ├─ libjpeg-turbo/libjpeg62-turbo @ 1:1.5.2-2+deb10u1
   │  │     ├─ libwebp/libwebp6 @ 0.6.1-2
   │  │     └─ libzstd/libzstd1 @ 1.3.8+dfsg-3+deb10u2
   │  └─ nginx @ 1.21.0-1~buster
   ├─ nginx-module-njs @ 1.21.0+0.5.3-1~buster
   │  ├─ nginx @ 1.21.0-1~buster
   │  └─ readline/libreadline7 @ 7.0-5
   │     ├─ ncurses/libtinfo6 @ 6.1+20181013-2+deb10u2
   │     └─ readline/readline-common @ 7.0-5
   ├─ nginx-module-xslt @ 1.21.0-1~buster
   │  ├─ libxml2 @ 2.9.4+dfsg1-7+deb10u1
   │  │  └─ icu/libicu63 @ 63.1-6+deb10u1
   │  │     └─ gcc-8/libstdc++6 @ 8.3.0-6
   │  ├─ libxslt/libxslt1.1 @ 1.1.32-2.2~deb10u1
   │  │  ├─ libgcrypt20 @ 1.8.4-5
   │  │  └─ libxml2 @ 2.9.4+dfsg1-7+deb10u1
   │  └─ nginx @ 1.21.0-1~buster
   ├─ pam/libpam-runtime @ 1.3.1-5
   │  └─ pam/libpam-modules @ 1.3.1-5
   ├─ sed @ 4.7-1
   ├─ shadow/login @ 1:4.5-1.1
   │  ├─ pam/libpam-modules @ 1.3.1-5
   │  ├─ pam/libpam-runtime @ 1.3.1-5
   │  └─ pam/libpam0g @ 1.3.1-5
   ├─ systemd/libsystemd0 @ 241-7~deb10u7
   ├─ systemd/libudev1 @ 241-7~deb10u7
   ├─ sysvinit/sysvinit-utils @ 2.93-8
   │  ├─ init-system-helpers @ 1.56+nmu1
   │  └─ util-linux @ 2.33.1-0.1
   ├─ tzdata @ 2021a-0+deb10u1
   ├─ util-linux @ 2.33.1-0.1
   ├─ util-linux/bsdutils @ 1:2.33.1-0.1
   │  └─ systemd/libsystemd0 @ 241-7~deb10u7
   ├─ util-linux/fdisk @ 2.33.1-0.1
   │  ├─ ncurses/libncursesw6 @ 6.1+20181013-2+deb10u2
   │  │  └─ ncurses/libtinfo6 @ 6.1+20181013-2+deb10u2
   │  ├─ ncurses/libtinfo6 @ 6.1+20181013-2+deb10u2
   │  ├─ util-linux/libfdisk1 @ 2.33.1-0.1
   │  │  ├─ util-linux/libblkid1 @ 2.33.1-0.1
   │  │  └─ util-linux/libuuid1 @ 2.33.1-0.1
   │  ├─ util-linux/libmount1 @ 2.33.1-0.1
   │  │  └─ util-linux/libblkid1 @ 2.33.1-0.1
   │  └─ util-linux/libsmartcols1 @ 2.33.1-0.1
   ├─ util-linux/libblkid1 @ 2.33.1-0.1
   ├─ util-linux/libfdisk1 @ 2.33.1-0.1
   ├─ util-linux/libmount1 @ 2.33.1-0.1
   ├─ util-linux/libsmartcols1 @ 2.33.1-0.1
   └─ util-linux/mount @ 2.33.1-0.1
      ├─ util-linux @ 2.33.1-0.1
      │  ├─ ncurses/libtinfo6 @ 6.1+20181013-2+deb10u2
      │  ├─ pam/libpam0g @ 1.3.1-5
      │  ├─ shadow/login @ 1:4.5-1.1
      │  ├─ systemd/libsystemd0 @ 241-7~deb10u7
      │  ├─ systemd/libudev1 @ 241-7~deb10u7
      │  ├─ util-linux/fdisk @ 2.33.1-0.1
      │  ├─ util-linux/libblkid1 @ 2.33.1-0.1
      │  ├─ util-linux/libmount1 @ 2.33.1-0.1
      │  ├─ util-linux/libsmartcols1 @ 2.33.1-0.1
      │  └─ util-linux/libuuid1 @ 2.33.1-0.1
      ├─ util-linux/libblkid1 @ 2.33.1-0.1
      ├─ util-linux/libmount1 @ 2.33.1-0.1
      └─ util-linux/libsmartcols1 @ 2.33.1-0.1

Testing nginx:latest...

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-1079067
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-1079073
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-405264
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Divide By Zero
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-405344
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tiff/libtiff5
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-405387
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-405477
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-405858
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Missing Release of Resource after Effective Lifetime
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TIFF-406148
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2

✗ Low severity vulnerability found in tar
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TAR-1063001
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > tar@1.30+dfsg-6

✗ Low severity vulnerability found in tar
  Description: CVE-2005-2541
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TAR-312331
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > tar@1.30+dfsg-6

✗ Low severity vulnerability found in tar
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-TAR-341203
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > tar@1.30+dfsg-6

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Authentication Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SYSTEMD-1291056
  Introduced through: systemd/libsystemd0@241-7~deb10u7, util-linux/bsdutils@1:2.33.1-0.1, apt@1.8.2.3, util-linux/mount@2.33.1-0.1, systemd/libudev1@241-7~deb10u7
  From: systemd/libsystemd0@241-7~deb10u7
  From: util-linux/bsdutils@1:2.33.1-0.1 > systemd/libsystemd0@241-7~deb10u7
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7
  and 4 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Link Following
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SYSTEMD-305144
  Introduced through: systemd/libsystemd0@241-7~deb10u7, util-linux/bsdutils@1:2.33.1-0.1, apt@1.8.2.3, util-linux/mount@2.33.1-0.1, systemd/libudev1@241-7~deb10u7
  From: systemd/libsystemd0@241-7~deb10u7
  From: util-linux/bsdutils@1:2.33.1-0.1 > systemd/libsystemd0@241-7~deb10u7
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7
  and 4 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Missing Release of Resource after Effective Lifetime
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SYSTEMD-542807
  Introduced through: systemd/libsystemd0@241-7~deb10u7, util-linux/bsdutils@1:2.33.1-0.1, apt@1.8.2.3, util-linux/mount@2.33.1-0.1, systemd/libudev1@241-7~deb10u7
  From: systemd/libsystemd0@241-7~deb10u7
  From: util-linux/bsdutils@1:2.33.1-0.1 > systemd/libsystemd0@241-7~deb10u7
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7
  and 4 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SYSTEMD-570991
  Introduced through: systemd/libsystemd0@241-7~deb10u7, util-linux/bsdutils@1:2.33.1-0.1, apt@1.8.2.3, util-linux/mount@2.33.1-0.1, systemd/libudev1@241-7~deb10u7
  From: systemd/libsystemd0@241-7~deb10u7
  From: util-linux/bsdutils@1:2.33.1-0.1 > systemd/libsystemd0@241-7~deb10u7
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7
  and 4 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in shadow/passwd
  Description: Time-of-check Time-of-use (TOCTOU)
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SHADOW-306205
  Introduced through: nginx@1.21.0-1~buster, shadow/login@1:4.5-1.1, util-linux/mount@2.33.1-0.1
  From: nginx@1.21.0-1~buster > adduser@3.118 > shadow/passwd@1:4.5-1.1
  From: shadow/login@1:4.5-1.1
  From: util-linux/mount@2.33.1-0.1 > util-linux@2.33.1-0.1 > shadow/login@1:4.5-1.1
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in shadow/passwd
  Description: Incorrect Permission Assignment for Critical Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SHADOW-306230
  Introduced through: nginx@1.21.0-1~buster, shadow/login@1:4.5-1.1, util-linux/mount@2.33.1-0.1
  From: nginx@1.21.0-1~buster > adduser@3.118 > shadow/passwd@1:4.5-1.1
  From: shadow/login@1:4.5-1.1
  From: util-linux/mount@2.33.1-0.1 > util-linux@2.33.1-0.1 > shadow/login@1:4.5-1.1
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in shadow/passwd
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SHADOW-306250
  Introduced through: nginx@1.21.0-1~buster, shadow/login@1:4.5-1.1, util-linux/mount@2.33.1-0.1
  From: nginx@1.21.0-1~buster > adduser@3.118 > shadow/passwd@1:4.5-1.1
  From: shadow/login@1:4.5-1.1
  From: util-linux/mount@2.33.1-0.1 > util-linux@2.33.1-0.1 > shadow/login@1:4.5-1.1
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in shadow/passwd
  Description: Incorrect Permission Assignment for Critical Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SHADOW-539852
  Introduced through: nginx@1.21.0-1~buster, shadow/login@1:4.5-1.1, util-linux/mount@2.33.1-0.1
  From: nginx@1.21.0-1~buster > adduser@3.118 > shadow/passwd@1:4.5-1.1
  From: shadow/login@1:4.5-1.1
  From: util-linux/mount@2.33.1-0.1 > util-linux@2.33.1-0.1 > shadow/login@1:4.5-1.1
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in perl/perl-base
  Description: Link Following
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-PERL-327793
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > perl/perl-base@5.28.1-6+deb10u1

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-PCRE3-345321
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-12

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-PCRE3-345353
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-12

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Uncontrolled Recursion
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-PCRE3-345502
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-12

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-PCRE3-345530
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-12

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-PCRE3-572368
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-12

✗ Low severity vulnerability found in openssl/libssl1.1
  Description: Cryptographic Issues
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-OPENSSL-374709
  Introduced through: nginx@1.21.0-1~buster, ca-certificates@20200601~deb10u2, curl@7.64.0-4+deb10u2
  From: nginx@1.21.0-1~buster > openssl/libssl1.1@1.1.1d-0+deb10u6
  From: ca-certificates@20200601~deb10u2 > openssl@1.1.1d-0+deb10u6 > openssl/libssl1.1@1.1.1d-0+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openssl/libssl1.1@1.1.1d-0+deb10u6
  and 2 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in openssl/libssl1.1
  Description: Cryptographic Issues
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-OPENSSL-374996
  Introduced through: nginx@1.21.0-1~buster, ca-certificates@20200601~deb10u2, curl@7.64.0-4+deb10u2
  From: nginx@1.21.0-1~buster > openssl/libssl1.1@1.1.1d-0+deb10u6
  From: ca-certificates@20200601~deb10u2 > openssl@1.1.1d-0+deb10u6 > openssl/libssl1.1@1.1.1d-0+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openssl/libssl1.1@1.1.1d-0+deb10u6
  and 2 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Improper Initialization
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-OPENLDAP-304601
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > openldap/libldap-common@2.4.47+dfsg-3+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Cryptographic Issues
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-OPENLDAP-304654
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > openldap/libldap-common@2.4.47+dfsg-3+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-OPENLDAP-304666
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > openldap/libldap-common@2.4.47+dfsg-3+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Improper Certificate Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-OPENLDAP-584924
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > openldap/libldap-common@2.4.47+dfsg-3+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in nginx
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-NGINX-341071
  Introduced through: nginx@1.21.0-1~buster, nginx-module-geoip@1.21.0-1~buster, nginx-module-image-filter@1.21.0-1~buster, nginx-module-njs@1.21.0+0.5.3-1~buster, nginx-module-xslt@1.21.0-1~buster
  From: nginx@1.21.0-1~buster
  From: nginx-module-geoip@1.21.0-1~buster > nginx@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > nginx@1.21.0-1~buster
  and 2 more...

✗ Low severity vulnerability found in nginx
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-NGINX-341087
  Introduced through: nginx@1.21.0-1~buster, nginx-module-geoip@1.21.0-1~buster, nginx-module-image-filter@1.21.0-1~buster, nginx-module-njs@1.21.0+0.5.3-1~buster, nginx-module-xslt@1.21.0-1~buster
  From: nginx@1.21.0-1~buster
  From: nginx-module-geoip@1.21.0-1~buster > nginx@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > nginx@1.21.0-1~buster
  and 2 more...

✗ Low severity vulnerability found in nettle/libnettle6
  Description: CVE-2021-3580
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-NETTLE-1301269
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-2 > nettle/libnettle6@3.4.1-1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6 > nettle/libnettle6@3.4.1-1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6 > nettle/libhogweed4@3.4.1-1 > nettle/libnettle6@3.4.1-1
  and 2 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in lz4/liblz4-1
  Description: Buffer Overflow
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LZ4-473072
  Introduced through: lz4/liblz4-1@1.8.3-1, apt@1.8.2.3
  From: lz4/liblz4-1@1.8.3-1
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > lz4/liblz4-1@1.8.3-1
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7 > lz4/liblz4-1@1.8.3-1

✗ Low severity vulnerability found in libxslt/libxslt1.1
  Description: Use of Insufficiently Random Values
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXSLT-308013
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1

✗ Low severity vulnerability found in libxml2
  Description: CVE-2021-3541
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-1293202
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ Low severity vulnerability found in libxml2
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-609787
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ Low severity vulnerability found in libwebp/libwebp6
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-277882
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2

✗ Low severity vulnerability found in libtasn1-6
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBTASN16-339585
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6 > libtasn1-6@4.13-3
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in libssh2/libssh2-1
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBSSH2-474372
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > libssh2/libssh2-1@1.8.0-2.1
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in libseccomp/libseccomp2
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBSECCOMP-341044
  Introduced through: libseccomp/libseccomp2@2.3.3-4, apt@1.8.2.3
  From: libseccomp/libseccomp2@2.3.3-4
  From: apt@1.8.2.3 > libseccomp/libseccomp2@2.3.3-4

✗ Low severity vulnerability found in libpng1.6/libpng16-16
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBPNG16-296440
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libpng1.6/libpng16-16@1.6.36-6
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > fontconfig/libfontconfig1@2.13.1-2 > freetype/libfreetype6@2.9.1-3+deb10u2 > libpng1.6/libpng16-16@1.6.36-6

✗ Low severity vulnerability found in libpng1.6/libpng16-16
  Description: Memory Leak
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBPNG16-296468
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libpng1.6/libpng16-16@1.6.36-6
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > fontconfig/libfontconfig1@2.13.1-2 > freetype/libfreetype6@2.9.1-3+deb10u2 > libpng1.6/libpng16-16@1.6.36-6

✗ Low severity vulnerability found in libpng1.6/libpng16-16
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBPNG16-296471
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libpng1.6/libpng16-16@1.6.36-6
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > fontconfig/libfontconfig1@2.13.1-2 > freetype/libfreetype6@2.9.1-3+deb10u2 > libpng1.6/libpng16-16@1.6.36-6

✗ Low severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBJPEGTURBO-1298595
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libjpeg-turbo/libjpeg62-turbo@1:1.5.2-2+deb10u1
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libjpeg-turbo/libjpeg62-turbo@1:1.5.2-2+deb10u1

✗ Low severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBJPEGTURBO-299879
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libjpeg-turbo/libjpeg62-turbo@1:1.5.2-2+deb10u1
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libjpeg-turbo/libjpeg62-turbo@1:1.5.2-2+deb10u1

✗ Low severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Excessive Iteration
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBJPEGTURBO-572943
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libjpeg-turbo/libjpeg62-turbo@1:1.5.2-2+deb10u1
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libjpeg-turbo/libjpeg62-turbo@1:1.5.2-2+deb10u1

✗ Low severity vulnerability found in libgd2/libgd3
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBGD2-548728
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2

✗ Low severity vulnerability found in libgcrypt20
  Description: Use of a Broken or Risky Cryptographic Algorithm
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBGCRYPT20-391902
  Introduced through: apt@1.8.2.3, nginx-module-xslt@1.21.0-1~buster, curl@7.64.0-4+deb10u2
  From: apt@1.8.2.3 > gnupg2/gpgv@2.2.12-1+deb10u1 > libgcrypt20@1.8.4-5
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libgcrypt20@1.8.4-5
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7 > libgcrypt20@1.8.4-5
  and 1 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: CVE-2004-0971
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-KRB5-395883
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > krb5/libgssapi-krb5-2@1.17-3+deb10u1 > krb5/libkrb5support0@1.17-3+deb10u1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > krb5/libgssapi-krb5-2@1.17-3+deb10u1 > krb5/libk5crypto3@1.17-3+deb10u1 > krb5/libkrb5support0@1.17-3+deb10u1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > krb5/libgssapi-krb5-2@1.17-3+deb10u1 > krb5/libkrb5-3@1.17-3+deb10u1 > krb5/libkrb5support0@1.17-3+deb10u1
  and 6 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-KRB5-395955
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > krb5/libgssapi-krb5-2@1.17-3+deb10u1 > krb5/libkrb5support0@1.17-3+deb10u1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > krb5/libgssapi-krb5-2@1.17-3+deb10u1 > krb5/libk5crypto3@1.17-3+deb10u1 > krb5/libkrb5support0@1.17-3+deb10u1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > krb5/libgssapi-krb5-2@1.17-3+deb10u1 > krb5/libkrb5-3@1.17-3+deb10u1 > krb5/libkrb5support0@1.17-3+deb10u1
  and 6 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in jbigkit/libjbig0
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-JBIGKIT-289888
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > jbigkit/libjbig0@2.1-3.1+b2

✗ Low severity vulnerability found in gnutls28/libgnutls30
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GNUTLS28-340755
  Introduced through: apt@1.8.2.3, curl@7.64.0-4+deb10u2
  From: apt@1.8.2.3 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-2 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in gnupg2/gpgv
  Description: Use of a Broken or Risky Cryptographic Algorithm
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GNUPG2-535553
  Introduced through: gnupg2/gpgv@2.2.12-1+deb10u1, apt@1.8.2.3
  From: gnupg2/gpgv@2.2.12-1+deb10u1
  From: apt@1.8.2.3 > gnupg2/gpgv@2.2.12-1+deb10u1

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Double Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-1078993
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Uncontrolled Recursion
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-338106
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Uncontrolled Recursion
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-338163
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-356371
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-356671
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-356735
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: CVE-2010-4051
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-356875
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-452228
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-452267
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Use of Insufficiently Random Values
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-453375
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-453640
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-534995
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Integer Underflow
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-564233
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Low severity vulnerability found in expat/libexpat1
  Description: XML External Entity (XXE) Injection
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-EXPAT-358079
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > fontconfig/libfontconfig1@2.13.1-2 > expat/libexpat1@2.2.6-2+deb10u1

✗ Low severity vulnerability found in curl/libcurl4
  Description: CVE-2021-22898
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-CURL-1296892
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Low severity vulnerability found in coreutils
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-COREUTILS-317465
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > fontconfig/libfontconfig1@2.13.1-2 > fontconfig/fontconfig-config@2.13.1-2 > ucf@3.0038+nmu1 > coreutils@8.30-3

✗ Low severity vulnerability found in coreutils
  Description: Race Condition
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-COREUTILS-317494
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > fontconfig/libfontconfig1@2.13.1-2 > fontconfig/fontconfig-config@2.13.1-2 > ucf@3.0038+nmu1 > coreutils@8.30-3

✗ Low severity vulnerability found in bash
  Description: Improper Check for Dropped Privileges
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-BASH-536280
  Introduced through: bash@5.0-4
  From: bash@5.0-4

✗ Low severity vulnerability found in apt/libapt-pkg5.0
  Description: Improper Verification of Cryptographic Signature
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-APT-407502
  Introduced through: apt/libapt-pkg5.0@1.8.2.3, apt@1.8.2.3
  From: apt/libapt-pkg5.0@1.8.2.3
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3
  From: apt@1.8.2.3

✗ Medium severity vulnerability found in pcre3/libpcre3
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-PCRE3-572367
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-12

✗ Medium severity vulnerability found in nginx
  Description: CVE-2020-36309
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-NGINX-1244843
  Introduced through: nginx@1.21.0-1~buster, nginx-module-geoip@1.21.0-1~buster, nginx-module-image-filter@1.21.0-1~buster, nginx-module-njs@1.21.0+0.5.3-1~buster, nginx-module-xslt@1.21.0-1~buster
  From: nginx@1.21.0-1~buster
  From: nginx-module-geoip@1.21.0-1~buster > nginx@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > nginx@1.21.0-1~buster
  and 2 more...

✗ Medium severity vulnerability found in libxml2
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-1290152
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ Medium severity vulnerability found in libxml2
  Description: XML External Entity (XXE) Injection
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-429496
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ Medium severity vulnerability found in libgcrypt20
  Description: Race Condition
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBGCRYPT20-460489
  Introduced through: apt@1.8.2.3, nginx-module-xslt@1.21.0-1~buster, curl@7.64.0-4+deb10u2
  From: apt@1.8.2.3 > gnupg2/gpgv@2.2.12-1+deb10u1 > libgcrypt20@1.8.4-5
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libgcrypt20@1.8.4-5
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7 > libgcrypt20@1.8.4-5
  and 1 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Loop with Unreachable Exit Condition ('Infinite Loop')
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-1035462
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-1055403
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-559181
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ High severity vulnerability found in systemd/libsystemd0
  Description: Privilege Chaining
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SYSTEMD-345386
  Introduced through: systemd/libsystemd0@241-7~deb10u7, util-linux/bsdutils@1:2.33.1-0.1, apt@1.8.2.3, util-linux/mount@2.33.1-0.1, systemd/libudev1@241-7~deb10u7
  From: systemd/libsystemd0@241-7~deb10u7
  From: util-linux/bsdutils@1:2.33.1-0.1 > systemd/libsystemd0@241-7~deb10u7
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7
  and 4 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in systemd/libsystemd0
  Description: Incorrect Privilege Assignment
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-SYSTEMD-345391
  Introduced through: systemd/libsystemd0@241-7~deb10u7, util-linux/bsdutils@1:2.33.1-0.1, apt@1.8.2.3, util-linux/mount@2.33.1-0.1, systemd/libudev1@241-7~deb10u7
  From: systemd/libsystemd0@241-7~deb10u7
  From: util-linux/bsdutils@1:2.33.1-0.1 > systemd/libsystemd0@241-7~deb10u7
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7
  and 4 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in nettle/libnettle6
  Description: Use of a Broken or Risky Cryptographic Algorithm
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-NETTLE-1090205
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-2 > nettle/libnettle6@3.4.1-1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6 > nettle/libnettle6@3.4.1-1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6 > nettle/libhogweed4@3.4.1-1 > nettle/libnettle6@3.4.1-1
  and 2 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in lz4/liblz4-1
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LZ4-1277601
  Introduced through: lz4/liblz4-1@1.8.3-1, apt@1.8.2.3
  From: lz4/liblz4-1@1.8.3-1
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > lz4/liblz4-1@1.8.3-1
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7 > lz4/liblz4-1@1.8.3-1
  Fixed in: 1.8.3-1+deb10u1

✗ High severity vulnerability found in libxml2
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-1277346
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ High severity vulnerability found in libxml2
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-1277349
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ High severity vulnerability found in libxml2
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-1277350
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ High severity vulnerability found in libxml2
  Description: Loop with Unreachable Exit Condition ('Infinite Loop')
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBXML2-429486
  Introduced through: nginx-module-xslt@1.21.0-1~buster
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libxml2@2.9.4+dfsg1-7+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289553
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289557
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289561
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289573
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289576
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289584
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289586
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289591
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289592
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1289593
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Use of Uninitialized Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBWEBP-1290149
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > libwebp/libwebp6@0.6.1-2
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2 > tiff/libtiff5@4.1.0+git191117-2~deb10u2 > libwebp/libwebp6@0.6.1-2
  Fixed in: 0.6.1-2+deb10u1

✗ High severity vulnerability found in libssh2/libssh2-1
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBSSH2-452460
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > libssh2/libssh2-1@1.8.0-2.1
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in libidn2/libidn2-0
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBIDN2-474100
  Introduced through: curl@7.64.0-4+deb10u2
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > libidn2/libidn2-0@2.0.5-1+deb10u1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > libpsl/libpsl5@0.20.2-2 > libidn2/libidn2-0@2.0.5-1+deb10u1
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6 > libidn2/libidn2-0@2.0.5-1+deb10u1
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in libgd2/libgd3
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBGD2-558917
  Introduced through: nginx-module-image-filter@1.21.0-1~buster
  From: nginx-module-image-filter@1.21.0-1~buster > libgd2/libgd3@2.2.5-5.2

✗ High severity vulnerability found in libgcrypt20
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-LIBGCRYPT20-1297893
  Introduced through: apt@1.8.2.3, nginx-module-xslt@1.21.0-1~buster, curl@7.64.0-4+deb10u2
  From: apt@1.8.2.3 > gnupg2/gpgv@2.2.12-1+deb10u1 > libgcrypt20@1.8.4-5
  From: nginx-module-xslt@1.21.0-1~buster > libxslt/libxslt1.1@1.1.32-2.2~deb10u1 > libgcrypt20@1.8.4-5
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > systemd/libsystemd0@241-7~deb10u7 > libgcrypt20@1.8.4-5
  and 1 more...
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in gnutls28/libgnutls30
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GNUTLS28-1085094
  Introduced through: apt@1.8.2.3, curl@7.64.0-4+deb10u2
  From: apt@1.8.2.3 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-2 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in gnutls28/libgnutls30
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GNUTLS28-1085097
  Introduced through: apt@1.8.2.3, curl@7.64.0-4+deb10u2
  From: apt@1.8.2.3 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-2 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in gnutls28/libgnutls30
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GNUTLS28-609778
  Introduced through: apt@1.8.2.3, curl@7.64.0-4+deb10u2
  From: apt@1.8.2.3 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-2 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  From: curl@7.64.0-4+deb10u2 > curl/libcurl4@7.64.0-4+deb10u2 > openldap/libldap-2.4-2@2.4.47+dfsg-3+deb10u6 > gnutls28/libgnutls30@3.6.7-4+deb10u6
  Image layer: '/bin/sh -c set -x     && addgroup --system --gid 101 nginx     && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx     && apt-get update     && apt-get install --no-install-recommends --no-install-suggests -y gnupg1 ca-certificates     &&     NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62;     found='';     for server in         ha.pool.sks-keyservers.net         hkp://keyserver.ubuntu.com:80         hkp://p80.pool.sks-keyservers.net:80         pgp.mit.edu     ; do         echo "Fetching GPG key $NGINX_GPGKEY from $server";         apt-key adv --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break;     done;     test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1;     apt-get remove --purge --auto-remove -y gnupg1 && rm -rf /var/lib/apt/lists/*     && dpkgArch="$(dpkg --print-architecture)"     && nginxPackages="         nginx=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-xslt=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-geoip=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-image-filter=${NGINX_VERSION}-${PKG_RELEASE}         nginx-module-njs=${NGINX_VERSION}+${NJS_VERSION}-${PKG_RELEASE}     "     && case "$dpkgArch" in         amd64|i386|arm64)             echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list             && apt-get update             ;;         *)             echo "deb-src https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list                         && tempDir="$(mktemp -d)"             && chmod 777 "$tempDir"                         && savedAptMark="$(apt-mark showmanual)"                         && apt-get update             && apt-get build-dep -y $nginxPackages             && (                 cd "$tempDir"                 && DEB_BUILD_OPTIONS="nocheck parallel=$(nproc)"                     apt-get source --compile $nginxPackages             )                         && apt-mark showmanual | xargs apt-mark auto > /dev/null             && { [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; }                         && ls -lAFh "$tempDir"             && ( cd "$tempDir" && dpkg-scanpackages . > Packages )             && grep '^Package: ' "$tempDir/Packages"             && echo "deb [ trusted=yes ] file://$tempDir ./" > /etc/apt/sources.list.d/temp.list             && apt-get -o Acquire::GzipIndexes=false update             ;;     esac         && apt-get install --no-install-recommends --no-install-suggests -y                         $nginxPackages                         gettext-base                         curl     && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list         && if [ -n "$tempDir" ]; then         apt-get purge -y --auto-remove         && rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list;     fi     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log     && mkdir /docker-entrypoint.d'

✗ High severity vulnerability found in glibc/libc-bin
  Description: Reachable Assertion
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-1065768
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ High severity vulnerability found in glibc/libc-bin
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-1296899
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ High severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-559488
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ High severity vulnerability found in glibc/libc-bin
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GLIBC-559493
  Introduced through: glibc/libc-bin@2.28-10, meta-common-packages@meta
  From: glibc/libc-bin@2.28-10
  From: meta-common-packages@meta > glibc/libc6@2.28-10

✗ High severity vulnerability found in gcc-8/libstdc++6
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GCC8-347558
  Introduced through: apt@1.8.2.3, nginx-module-xslt@1.21.0-1~buster, meta-common-packages@meta
  From: apt@1.8.2.3 > gcc-8/libstdc++6@8.3.0-6
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > gcc-8/libstdc++6@8.3.0-6
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1 > icu/libicu63@63.1-6+deb10u1 > gcc-8/libstdc++6@8.3.0-6
  and 2 more...

✗ High severity vulnerability found in gcc-8/libstdc++6
  Description: Insufficient Entropy
  Info: https://snyk.io/vuln/SNYK-DEBIAN10-GCC8-469413
  Introduced through: apt@1.8.2.3, nginx-module-xslt@1.21.0-1~buster, meta-common-packages@meta
  From: apt@1.8.2.3 > gcc-8/libstdc++6@8.3.0-6
  From: apt@1.8.2.3 > apt/libapt-pkg5.0@1.8.2.3 > gcc-8/libstdc++6@8.3.0-6
  From: nginx-module-xslt@1.21.0-1~buster > libxml2@2.9.4+dfsg1-7+deb10u1 > icu/libicu63@63.1-6+deb10u1 > gcc-8/libstdc++6@8.3.0-6
  and 2 more...
 ```

 </details><br>

```
Organization:      24x7classroom
Package manager:   deb
Project name:      docker-image|nginx
Docker image:      nginx:latest
Platform:          linux/amd64
Licenses:          enabled

Tested 136 dependencies for known issues, found 114 issues.
```

2. Build docker image and scan with Dockerfile

> Build image

```bash
$  docker build -t php-basic-nginx:latest -f docker/nginx/Dockerfile .
Sending build context to Docker daemon  2.157MB
Step 1/7 : FROM nginx:1.14
 ---> 295c7be07902
Step 2/7 : RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl
 ---> Using cache
 ---> 1eb4016b7dcf
Step 3/7 : COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
 ---> e26ac7d90825
Step 4/7 : COPY css /var/www/html/css
 ---> a75a946404fd
Step 5/7 : COPY img /var/www/html/img
 ---> df42bbff4feb
Step 6/7 : RUN chown -R nginx:nginx /var/www/html
 ---> Running in f064fa5041bd
Removing intermediate container f064fa5041bd
 ---> cab62c1de7ae
Step 7/7 : HEALTHCHECK --interval=15s --timeout=10s --start-period=60s --retries=2 CMD curl -f http://127.0.0.1/health-check.php || exit 1
 ---> Running in 4cc6816a23fd
Removing intermediate container 4cc6816a23fd
 ---> 2cdca28306d7
Successfully built 2cdca28306d7
Successfully tagged php-basic-nginx:latest
```

> Scan image with Dockerfile

```bash
$  docker images | grep nginx
php-basic-nginx                        latest         2cdca28306d7   2 minutes ago   144MB

$  docker scan --dependency-tree php-basic-nginx:latest -f docker/nginx/Dockerfile
```

<details><summary><i>Click to view all vulnerabilities reported</i></summary><br>

```
docker-image|php-basic-nginx @ latest
   ├─ apt @ 1.4.9
   │  ├─ adduser @ 3.115
   │  ├─ apt/libapt-pkg5.0 @ 1.4.9
   │  ├─ debian-archive-keyring @ 2017.5
   │  ├─ gcc-6/libstdc++6 @ 6.3.0-18+deb9u1
   │  ├─ gnupg2/gpgv @ 2.1.18-8~deb9u4
   │  └─ init-system-helpers @ 1.48
   ├─ apt/libapt-pkg5.0 @ 1.4.9
   │  ├─ gcc-6/libstdc++6 @ 6.3.0-18+deb9u1
   │  └─ lz4/liblz4-1 @ 0.0~r131-2+b1
   ├─ base-files @ 9.9+deb9u8
   ├─ base-passwd @ 3.5.43
   │  └─ cdebconf/libdebconfclient0 @ 0.227
   ├─ bash @ 4.4-5
   │  ├─ base-files @ 9.9+deb9u8
   │  │  └─ mawk/mawk @ 1.3.3-17+b3
   │  ├─ dash @ 0.5.8-2.4
   │  │  └─ debianutils @ 4.8.1.1
   │  ├─ debianutils @ 4.8.1.1
   │  └─ ncurses/libtinfo5 @ 6.0+20161126-1+deb9u2
   ├─ cdebconf/libdebconfclient0 @ 0.227
   ├─ curl @ 7.52.1-5+deb9u14
   │  └─ curl/libcurl3 @ 7.52.1-5+deb9u14
   │     ├─ e2fsprogs/libcomerr2 @ 1.43.4-2
   │     ├─ krb5/libgssapi-krb5-2 @ 1.15-1+deb9u2
   │     │  ├─ e2fsprogs/libcomerr2 @ 1.43.4-2
   │     │  ├─ keyutils/libkeyutils1 @ 1.5.9-9
   │     │  ├─ krb5/libk5crypto3 @ 1.15-1+deb9u2
   │     │  │  ├─ keyutils/libkeyutils1 @ 1.5.9-9
   │     │  │  └─ krb5/libkrb5support0 @ 1.15-1+deb9u2
   │     │  │     └─ keyutils/libkeyutils1 @ 1.5.9-9
   │     │  ├─ krb5/libkrb5-3 @ 1.15-1+deb9u2
   │     │  │  ├─ e2fsprogs/libcomerr2 @ 1.43.4-2
   │     │  │  ├─ keyutils/libkeyutils1 @ 1.5.9-9
   │     │  │  ├─ krb5/libk5crypto3 @ 1.15-1+deb9u2
   │     │  │  └─ krb5/libkrb5support0 @ 1.15-1+deb9u2
   │     │  └─ krb5/libkrb5support0 @ 1.15-1+deb9u2
   │     ├─ krb5/libk5crypto3 @ 1.15-1+deb9u2
   │     ├─ krb5/libkrb5-3 @ 1.15-1+deb9u2
   │     ├─ libidn2-0 @ 0.16-1+deb9u1
   │     │  └─ libunistring/libunistring0 @ 0.9.6+really0.9.3-0.1
   │     ├─ libpsl/libpsl5 @ 0.17.0-3
   │     │  ├─ libidn2-0 @ 0.16-1+deb9u1
   │     │  └─ libunistring/libunistring0 @ 0.9.6+really0.9.3-0.1
   │     ├─ libssh2/libssh2-1 @ 1.7.0-1+deb9u1
   │     │  └─ libgcrypt20 @ 1.7.6-2+deb9u3
   │     │     └─ libgpg-error/libgpg-error0 @ 1.26-2
   │     ├─ nghttp2/libnghttp2-14 @ 1.18.1-1+deb9u1
   │     ├─ openldap/libldap-2.4-2 @ 2.4.44+dfsg-5+deb9u8
   │     │  ├─ cyrus-sasl2/libsasl2-2 @ 2.1.27~101-g0780600+dfsg-3+deb9u1
   │     │  │  └─ cyrus-sasl2/libsasl2-modules-db @ 2.1.27~101-g0780600+dfsg-3+deb9u1
   │     │  │     └─ db5.3/libdb5.3 @ 5.3.28-12+deb9u1
   │     │  ├─ gnutls28/libgnutls30 @ 3.5.8-5+deb9u5
   │     │  │  ├─ gmp/libgmp10 @ 2:6.1.2+dfsg-1
   │     │  │  ├─ libidn/libidn11 @ 1.33-1+deb9u1
   │     │  │  ├─ libtasn1-6 @ 4.10-1.1+deb9u1
   │     │  │  ├─ nettle/libhogweed4 @ 3.3-1+b2
   │     │  │  │  ├─ gmp/libgmp10 @ 2:6.1.2+dfsg-1
   │     │  │  │  └─ nettle/libnettle6 @ 3.3-1+b2
   │     │  │  ├─ nettle/libnettle6 @ 3.3-1+b2
   │     │  │  └─ p11-kit/libp11-kit0 @ 0.23.3-2+deb9u1
   │     │  │     └─ libffi/libffi6 @ 3.2.1-6
   │     │  └─ openldap/libldap-common @ 2.4.44+dfsg-5+deb9u8
   │     ├─ openssl1.0/libssl1.0.2 @ 1.0.2u-1~deb9u4
   │     └─ rtmpdump/librtmp1 @ 2.4+20151223.gitfa8646d.1-1+b1
   │        ├─ gmp/libgmp10 @ 2:6.1.2+dfsg-1
   │        ├─ gnutls28/libgnutls30 @ 3.5.8-5+deb9u5
   │        ├─ nettle/libhogweed4 @ 3.3-1+b2
   │        └─ nettle/libnettle6 @ 3.3-1+b2
   ├─ dash @ 0.5.8-2.4
   ├─ debian-archive-keyring @ 2017.5
   │  └─ gnupg2/gpgv @ 2.1.18-8~deb9u4
   ├─ debianutils @ 4.8.1.1
   │  └─ sensible-utils @ 0.0.9+deb9u1
   ├─ diffutils @ 1:3.5-3
   ├─ e2fsprogs @ 1.43.4-2
   │  ├─ e2fsprogs/e2fslibs @ 1.43.4-2
   │  ├─ e2fsprogs/libcomerr2 @ 1.43.4-2
   │  ├─ e2fsprogs/libss2 @ 1.43.4-2
   │  ├─ util-linux @ 2.29.2-1+deb9u1
   │  │  ├─ ncurses/libncursesw5 @ 6.0+20161126-1+deb9u2
   │  │  ├─ ncurses/libtinfo5 @ 6.0+20161126-1+deb9u2
   │  │  ├─ systemd/libsystemd0 @ 232-25+deb9u9
   │  │  ├─ systemd/libudev1 @ 232-25+deb9u9
   │  │  ├─ util-linux/libblkid1 @ 2.29.2-1+deb9u1
   │  │  ├─ util-linux/libfdisk1 @ 2.29.2-1+deb9u1
   │  │  ├─ util-linux/libmount1 @ 2.29.2-1+deb9u1
   │  │  ├─ util-linux/libsmartcols1 @ 2.29.2-1+deb9u1
   │  │  └─ util-linux/libuuid1 @ 2.29.2-1+deb9u1
   │  ├─ util-linux/libblkid1 @ 2.29.2-1+deb9u1
   │  └─ util-linux/libuuid1 @ 2.29.2-1+deb9u1
   ├─ e2fsprogs/e2fslibs @ 1.43.4-2
   ├─ e2fsprogs/libss2 @ 1.43.4-2
   │  └─ e2fsprogs/libcomerr2 @ 1.43.4-2
   ├─ findutils @ 4.6.0+git+20161106-2
   ├─ gettext/gettext-base @ 0.19.8.1-2
   ├─ glibc/libc-bin @ 2.24-11+deb9u4
   ├─ gnupg2/gpgv @ 2.1.18-8~deb9u4
   │  ├─ libgcrypt20 @ 1.7.6-2+deb9u3
   │  └─ libgpg-error/libgpg-error0 @ 1.26-2
   ├─ grep @ 2.27-2
   ├─ gzip/gzip @ 1.6-5+b1
   ├─ hostname/hostname @ 3.18+b1
   ├─ lz4/liblz4-1 @ 0.0~r131-2+b1
   ├─ mawk/mawk @ 1.3.3-17+b3
   ├─ meta-common-packages @ meta
   │  ├─ acl/libacl1 @ 2.2.52-3+b1
   │  ├─ attr/libattr1 @ 1:2.4.47-2+b2
   │  ├─ audit/libaudit-common @ 1:2.6.7-2
   │  ├─ audit/libaudit1 @ 1:2.6.7-2
   │  ├─ bzip2/libbz2-1.0 @ 1.0.6-8.1
   │  ├─ debconf @ 1.5.61
   │  ├─ dpkg @ 1.18.25
   │  ├─ gcc-6/gcc-6-base @ 6.3.0-18+deb9u1
   │  ├─ gcc-6/libgcc1 @ 1:6.3.0-18+deb9u1
   │  ├─ glibc/libc6 @ 2.24-11+deb9u4
   │  ├─ glibc/multiarch-support @ 2.24-11+deb9u4
   │  ├─ libcap-ng/libcap-ng0 @ 0.7.7-3+b1
   │  ├─ libselinux/libselinux1 @ 2.6-3+b3
   │  ├─ pam/libpam0g @ 1.1.8-3.6
   │  ├─ pcre3/libpcre3 @ 2:8.39-3
   │  ├─ perl/perl-base @ 5.24.1-3+deb9u5
   │  ├─ tar @ 1.29b-1.1
   │  ├─ xz-utils/liblzma5 @ 5.2.2-1.2+b1
   │  └─ zlib/zlib1g @ 1:1.2.8.dfsg-5
   ├─ ncurses/libncursesw5 @ 6.0+20161126-1+deb9u2
   │  └─ ncurses/libtinfo5 @ 6.0+20161126-1+deb9u2
   ├─ ncurses/ncurses-base @ 6.0+20161126-1+deb9u2
   ├─ ncurses/ncurses-bin @ 6.0+20161126-1+deb9u2
   │  └─ ncurses/libtinfo5 @ 6.0+20161126-1+deb9u2
   ├─ nginx @ 1.14.2-1~stretch
   ├─ nginx-module-geoip @ 1.14.2-1~stretch
   │  ├─ geoip/libgeoip1 @ 1.6.9-4
   │  └─ nginx @ 1.14.2-1~stretch
   ├─ nginx-module-image-filter @ 1.14.2-1~stretch
   │  ├─ libgd2/libgd3 @ 2.2.4-2+deb9u4
   │  │  ├─ fontconfig/libfontconfig1 @ 2.11.0-6.7+b1
   │  │  │  ├─ expat/libexpat1 @ 2.2.0-2+deb9u1
   │  │  │  ├─ fontconfig/fontconfig-config @ 2.11.0-6.7
   │  │  │  │  ├─ fonts-dejavu/fonts-dejavu-core @ 2.37-1
   │  │  │  │  └─ ucf @ 3.0036
   │  │  │  │     └─ coreutils @ 8.26-3
   │  │  │  └─ freetype/libfreetype6 @ 2.6.3-3.2
   │  │  │     └─ libpng1.6/libpng16-16 @ 1.6.28-1
   │  │  ├─ freetype/libfreetype6 @ 2.6.3-3.2
   │  │  ├─ libjpeg-turbo/libjpeg62-turbo @ 1:1.5.1-2
   │  │  ├─ libpng1.6/libpng16-16 @ 1.6.28-1
   │  │  ├─ libwebp/libwebp6 @ 0.5.2-1
   │  │  ├─ libx11/libx11-6 @ 2:1.6.4-3+deb9u1
   │  │  │  ├─ libx11/libx11-data @ 2:1.6.4-3+deb9u1
   │  │  │  └─ libxcb/libxcb1 @ 1.12-1
   │  │  │     ├─ libxau/libxau6 @ 1:1.0.8-1
   │  │  │     └─ libxdmcp/libxdmcp6 @ 1:1.1.2-3
   │  │  │        └─ libbsd/libbsd0 @ 0.8.3-1
   │  │  ├─ libxpm/libxpm4 @ 1:3.5.12-1
   │  │  │  └─ libx11/libx11-6 @ 2:1.6.4-3+deb9u1
   │  │  └─ tiff/libtiff5 @ 4.0.8-2+deb9u4
   │  │     ├─ jbigkit/libjbig0 @ 2.1-3.1+b2
   │  │     └─ libjpeg-turbo/libjpeg62-turbo @ 1:1.5.1-2
   │  └─ nginx @ 1.14.2-1~stretch
   ├─ nginx-module-njs @ 1.14.2.0.2.6-1~stretch
   │  ├─ libedit/libedit2 @ 3.1-20160903-3
   │  │  ├─ libbsd/libbsd0 @ 0.8.3-1
   │  │  ├─ ncurses/libncurses5 @ 6.0+20161126-1+deb9u2
   │  │  │  └─ ncurses/libtinfo5 @ 6.0+20161126-1+deb9u2
   │  │  └─ ncurses/libtinfo5 @ 6.0+20161126-1+deb9u2
   │  └─ nginx @ 1.14.2-1~stretch
   │     ├─ adduser @ 3.115
   │     │  └─ shadow/passwd @ 1:4.4-4.1
   │     │     ├─ libsemanage/libsemanage1 @ 2.6-2
   │     │     │  ├─ libsemanage/libsemanage-common @ 2.6-2
   │     │     │  ├─ libsepol/libsepol1 @ 2.6-2
   │     │     │  └─ ustr/libustr-1.0-1 @ 1.0.4-6
   │     │     └─ pam/libpam-modules @ 1.1.8-3.6
   │     │        ├─ db5.3/libdb5.3 @ 5.3.28-12+deb9u1
   │     │        └─ pam/libpam-modules-bin @ 1.1.8-3.6
   │     ├─ init-system-helpers @ 1.48
   │     ├─ lsb/lsb-base @ 9.20161125
   │     └─ openssl/libssl1.1 @ 1.1.0j-1~deb9u1
   ├─ nginx-module-xslt @ 1.14.2-1~stretch
   │  ├─ libxml2 @ 2.9.4+dfsg1-2.2+deb9u2
   │  │  └─ icu/libicu57 @ 57.1-6+deb9u2
   │  │     └─ gcc-6/libstdc++6 @ 6.3.0-18+deb9u1
   │  ├─ libxslt/libxslt1.1 @ 1.1.29-2.1
   │  │  ├─ libgcrypt20 @ 1.7.6-2+deb9u3
   │  │  └─ libxml2 @ 2.9.4+dfsg1-2.2+deb9u2
   │  └─ nginx @ 1.14.2-1~stretch
   ├─ pam/libpam-runtime @ 1.1.8-3.6
   │  └─ pam/libpam-modules @ 1.1.8-3.6
   ├─ sed @ 4.4-1
   ├─ sensible-utils @ 0.0.9+deb9u1
   ├─ shadow/login @ 1:4.4-4.1
   │  ├─ pam/libpam-modules @ 1.1.8-3.6
   │  └─ pam/libpam-runtime @ 1.1.8-3.6
   ├─ systemd/libsystemd0 @ 232-25+deb9u9
   ├─ systemd/libudev1 @ 232-25+deb9u9
   ├─ sysvinit/sysvinit-utils @ 2.88dsf-59.9
   │  ├─ init-system-helpers @ 1.48
   │  └─ util-linux @ 2.29.2-1+deb9u1
   ├─ tzdata @ 2018i-0+deb9u1
   ├─ util-linux @ 2.29.2-1+deb9u1
   ├─ util-linux/bsdutils @ 1:2.29.2-1+deb9u1
   │  └─ systemd/libsystemd0 @ 232-25+deb9u9
   │     ├─ libgcrypt20 @ 1.7.6-2+deb9u3
   │     └─ lz4/liblz4-1 @ 0.0~r131-2+b1
   ├─ util-linux/libblkid1 @ 2.29.2-1+deb9u1
   ├─ util-linux/libfdisk1 @ 2.29.2-1+deb9u1
   │  ├─ util-linux/libblkid1 @ 2.29.2-1+deb9u1
   │  └─ util-linux/libuuid1 @ 2.29.2-1+deb9u1
   ├─ util-linux/libmount1 @ 2.29.2-1+deb9u1
   ├─ util-linux/libsmartcols1 @ 2.29.2-1+deb9u1
   ├─ util-linux/libuuid1 @ 2.29.2-1+deb9u1
   │  └─ shadow/passwd @ 1:4.4-4.1
   └─ util-linux/mount @ 2.29.2-1+deb9u1
      ├─ systemd/libudev1 @ 232-25+deb9u9
      ├─ util-linux/libblkid1 @ 2.29.2-1+deb9u1
      │  └─ util-linux/libuuid1 @ 2.29.2-1+deb9u1
      ├─ util-linux/libmount1 @ 2.29.2-1+deb9u1
      │  └─ util-linux/libblkid1 @ 2.29.2-1+deb9u1
      └─ util-linux/libsmartcols1 @ 2.29.2-1+deb9u1

Testing php-basic-nginx:latest...

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-1079069
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-1079072
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405199
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405263
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Divide By Zero
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405343
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405386
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405476
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405857
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Missing Release of Resource after Effective Lifetime
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-406147
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tiff/libtiff5
  Description: Memory Leak
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-406359
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tar
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TAR-1063003
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > tar@1.29b-1.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tar
  Description: CVE-2005-2541
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TAR-312330
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > tar@1.29b-1.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in tar
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TAR-341215
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > tar@1.29b-1.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Authentication Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-1291055
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-305045
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-305135
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-305139
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Link Following
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-305143
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Link Following
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-305165
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Missing Release of Resource after Effective Lifetime
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-542812
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in systemd/libsystemd0
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-570989
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in shadow/passwd
  Description: Time-of-check Time-of-use (TOCTOU)
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SHADOW-306204
  Introduced through: util-linux/libuuid1@2.29.2-1+deb9u1, nginx-module-njs@1.14.2.0.2.6-1~stretch, shadow/login@1:4.4-4.1
  From: util-linux/libuuid1@2.29.2-1+deb9u1 > shadow/passwd@1:4.4-4.1
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > adduser@3.115 > shadow/passwd@1:4.4-4.1
  From: shadow/login@1:4.4-4.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in shadow/passwd
  Description: Incorrect Permission Assignment for Critical Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SHADOW-306229
  Introduced through: util-linux/libuuid1@2.29.2-1+deb9u1, nginx-module-njs@1.14.2.0.2.6-1~stretch, shadow/login@1:4.4-4.1
  From: util-linux/libuuid1@2.29.2-1+deb9u1 > shadow/passwd@1:4.4-4.1
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > adduser@3.115 > shadow/passwd@1:4.4-4.1
  From: shadow/login@1:4.4-4.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in shadow/passwd
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SHADOW-306249
  Introduced through: util-linux/libuuid1@2.29.2-1+deb9u1, nginx-module-njs@1.14.2.0.2.6-1~stretch, shadow/login@1:4.4-4.1
  From: util-linux/libuuid1@2.29.2-1+deb9u1 > shadow/passwd@1:4.4-4.1
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > adduser@3.115 > shadow/passwd@1:4.4-4.1
  From: shadow/login@1:4.4-4.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in shadow/passwd
  Description: Incorrect Permission Assignment for Critical Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SHADOW-539860
  Introduced through: util-linux/libuuid1@2.29.2-1+deb9u1, nginx-module-njs@1.14.2.0.2.6-1~stretch, shadow/login@1:4.4-4.1
  From: util-linux/libuuid1@2.29.2-1+deb9u1 > shadow/passwd@1:4.4-4.1
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > adduser@3.115 > shadow/passwd@1:4.4-4.1
  From: shadow/login@1:4.4-4.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in perl/perl-base
  Description: Link Following
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PERL-327792
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > perl/perl-base@5.24.1-3+deb9u5
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PCRE3-345320
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PCRE3-345352
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Uncontrolled Recursion
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PCRE3-345501
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PCRE3-345529
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in pcre3/libpcre3
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PCRE3-572352
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in openssl/libssl1.1
  Description: Cryptographic Issues
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-374708
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in openssl/libssl1.1
  Description: Cryptographic Issues
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-374995
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in openssl/libssl1.1
  Description: Missing Encryption of Sensitive Data
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-466473
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.0l-1~deb9u1

✗ Low severity vulnerability found in openssl/libssl1.1
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-536850
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Improper Initialization
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENLDAP-304600
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > openldap/libldap-common@2.4.44+dfsg-5+deb9u8
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Cryptographic Issues
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENLDAP-304653
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > openldap/libldap-common@2.4.44+dfsg-5+deb9u8
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENLDAP-304665
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > openldap/libldap-common@2.4.44+dfsg-5+deb9u8
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in openldap/libldap-common
  Description: Improper Certificate Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENLDAP-584935
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > openldap/libldap-common@2.4.44+dfsg-5+deb9u8
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in nginx
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NGINX-341070
  Introduced through: nginx@1.14.2-1~stretch, nginx-module-geoip@1.14.2-1~stretch, nginx-module-image-filter@1.14.2-1~stretch, nginx-module-xslt@1.14.2-1~stretch, nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx@1.14.2-1~stretch
  From: nginx-module-geoip@1.14.2-1~stretch > nginx@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > nginx@1.14.2-1~stretch
  and 2 more...
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in nginx
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NGINX-341086
  Introduced through: nginx@1.14.2-1~stretch, nginx-module-geoip@1.14.2-1~stretch, nginx-module-image-filter@1.14.2-1~stretch, nginx-module-xslt@1.14.2-1~stretch, nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx@1.14.2-1~stretch
  From: nginx-module-geoip@1.14.2-1~stretch > nginx@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > nginx@1.14.2-1~stretch
  and 2 more...
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in nghttp2/libnghttp2-14
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NGHTTP2-351879
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > nghttp2/libnghttp2-14@1.18.1-1+deb9u1
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in nettle/libnettle6
  Description: CVE-2021-3580
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NETTLE-1301267
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-1+b1 > nettle/libnettle6@3.3-1+b2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5 > nettle/libnettle6@3.3-1+b2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5 > nettle/libhogweed4@3.3-1+b2 > nettle/libnettle6@3.3-1+b2
  and 2 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in ncurses/libtinfo5
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NCURSES-343181
  Introduced through: bash@4.4-5, ncurses/libncursesw5@6.0+20161126-1+deb9u2, ncurses/ncurses-bin@6.0+20161126-1+deb9u2, e2fsprogs@1.43.4-2, nginx-module-njs@1.14.2.0.2.6-1~stretch, ncurses/ncurses-base@6.0+20161126-1+deb9u2
  From: bash@4.4-5 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  From: ncurses/libncursesw5@6.0+20161126-1+deb9u2 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  From: ncurses/ncurses-bin@6.0+20161126-1+deb9u2 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  and 8 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in ncurses/libtinfo5
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NCURSES-473135
  Introduced through: bash@4.4-5, ncurses/libncursesw5@6.0+20161126-1+deb9u2, ncurses/ncurses-bin@6.0+20161126-1+deb9u2, e2fsprogs@1.43.4-2, nginx-module-njs@1.14.2.0.2.6-1~stretch, ncurses/ncurses-base@6.0+20161126-1+deb9u2
  From: bash@4.4-5 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  From: ncurses/libncursesw5@6.0+20161126-1+deb9u2 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  From: ncurses/ncurses-bin@6.0+20161126-1+deb9u2 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  and 8 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in ncurses/libtinfo5
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NCURSES-473138
  Introduced through: bash@4.4-5, ncurses/libncursesw5@6.0+20161126-1+deb9u2, ncurses/ncurses-bin@6.0+20161126-1+deb9u2, e2fsprogs@1.43.4-2, nginx-module-njs@1.14.2.0.2.6-1~stretch, ncurses/ncurses-base@6.0+20161126-1+deb9u2
  From: bash@4.4-5 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  From: ncurses/libncursesw5@6.0+20161126-1+deb9u2 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  From: ncurses/ncurses-bin@6.0+20161126-1+deb9u2 > ncurses/libtinfo5@6.0+20161126-1+deb9u2
  and 8 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in lz4/liblz4-1
  Description: Buffer Overflow
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LZ4-473077
  Introduced through: lz4/liblz4-1@0.0~r131-2+b1, apt/libapt-pkg5.0@1.4.9, util-linux/bsdutils@1:2.29.2-1+deb9u1
  From: lz4/liblz4-1@0.0~r131-2+b1
  From: apt/libapt-pkg5.0@1.4.9 > lz4/liblz4-1@0.0~r131-2+b1
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9 > lz4/liblz4-1@0.0~r131-2+b1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libxslt/libxslt1.1
  Description: Use of Insufficiently Random Values
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXSLT-308012
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libxml2
  Description: CVE-2021-3541
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-1293203
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u5

✗ Low severity vulnerability found in libwebp/libwebp6
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-277881
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libtasn1-6
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBTASN16-339584
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5 > libtasn1-6@4.10-1.1+deb9u1
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in libssh2/libssh2-1
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBSSH2-474375
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > libssh2/libssh2-1@1.7.0-1+deb9u1
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in libpng1.6/libpng16-16
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBPNG16-296439
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libpng1.6/libpng16-16@1.6.28-1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > freetype/libfreetype6@2.6.3-3.2 > libpng1.6/libpng16-16@1.6.28-1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libpng1.6/libpng16-16
  Description: Memory Leak
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBPNG16-296467
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libpng1.6/libpng16-16@1.6.28-1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > freetype/libfreetype6@2.6.3-3.2 > libpng1.6/libpng16-16@1.6.28-1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libpng1.6/libpng16-16
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBPNG16-296470
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libpng1.6/libpng16-16@1.6.28-1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > freetype/libfreetype6@2.6.3-3.2 > libpng1.6/libpng16-16@1.6.28-1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-1298593
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-299878
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-481424
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Excessive Iteration
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-572942
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libgd2/libgd3
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBGD2-548726
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in libgcrypt20
  Description: Use of a Broken or Risky Cryptographic Algorithm
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBGCRYPT20-391901
  Introduced through: gnupg2/gpgv@2.1.18-8~deb9u4, util-linux/bsdutils@1:2.29.2-1+deb9u1, nginx-module-xslt@1.14.2-1~stretch, curl@7.52.1-5+deb9u14
  From: gnupg2/gpgv@2.1.18-8~deb9u4 > libgcrypt20@1.7.6-2+deb9u3
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9 > libgcrypt20@1.7.6-2+deb9u3
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libgcrypt20@1.7.6-2+deb9u3
  and 1 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-395791
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: Double Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-395844
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: CVE-2004-0971
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-395882
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-395954
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: LDAP Injection
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-396210
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in krb5/libkrb5support0
  Description: Reachable Assertion
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-396226
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in jbigkit/libjbig0
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-JBIGKIT-289887
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > jbigkit/libjbig0@2.1-3.1+b2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in gnutls28/libgnutls30
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GNUTLS28-340754
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-1+b1 > gnutls28/libgnutls30@3.5.8-5+deb9u5
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in gnupg2/gpgv
  Description: Key Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GNUPG2-340421
  Introduced through: gnupg2/gpgv@2.1.18-8~deb9u4, debian-archive-keyring@2017.5, apt@1.4.9
  From: gnupg2/gpgv@2.1.18-8~deb9u4
  From: debian-archive-keyring@2017.5 > gnupg2/gpgv@2.1.18-8~deb9u4
  From: apt@1.4.9 > gnupg2/gpgv@2.1.18-8~deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in gnupg2/gpgv
  Description: Use of a Broken or Risky Cryptographic Algorithm
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GNUPG2-535537
  Introduced through: gnupg2/gpgv@2.1.18-8~deb9u4, debian-archive-keyring@2017.5, apt@1.4.9
  From: gnupg2/gpgv@2.1.18-8~deb9u4
  From: debian-archive-keyring@2017.5 > gnupg2/gpgv@2.1.18-8~deb9u4
  From: apt@1.4.9 > gnupg2/gpgv@2.1.18-8~deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Double Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-1078994
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Uncontrolled Recursion
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-338103
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Uncontrolled Recursion
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-338175
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356366
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356370
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Improper Data Handling
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356500
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Improper Resource Shutdown or Release
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356631
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356670
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Resource Management Errors
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356734
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: CVE-2010-4051
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356874
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-453121
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-453364
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Use of Insufficiently Random Values
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-453579
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-453766
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-534996
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in glibc/libc-bin
  Description: Integer Underflow
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-564230
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in gettext/gettext-base
  Description: Double Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GETTEXT-320220
  Introduced through: gettext/gettext-base@0.19.8.1-2
  From: gettext/gettext-base@0.19.8.1-2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in expat/libexpat1
  Description: XML External Entity (XXE) Injection
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-EXPAT-358078
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > expat/libexpat1@2.2.0-2+deb9u1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in curl/libcurl3
  Description: CVE-2021-22898
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-CURL-1296888
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Low severity vulnerability found in coreutils
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-COREUTILS-317464
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > fontconfig/fontconfig-config@2.11.0-6.7 > ucf@3.0036 > coreutils@8.26-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in coreutils
  Description: Race Condition
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-COREUTILS-317493
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > fontconfig/fontconfig-config@2.11.0-6.7 > ucf@3.0036 > coreutils@8.26-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in bash
  Description: Improper Check for Dropped Privileges
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-BASH-536274
  Introduced through: bash@4.4-5
  From: bash@4.4-5
  Image layer: Introduced by your base image (nginx:1.14)

✗ Low severity vulnerability found in apt/libapt-pkg5.0
  Description: Improper Verification of Cryptographic Signature
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-APT-407501
  Introduced through: apt/libapt-pkg5.0@1.4.9, apt@1.4.9
  From: apt/libapt-pkg5.0@1.4.9
  From: apt@1.4.9 > apt/libapt-pkg5.0@1.4.9
  From: apt@1.4.9
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in tiff/libtiff5
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-336739
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 4.0.8-2+deb9u5

✗ Medium severity vulnerability found in tiff/libtiff5
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405174
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 4.0.8-2+deb9u5

✗ Medium severity vulnerability found in tiff/libtiff5
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405183
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 4.0.8-2+deb9u5

✗ Medium severity vulnerability found in tiff/libtiff5
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-459344
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 4.0.8-2+deb9u5

✗ Medium severity vulnerability found in tar
  Description: Loop with Unreachable Exit Condition ('Infinite Loop')
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TAR-312293
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > tar@1.29b-1.1
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in systemd/libsystemd0
  Description: Race Condition
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-305070
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'
  Fixed in: 232-25+deb9u10

✗ Medium severity vulnerability found in pcre3/libpcre3
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PCRE3-572364
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > pcre3/libpcre3@2:8.39-3
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in openssl/libssl1.1
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-1049097
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.0l-1~deb9u2

✗ Medium severity vulnerability found in openssl/libssl1.1
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-1075336
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.0l-1~deb9u3

✗ Medium severity vulnerability found in openssl/libssl1.1
  Description: Missing Encryption of Sensitive Data
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-466469
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.0l-1~deb9u1

✗ Medium severity vulnerability found in nginx
  Description: CVE-2020-36309
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NGINX-1244846
  Introduced through: nginx@1.14.2-1~stretch, nginx-module-geoip@1.14.2-1~stretch, nginx-module-image-filter@1.14.2-1~stretch, nginx-module-xslt@1.14.2-1~stretch, nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx@1.14.2-1~stretch
  From: nginx-module-geoip@1.14.2-1~stretch > nginx@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > nginx@1.14.2-1~stretch
  and 2 more...
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in nettle/libnettle6
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NETTLE-302009
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-1+b1 > nettle/libnettle6@3.3-1+b2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5 > nettle/libnettle6@3.3-1+b2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5 > nettle/libhogweed4@3.3-1+b2 > nettle/libnettle6@3.3-1+b2
  and 2 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Medium severity vulnerability found in libxml2
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-1290156
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u4

✗ Medium severity vulnerability found in libxml2
  Description: Loop with Unreachable Exit Condition ('Infinite Loop')
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429392
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ Medium severity vulnerability found in libxml2
  Description: XML External Entity (XXE) Injection
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429495
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in libxml2
  Description: Allocation of Resources Without Limits or Throttling
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429525
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ Medium severity vulnerability found in libxml2
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429728
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in libxml2
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-609786
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ Medium severity vulnerability found in libx11/libx11-data
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBX11-597126
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libx11/libx11-6@2:1.6.4-3+deb9u1 > libx11/libx11-data@2:1.6.4-3+deb9u1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libx11/libx11-6@2:1.6.4-3+deb9u1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libxpm/libxpm4@1:3.5.12-1 > libx11/libx11-6@2:1.6.4-3+deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2:1.6.4-3+deb9u2

✗ Medium severity vulnerability found in libpng1.6/libpng16-16
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBPNG16-296445
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libpng1.6/libpng16-16@1.6.28-1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > freetype/libfreetype6@2.6.3-3.2 > libpng1.6/libpng16-16@1.6.28-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.6.28-1+deb9u1

✗ Medium severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Divide By Zero
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-299865
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1:1.5.1-2+deb9u1

✗ Medium severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-340684
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1:1.5.1-2+deb9u1

✗ Medium severity vulnerability found in libgd2/libgd3
  Description: Use of Uninitialized Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBGD2-349173
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.2.4-2+deb9u5

✗ Medium severity vulnerability found in libgcrypt20
  Description: Race Condition
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBGCRYPT20-460491
  Introduced through: gnupg2/gpgv@2.1.18-8~deb9u4, util-linux/bsdutils@1:2.29.2-1+deb9u1, nginx-module-xslt@1.14.2-1~stretch, curl@7.52.1-5+deb9u14
  From: gnupg2/gpgv@2.1.18-8~deb9u4 > libgcrypt20@1.7.6-2+deb9u3
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9 > libgcrypt20@1.7.6-2+deb9u3
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libgcrypt20@1.7.6-2+deb9u3
  and 1 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Medium severity vulnerability found in krb5/libkrb5support0
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-396036
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Medium severity vulnerability found in krb5/libkrb5support0
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-KRB5-396218
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libk5crypto3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > krb5/libgssapi-krb5-2@1.15-1+deb9u2 > krb5/libkrb5-3@1.15-1+deb9u2 > krb5/libkrb5support0@1.15-1+deb9u2
  and 6 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Medium severity vulnerability found in gnutls28/libgnutls30
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GNUTLS28-340579
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-1+b1 > gnutls28/libgnutls30@3.5.8-5+deb9u5
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Loop with Unreachable Exit Condition ('Infinite Loop')
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-1035461
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-1055402
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Allocation of Resources Without Limits or Throttling
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356559
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356682
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in glibc/libc-bin
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-559182
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ Medium severity vulnerability found in freetype/libfreetype6
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-FREETYPE-1019584
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > freetype/libfreetype6@2.6.3-3.2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > freetype/libfreetype6@2.6.3-3.2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.6.3-3.2+deb9u2

✗ Medium severity vulnerability found in e2fsprogs/libcomerr2
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-E2FSPROGS-468975
  Introduced through: e2fsprogs/libss2@1.43.4-2, e2fsprogs@1.43.4-2, curl@7.52.1-5+deb9u14, e2fsprogs/e2fslibs@1.43.4-2
  From: e2fsprogs/libss2@1.43.4-2 > e2fsprogs/libcomerr2@1.43.4-2
  From: e2fsprogs@1.43.4-2 > e2fsprogs/libcomerr2@1.43.4-2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > e2fsprogs/libcomerr2@1.43.4-2
  and 7 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'
  Fixed in: 1.43.4-2+deb9u1

✗ Medium severity vulnerability found in e2fsprogs/libcomerr2
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-E2FSPROGS-540843
  Introduced through: e2fsprogs/libss2@1.43.4-2, e2fsprogs@1.43.4-2, curl@7.52.1-5+deb9u14, e2fsprogs/e2fslibs@1.43.4-2
  From: e2fsprogs/libss2@1.43.4-2 > e2fsprogs/libcomerr2@1.43.4-2
  From: e2fsprogs@1.43.4-2 > e2fsprogs/libcomerr2@1.43.4-2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > e2fsprogs/libcomerr2@1.43.4-2
  and 7 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'
  Fixed in: 1.43.4-2+deb9u2

✗ Medium severity vulnerability found in apt/libapt-pkg5.0
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-APT-1049972
  Introduced through: apt/libapt-pkg5.0@1.4.9, apt@1.4.9
  From: apt/libapt-pkg5.0@1.4.9
  From: apt@1.4.9 > apt/libapt-pkg5.0@1.4.9
  From: apt@1.4.9
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.4.11

✗ Medium severity vulnerability found in apt/libapt-pkg5.0
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-APT-568929
  Introduced through: apt/libapt-pkg5.0@1.4.9, apt@1.4.9
  From: apt/libapt-pkg5.0@1.4.9
  From: apt@1.4.9 > apt/libapt-pkg5.0@1.4.9
  From: apt@1.4.9
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.4.10

✗ High severity vulnerability found in util-linux/libblkid1
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-UTILLINUX-285822
  Introduced through: util-linux/libblkid1@2.29.2-1+deb9u1, util-linux/libfdisk1@2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, util-linux/mount@2.29.2-1+deb9u1, util-linux/libmount1@2.29.2-1+deb9u1, util-linux/libsmartcols1@2.29.2-1+deb9u1, util-linux/libuuid1@2.29.2-1+deb9u1, util-linux@2.29.2-1+deb9u1, sysvinit/sysvinit-utils@2.88dsf-59.9, util-linux/bsdutils@1:2.29.2-1+deb9u1
  From: util-linux/libblkid1@2.29.2-1+deb9u1
  From: util-linux/libfdisk1@2.29.2-1+deb9u1 > util-linux/libblkid1@2.29.2-1+deb9u1
  From: e2fsprogs@1.43.4-2 > util-linux/libblkid1@2.29.2-1+deb9u1
  and 21 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ High severity vulnerability found in tiff/libtiff5
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-1078787
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in tiff/libtiff5
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-1078794
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in tiff/libtiff5
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405166
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 4.0.8-2+deb9u5

✗ High severity vulnerability found in tiff/libtiff5
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-405293
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 4.0.8-2+deb9u5

✗ High severity vulnerability found in tiff/libtiff5
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-TIFF-473085
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 4.0.8-2+deb9u5

✗ High severity vulnerability found in systemd/libsystemd0
  Description: Deserialization of Untrusted Data
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-305096
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'
  Fixed in: 232-25+deb9u10

✗ High severity vulnerability found in systemd/libsystemd0
  Description: Access Restriction Bypass
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-342746
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'
  Fixed in: 232-25+deb9u11

✗ High severity vulnerability found in systemd/libsystemd0
  Description: Incorrect Privilege Assignment
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-345383
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ High severity vulnerability found in systemd/libsystemd0
  Description: Privilege Chaining
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-345390
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ High severity vulnerability found in systemd/libsystemd0
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SYSTEMD-546478
  Introduced through: systemd/libsystemd0@232-25+deb9u9, util-linux/bsdutils@1:2.29.2-1+deb9u1, e2fsprogs@1.43.4-2, systemd/libudev1@232-25+deb9u9, util-linux/mount@2.29.2-1+deb9u1
  From: systemd/libsystemd0@232-25+deb9u9
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  From: e2fsprogs@1.43.4-2 > util-linux@2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9
  and 3 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ High severity vulnerability found in shadow/passwd
  Description: Improper Privilege Management
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SHADOW-1086623
  Introduced through: util-linux/libuuid1@2.29.2-1+deb9u1, nginx-module-njs@1.14.2.0.2.6-1~stretch, shadow/login@1:4.4-4.1
  From: util-linux/libuuid1@2.29.2-1+deb9u1 > shadow/passwd@1:4.4-4.1
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > adduser@3.115 > shadow/passwd@1:4.4-4.1
  From: shadow/login@1:4.4-4.1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1:4.4-4.1+deb9u1

✗ High severity vulnerability found in shadow/passwd
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-SHADOW-306269
  Introduced through: util-linux/libuuid1@2.29.2-1+deb9u1, nginx-module-njs@1.14.2.0.2.6-1~stretch, shadow/login@1:4.4-4.1
  From: util-linux/libuuid1@2.29.2-1+deb9u1 > shadow/passwd@1:4.4-4.1
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > adduser@3.115 > shadow/passwd@1:4.4-4.1
  From: shadow/login@1:4.4-4.1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1:4.4-4.1+deb9u1

✗ High severity vulnerability found in perl/perl-base
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PERL-570790
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > perl/perl-base@5.24.1-3+deb9u5
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 5.24.1-3+deb9u7

✗ High severity vulnerability found in perl/perl-base
  Description: Buffer Overflow
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PERL-570794
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > perl/perl-base@5.24.1-3+deb9u5
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 5.24.1-3+deb9u7

✗ High severity vulnerability found in perl/perl-base
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-PERL-570799
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > perl/perl-base@5.24.1-3+deb9u5
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 5.24.1-3+deb9u7

✗ High severity vulnerability found in openssl/libssl1.1
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-1075328
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.0l-1~deb9u3

✗ High severity vulnerability found in openssl/libssl1.1
  Description: Cryptographic Issues
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-OPENSSL-339889
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > nginx@1.14.2-1~stretch > openssl/libssl1.1@1.1.0j-1~deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.0k-1~deb9u1

✗ High severity vulnerability found in nettle/libnettle6
  Description: Use of a Broken or Risky Cryptographic Algorithm
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-NETTLE-1090207
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > rtmpdump/librtmp1@2.4+20151223.gitfa8646d.1-1+b1 > nettle/libnettle6@3.3-1+b2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5 > nettle/libnettle6@3.3-1+b2
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > openldap/libldap-2.4-2@2.4.44+dfsg-5+deb9u8 > gnutls28/libgnutls30@3.5.8-5+deb9u5 > nettle/libhogweed4@3.3-1+b2 > nettle/libnettle6@3.3-1+b2
  and 2 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ High severity vulnerability found in lz4/liblz4-1
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LZ4-1277599
  Introduced through: lz4/liblz4-1@0.0~r131-2+b1, apt/libapt-pkg5.0@1.4.9, util-linux/bsdutils@1:2.29.2-1+deb9u1
  From: lz4/liblz4-1@0.0~r131-2+b1
  From: apt/libapt-pkg5.0@1.4.9 > lz4/liblz4-1@0.0~r131-2+b1
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9 > lz4/liblz4-1@0.0~r131-2+b1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.0~r131-2+deb9u1

✗ High severity vulnerability found in libxslt/libxslt1.1
  Description: Improper Access Control
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXSLT-343263
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.29-2.1+deb9u1

✗ High severity vulnerability found in libxslt/libxslt1.1
  Description: Access of Resource Using Incompatible Type ('Type Confusion')
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXSLT-451291
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.29-2.1+deb9u1

✗ High severity vulnerability found in libxslt/libxslt1.1
  Description: Use of Uninitialized Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXSLT-451292
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.29-2.1+deb9u1

✗ High severity vulnerability found in libxslt/libxslt1.1
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXSLT-473886
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1.1.29-2.1+deb9u2

✗ High severity vulnerability found in libxml2
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-1277339
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u4

✗ High severity vulnerability found in libxml2
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-1277342
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u4

✗ High severity vulnerability found in libxml2
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-1277344
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u4

✗ High severity vulnerability found in libxml2
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429345
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in libxml2
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429367
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ High severity vulnerability found in libxml2
  Description: Loop with Unreachable Exit Condition ('Infinite Loop')
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429485
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in libxml2
  Description: NULL Pointer Dereference
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-429564
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ High severity vulnerability found in libxml2
  Description: Missing Release of Resource after Effective Lifetime
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-539774
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ High severity vulnerability found in libxml2
  Description: Loop with Unreachable Exit Condition ('Infinite Loop')
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-542924
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ High severity vulnerability found in libxml2
  Description: Improper Resource Shutdown or Release
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBXML2-542930
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libxml2@2.9.4+dfsg1-2.2+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.9.4+dfsg1-2.2+deb9u3

✗ High severity vulnerability found in libx11/libx11-data
  Description: Buffer Overflow
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBX11-1293571
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libx11/libx11-6@2:1.6.4-3+deb9u1 > libx11/libx11-data@2:1.6.4-3+deb9u1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libx11/libx11-6@2:1.6.4-3+deb9u1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libxpm/libxpm4@1:3.5.12-1 > libx11/libx11-6@2:1.6.4-3+deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2:1.6.4-3+deb9u4

✗ High severity vulnerability found in libx11/libx11-data
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBX11-608551
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libx11/libx11-6@2:1.6.4-3+deb9u1 > libx11/libx11-data@2:1.6.4-3+deb9u1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libx11/libx11-6@2:1.6.4-3+deb9u1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libxpm/libxpm4@1:3.5.12-1 > libx11/libx11-6@2:1.6.4-3+deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2:1.6.4-3+deb9u3

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289551
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289554
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289559
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289560
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289564
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289570
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-Bounds
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289571
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289577
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289578
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1289582
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libwebp/libwebp6
  Description: Use of Uninitialized Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBWEBP-1290151
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libwebp/libwebp6@0.5.2-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.5.2-1+deb9u1

✗ High severity vulnerability found in libssh2/libssh2-1
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBSSH2-453578
  Introduced through: curl@7.52.1-5+deb9u14
  From: curl@7.52.1-5+deb9u14 > curl/libcurl3@7.52.1-5+deb9u14 > libssh2/libssh2-1@1.7.0-1+deb9u1
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ High severity vulnerability found in libpng1.6/libpng16-16
  Description: Improper Input Validation
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBPNG16-452465
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libpng1.6/libpng16-16@1.6.28-1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > freetype/libfreetype6@2.6.3-3.2 > libpng1.6/libpng16-16@1.6.28-1
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-571503
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1:1.5.1-2+deb9u1

✗ High severity vulnerability found in libjpeg-turbo/libjpeg62-turbo
  Description: Resource Exhaustion
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBJPEGTURBO-572989
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > tiff/libtiff5@4.0.8-2+deb9u4 > libjpeg-turbo/libjpeg62-turbo@1:1.5.1-2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 1:1.5.1-2+deb9u1

✗ High severity vulnerability found in libgd2/libgd3
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBGD2-558916
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in libgcrypt20
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBGCRYPT20-1297891
  Introduced through: gnupg2/gpgv@2.1.18-8~deb9u4, util-linux/bsdutils@1:2.29.2-1+deb9u1, nginx-module-xslt@1.14.2-1~stretch, curl@7.52.1-5+deb9u14
  From: gnupg2/gpgv@2.1.18-8~deb9u4 > libgcrypt20@1.7.6-2+deb9u3
  From: util-linux/bsdutils@1:2.29.2-1+deb9u1 > systemd/libsystemd0@232-25+deb9u9 > libgcrypt20@1.7.6-2+deb9u3
  From: nginx-module-xslt@1.14.2-1~stretch > libxslt/libxslt1.1@1.1.29-2.1 > libgcrypt20@1.7.6-2+deb9u3
  and 1 more...
  Image layer: 'RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl'

✗ High severity vulnerability found in libbsd/libbsd0
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-LIBBSD-541044
  Introduced through: nginx-module-njs@1.14.2.0.2.6-1~stretch, nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-njs@1.14.2.0.2.6-1~stretch > libedit/libedit2@3.1-20160903-3 > libbsd/libbsd0@0.8.3-1
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > libx11/libx11-6@2:1.6.4-3+deb9u1 > libxcb/libxcb1@1.12-1 > libxdmcp/libxdmcp6@1:1.1.2-3 > libbsd/libbsd0@0.8.3-1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 0.8.3-1+deb9u1

✗ High severity vulnerability found in icu/libicu57
  Description: Integer Overflow or Wraparound
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-ICU-560091
  Introduced through: nginx-module-xslt@1.14.2-1~stretch
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2 > icu/libicu57@57.1-6+deb9u2
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 57.1-6+deb9u4

✗ High severity vulnerability found in gnupg2/gpgv
  Description: Cross-site Request Forgery (CSRF)
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GNUPG2-340461
  Introduced through: gnupg2/gpgv@2.1.18-8~deb9u4, debian-archive-keyring@2017.5, apt@1.4.9
  From: gnupg2/gpgv@2.1.18-8~deb9u4
  From: debian-archive-keyring@2017.5 > gnupg2/gpgv@2.1.18-8~deb9u4
  From: apt@1.4.9 > gnupg2/gpgv@2.1.18-8~deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Reachable Assertion
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-1065766
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-1296897
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Improper Data Handling
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-338160
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-338164
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356602
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356851
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-356862
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-559491
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in glibc/libc-bin
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GLIBC-559495
  Introduced through: glibc/libc-bin@2.24-11+deb9u4, meta-common-packages@meta
  From: glibc/libc-bin@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/libc6@2.24-11+deb9u4
  From: meta-common-packages@meta > glibc/multiarch-support@2.24-11+deb9u4
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in gcc-6/libstdc++6
  Description: Information Exposure
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-GCC6-347562
  Introduced through: apt/libapt-pkg5.0@1.4.9, apt@1.4.9, nginx-module-xslt@1.14.2-1~stretch, meta-common-packages@meta
  From: apt/libapt-pkg5.0@1.4.9 > gcc-6/libstdc++6@6.3.0-18+deb9u1
  From: apt@1.4.9 > gcc-6/libstdc++6@6.3.0-18+deb9u1
  From: nginx-module-xslt@1.14.2-1~stretch > libxml2@2.9.4+dfsg1-2.2+deb9u2 > icu/libicu57@57.1-6+deb9u2 > gcc-6/libstdc++6@6.3.0-18+deb9u1
  and 2 more...
  Image layer: Introduced by your base image (nginx:1.14)

✗ High severity vulnerability found in expat/libexpat1
  Description: XML External Entity (XXE) Injection
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-EXPAT-450910
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > expat/libexpat1@2.2.0-2+deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.2.0-2+deb9u2

✗ High severity vulnerability found in expat/libexpat1
  Description: Out-of-bounds Read
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-EXPAT-460773
  Introduced through: nginx-module-image-filter@1.14.2-1~stretch
  From: nginx-module-image-filter@1.14.2-1~stretch > libgd2/libgd3@2.2.4-2+deb9u4 > fontconfig/libfontconfig1@2.11.0-6.7+b1 > expat/libexpat1@2.2.0-2+deb9u1
  Image layer: Introduced by your base image (nginx:1.14)
  Fixed in: 2.2.0-2+deb9u3

✗ High severity vulnerability found in bzip2/libbz2-1.0
  Description: Out-of-bounds Write
  Info: https://snyk.io/vuln/SNYK-DEBIAN9-BZIP2-450801
  Introduced through: meta-common-packages@meta
  From: meta-common-packages@meta > bzip2/libbz2-1.0@1.0.6-8.1
  Image layer: Introduced by your base image (nginx:1.14)
```

</details><br>

```
Organization:      24x7classroom
Package manager:   deb
Target file:       /app/Dockerfile
Project name:      docker-image|php-basic-nginx
Docker image:      php-basic-nginx:latest
Platform:          linux/amd64
Base image:        nginx:1.14
Licenses:          enabled

Tested 135 dependencies for known issues, found 200 issues.

Base Image  Vulnerabilities  Severity
nginx:1.14  178              67 high, 33 medium, 78 low

Recommendations for base image upgrade:

Minor upgrades
Base Image      Vulnerabilities  Severity
nginx:mainline  114              32 high, 8 medium, 74 low

Alternative image types
Base Image           Vulnerabilities  Severity
nginx:mainline-perl  114              32 high, 8 medium, 74 low
```

> Dockerfile

	```
	FROM nginx:1.14
	
	# Install curl for health check
	RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y curl
	
	# Configure NGINX
	COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf
	
	# Copy static files
	COPY css /var/www/html/css
	COPY img /var/www/html/img
	RUN chown -R nginx:nginx /var/www/html
	
	HEALTHCHECK --interval=15s --timeout=10s --start-period=60s --retries=2 CMD curl -f http://127.0.0.1/health-check.php || exit 1
	```
