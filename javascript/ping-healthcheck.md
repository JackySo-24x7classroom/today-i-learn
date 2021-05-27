# Nodejs - Add Ping or Healthcheck routes and handlers

![Ping cover image](images/ping-cover.jpg)

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [`Add Ping check in HTTP and HTTPS server`](#add-ping-check-in-http-and-https-server)
- [`Add Health check in HTTP and HTTPS server`](#add-health-check-in-http-and-https-server)

<!-- vim-markdown-toc -->

## `Add Ping check in HTTP and HTTPS server`

- [x] Redefine server return
  - [x] Path
  - [x] Status Code
- [x] Add handler in router
  - [x] ping
- [x] Define `ping` handler
  - [x] Status Code 200

> Redefine server return - See <span style="color:blue"><i>Blue colored code</i></span> below

<pre>
        // Return the response
        res.setHeader('Content-Type', 'application/json');
        res.writeHead(statusCode);
        res.end(payloadString);
	<span style="color:blue">console.log(trimmedPath,statusCode);</span>
</pre>

> Define `ping` handler and set into router

<pre>
// Define the request router
var router = {
  'ping' : handlers.ping
};

// Ping handler
 handlers.ping = function(data,callback){
     callback(200);
</pre>

> Validation - Run servers and watch console logging (when hit)

```bash
# Run servers
$  node index.js
The HTTP server is running on port 3000
The HTTPS server is running on port 3001

# Console logging for http://localhost:3000/sample
sample 404

# Console logging for http://localhost:3000/ping
ping 200

# Console logginf for https://localhost:3001/ping
ping 200

# Console logging for https://localhost:3001/ping
ping 200
```

> Hit the HTTP and HTTPS server and URL paths

```bash
# Hit http url path sample
$  curl http://localhost:3000/sample
{}

# Hit http url path ping
$  curl http://localhost:3000/ping
{}

# Hit https url path ping
$  curl -k https://localhost:3001/ping
{}

# Hit https url path ping with verbose output
$  curl -v -k https://localhost:3001/ping
{}
*   Trying 127.0.0.1:3001...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3001 (#0)
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
> GET /ping HTTP/1.1
> Host: localhost:3001
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Thu, 27 May 2021 04:04:49 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
```

[Back to Top](#nodejs---add-ping-or-healthcheck-handling)

---

## `Add Health check in HTTP and HTTPS server`

- [x] Add handler in router
  - [x] healthcheck
- [x] Define `healthcheck` handler
  - [x] Status Code 201

> Add handler `healthcheck` - See  <span style="color:blue"><i>Blue colored code</i></span> below

<pre>
// Define all the handlers
var handlers = {};
<span style="color:blue">
// Healthcheck handler
handlers.healthcheck = function(data,callback){
    callback(201);
};
</span>

// Ping handler
handlers.ping = function(data,callback){
    callback(200);
};

// Not-Found handler
handlers.notFound = function(data,callback){
  callback(404);
};

// Define the request router
var router = {
  'ping' : handlers.ping<span style="color:blue">,
  'healthcheck' : handlers.healthcheck</span>
};
</pre>

> Validation - HIT url and various paths `/ping` and `/healthcheck`

```bash
$  curl http://localhost:3000/ping
{}

$  curl http://localhost:3000/healthcheck
{}

$  curl http://localhost:3000/notund/
{}
```

> See console log for URL and path hits

```bash
$  node index.js
The HTTP server is running on port 3000
The HTTPS server is running on port 3001

ping 200

healthcheck 201

notfound 404
```

[Back to Top](#nodejs---add-ping-or-healthcheck-handling)

---
