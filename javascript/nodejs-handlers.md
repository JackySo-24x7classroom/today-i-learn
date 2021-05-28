# Nodejs - HTTP(S) service handlers for (GET, POST, PUT, DELETE) methods

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [`Service handlers` library for server use](#service-handlers-library-for-server-use)
- [`Users` handlers](#users-handlers)
	- [Testing HTTP methods in `Users` handler](#testing-http-methods-in-users-handler)

<!-- vim-markdown-toc -->

## `Service handlers` library for server use 

- [ ] Build service handler library
  - [ ] Add handlers
    - [ ] ping
    - [ ] nofound
    - [ ] users
  - [ ] Export for other use
- [ ] Add library to index.js
  - [ ] Dependency
    - [ ] Add `lib/handlers`
  - [ ] Server logic for both the http and https server
    - [ ] Check the router for a matching path for a handler. If one is not found, use the `notFound handler` instead.
    - [ ] Route the request to the `handler specified` in the router
  - [ ] Define the request router
    - [ ] route `ping`
    - [ ] route `users`

`lib/handlers.js`

```javascript
/*
 * Request Handlers
 *
 */

// Dependencies

// Define all the handlers
var handlers = {};

// Ping
handlers.ping = function(data,callback){
    callback(200);
};

// Not-Found
handlers.notFound = function(data,callback){
  callback(404);
};

// Users
handlers.users = function(data,callback){
    callback(201);
};

// Export the handlers
module.exports = handlers;
```

`index.js`

  - [x] Dependency
    - [x] Add `lib/handlers`
  - [x] Server logic for both the http and https server
    - [x] Check the router for a matching path for a handler. If one is not found, use the `notFound handler` instead.
    - [x] Route the request to the `handler specified` in the router
  - [x] Define the request router
    - [x] route `ping`
    - [x] route `users`

> See <span style="color:blue">blue colored text</span> for codes

<pre>
/*
 * Primary file for API
 *
 */

// Dependencies
var http = require('http');
var https = require('https');
var url = require('url');
var StringDecoder = require('string_decoder').StringDecoder;
var config = require('./lib/config');
var fs = require('fs');
<span style="color:blue">var handlers = require('./lib/handlers');</span>
var helpers = require('./lib/helpers');

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

      <span style="color:blue">
      // Check the router for a matching path for a handler. If one is not found, use the notFound handler instead.
      var chosenHandler = typeof(router[trimmedPath]) !== 'undefined' ? router[trimmedPath] : handlers.notFound;
      </span>

      // Construct the data object to send to the handler
      var data = {
        'trimmedPath' : trimmedPath,
        'queryStringObject' : queryStringObject,
        'method' : method,
        'headers' : headers,
        'payload' : helpers.parseJsonToObject(buffer)
      };

      // Route the request to the handler specified in the router
      <span style="color:blue">chosenHandler</span>(data,function(statusCode,payload){

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
        console.log(trimmedPath,statusCode);
      });

  });
};

<span style="color:blue">
// Define the request router
var router = {
  'ping' : handlers.ping,
  'users' : handlers.users
};
</span>
</pre>

`Testing` - Validate the codes

> Start server and watch console logging

```bash
$  node index.js
The HTTP server is running on port 3000
The HTTPS server is running on port 3001

ping 200

demo 404

users 201

 404

 404
 
ping 200

ping 200

demo 404

users 201
```

> Hit the URLs

```bash
$  curl http://localhost:3000/ping
{}

$  curl http://localhost:3000/demo
{}

$  curl http://localhost:3000/users
{}

$  curl http://localhost:3000

$  curl -k https://localhost:3001/
{}

$  curl -k https://localhost:3001/ping
{}

$  curl -k https://localhost:3001/ping/
{}

$  curl -k https://localhost:3001/demo
{}

$  curl -k https://localhost:3001/users
{}
```

