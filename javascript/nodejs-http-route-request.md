# Nodejs HTTP server - Add routes and return JSON output

`HTTP routes and handlers`

- [x] Dependencies
  - [x] require http
- [x] Handlers
  - [x] `default`
  - [x] `sample`
- [x] Server response
  - [x] Construct data structure
  - [x] Program handler into HTTP Server 
  - [x] Add default handler into HTTP Server when URL path not configured
- [x] Start server
  - [x] listening tcp port 3000
  - [x] Console log message 

> Define handlers

```javascript

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

> Construct data for response and replace the following basic response and console logging

```javascript
      // Send the response
      res.end('Hello World!\n');

      // Log the request/response
      console.log('Request received with this payload: ',buffer);
```

> Pick handler logic
* Return HTTP status code if type of variable `statusCode` is number, otherwise, return default 200
* Return HTTP payload if type of variable `payload` is object, otherwise, return null string

> Transformation logic
* Format payload to JSON

> Console logging
* Message "Returning this response: " + statusCode + payloadString

> `Codes:`

```javascript
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
        res.writeHead(statusCode);
        res.end(payloadString);
        console.log("Returning this response: ",statusCode,payloadString);
 
      });
```


> Terminal #1 - Start HTTP server and watch console logging
```bash
The server is up and running now

Returning this response:  404 {}

Returning this response:  406 {"name":"sample handler"}

Returning this response:  404 {}
```

> Terminal #2 - Hit the URLs
```bash
# Hit standard URL
$  curl http://localhost:3000
{}

# Hit URL with configured path /sample
$  curl http://localhost:3000/sample
{"name":"sample handler"}

# Hit UrL with unconfigured path /demo
$  curl http://localhost:3000/demo
{}

$  curl http://localhost:3000/
Returning this response:  404 {}
```

> Hit URL and show output in verbose mode

```bash
$  curl -v http://localhost:3000/sample
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /sample HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 406 Not Acceptable
< Date: Wed, 26 May 2021 09:18:15 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
```

`Return HTTP output in JSON format`

- [x] Dependencies
  - [x] require http
- [x] Server response
  - [x] Add `Content-Type: application/json` into HTTP header 

```diff
       // Return the response
+        res.setHeader('Content-Type', 'application/json');
        res.writeHead(statusCode);
        res.end(payloadString);
        console.log("Returning this response: ",statusCode,payloadString);
```

> HTTP browser support JSON will format output 

```bash
$  curl -v http://localhost:3000/sample
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /sample HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 406 Not Acceptable
< Content-Type: application/json
< Date: Wed, 26 May 2021 09:26:17 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
```

<details><summary><b>Show <i>All-in-one</i> code</b></summary><br>

```javascript
/*
 * Primary file for API
 *
 */

// Dependencies
var http = require('http');
var url = require('url');
var StringDecoder = require('string_decoder').StringDecoder;

 // Configure the server to respond to all requests with a string
var server = http.createServer(function(req,res){

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
});

// Start the server
server.listen(3000,function(){
  console.log('The server is up and running now');
});

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
