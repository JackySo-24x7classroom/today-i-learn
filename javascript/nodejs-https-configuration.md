# Nodejs HTTPS server and Configuration

<!-- vim-markdown-toc GFM -->

- [`Add Configuration for environments`](#add-configuration-for-environments)
- [`Setup HTTPS server`](#setup-https-server)

<!-- vim-markdown-toc -->

## `Add Configuration for environments`

- [x] Container `environments` for all environments
- [x] Staging (default) environment
  - [x] tcp port 3000
  - [x] Env name: staging
- [x] Production environment
  - [x] tcp port 5000
  - [x] Env name: production
- [x] Determine which environment was passed as a command-line argument
  - [x] Use `process.env.NODE_ENV`
- [x] Check that the current environment is one of the environments above, if not default to staging
  - [x] `environments[currentEnvironment]`
- [x] Export the module
- [x] Review index.js to use configuration and environments


> Develop Configuration module - config.js

```javascript
/*
 * Create and export configuration variables
 *
 */

// Container for all environments
var environments = {};

// Staging (default) environment
environments.staging = {
  'port' : 3000,
  'envName' : 'staging'
};

// Production environment
environments.production = {
  'port' : 5000,
  'envName' : 'production'
};

// Determine which environment was passed as a command-line argument
var currentEnvironment = typeof(process.env.NODE_ENV) == 'string' ? process.env.NODE_ENV.toLowerCase() : '';

// Check that the current environment is one of the environments above, if not default to staging
var environmentToExport = typeof(environments[currentEnvironment]) == 'object' ? environments[currentEnvironment] : environments.staging;

// Export the module
module.exports = environmentToExport;
```

> Add configuration and environment into main code - index.js

```javascript
var config = require('./config');
```

> Use configuration to define HTTP server start

```javascript
// Start the server
server.listen(config.port,function(){
  console.log('The server is up and running on port '+config.port+' in '+config.envName+' mode.');
});
```
> Validation - Use environment variables to run

```bash
# Default run
$  node index.js
The server is up and running on port 3000 in staging mode.

# Set production environment variable to run
$  NODE_ENV=production node index.js
The server is up and running on port 5000 in production mode.

# Set development environment variable to run
$  NODE_ENV=development node index.js
The server is up and running on port 3000 in staging mode.

# Set Production environment variable to run
$  NODE_ENV=Production node index.js
The server is up and running on port 5000 in production mode.
```

[Back to Top](#nodejs-https-server-and-configuration)

---

## `Setup HTTPS server`

- [x] Generate SSL
  - [x] SSL Private key
  - [x] SSL Certificate

- [x] Dependencies
  - [x] require http
  - [x] require fs
  - [x] require https
  - [x] require (homemade) config
- [x] HTTP Server
  - [x] Instantiate the HTTP server
  - [x] Start the HTTP serve
- [x] HTTPS Server
  - [x] Instantiate the HTTPS server
  - [x] Start the HTTPS serve
- [x] Server Logic for both HTTP and HTTPS server
  - [x] Parse the url
  - [x] Get the path
  - [x] Get the query string as an object
  - [x] Get the HTTP method
  - [x] Get the headers as an object
  - [x] Get the payload
  - [x] Define handlers
    - [x] Check the router for a matching path for a handler. If one is not found, use the notFound handler instead
    - [x] Construct data object to send to handler
    - [x] Route the request to the handler specified in the router
      - [x] Use the status code returned from the handler, or set the default status code to 200
      - [x] Use the payload returned from the handler, or set the default payload to an empty object
      - [x] Convert the payload to a string
      - [x] Return the response

<pre>
Adding HTTPS support/
├── config.js
├── https
│   ├── cert.pem
│   └── key.pem
└── index.js

1 directory, 5 files
</pre>

> Generate SSL certificate

```bash
$ openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout https/key.pem -out https/cert.pem

Generating a RSA private key
....................................................................................................................................................................................................................+++++
.....................+++++
writing new private key to 'https/key.pem'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]: AU
State or Province Name (full name) [Some-State]:VIC
Locality Name (eg, city) []:Melbourne
Organization Name (eg, company) [Internet Widgits Pty Ltd]:24x7 Demo Pty Ltd
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:localhost
Email Address []:user@24x7demo.com

$  tree https
https
├── cert.pem
└── key.pem

0 directories, 2 files

# Validate SSL certificate
$ openssl x509 -in https/cert.pem -text

# Validate RSA private key
$ openssl rsa -in https/key.pem -text

```

> Setup HTTPS server 

> Add HTTPS port into config.js

```diff
// Staging (default) environment
environments.staging = {
  'httpPort' : 3000,
+  'httpsPort' : 3001,
  'envName' : 'staging'
};

// Production environment
environments.production = {
  'httpPort' : 5000,
+  'httpsPort' : 5001,
  'envName' : 'production'
};

```

> Configure HTTPS server into index.js

- [ ] Dependencies
  - [ ] http
  - [ ] https
  - [ ] fs
  - [ ] ./config.js
- [ ] HTTP Server
  - [ ] Instantiate the HTTP server
  - [ ] Start the HTTP serve
- [ ] HTTPS Server
  - [ ] Instantiate the HTTPS server
  - [ ] Start the HTTPS serve

```javascript
// Dependencies
var http = require('http');
var https = require('https');
var url = require('url');
var config = require('./config');
var fs = require('fs');

// Instantiate the HTTP server
var httpServer = http.createServer(function(req,res){
  unifiedServer(req,res);
});

// Start the HTTP server
httpServer.listen(config.httpPort,function(){
  console.log('The HTTP server is running on port '+config.httpPort);
});

// Instantiate the HTTPS server
var httpsServerOptions = {
  'key': fs.readFileSync('./https/key.pem'),
  'cert': fs.readFileSync('./https/cert.pem')
};

// Start the HTTPS server
httpsServer.listen(config.httpsPort,function(){
 console.log('The HTTPS server is running on port '+config.httpsPort);
});

```

> Terminal #1 - Start HTTP & HTTPS server and watch console logging
```bash
# Start HTTP and HTTPS servers
$  node index.js
The HTTP server is running on port 3000
The HTTPS server is running on port 3001
Returning this response:  406 {"name":"sample handler"}
Returning this response:  406 {"name":"sample handler"}

# Set production environment variable and Start HTTP and HTTPS servers
$  NODE_ENV=production node index.js
The HTTP server is running on port 5000
The HTTPS server is running on port 5001
Returning this response:  406 {"name":"sample handler"}
Returning this response:  406 {"name":"sample handler"}

```

> Terminal #2 - Hit the URLs
```bash 
# Connect to localhost:3000
$  curl http://localhost:3000/sample
{"name":"sample handler"}

# Connect to localhost:3001
$  curl https://localhost:3001/sample
curl: (60) SSL certificate problem: self signed certificate
More details here: https://curl.haxx.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.

# Connect to localhost:3001 and ignore SSL cert check
$  curl -k https://localhost:3001/sample
{"name":"sample handler"}

# Connect to localhost:5001
$  curl -k https://localhost:5001/sample
{"name":"sample handler"}

# Connect to localhost:5000
$  curl http://localhost:5000/sample
{"name":"sample handler"}

```

> Hit URL and show output in verbose mode to see details of HTTPS certificate

```bash
$  curl -v -k https://localhost:5001/sample
*   Trying 127.0.0.1:5001...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 5001 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/certs/ca-certificates.crt
  CApath: /etc/ssl/certs
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=US; ST=CA; L=San Francisco; O=Master Course; OU=Node.js; CN=localhost; emailAddress=test@test.com
*  start date: Dec  9 05:11:08 2017 GMT
*  expire date: Dec  7 05:11:08 2027 GMT
*  issuer: C=US; ST=CA; L=San Francisco; O=Master Course; OU=Node.js; CN=localhost; emailAddress=test@test.com
*  SSL certificate verify result: self signed certificate (18), continuing anyway.
> GET /sample HTTP/1.1
> Host: localhost:5001
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 406 Not Acceptable
< Content-Type: application/json
< Date: Thu, 27 May 2021 00:53:06 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{"name":"sample handler"}
```

<details><summary><i>Show codes</i></summary><br>

<pre>
Adding HTTPS support/
├── config.js
├── https
│   ├── cert.pem
│   └── key.pem
└── index.js

1 directory, 5 files
</pre>

`config.js`

```javascript
/*
 * Create and export configuration variables
 *
 */

// Container for all environments
var environments = {};

// Staging (default) environment
environments.staging = {
  'httpPort' : 3000,
  'httpsPort' : 3001,
  'envName' : 'staging'
};

// Production environment
environments.production = {
  'httpPort' : 5000,
  'httpsPort' : 5001,
  'envName' : 'production'
};

// Determine which environment was passed as a command-line argument
var currentEnvironment = typeof(process.env.NODE_ENV) == 'string' ? process.env.NODE_ENV.toLowerCase() : '';

// Check that the current environment is one of the environments above, if not default to staging
var environmentToExport = typeof(environments[currentEnvironment]) == 'object' ? environments[currentEnvironment] : environments.staging;

// Export the module
module.exports = environmentToExport;

```

`index.js`

```javascript
/*
 * Primary file for API
 *
 */

// Dependencies
var http = require('http');
var https = require('https');
var url = require('url');
var StringDecoder = require('string_decoder').StringDecoder;
var config = require('./config');
var fs = require('fs');


 // Instantiate the HTTP server
var httpServer = http.createServer(function(req,res){
  unifiedServer(req,res);
});

// Start the HTTP server
httpServer.listen(config.httpPort,function(){
  console.log('The HTTP server is running on port '+config.httpPort);
});

// Instantiate the HTTPS server
var httpsServerOptions = {
  'key': fs.readFileSync('./https/key.pem'),
  'cert': fs.readFileSync('./https/cert.pem')
};
var httpsServer = https.createServer(httpsServerOptions,function(req,res){
  unifiedServer(req,res);
});

// Start the HTTPS server
httpsServer.listen(config.httpsPort,function(){
 console.log('The HTTPS server is running on port '+config.httpsPort);
});

// All the server logic for both the http and https server
var unifiedServer = function(req,res){

  // Parse the url
  var parsedUrl = url.parse(req.url, true);

  // Get the path
  var path = parsedUrl.pathname;
  var trimmedPath = path.replace(/^\/+|\/+$/g, '');

  // Get the query string as an object
  var queryStringObject = parsedUrl.query;

  // Get the HTTP method
  var method = req.method.toLowerCase();

  //Get the headers as an object
  var headers = req.headers;

  // Get the payload,if any
  var decoder = new StringDecoder('utf-8');
  var buffer = '';
  req.on('data', function(data) {
      buffer += decoder.write(data);
  });
  req.on('end', function() {
      buffer += decoder.end();

      // Check the router for a matching path for a handler. If one is not found, use the notFound handler instead.
      var chosenHandler = typeof(router[trimmedPath]) !== 'undefined' ? router[trimmedPath] : handlers.notFound;

      // Construct the data object to send to the handler
      var data = {
        'trimmedPath' : trimmedPath,
        'queryStringObject' : queryStringObject,
        'method' : method,
        'headers' : headers,
        'payload' : buffer
      };

      // Route the request to the handler specified in the router
      chosenHandler(data,function(statusCode,payload){

        // Use the status code returned from the handler, or set the default status code to 200
        statusCode = typeof(statusCode) == 'number' ? statusCode : 200;

        // Use the payload returned from the handler, or set the default payload to an empty object
        payload = typeof(payload) == 'object'? payload : {};

        // Convert the payload to a string
        var payloadString = JSON.stringify(payload);

        // Return the response
        res.setHeader('Content-Type', 'application/json');
        res.writeHead(statusCode);
        res.end(payloadString);
        console.log("Returning this response: ",statusCode,payloadString);

      });

  });
};

// Define all the handlers
var handlers = {};

// Sample handler
handlers.sample = function(data,callback){
    callback(406,{'name':'sample handler'});
};

// Not found handler
handlers.notFound = function(data,callback){
  callback(404);
};

// Define the request router
var router = {
  'sample' : handlers.sample
};


```
</details><br>

[Back to Top](#nodejs-https-server-and-configuration)

---