[Back to Top](#nodejs---http-and-https-service-handlers)

---

## `Users` handlers

- [x] Handler Users
- [x] Add container for all the users methods
- [x] Users sub-handler - post (Add)
  - [x] Required data: firstName, lastName, phone, password, tosAgreement
  - [x] Optional data: nil
    - [x] Check that all required fields are filled out
      - [x] Make sure the user doesnt already exist
          - [x] Hash the password
          - [x] Create the user object
            - [x] Store the user
          - [x] User already exists
- [x] Users sub-handler - get (Read)
  - [x] Required data: phone
  - [x] Optional data: nil
    - [x] Check that phone number is valid
      - [x] Lookup the user
          - [x] Remove the hashed password from the user user object before returning it to the requester
- [x] Users sub-handler - put (Update)
  - [x] Required data: phone
  - [x] Optional data: firstName, lastName, password (at least one must be specified)
    - [x] Check for required field
    - [x] Check for optional fields
    - [x] Error if phone is invalid
      - [x] Error if nothing is sent to update
        - [x] Lookup the user
            - [x] Update the fields if necessary
            - [x] Store the new updates
- [x] Users sub-handler - delete (Delete)
  - [x] Required data: phone
    - [x] Check that phone number is valid
      - [x] Lookup the user
- [x] @TODO Reminder for next
  - [x] Only let an authenticated user access their object. Dont let them access anyone elses.

`lib/handlers.js`

<pre>
/*
 * Request Handlers
 *
 */

// Dependencies
var _data = require('./data');
var helpers = require('./helpers');

// Define all the handlers
var handlers = {};

// Ping
handlers.ping = function(data,callback){
    callback(200);
};

// Not-Found
handlers.notFound = function(data,callback){
  callback(404);
};

<span style="color:blue">
// Users
handlers.users = function(data,callback){
  var acceptableMethods = ['post','get','put','delete'];
  if(acceptableMethods.indexOf(data.method) > -1){
    handlers._users[data.method](data,callback);
  } else {
    callback(405);
  }
};

// Container for all the users methods
handlers._users  = {};

// Users - post (Add)
// Required data: firstName, lastName, phone, password, tosAgreement
// Optional data: none
handlers._users.post = function(data,callback){
  // Check that all required fields are filled out
  var firstName = typeof(data.payload.firstName) == 'string' && data.payload.firstName.trim().length > 0 ? data.payload.firstName.trim() : false;
  var lastName = typeof(data.payload.lastName) == 'string' && data.payload.lastName.trim().length > 0 ? data.payload.lastName.trim() : false;
  var phone = typeof(data.payload.phone) == 'string' && data.payload.phone.trim().length == 10 ? data.payload.phone.trim() : false;
  var password = typeof(data.payload.password) == 'string' && data.payload.password.trim().length > 0 ? data.payload.password.trim() : false;
  var tosAgreement = typeof(data.payload.tosAgreement) == 'boolean' && data.payload.tosAgreement == true ? true : false;

  if(firstName && lastName && phone && password && tosAgreement){
    // Make sure the user doesnt already exist
    _data.read('users',phone,function(err,data){
      if(err){
        // Hash the password
        var hashedPassword = helpers.hash(password);

        // Create the user object
        if(hashedPassword){
          var userObject = {
            'firstName' : firstName,
            'lastName' : lastName,
            'phone' : phone,
            'hashedPassword' : hashedPassword,
            'tosAgreement' : true
          };

          // Store the user
          _data.create('users',phone,userObject,function(err){
            if(!err){
              callback(200);
            } else {
              console.log(err);
              callback(500,{'Error' : 'Could not create the new user'});
            }
          });
        } else {
          callback(500,{'Error' : 'Could not hash the user\'s password.'});
        }

      } else {
        // User already exists
        callback(400,{'Error' : 'A user with that phone number already exists'});
      }
    });

  } else {
    callback(400,{'Error' : 'Missing required fields'});
  }

};

// Users - get (Read)
// Required data: phone
// Optional data: none
handlers._users.get = function(data,callback){
  // Check that phone number is valid
  var phone = typeof(data.queryStringObject.phone) == 'string' && data.queryStringObject.phone.trim().length == 10 ? data.queryStringObject.phone.trim() : false;
  if(phone){
    // Lookup the user
    _data.read('users',phone,function(err,data){
      if(!err && data){
        // Remove the hashed password from the user user object before returning it to the requester
        delete data.hashedPassword;
        callback(200,data);
      } else {
        callback(404);
      }
    });
  } else {
    callback(400,{'Error' : 'Missing required field'})
  }
};

// Users - put (Update)
// Required data: phone
// Optional data: firstName, lastName, password (at least one must be specified)
handlers._users.put = function(data,callback){
  // Check for required field
  var phone = typeof(data.payload.phone) == 'string' && data.payload.phone.trim().length == 10 ? data.payload.phone.trim() : false;

  // Check for optional fields
  var firstName = typeof(data.payload.firstName) == 'string' && data.payload.firstName.trim().length > 0 ? data.payload.firstName.trim() : false;
  var lastName = typeof(data.payload.lastName) == 'string' && data.payload.lastName.trim().length > 0 ? data.payload.lastName.trim() : false;
  var password = typeof(data.payload.password) == 'string' && data.payload.password.trim().length > 0 ? data.payload.password.trim() : false;

  // Error if phone is invalid
  if(phone){
    // Error if nothing is sent to update
    if(firstName || lastName || password){
      // Lookup the user
      _data.read('users',phone,function(err,userData){
        if(!err && userData){
          // Update the fields if necessary
          if(firstName){
            userData.firstName = firstName;
          }
          if(lastName){
            userData.lastName = lastName;
          }
          if(password){
            userData.hashedPassword = helpers.hash(password);
          }
          // Store the new updates
          _data.update('users',phone,userData,function(err){
            if(!err){
              callback(200);
            } else {
              console.log(err);
              callback(500,{'Error' : 'Could not update the user.'});
            }
          });
        } else {
          callback(400,{'Error' : 'Specified user does not exist.'});
        }
      });
    } else {
      callback(400,{'Error' : 'Missing fields to update.'});
    }
  } else {
    callback(400,{'Error' : 'Missing required field.'});
  }

};

// Users - delete (Delete)
// Required data: phone
handlers._users.delete = function(data,callback){
  // Check that phone number is valid
  var phone = typeof(data.queryStringObject.phone) == 'string' && data.queryStringObject.phone.trim().length == 10 ? data.queryStringObject.phone.trim() : false;
  if(phone){
    // Lookup the user
    _data.read('users',phone,function(err,data){
      if(!err && data){
        _data.delete('users',phone,function(err){
          if(!err){
            callback(200);
          } else {
            callback(500,{'Error' : 'Could not delete the specified user'});
          }
        });
      } else {
        callback(400,{'Error' : 'Could not find the specified user.'});
      }
    });
  } else {
    callback(400,{'Error' : 'Missing required field'})
  }
};
</span>

// Export the handlers
module.exports = handlers;
</pre>

> Helpers library

- [x] Dependencies
  - [x] homemade `./config`
  - [x] crypto
- [x] Container for all the helpers
- [x] Parse a JSON string to an object in all cases, without throwing
- [x] Create a SHA256 hash
- [x] Export the module `helpers`

`lib/helpers.js`

```javascript
/*
 * Helpers for various tasks
 *
 */

// Dependencies
var config = require('./config');
var crypto = require('crypto');

// Container for all the helpers
var helpers = {};

// Parse a JSON string to an object in all cases, without throwing
helpers.parseJsonToObject = function(str){
  try{
    var obj = JSON.parse(str);
    return obj;
  } catch(e){
    return {};
  }
};

// Create a SHA256 hash
helpers.hash = function(str){
  if(typeof(str) == 'string' && str.length > 0){
    var hash = crypto.createHmac('sha256', config.hashingSecret).update(str).digest('hex');
    return hash;
  } else {
    return false;
  }
};
// Export the module
module.exports = helpers;
```

### Testing HTTP methods in `Users` handler

> Testing GET method  - Initial trying URL http://localhost:3000/users

```bash
# Try hitting URL
$  curl -v http://localhost:3000/users
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 400 Bad Request
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:08:09 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact

{"Error":"Missing required field"}

# Try hitting URL with POST method
$  curl -v -X POST http://localhost:3000/users
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 400 Bad Request
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:07:45 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact

{"Error":"Missing required fields"}
```

> Testing GET method - Read existing user who with phone number `5555555555`

```bash
# Try hitting URL with query phone=5555555555
curl -v http://localhost:3000/users?phone=5555555555
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users?phone=5555555555 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:16:41 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact

{"firstName":"Example","lastName":"User","phone":"5555555555","tosAgreement":true,"checks":["dzz4nfyluk5eam7bqg5k","uhwhtakv8qgkkadlev47","cg2pwijpo5lqyu1w29lu"]}

# Try hitting URL with query phone=5555555555 and output in json format
$  curl -sv http://localhost:3000/users?phone=5555555555 | jq
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users?phone=5555555555 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:17:40 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [173 bytes data]
* Connection #0 to host localhost left intact
{
  "firstName": "Example",
  "lastName": "User",
  "phone": "5555555555",
  "tosAgreement": true,
  "checks": [
    "dzz4nfyluk5eam7bqg5k",
    "uhwhtakv8qgkkadlev47",
    "cg2pwijpo5lqyu1w29lu"
  ]
}
```

> Testing GET method - Try GET method with phone=`5555555556`

```bash
# Try hitting URL with query other phone number
$  curl -sv http://localhost:3000/users?phone=5555555556
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users?phone=5555555556 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 404 Not Found
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:19:32 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [12 bytes data]
* Connection #0 to host localhost left intact
{}

```

> Construct json file for adding new user

`.data/user-info.txt`

```json
{
  "firstName": "Jacky",
  "lastName": "So",
  "phone": "1234567890",
  "tosAgreement": true,
  "password": "ThisIsaPassword"
}

```
> Testing POST method - Add new user with `.data/user-info.txt`

```bash
$  curl -v -X POST -d @.data/user-info.txt http://localhost:3000/users
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 122
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 122 out of 122 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:33:05 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{}

# 1234567890.json will be created

$  tree .data
.data
├── user-info.txt
└── users
    ├── 1234567890.json
    ├── 5551234567.json
    └── 5555555555.json

1 directory, 4 files

# Hashed password is stored when user creating
$  cat .data/users/1234567890.json | jq
{
  "firstName": "Jacky",
  "lastName": "So",
  "phone": "1234567890",
  "hashedPassword": "0a2b3292782b67e914ffde869c68547964fafdb551de91dd75e83b14e39f0d82",
  "tosAgreement": true
}

# Try to add same user again
$  curl -v -X POST -d @.data/user-info.txt http://localhost:3000/users
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 122
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 122 out of 122 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 400 Bad Request
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:38:24 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{"Error":"A user with that phone number already exists"}

# Try add user with other phone number
$  curl -v -X POST -d @.data/user-info.txt http://localhost:3000/users
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 122
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 122 out of 122 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:39:48 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact

# User with new phone numer 2222222222 has been created

$  tree .data
.data
├── user-info.txt
└── users
    ├── 1234567890.json
    ├── 2222222222.json
    ├── 5551234567.json
    └── 5555555555.json

1 directory, 5 files

# Try tosAgreement: false
#{
#  "firstName": "Jacky",
#  "lastName": "So",
#  "phone": "3333333333",
#  "password": "ThisIsaPassword",
#  "tosAgreement": false
#}

$  curl -v -X POST -d @.data/user-info.txt http://localhost:3000/users
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 123
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 123 out of 123 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 400 Bad Request
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:42:22 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{"Error":"Missing required fields"}
```

> Testing DELETE method - Delete user with phone number `2222222222`

```bash
# Delete user with phone number 2222222222
$  curl -v -X DELETE http://localhost:3000/users?phone=2222222222
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> DELETE /users?phone=2222222222 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:45:42 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact

# 2222222222.json has been deleted
$  tree .data
.data
├── user-info.txt
└── users
    ├── 1234567890.json
    ├── 5551234567.json
    └── 5555555555.json

1 directory, 4 files

```

> Testing PUT method - update user

```bash
# Add new user
$  curl -v -X POST -d @.data/user-info.txt http://localhost:3000/users
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 122
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 122 out of 122 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:51:46 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{}

# Validate new user's phone number json file
$  tree .data
```
<pre>
.data
├── user-info.txt
├── users
│   ├── 1234567890.json
│   ├── <span style="color:blue">3333333333.json</span>
│   ├── 5551234567.json
│   └── 5555555555.json
└── user-update.txt

1 directory, 6 files
</pre>

```json
$  cat .data/users/3333333333.json | jq
{
  "firstName": "Jacky",
  "lastName": "So",
  "phone": "3333333333",
  "hashedPassword": "0a2b3292782b67e914ffde869c68547964fafdb551de91dd75e83b14e39f0d82",
  "tosAgreement": true
}

$  cat .data/user-update.txt
{
  "firstName": "Mark",
  "lastName": "Mak",
  "phone": "3333333333"
}
```

```bash
$  curl -v -X PUT -d @.data/user-update.txt http://localhost:3000/users
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> PUT /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 67
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 67 out of 67 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Fri, 28 May 2021 04:53:44 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact

$  tree .data
.data
├── user-info.txt
├── users
│   ├── 1234567890.json
│   ├── 3333333333.json
│   ├── 5551234567.json
│   └── 5555555555.json
└── user-update.txt

1 directory, 6 files

$  cat .data/users/3333333333.json | jq
```
```json
{
  "firstName": "Mark",
  "lastName": "Mak",
  "phone": "3333333333",
  "hashedPassword": "0a2b3292782b67e914ffde869c68547964fafdb551de91dd75e83b14e39f0d82",
  "tosAgreement": true
}
```

[Back to Top](#nodejs---http-and-https-service-handlers)

---
