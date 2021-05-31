# Nodejs - Add tokens handler for authentication purpose

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Add request handlers - tokens](#add-request-handlers---tokens)
- [Validation works](#validation-works)

<!-- vim-markdown-toc -->

## Add request handlers - tokens

- [ ] `index.js`
  - [ ] Add route in router
    - [ ] `tokens`
- [ ] `lib/handlers.js`
  - [ ] `users` handlers 
    - [ ] `users.get`
    - [ ] `users.post`
    - [ ] `users.put`
    - [ ] `users.delete`
      - [ ] Verify that the given token is valid for the phone number before users routines logic
        - [ ] Get `tokens` from header
        - [ ] Call `tokens.verifyToken` 
  - [ ] Add `tokens` handler
    - [ ] accept methods
      - [ ] `post`
      - [ ] `get`
      - [ ] `put`
      - [ ] `delete`
    - [ ] Initialize `tokens` handler
    - [ ] `post` method routine
      - [ ] Validate required data `phone` and `password` in post request
        - [ ] When all good
          - [ ] Lookup the user who matches that phone number
	    - [ ] When user found
	      - [ ] Hash the sent password, and compare it to the password stored in the user object
	    - [ ] When password matched
              - [ ] Create a new token with a random name. Set an expiration date 1 hour in the future.
              - [ ] Store token in file
    - [ ] `get` method routine
      - [ ] Validate required data token `id` in get request
        - [ ] When valid `id`
	  - [ ] Lookup `token`
    - [ ] `put` method routine
      - [ ] Validate required data `id` and `extend` in put request
        - [ ] When all good
          - [ ] Lookup the existing token
            - [ ] When valid `id`
              - [ ] Check to make sure the token isn't already expired
              - [ ] Set the expiration an hour from now
              - [ ] Store the new updates - expiration
    - [ ] `delete` method routine
      - [ ] Validate required data token `id` in get request
        - [ ] When valid `id`
          - [ ] Delete the token
    - [ ] `verifyToken` routine
      - [ ] Lookup the token from file
        - [ ] Check that the token is for the given user and has not expired


`index.js`

<pre>
// Define the request router
var router = {
  'ping' : handlers.ping,
  'users' : handlers.users<span style="color:blue">,
  'tokens' : handlers.tokens</span>
};
</pre>


`lib/handlers`

<pre>
handlers._users.get = function(data,callback){
  // Check that phone number is valid
  var phone = typeof(data.queryStringObject.phone) == 'string' && data.queryStringObject.phone.trim().length == 10 ? data.queryStringObject.phone.trim() : false;
  if(phone){

    <span style="color:blue">
    // Get token from headers
    var token = typeof(data.headers.token) == 'string' ? data.headers.token : false;
    // Verify that the given token is valid for the phone number
    handlers._tokens.verifyToken(token,phone,function(tokenIsValid){
      if(tokenIsValid){</span>
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
        callback(403,{"Error" : "Missing required token in header, or token is invalid."})
      }
    });
  } else {
    callback(400,{'Error' : 'Missing required field'})
  }
};
</pre>

> Add similar tokens.verifyTokens in `handlers._users.post`, `handlers._users.put`, and `handlers._user.delete` to ensure token based authentication check is in place before its users handlers logic

```javascript

// Tokens
handlers.tokens = function(data,callback){
  var acceptableMethods = ['post','get','put','delete'];
  if(acceptableMethods.indexOf(data.method) > -1){
    handlers._tokens[data.method](data,callback);
  } else {
    callback(405);
  }
};

// Container for all the tokens methods
handlers._tokens  = {};

// Tokens - post
// Required data: phone, password
// Optional data: none
handlers._tokens.post = function(data,callback){
  var phone = typeof(data.payload.phone) == 'string' && data.payload.phone.trim().length == 10 ? data.payload.phone.trim() : false;
  var password = typeof(data.payload.password) == 'string' && data.payload.password.trim().length > 0 ? data.payload.password.trim() : false;
  if(phone && password){
    // Lookup the user who matches that phone number
    _data.read('users',phone,function(err,userData){
      if(!err && userData){
        // Hash the sent password, and compare it to the password stored in the user object
        var hashedPassword = helpers.hash(password);
        if(hashedPassword == userData.hashedPassword){
          // If valid, create a new token with a random name. Set an expiration date 1 hour in the future.
          var tokenId = helpers.createRandomString(20);
          var expires = Date.now() + 1000 * 60 * 60;
          var tokenObject = {
            'phone' : phone,
            'id' : tokenId,
            'expires' : expires
          };

          // Store the token
          _data.create('tokens',tokenId,tokenObject,function(err){
            if(!err){
              callback(200,tokenObject);
            } else {
              callback(500,{'Error' : 'Could not create the new token'});
            }
          });
        } else {
          callback(400,{'Error' : 'Password did not match the specified user\'s stored password'});
        }
      } else {
        callback(400,{'Error' : 'Could not find the specified user.'});
      }
    });
  } else {
    callback(400,{'Error' : 'Missing required field(s).'})
  }
};

// Tokens - get
// Required data: id
// Optional data: none
handlers._tokens.get = function(data,callback){
  // Check that id is valid
  var id = typeof(data.queryStringObject.id) == 'string' && data.queryStringObject.id.trim().length == 20 ? data.queryStringObject.id.trim() : false;
  if(id){
    // Lookup the token
    _data.read('tokens',id,function(err,tokenData){
      if(!err && tokenData){
        callback(200,tokenData);
      } else {
        callback(404);
      }
    });
  } else {
    callback(400,{'Error' : 'Missing required field, or field invalid'})
  }
};

// Tokens - put
// Required data: id, extend
// Optional data: none
handlers._tokens.put = function(data,callback){
  var id = typeof(data.payload.id) == 'string' && data.payload.id.trim().length == 20 ? data.payload.id.trim() : false;
  var extend = typeof(data.payload.extend) == 'boolean' && data.payload.extend == true ? true : false;
  if(id && extend){
    // Lookup the existing token
    _data.read('tokens',id,function(err,tokenData){
      if(!err && tokenData){
        // Check to make sure the token isn't already expired
        if(tokenData.expires > Date.now()){
          // Set the expiration an hour from now
          tokenData.expires = Date.now() + 1000 * 60 * 60;
          // Store the new updates
          _data.update('tokens',id,tokenData,function(err){
            if(!err){
              callback(200);
            } else {
              callback(500,{'Error' : 'Could not update the token\'s expiration.'});
            }
          });
        } else {
          callback(400,{"Error" : "The token has already expired, and cannot be extended."});
        }
      } else {
        callback(400,{'Error' : 'Specified user does not exist.'});
      }
    });
  } else {
    callback(400,{"Error": "Missing required field(s) or field(s) are invalid."});
  }
};


// Tokens - delete
// Required data: id
// Optional data: none
handlers._tokens.delete = function(data,callback){
  // Check that id is valid
  var id = typeof(data.queryStringObject.id) == 'string' && data.queryStringObject.id.trim().length == 20 ? data.queryStringObject.id.trim() : false;
  if(id){
    // Lookup the token
    _data.read('tokens',id,function(err,tokenData){
      if(!err && tokenData){
        // Delete the token
        _data.delete('tokens',id,function(err){
          if(!err){
            callback(200);
          } else {
            callback(500,{'Error' : 'Could not delete the specified token'});
          }
        });
      } else {
        callback(400,{'Error' : 'Could not find the specified token.'});
      }
    });
  } else {
    callback(400,{'Error' : 'Missing required field'})
  }
};

// Verify if a given token id is currently valid for a given user
handlers._tokens.verifyToken = function(id,phone,callback){
  // Lookup the token
  _data.read('tokens',id,function(err,tokenData){
    if(!err && tokenData){
      // Check that the token is for the given user and has not expired
      if(tokenData.phone == phone && tokenData.expires > Date.now()){
        callback(true);
      } else {
        callback(false);
      }
    } else {
      callback(false);
    }
  });
};

```

[Back to Top](#nodejs---add-tokens-handler-for-authentication-purpose)

---

## Validation works

> Start node services

```bash
$  node index.js
The HTTP server is running on port 3000
The HTTPS server is running on port 3001
tokens 200
tokens 200
tokens 200
tokens 200
users 403
users 200
users 200
users 200
users 200
```

> Run to validate handlers `tokens` and `users` operations 

**Automation menu** 

```bash
$  make

 Choose a command run:

start-users-node-svc                     Run nodejs to start users services
read-user-info                           Read content of $(user-info)
read-user-update                         Read content of $(user-update)
read-user-token                          Read content of $(token-user-info)
get-user                                 Read user - Curl GET user with phone number $(PHONE)
post-user                                Add user - Curl POST user with $(user-info)
delete-user                              Delete user - Curl DELETE user with phone number $(PHONE)
put-user                                 Update user - Curl PUT user with $(user-update)
post-tokens                              Path /tokens - Curl POST tokens with $(check-info)
get-tokens                               Path /tokens - Curl GET tokens with $(TOKEN-ID)
put-tokens                               Update token to extend expiration - Curl PUT tokens with $(token-extend-info)
delete-tokens                            Delete token - Curl DELETE user with phone number $(TOKEN-ID)
```

* get method of users without token supplied in header

```bash
$  make get-user
curl -sv http://localhost:3000/users?phone=3333333333 | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users?phone=3333333333 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 403 Forbidden
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:29:44 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [77 bytes data]
* Connection #0 to host localhost left intact
{
  "Error": "Missing required token in header, or token is invalid."
}
```

`Note` - Error message received 

```json
{
  "Error": "Missing required token in header, or token is invalid."
}
```

* Create token

```
$  make post-tokens
curl -v -X POST --header application/json -d @./deliverable/nodejs-master-class/build-a-restful-api/Service 3 - Tokens/user-authenticated.json http://localhost:3000/tokens
Hit enter to run or ctrl-C to abort
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /tokens HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 55
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 55 out of 55 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:39:58 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{"phone":"3333333333","id":"wbah4ggi8ld64bq31uqb","expires":1622453998022}
```

* View newly created token

```bash
$  make get-tokens
curl -sv http://localhost:3000/tokens?id=xgazk4ifeg0skgepx28r | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /tokens?id=xgazk4ifeg0skgepx28r HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:40:08 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [85 bytes data]
* Connection #0 to host localhost left intact
```
```json
{
  "phone": "3333333333",
  "id": "xgazk4ifeg0skgepx28r",
  "expires": 1622453968841
}
```

* Delete token

```bash
$  make delete-tokens
curl -v -X DELETE http://localhost:3000/tokens?id=xgazk4ifeg0skgepx28r
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> DELETE /tokens?id=xgazk4ifeg0skgepx28r HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:41:48 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
```

* Lookup token to validate deletion

```bash
$  make get-tokens
curl -sv http://localhost:3000/tokens?id=xgazk4ifeg0skgepx28r | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /tokens?id=xgazk4ifeg0skgepx28r HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 404 Not Found
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:41:53 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [12 bytes data]
* Connection #0 to host localhost left intact
{}
```

* Create token again

```bash
$  make post-tokens
curl -v -X POST --header application/json -d @./deliverable/nodejs-master-class/build-a-restful-api/Service 3 - Tokens/user-authenticated.json http://localhost:3000/tokens
Hit enter to run or ctrl-C to abort
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /tokens HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 55
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 55 out of 55 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:42:16 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{"phone":"3333333333","id":"uvqkq9z3idcg5ye7dqin","expires":1622454136540}
```

* View newly created token

```bash
$  make get-tokens TOKEN-ID=uvqkq9z3idcg5ye7dqin
curl -sv http://localhost:3000/tokens?id=uvqkq9z3idcg5ye7dqin | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /tokens?id=uvqkq9z3idcg5ye7dqin HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:42:34 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [85 bytes data]
* Connection #0 to host localhost left intact
```
```json
{
  "phone": "3333333333",
  "id": "uvqkq9z3idcg5ye7dqin",
  "expires": 1622454136540
}
```

* Update token - extend expiration

```bash
$  make put-tokens
curl -v -X PUT -d @./deliverable/nodejs-master-class/build-a-restful-api/Service 3 - Tokens/token-extend.json http://localhost:3000/tokens
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> PUT /tokens HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 47
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 47 out of 47 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:44:28 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
```

* View token new expiration

```bash
$  make get-tokens TOKEN-ID=uvqkq9z3idcg5ye7dqin
curl -sv http://localhost:3000/tokens?id=uvqkq9z3idcg5ye7dqin | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /tokens?id=uvqkq9z3idcg5ye7dqin HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:45:05 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [85 bytes data]
* Connection #0 to host localhost left intact
```
```json
{
  "phone": "3333333333",
  "id": "uvqkq9z3idcg5ye7dqin",
  "expires": 1622454268521
}
```

* Update token - expiration

```bash
$  make put-tokens
curl -v -X PUT -d @./deliverable/nodejs-master-class/build-a-restful-api/Service 3 - Tokens/token-extend.json http://localhost:3000/tokens
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> PUT /tokens HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> Content-Length: 47
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 47 out of 47 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:45:12 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
{}
```

* View token - new expiration

```bash
$  make get-tokens TOKEN-ID=uvqkq9z3idcg5ye7dqin
curl -sv http://localhost:3000/tokens?id=uvqkq9z3idcg5ye7dqin | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /tokens?id=uvqkq9z3idcg5ye7dqin HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:45:15 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [85 bytes data]
* Connection #0 to host localhost left intact
```
```json
{
  "phone": "3333333333",
  "id": "uvqkq9z3idcg5ye7dqin",
  "expires": 1622454312139
}
```

* View user with token in request header

```bash
$  make get-user
curl -sv http://localhost:3000/users?phone=3333333333 | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users?phone=3333333333 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> token: uvqkq9z3idcg5ye7dqin
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 08:59:18 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [89 bytes data]
* Connection #0 to host localhost left intact
```
```json
{
  "firstName": "Jacky",
  "lastName": "So",
  "phone": "3333333333",
  "tosAgreement": true
}
```

* View user with token

```bash
$  make get-user TOKEN-ID=uvqkq9z3idcg5ye7dqin
curl -sv http://localhost:3000/users?phone=3333333333 | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users?phone=3333333333 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> token: uvqkq9z3idcg5ye7dqin
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 09:00:18 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [89 bytes data]
* Connection #0 to host localhost left intact
```
```json
{
  "firstName": "Jacky",
  "lastName": "So",
  "phone": "3333333333",
  "tosAgreement": true
}
```

* Delete user with token

```bash
$  make delete-user TOKEN-ID=uvqkq9z3idcg5ye7dqin
curl -v -X DELETE http://localhost:3000/users?phone=3333333333
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> DELETE /users?phone=3333333333 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> token: uvqkq9z3idcg5ye7dqin
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 09:03:07 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
```

* Create user with token

```bash
$  make post-user TOKEN-ID=uvqkq9z3idcg5ye7dqin
curl -v -X POST -d @./deliverable/nodejs-master-class/build-a-restful-api/Service 2 - Users/.data/user-info.txt http://localhost:3000/users
Hit enter to run or ctrl-C to abort
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> POST /users HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> token: uvqkq9z3idcg5ye7dqin
> Content-Length: 122
> Content-Type: application/x-www-form-urlencoded
>
* upload completely sent off: 122 out of 122 bytes
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 09:04:14 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
* Connection #0 to host localhost left intact
```

* View new created user

```bash
$  make get-user TOKEN-ID=uvqkq9z3idcg5ye7dqin
curl -sv http://localhost:3000/users?phone=3333333333 | jq
Hit enter to run or ctrl-C to abort
*   Trying 127.0.0.1:3000...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
> GET /users?phone=3333333333 HTTP/1.1
> Host: localhost:3000
> User-Agent: curl/7.68.0
> Accept: */*
> token: uvqkq9z3idcg5ye7dqin
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Content-Type: application/json
< Date: Mon, 31 May 2021 09:04:23 GMT
< Connection: keep-alive
< Transfer-Encoding: chunked
<
{ [89 bytes data]
* Connection #0 to host localhost left intact
{
  "firstName": "Jacky",
  "lastName": "So",
  "phone": "3333333333",
  "tosAgreement": true
}
```

[Back to Top](#nodejs---add-tokens-handler-for-authentication-purpose)

---
