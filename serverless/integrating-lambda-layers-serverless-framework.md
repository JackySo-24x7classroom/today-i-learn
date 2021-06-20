# Integrating Lambda Layers with the Serverless Framework

![Cover image](99a40ca0-5972-4b13-90ad-a458de7c18e1.jpg)

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Initializing a Project Using the Serverless Framework](#initializing-a-project-using-the-serverless-framework)
- [Releasing and Integrating the Lambda Layer](#releasing-and-integrating-the-lambda-layer)
- [Testing the Lambda with the Integrated Layer](#testing-the-lambda-with-the-integrated-layer)
- [Explore Serverless command and deployment](#explore-serverless-command-and-deployment)

<!-- vim-markdown-toc -->

> If you are building different microservices, you should fall into the scenario where you have to install the same library and/or package on the microservices. This could become painful when you have dozens of services to handle and maintain. A good solution would be to have the microservices pointing to a single entity that acts as a container for the packages used in the microservices.

> You can leverage AWS Lambda Layers with the Serverless Framework to achieve this result. A Lambda Layer is a container where you can put any kind of dependency that will be used from the Lambda functions. After creating it, you only need to link the Lambda to the Layer.

> Here, you will use the Serverless Framework to integrate a public Lambda Layer and to deploy a function that leverages it.

## Initializing a Project Using the Serverless Framework

> The Serverless Framework is a powerful tool to build and deploy serverless microservices. You can use it as a single point to define functions, resources, triggers, and permissions to assign to functions. You can also leverage the framework to use specific domains parts, such as Lambda layers for AWS.

`Workflow`

1. Create a new Serverless Framework project:

```bash
$ serverless create --template aws-python3

Serverless: Generating boilerplate...
 _______                             __
|   _   .-----.----.--.--.-----.----|  .-----.-----.-----.
|   |___|  -__|   _|  |  |  -__|   _|  |  -__|__ --|__ --|
|____   |_____|__|  \___/|_____|__| |__|_____|_____|_____|
|   |   |             The Serverless Application Framework
|       |                           serverless.com, v2.30.3
 -------'

Serverless: Successfully generated boilerplate for template: "aws-python3"
Serverless: NOTE: Please update the "service" property in serverless.yml with your service name
```

2. Setup AWS credential

```bash
root@1a08049e0407:/home/project# cat <<EOF > ~/.aws/credentials
> [default]
> aws_access_key_id = AKIA6IBU74TAPFRQFSUI
> aws_secret_access_key = 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
> EOF
root@1a08049e0407:/home/project# aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************FSUI shared-credentials-file
secret_key     ****************nqOu shared-credentials-file
    region                us-west-2      config-file    ~/.aws/config
root@1a08049e0407:/home/project#
```

3. Create folder `functions` and `__init__.py` into functions folder


```bash
root@1a08049e0407:/home/project# tree .
.
.
├── functions
│   └── __init__.py
├── handler.py
└── serverless.yml

1 directory, 3 files
```

## Releasing and Integrating the Lambda Layer

> Lambda layers are very important components when you have different microservices and you don't want to manually handle the dependencies for each one of them. You can use Lambda layers to easily maintain and distribute packages to different microservices.


`Workflow`

1. Create `test.py` in folder `functions`

```python
import json
import psycopg2

def test(event, context):
    try:
        conn = psycopg2.connect("dbname=test user=postgres")
    except Exception:
        print('Error occurred with the psycopg2 library')
    finally:
        return {
            'statusCode': 204
        }
```

> This function leverages the psycopg2 library, one of the most used and common Python libraries to work with PostgreSQL. The function handles a possible error because you don't have any DB to connect to.

> The Lambda layer you will integrate will inject the function the psycopg2 library needed.

2. Override the content of Lambda handler `handler.py` with:

```python
from functions.test import test
```

3. Override the content of Serverless configuration file `serverless.yml` with:

```yaml
service: serverless-lab

frameworkVersion: '2'

provider:
  name: aws
  runtime: python3.7
  lambdaHashingVersion: 20201221
  region: us-west-2 # MAKE SURE NOT TO CHANGE THIS
  timeout: 10 # You set a timeout of 10 seconds for the functions
  role: arn:aws:iam::979363685568:role/cloudacademylabs-ServerlessLambdaRole-Z3RVG2SEMGMS

functions:
  test:
    handler: handler.test
    layers:
      - arn:aws:lambda:us-west-2:898466741470:layer:psycopg2-py37:7
    events:
      - http:
          path: test
          method: get
```

> The layers property under the test function means the function is integrating the Lambda layers you specified. You can find more information about the public Lambda layer you integrated by visiting the [psycopg2-lambda-layer GitHub page](https://github.com/jetbridge/psycopg2-lambda-layer).

> To explore more public Lambda layers, you can find dozens by visiting the [AWSome Layers GitHub page](https://github.com/mthenw/awesome-layers).

4. Deploy microservice on AWS

```bash
$ serverless deploy

Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
Serverless: Packaging service...
Serverless: Excluding development dependencies...
Serverless: Creating Stack...
Serverless: Checking Stack create progress...
........
Serverless: Stack create finished...
Serverless: Uploading CloudFormation file to S3...
Serverless: Uploading artifacts...
Serverless: Uploading service serverless-lab.zip file to S3 (852 B)...
Serverless: Validating template...
Serverless: Updating Stack...
Serverless: Checking Stack update progress...
...........................
Serverless: Stack update finished...
Service Information
service: serverless-lab
stage: dev
region: us-west-2
stack: serverless-lab-dev
resources: 10
api keys:
  None
endpoints:
  GET - https://e0gp6mvf5j.execute-api.us-west-2.amazonaws.com/dev/test
functions:
  test: serverless-lab-dev-test
layers:
  None

**************************************************************************************************************************************
Serverless: Announcing Metrics, CI/CD, Secrets and more built into Serverless Framework. Run "serverless login" to activate for free..
**************************************************************************************************************************************
```

## Testing the Lambda with the Integrated Layer

`Workflow`

1. Trigger the deployed lambda function

<pre>
$  curl -v https://e0gp6mvf5j.execute-api.us-west-2.amazonaws.com/dev/test
*   Trying 65.8.14.101:443...
* TCP_NODELAY set
* Connected to e0gp6mvf5j.execute-api.us-west-2.amazonaws.com (65.8.14.101) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_128_GCM_SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=*.execute-api.us-west-2.amazonaws.com
*  start date: Jun 16 00:00:00 2021 GMT
*  expire date: Jul 15 23:59:59 2022 GMT
*  subjectAltName: host "e0gp6mvf5j.execute-api.us-west-2.amazonaws.com" matched cert's "*.execute-api.us-west-2.amazonaws.com"
*  issuer: C=US; O=Amazon; OU=Server CA 1B; CN=Amazon
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x5592485a6e10)
> GET /dev/test HTTP/2
> Host: e0gp6mvf5j.execute-api.us-west-2.amazonaws.com
> user-agent: curl/7.68.0
> accept: */*
> 
* Connection state changed (MAX_CONCURRENT_STREAMS == 128)!
<span style="color:blue">< HTTP/2 204</span>
< date: Sun, 20 Jun 2021 09:11:43 GMT
< x-amzn-requestid: d0d6071c-2cce-4816-850b-f2dc57e4575f
< x-amz-apigw-id: BN3sYFnpPHcFcWw=
< x-amzn-trace-id: Root=1-60cf064f-0fcb0de8506dd39e127968ac;Sampled=0
< x-cache: Miss from cloudfront
< via: 1.1 ea851a39fcf5baed153ab72ce3a876e2.cloudfront.net (CloudFront)
< x-amz-cf-pop: MEL50-C1
< x-amz-cf-id: Anf8UPa_zdqo2hGKk5oRmM8I4aZed6nPABHUP6gfkLPBxyHrrbUe6g==
< 
</pre>

> The function doesn't return anything (it completed with a 204 - No Content HTTP code), you won't get any return value.

2. View logging

```bash
$ serverless logs -f test
Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
START RequestId: 9657c22b-0f4d-4508-8fe7-77b66a366837 Version: $LATEST
Error occurred with the psycopg2 library
END RequestId: 9657c22b-0f4d-4508-8fe7-77b66a366837
REPORT RequestId: 9657c22b-0f4d-4508-8fe7-77b66a366837  Duration: 1.93 ms       Billed Duration: 2 ms   Memory Size: 1024 MB    Max Memory Used: 55 MB  Init Duration: 183.60 ms

START RequestId: 916d75f3-5360-4772-a8af-53dd8bb5701c Version: $LATEST
Error occurred with the psycopg2 library
END RequestId: 916d75f3-5360-4772-a8af-53dd8bb5701c
REPORT RequestId: 916d75f3-5360-4772-a8af-53dd8bb5701c  Duration: 1.75 ms       Billed Duration: 2 ms   Memory Size: 1024 MB    Max Memory Used: 56 MB

START RequestId: f4d38a93-6c89-4f6c-a259-2b61717739eb Version: $LATEST
Error occurred with the psycopg2 library
END RequestId: f4d38a93-6c89-4f6c-a259-2b61717739eb
REPORT RequestId: f4d38a93-6c89-4f6c-a259-2b61717739eb  Duration: 1.79 ms       Billed Duration: 2 ms   Memory Size: 1024 MB    Max Memory Used: 56 MB

START RequestId: 48aa6afb-2659-4d1b-86ef-1b3b89a3ff00 Version: $LATEST
Error occurred with the psycopg2 library
END RequestId: 48aa6afb-2659-4d1b-86ef-1b3b89a3ff00
REPORT RequestId: 48aa6afb-2659-4d1b-86ef-1b3b89a3ff00  Duration: 1.78 ms       Billed Duration: 2 ms   Memory Size: 1024 MB    Max Memory Used: 56 MB

START RequestId: 647854fb-475b-4cad-938c-5912945a3ad9 Version: $LATEST
Error occurred with the psycopg2 library
END RequestId: 647854fb-475b-4cad-938c-5912945a3ad9
REPORT RequestId: 647854fb-475b-4cad-938c-5912945a3ad9  Duration: 2.19 ms       Billed Duration: 3 ms   Memory Size: 1024 MB    Max Memory Used: 56 MB

START RequestId: edb15e62-6210-4477-b9e9-929309c85c9d Version: $LATEST
Error occurred with the psycopg2 library
END RequestId: edb15e62-6210-4477-b9e9-929309c85c9d
REPORT RequestId: edb15e62-6210-4477-b9e9-929309c85c9d  Duration: 1.57 ms       Billed Duration: 2 ms   Memory Size: 1024 MB    Max Memory Used: 56 MB
```

> The log describes the error you set in the Except block. That is expected because you tried to establish a connection to a PostgreSQL DB that doesn't exist. That means the psycopg2 library worked fine and that was discovered correctly by the Lambda function through the Lambda Layer.

3. Remove the layers property from the test function in the `serverless.yml` file and redeploy serverless again

```yaml
service: serverless-lab

frameworkVersion: '2'

provider:
  name: aws
  runtime: python3.7
  lambdaHashingVersion: 20201221
  region: us-west-2 # MAKE SURE NOT TO CHANGE THIS
  timeout: 10 # You set a timeout of 10 seconds for the functions
  role: arn:aws:iam::979363685568:role/cloudacademylabs-ServerlessLambdaRole-Z3RVG2SEMGMS

functions:
  test:
    handler: handler.test
    events:
      - http:
          path: test
          method: get
```

```bash
$ serverless deploy
Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
Serverless: Packaging service...
Serverless: Excluding development dependencies...
Serverless: Uploading CloudFormation file to S3...
Serverless: Uploading artifacts...
Serverless: Uploading service serverless-lab.zip file to S3 (852 B)...
Serverless: Validating template...
Serverless: Updating Stack...
Serverless: Checking Stack update progress...
..............
Serverless: Stack update finished...
Service Information
service: serverless-lab
stage: dev
region: us-west-2
stack: serverless-lab-dev
resources: 10
api keys:
  None
endpoints:
  GET - https://e0gp6mvf5j.execute-api.us-west-2.amazonaws.com/dev/test
functions:
  test: serverless-lab-dev-test
layers:
  None

**********************************************************************************
Serverless: Update available. Run "npm install -g serverless@^2.47.0" to update
            You may turn on automatic updates via "serverless config --autoupdate"
**********************************************************************************
```

4. Trigger the re-deployed Lambda function

```bash
$  curl https://e0gp6mvf5j.execute-api.us-west-2.amazonaws.com/dev/test
{"message": "Internal server error"}
```

`Note`: This time an error occurred. You are now going to investigate logging to see what went wrong.

```bash
serverless logs -f test
Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
START RequestId: 73fb982d-2e4b-41b1-93ac-5ac2b7cf7d90 Version: $LATEST
Traceback (most recent call last): Unable to import module 'handler': No module named 'psycopg2'
END RequestId: 73fb982d-2e4b-41b1-93ac-5ac2b7cf7d90
REPORT RequestId: 73fb982d-2e4b-41b1-93ac-5ac2b7cf7d90  Duration: 2.12 ms       Billed Duration: 3 ms   Memory Size: 1024 MB    Max Memory Used: 48 MB  Init Duration: 123.18 ms

START RequestId: 461a420b-f95b-4045-879d-473727b3707d Version: $LATEST
Traceback (most recent call last): Unable to import module 'handler': No module named 'psycopg2'
END RequestId: 461a420b-f95b-4045-879d-473727b3707d
REPORT RequestId: 461a420b-f95b-4045-879d-473727b3707d  Duration: 1.60 ms       Billed Duration: 2 ms   Memory Size: 1024 MB    Max Memory Used: 48 MB
```

## Explore Serverless command and deployment

> Check version and deployed serverless function information

```bash
$ serverless --version
Framework Core: 2.30.3
Plugin: 4.5.1
SDK: 4.2.0
Components: 3.7.4

$ serverless deploy list
Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
Serverless: Listing deployments:
Serverless: -------------
Serverless: Timestamp: 1624179867084
Serverless: Datetime: 2021-06-20T09:04:27.084Z
Serverless: Files:
Serverless: - compiled-cloudformation-template.json
Serverless: - serverless-lab.zip
Serverless: -------------
Serverless: Timestamp: 1624180726392
Serverless: Datetime: 2021-06-20T09:18:46.392Z
Serverless: Files:
Serverless: - compiled-cloudformation-template.json
Serverless: - serverless-lab.zip
Serverless: -------------
Serverless: Timestamp: 1624180955529
Serverless: Datetime: 2021-06-20T09:22:35.529Z
Serverless: Files:
Serverless: - compiled-cloudformation-template.json
Serverless: - serverless-lab.zip

$ serverless deploy list functions
Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
Serverless: Listing functions and their last 5 versions:
Serverless: -------------
Serverless: test: $LATEST, 1, 2

serverless info --verbose
Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
Service Information
service: serverless-lab
stage: dev
region: us-west-2
stack: serverless-lab-dev
resources: 10
api keys:
  None
endpoints:
  GET - https://e0gp6mvf5j.execute-api.us-west-2.amazonaws.com/dev/test
functions:
  test: serverless-lab-dev-test
layers:
  None

Stack Outputs
TestLambdaFunctionQualifiedArn: arn:aws:lambda:us-west-2:979363685568:function:serverless-lab-dev-test:2
ServiceEndpoint: https://e0gp6mvf5j.execute-api.us-west-2.amazonaws.com/dev
ServerlessDeploymentBucketName: serverless-lab-dev-serverlessdeploymentbucket-11cdzcomsdck8

$ serverless info | grep GET | awk -F'GET - ' '{ print $2 }' 
https://e0gp6mvf5j.execute-api.us-west-2.amazonaws.com/dev/test
```

> Local test

```bash
serverless invoke local -f test
Serverless: Deprecation warning: Starting with version 3.0.0, following property will be replaced:
              "provider.role" -> "provider.iam.role"
            More Info: https://www.serverless.com/framework/docs/deprecations/#PROVIDER_IAM_SETTINGS
Serverless: Deprecation warning: Starting with next major version, API Gateway naming will be changed from "{stage}-{service}" to "{service}-{stage}".
            Set "provider.apiGateway.shouldStartNameWithService" to "true" to adapt to the new behavior now.
            More Info: https://www.serverless.com/framework/docs/deprecations/#AWS_API_GATEWAY_NAME_STARTING_WITH_SERVICE
Traceback (most recent call last):
  File "/usr/local/lib/node_modules/serverless/lib/plugins/aws/invokeLocal/runtimeWrappers/invoke.py", line 72, in <module>

    module = import_module(args.handler_path.replace('/', '.'))
  File "/usr/local/lib/python3.8/importlib/__init__.py", line 127, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
  File "<frozen importlib._bootstrap>", line 1014, in _gcd_import
  File "<frozen importlib._bootstrap>", line 991, in _find_and_load
  File "<frozen importlib._bootstrap>", line 975, in _find_and_load_unlocked
  File "<frozen importlib._bootstrap>", line 671, in _load_unlocked
  File "<frozen importlib._bootstrap_external>", line 783, in exec_module
  File "<frozen importlib._bootstrap>", line 219, in _call_with_frames_removed
  File "./handler.py", line 1, in <module>
    from functions.test import test
  File "./functions/test.py", line 2, in <module>
    import psycopg2
ModuleNotFoundError: No module named 'psycopg2'
```
