# On-demand include in Makefile

**Requirements List**
- [x] Environment
  - [x] Unix/Linux
- [x] Configuration
  - [x] GNU make

### Usage

Use `variable` to include other GNU make content into Makefile configuration

```make
# Set IaC-Core to true to fetch if not exists locally
Include-Other := true

# Use local first when exist, download from URL if not exists and validate checksum
-include other.mk
other.mk:
ifeq ("$(Include-Other)","true")
        @curl \
                -o Makefile.fetched \
                -sL "https://raw.githubusercontent.com/<user>/<repo>/main/other.mk"
        @echo "<sha256sum> *Makefile.fetched" \
                | sha256sum --quiet --check - \
                && mv Makefile.fetched $@
endif
```

### Example


<details><summary><b>Example #1 - coding and output </b></summary>

<script src="https://gist.github.com/JackySo-24x7classroom/c98f82ba474c299071fa9f3a26284f78.js"></script>

>**Read code**[![](https://img.shields.io/badge/Read-code-informational?style=flat&logo=linux&logoColor=white&color=2bbc8a)](https://gist.githubusercontent.com/JackySo-24x7classroom/c98f82ba474c299071fa9f3a26284f78/raw/2cf9fd988b5a1d91c68e3ceff6852e39d58f374a/gistfile0.txt)

>**Run example**

```bash
$  make -f Makefile-sample 
Makefile.fetched: OK

 Choose a command run:

blog-howto                               Howto - 
check-docker                             Check docker installed in $PATH and run docker info, install docker if missing
check-repo                               Check docker repo

$  make -f Makefile-sample sha256sum
96978bf6fcd4f1cf1e98abdc7ad1efbf5a5dae3d0c2332641fe14f91841acdd6  Makefile-sample
```

</details>
