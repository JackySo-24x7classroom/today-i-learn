# NodeJs HTTP server - Start and Parsing

`Code convention`

- [ ] Description/Comments
- [ ] Dependencies
  - [ ] require libraries
- [ ] Main code
  - [ ] Server Response and return
    - [ ] raw data
    - [ ] encoded data
    - [ ] json
  - [ ] Start server
    - [ ] listening port
    - [ ] Console log message 
      - [ ] status
      - [ ] metadata

`Start a HTTP server`

- [x] Dependencies
  - [x] require http
- [x] Server response
  - [x] `Hello World`
- [x] Start server
  - [x] listening tcp port 3000
  - [x] Console log message 

<details><summary><b>View code</b></summary><br>

```javascript
/*
 * Primary file for API
 *
 */

// Dependencies
var http = require('http');

// Configure the server to respond to all requests with a string
var server = http.createServer(function(req,res){
  res.end('Hello World!\n');
});

// Start the server
server.listen(3000,function(){
  console.log('The server is up and running now');
});
```

</details><br>

```bash
# Start a HTTP server
$  node Starting\ a\ Server/
The server is up and running now

# Explore running nodejs HTTP server
$  netstat -pan | grep 3000
 will not be shown, you would have to be root to see it all.)
tcp6       0      0 :::3000                 :::*                    LISTEN      23342/node

# Connect to localhost:3000
$  curl http://localhost:3000
Hello World!
```

`Parsing`

- [x] Dependencies
  - [x] require http
  - [x] require url
- [x] Parsing
  - [x] `URL path`
  - [x] `HTTP method`
  - [x] `Query string`
  - [x] `HTTP header`
  - [x] `HTTP payload`
- [x] Server response
  - [x] `Hello World`
- [x] Server Console
  - [x] logging `path`, `method`, `query string`
  - [x] logging `header` when hit
  - [x] logging `payload` when hit

<details><summary><b>View code</b></summary><br>

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

      // Send the response
      res.end('Hello World!\n');

      // Log the request/response
      console.log('Request received on path: '+trimmedPath+' with method: '+method+' and this query string: ',queryStringObject);
      console.log('Request received with these headers: ',headers);
      console.log('Request received with this payload: ',buffer);
  });
});

// Start the server
server.listen(3000,function(){
  console.log('The server is up and running now');
});
```

</details><br>

> Terminal #1 - Start HTTP server and watch console logging
```bash
$  node index.js
The server is up and running now

Request received on path:  with method: get and this query string:  [Object: null prototype] {}
Request received with these headers:  { host: 'localhost:3000',
  'user-agent': 'curl/7.68.0',
  accept: '*/*' }
Request received with this payload:

# Logging - get method and url path
Request received on path: demo/jackyso with method: get and this query string:  [Object: null prototype] {}
Request received with these headers:  { host: 'localhost:3000',
  'user-agent': 'curl/7.68.0',
  accept: '*/*' }
Request received with this payload:

# Logging - get method and query string
Request received on path:  with method: get and this query string:  [Object: null prototype] { demo: 'true' }
Request received with these headers:  { host: 'localhost:3000',
  'user-agent': 'curl/7.68.0',
  accept: '*/*' }
Request received with this payload:

# Logging - put method and payload
Request received on path: user/888 with method: put and this query string:  [Object: null prototype] {}
Request received with these headers:  { host: 'localhost:3000',
  'user-agent': 'curl/7.68.0',
  accept: '*/*',
  'content-length': '45',
  'content-type': 'application/x-www-form-urlencoded' }
Request received with this payload:  name=JackySo&email=jacky.so@24x7classroom.com

```

> Terminal #2 - Hit the URLs
```bash
# Hit standard url 
$  curl http://localhost:3000
Hello World!

# Hit url with query string ?demo=true
$  curl http://localhost:3000?demo=true
Hello World!

# Hit url with path /demo/jackyso
$  curl http://localhost:3000/demo/jackyso/
Hello World!

# Hit url with PUT method and payload 'name=JackySo' and 'email=jacky.so@24x7classroom.com'
$  curl -X PUT -d 'name=JackySo&email=jacky.so@24x7classroom.com' http://localhost:3000/user/888
Hello World!
```
