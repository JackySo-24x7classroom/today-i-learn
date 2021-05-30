# Nodejs learning - Connecting to an API

## API call - send SMS message

- [x] Dependencies
  - [x] querystring
  - [x] https
- [x] Function `sendTwilioSms`(phone, msg, callback)
  - [x] Validate parameters
    - [x] phone (string, len == 10)
    - [x] msg (string, len > 0 and < 1600) `# as per Twilio service limit`
    - [x] when `phone` and `msg` all good
      - [x] Construct API request payload
        - [x] `From` : twilio.fromPhone value configured in config library
        - [x] `To` : Area code +1 plus `phone`
	- [x] `Body` : `msg`
      - [x] Declare Payload string using function `querystring.stringify`
      - [x] Construct request details
        - [x] `protocol` : https:
        - [x] `hostname` : api.twilio.com
        - [x] `method` : POST
        - [x] URL `path`
	  - [x] `/2010-04-01/Accounts/` + 
	  - [x] `twilio.accountSid` value configured in config library +
	  - [x] `/Messages.json`
        - [x] `auth`
	  - [x] `twilio.accountSid` value configured in config library +
	  - [x] `twilio.authToken` value configured in config library
        - [x] `headers`
          - [x] 'Content-Type' : 'application/x-www-form-urlencoded'
          - [x] 'Content-Length': Buffer.byteLength(stringPayload)
      - [x] Instantiate the request object
        - [x] Send Request - Call `https.request`
          - [x] Grab the status `statusCode` of the sent request
	    - [x] When status == 200 or 201
	      - [x] callback false
	      [x] Else
	      - [x] callback message `"Status code returned was " +status`
      - [x] Bind to the error event so it doesn't get thrown
      - [x] Write the payload to API call
      - [x] End the API request
    - [x] Else callback message `Given parameters were missing or invalid`
	      
<details><summary><i>Click to see code</i></summary><br>

```javascript
sendTwilioSms = function(phone,msg,callback){
  // Validate parameters
  phone = typeof(phone) == 'string' && phone.trim().length == 10 ? phone.trim() : false;
  msg = typeof(msg) == 'string' && msg.trim().length > 0 && msg.trim().length <= 1600 ? msg.trim() : false;
  if(phone && msg){

    // Construct the API request payload
    var payload = {
      'From' : config.twilio.fromPhone,
      'To' : '+1'+phone,
      'Body' : msg
    };
    var stringPayload = querystring.stringify(payload);


    // Construct the request details
    var requestDetails = {
      'protocol' : 'https:',
      'hostname' : 'api.twilio.com',
      'method' : 'POST',
      'path' : '/2010-04-01/Accounts/'+config.twilio.accountSid+'/Messages.json',
      'auth' : config.twilio.accountSid+':'+config.twilio.authToken,
      'headers' : {
        'Content-Type' : 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(stringPayload)
      }
    };

    // Instantiate the request object
    var req = https.request(requestDetails,function(res){
        // Grab the status of the sent request
        var status =  res.statusCode;
        // Callback successfully if the request went through
        if(status == 200 || status == 201){
          callback(false);
        } else {
          callback('Status code returned was '+status);
        }
    });

    // Bind to the error event so it doesn't get thrown
    req.on('error',function(e){
      callback(e);
    });

    // Write the payload to API call
    req.write(stringPayload);

    // End the API request
    req.end();

  } else {
    callback('Given parameters were missing or invalid');
  }
};
```
</details><br>

> Deploy code into helpers library and share for use

```javascript
/*
 * Helpers for various tasks
 *
 */

// Dependencies
var config = require('./config');
var https = require('https');
var querystring = require('querystring');

// Container for all the helpers
var helpers = {};

helpers.sendTwilioSms = function(phone,msg,callback){
  // Validate parameters
  phone = typeof(phone) == 'string' && phone.trim().length == 10 ? phone.trim() : false;
  msg = typeof(msg) == 'string' && msg.trim().length > 0 && msg.trim().length <= 1600 ? msg.trim() : false;
  if(phone && msg){

    // Construct the API request payload
    var payload = {
      'From' : config.twilio.fromPhone,
      'To' : '+1'+phone,
      'Body' : msg
    };
    var stringPayload = querystring.stringify(payload);

    // Construct the request details
    var requestDetails = {
      'protocol' : 'https:',
      'hostname' : 'api.twilio.com',
      'method' : 'POST',
      'path' : '/2010-04-01/Accounts/'+config.twilio.accountSid+'/Messages.json',
      'auth' : config.twilio.accountSid+':'+config.twilio.authToken,
      'headers' : {
        'Content-Type' : 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(stringPayload)
      }
    };

    // Instantiate the request object
    var req = https.request(requestDetails,function(res){
        // Grab the status of the sent request
        var status =  res.statusCode;
        // Callback successfully if the request went through
        if(status == 200 || status == 201){
          callback(false);
        } else {
          callback('Status code returned was '+status);
        }
    });

    // Bind to the error event so it doesn't get thrown
    req.on('error',function(e){
      callback(e);
    });

    // Write the payload to API call
    req.write(stringPayload);

    // End the API request
    req.end();

  } else {
    callback('Given parameters were missing or invalid');
  }
};

// Export the module
module.exports = helpers;
```

> Write `sms.js` to call helpers.sendTwilioSms

`sms.js`

```javascript
/*
 * Primary file for call API request
 *
 */

// Dependencies
var config = require('./lib/config');
var helpers = require('./lib/helpers');

// Call Twilio service and send SMS - helpers.sendTwilioSms

helpers.sendTwilioSms('1234567890','This is SMS test message, Hello', function(err){
  console.log(`This was error message`,err)
});

```

> Test - Call a invalid phone number

```bash
$  node sms.js
This was error message Status code returned was 400
```

> Test - Call a valid phone number
```bash
$  node sms.js
This was error message false
```

`Note`: No error on valid phone number calling
