# aws-gate docker

<!-- vim-markdown-toc GFM -->

- [Devops Work](#devops-work)
- [Testing Works](#testing-works)

<!-- vim-markdown-toc -->

## Devops Work

- [x] Download or clone codes from [github][github repo]
- [x] Create `docker-compose` service definition
  - [x] Build from Dockerfile
- [x] Add target in GNU Make
  - [x] Build - `build-aws-gate`
  - [x] Run - `run-aws-gate`

> Code structure

```
└─ $ ▶ tree aws-gate-master -L 1
aws-gate-master
├── aws_gate
├── aws-gate.spec
├── bin
├── CHANGELOG.md
├── completions
├── Dockerfile
├── docs
├── LICENSE.md
├── MANIFEST.in
├── mkdocs.yml
├── README.md
├── requirements
├── setup.cfg
├── setup.py
├── tasks.py
└── tests
```

> docker-compose service definition

```yaml
version: '2.3'
services:
  aws-gate:
    build:
      context: .
      dockerfile: Dockerfile
    privileged: true
    userns_mode: "host"
    volumes:
      - "$HOME/.aws:/root/.aws"
    environment:
      - AWS_DEFAULT_REGION
      - AWS_PROFILE
      - AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY
      - AWS_SESSION_TOKEN

```

> Dockerfile

```
FROM python:3.7-alpine
WORKDIR /code

ADD requirements/ /code/requirements

RUN apk add --no-cache --virtual .build-deps \
    build-base openssl-dev pkgconfig libffi-dev \
    cups-dev jpeg-dev && \
    # libc6-compat is needed for running session-manager-plugin
    apk add --no-cache libc6-compat && \
    pip install --no-cache-dir -r /code/requirements/requirements.txt && \
    apk del .build-deps

COPY . ./
RUN pip install -e .
RUN aws-gate bootstrap

ENTRYPOINT ["aws-gate"]
CMD ["--help"]
```

> GNU Make targets

```make

build-aws-gate: ## Build aws-gate image
	@echo "--- Docker Compose Build aws-gate Image"
	@docker-compose -f tools/docker-compose.yml build aws-gate

run-aws-gate: ## Run aws-gate $(OPT)
	@echo "--- Run aws-gate"
	@docker-compose -f tools/docker-compose.yml run --rm aws-gate $(OPT)
```

## Testing Works

> GNU Make menu

```bash
└─ $ ▶ make

 Choose a command run:

build-aws-gate                           Build aws-gate image
run-aws-gate                             Run aws-gate $(OPT)
```

> Build Docker Image

```bash
└─ $ ▶ make build-aws-gate
--- Docker Compose Build aws-gate Image
Building aws-gate
Step 1/9 : FROM python:3.7-alpine
 ---> 7a4d14c605a2
Step 2/9 : WORKDIR /code
 ---> Using cache
 ---> dfe7cd9d8b46
Step 3/9 : ADD requirements/ /code/requirements
 ---> Using cache
 ---> c3b30a546e0c
Step 4/9 : RUN apk add --no-cache --virtual .build-deps     build-base openssl-dev pkgconfig libffi-dev     cups-dev jpeg-dev &&     apk add --no-cache libc6-compat &&     pip install --no-cache-dir -r /code/requirements/requirements.txt &&     apk del .build-deps
 ---> Using cache
 ---> c7c576effa3f
Step 5/9 : COPY aws-gate-master/ ./
 ---> a02c5b10c1b6
Step 6/9 : RUN pip install -e .
 ---> Running in 1c4ae7e9e9eb
Obtaining file:///code
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Requirement already satisfied: boto3~=1.26.36 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (1.26.64)
Requirement already satisfied: cryptography==36.0.1 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (36.0.1)
Requirement already satisfied: marshmallow==3.14.1 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (3.14.1)
Requirement already satisfied: packaging==21.3 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (21.3)
Requirement already satisfied: PyYAML<6.1,>=5.1 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (6.0)
Requirement already satisfied: requests==2.26.0 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (2.26.0)
Requirement already satisfied: unix-ar==0.2.1 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (0.2.1)
Requirement already satisfied: wrapt==1.13.3 in /usr/local/lib/python3.7/site-packages (from aws-gate==0.11.2) (1.13.3)
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.7/site-packages (from cryptography==36.0.1->aws-gate==0.11.2) (1.15.1)
Requirement already satisfied: pyparsing!=3.0.5,>=2.0.2 in /usr/local/lib/python3.7/site-packages (from packaging==21.3->aws-gate==0.11.2) (3.0.9)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.7/site-packages (from requests==2.26.0->aws-gate==0.11.2) (2022.12.7)
Requirement already satisfied: charset-normalizer~=2.0.0 in /usr/local/lib/python3.7/site-packages (from requests==2.26.0->aws-gate==0.11.2) (2.0.12)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.7/site-packages (from requests==2.26.0->aws-gate==0.11.2) (3.4)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/local/lib/python3.7/site-packages (from requests==2.26.0->aws-gate==0.11.2) (1.26.14)
Requirement already satisfied: s3transfer<0.7.0,>=0.6.0 in /usr/local/lib/python3.7/site-packages (from boto3~=1.26.36->aws-gate==0.11.2) (0.6.0)
Requirement already satisfied: botocore<1.30.0,>=1.29.64 in /usr/local/lib/python3.7/site-packages (from boto3~=1.26.36->aws-gate==0.11.2) (1.29.64)
Requirement already satisfied: jmespath<2.0.0,>=0.7.1 in /usr/local/lib/python3.7/site-packages (from boto3~=1.26.36->aws-gate==0.11.2) (1.0.1)
Requirement already satisfied: python-dateutil<3.0.0,>=2.1 in /usr/local/lib/python3.7/site-packages (from botocore<1.30.0,>=1.29.64->boto3~=1.26.36->aws-gate==0.11.2) (2.8.2)
Requirement already satisfied: pycparser in /usr/local/lib/python3.7/site-packages (from cffi>=1.12->cryptography==36.0.1->aws-gate==0.11.2) (2.21)
Requirement already satisfied: six>=1.5 in /usr/local/lib/python3.7/site-packages (from python-dateutil<3.0.0,>=2.1->botocore<1.30.0,>=1.29.64->boto3~=1.26.36->aws-gate==0.11.2) (1.16.0)
Installing collected packages: aws-gate
  Running setup.py develop for aws-gate
Successfully installed aws-gate-0.11.2
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
WARNING: You are using pip version 22.0.4; however, version 23.0 is available.
You should consider upgrading via the '/usr/local/bin/python -m pip install --upgrade pip' command.
Removing intermediate container 1c4ae7e9e9eb
 ---> d4a8f6e48ef4
Step 7/9 : RUN aws-gate bootstrap
 ---> Running in b80a0bbdb4f3
session-manager-plugin (version 1.2.398.0) installed successfully!
Removing intermediate container b80a0bbdb4f3
 ---> 87bee004467f
Step 8/9 : ENTRYPOINT ["aws-gate"]
 ---> Running in a6c1c31012d6
Removing intermediate container a6c1c31012d6
 ---> e0b58239e335
Step 9/9 : CMD ["--help"]
 ---> Running in 1a4b10e2347a
Removing intermediate container 1a4b10e2347a
 ---> 433ee483c969

Successfully built 433ee483c969
Successfully tagged tools_aws-gate:latest

└─ $ ▶ docker images
REPOSITORY                          TAG            IMAGE ID       CREATED          SIZE
tools_aws-gate                      latest         433ee483c969   26 minutes ago   177MB
```

> Test Run

```bash
└─ $ ▶ make run-aws-gate
--- Run aws-gate
usage: aws-gate [-h] [-v] [--version]
                {bootstrap,exec,session,ssh,ssh-config,ssh-proxy,list,ls} ...

aws-gate - AWS SSM Session Manager client CLI

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose         increase output verbosity
  --version             show program's version number and exit

subcommands:
  {bootstrap,exec,session,ssh,ssh-config,ssh-proxy,list,ls}
    bootstrap           Download and install session-manager-plugin
    exec                Execute interactive command on instance
    session             Open new session on instance and connect to it
    ssh                 Open SSH session on instance and connect to it
    ssh-config          Generate SSH configuration file
    ssh-proxy           Open new SSH proxy session to instance
    list (ls)           List available instances

jso@ubunu2004 /media/sf_projects/templates/IaC
└─ $ ▶ make run-aws-gate OPT=ls
--- Run aws-gate
i-0cac9e94a811d9bb8 jdr-pen-prd-batch-svr ap-southeast-2b vpc-0a8ba448ce1dcb3b5 10.13.22.178
i-03080121898a1545f auth-v21.1.0-asg-svr-a ap-southeast-2b vpc-0a8ba448ce1dcb3b5 10.13.12.205
i-0b45af958ff50a11c jdr-pen-prd-aplus-odd-v22.3.2-asg-svr-a ap-southeast-2c vpc-0a8ba448ce1dcb3b5 10.13.13.159
```

[github repo]: https://github.com/xen0l/aws-gate
