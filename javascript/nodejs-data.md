# Nodejs - Develop data library for file manipulation

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Dependencies and Module](#dependencies-and-module)
- [Write file](#write-file)
- [Read file](#read-file)
- [Update file](#update-file)
- [Delete file](#delete-file)
- [List item in directory](#list-item-in-directory)

<!-- vim-markdown-toc -->

- [ ] Dependencies
- [ ] Container for module (to be exported)
- [ ] Base directory of data folder
  - [ ] Current folder of this module +
    - [ ] Relative path of `.data` folder
- [ ] Functions
  - [ ] Write data to a file
    - [ ] Open the file for writing
      - [ ] Convert data to string
      - [ ] Write to file and close it
  - [ ] Read data from a file
  - [ ] Update data in a file
    - [ ] Open the file for writing
      - [ ] Convert data to string
      - [ ] Truncate the file
        - [ ] Write to file and close it
  - [ ] Delete a file
    - [ ] Open the file for writing
      - [ ] Convert data to string
      - [ ] Write to file and close it
- [ ] Export the module

## Dependencies and Module

> Dependencies

- [x] Dependencies
  - [x] `path`
  - [x] `fs`

```javascript
/*
 * Library for storing and editing data
 *
 */

// Dependencies
var fs = require('fs');
var path = require('path');
```

> Container for module


- [x] Container for module (to be exported)
  - [x] `lib`
- [x] Base directory of data folder
- [x] Export the module

```javascript
// Container for module (to be exported)
var lib = {};

// Base directory of data folder
lib.baseDir = path.join(__dirname,'/../.data/');

// Export the module
module.exports = lib;
```

[Back to Top](#nodejs---develop-data-library-for-file-manipulation)

---

## Write file

> `Function` - Write data to file

- [x] Functions
  - [x] Write data to a file
    - [x] Open the file for writing
      - [x] `lib.baseDir`/`dir`/`file`.json
      - [x] in write mode `wx`
      - [x] function
        - [x] err
	- [x] fileDescriptor
      - [x] When err
        - [x] Callback err msg `Failed to open new file` + `Reason`
      - [x] When No err
        - [x] Convert data to string
          - [x] JSON format
        - [x] Write to file
          - [x] When err
            - [x] Callback err msg `Failed to write`
          - [x] When No err
            - [x] Close it
              - [x] When err
                - [x] Callback err msg `Failed to close`
              - [x] When No err
                - [x] Callback `False`


```javascript
// Write data to a file
lib.create = function(dir,file,data,callback){
  // Open the file for writing
  fs.open(lib.baseDir+dir+'/'+file+'.json', 'wx', function(err, fileDescriptor){
    if(!err && fileDescriptor){
      // Convert data to string
      var stringData = JSON.stringify(data);

      // Write to file and close it
      fs.writeFile(fileDescriptor, stringData,function(err){
        if(!err){
          fs.close(fileDescriptor,function(err){
            if(!err){
              callback(false);
            } else {
              callback('Error closing new file');
            }
          });
        } else {
          callback('Error writing to new file');
        }
      });
    } else {
      callback('Could not create new file, it may already exist');
    }
  });

};
```

> Testing - Write data to new file function

> Write javascript `test.js` to test file creation and store data into file

```javascript
/*
 * Primary file for Testing
 *
 */

// Dependencies
var _data = require('./lib/data');
var fs = require('fs');

// Testing
_data.create('demo','newfile',{'foo' : 'bar'},function(err){
  console.log('This was the error', err);
});
```

```bash
$ mkdir -p .data/demo

$  node test.js
This was the error false

$  ls .data/demo
newfile.json

$  cat .data/demo/newfile.json
{"foo":"bar"}

$  cat .data/demo/newfile.json  | jq
```
```json
{
  "foo": "bar"
}
```

[Back to Top](#nodejs---develop-data-library-for-file-manipulation)

---

## Read file

> `Function` - Read data from file

- [x] Functions
  - [x] Read data from a file
    - [x] `lib.baseDir`/`dir`/`file`.json
    - [x] with `utf8` encoding
    - [x] function
        - [x] err
	- [x] data
        - [x] Callback `err` if any + `data`

```javascript
// Read data from a file
lib.read = function(dir,file,callback){
  fs.readFile(lib.baseDir+dir+'/'+file+'.json', 'utf8', function(err,data){
    callback(err,data);
  });
};
```

> Testing - Read data from file

> Write javascript `test.js` to test file reading

```javascript
/*
 * Primary file for Testing
 *
 */

// Dependencies
var _data = require('./lib/data');
var fs = require('fs');

// Testing for read file
_data.read('demo','newfile1',function(err,data){
  if(!err){
    console.log('This is data in file', data);
  } else {
    console.log('This was error', err);
  };
});

```

> Run test

```bash
$  node test.js
This is data in file {"foo":"bar"}
```

> Update `test.js` with not existed file `newfile1.json` and run test again

```bash
$  node test.js

This was error { [Error: ENOENT: no such file or directory, open '..../.data/demo/newfile1.json']
  errno: -2,
  code: 'ENOENT',
  syscall: 'open',
  path:
   '..../.data/demo/newfile1.json' }

```

[Back to Top](#nodejs---develop-data-library-for-file-manipulation)

---

## Update file

> `Function` - Update data in existing file

- [x] Functions
  - [x] Update file
    - [x] `lib.baseDir`/`dir`/`file`.json
    - [x] mode `r+`
    - [x] function
      - [x] err
      - [x] fileDescriptor
    - [x] When err
        - [x] Callback err msg `Failed to open file for update` + `Reason`
    - [x] When No err
      - [x] Convert data to string
        - [x] JSON format
      - [x] Truncate file
        - [x] fileDescriptor
	- [x] function
	  - [x] err
        - [x] When err
          - [x] Callback err msg `Failed to truncate file`
        - [x] When No err
          - [x] Write to file
            - [x] fileDescriptor
            - [x] stringData
            - [x] Function
              - [x] err
            - [x] When err
              - [x] Callback err msg `Failed to write data to file`
            - [x] When No err
              - [x] Close file
                - [x] fileDescriptor
                - [x] Function
                  - [x] err
                - [x] When err
                  - [x] Callback err msg `Failed to close file`
                - [x] When No err
                  - [x] Callback `False`

```javascript
// Update data in a file
lib.update = function(dir,file,data,callback){

  // Open the file for writing
  fs.open(lib.baseDir+dir+'/'+file+'.json', 'r+', function(err, fileDescriptor){
    if(!err && fileDescriptor){
      // Convert data to string
      var stringData = JSON.stringify(data);

      // Truncate the file
      fs.truncate(fileDescriptor,function(err){
        if(!err){
          // Write to file and close it
          fs.writeFile(fileDescriptor, stringData,function(err){
            if(!err){
              fs.close(fileDescriptor,function(err){
                if(!err){
                  callback(false);
                } else {
                  callback('Error closing existing file');
                }
              });
            } else {
              callback('Error writing to existing file');
            }
          });
        } else {
          callback('Error truncating file');
        }
      });
    } else {
      callback('Could not open file for updating, it may not exist yet');
    }
  });

};
```

> Testing - Update data in existing file

> Write javascript `test.js` to test file updating

```javascript
// Dependencies
var _data = require('./lib/data');
var fs = require('fs');

// Testing for update
_data.update('demo','newfile',{'hello' : 'jacky'},function(err){
  console.log('This was the error', err);
});

```

```bash
$  node test.js
This was the error false
$  cat .data/demo/newfile.json
{"hello":"jacky"}
$  cat .data/demo/newfile.json | jq
```
```json
{
  "hello": "jacky"
}
```

[Back to Top](#nodejs---develop-data-library-for-file-manipulation)

---

## Delete file

> `Function` - Delete a file

- [x] Functions
  - [x] Delete file
    - [x] `lib.baseDir`/`dir`/`file`.json
    - [x] mode `r+`
    - [x] function
      - [x] err
      - [x] fileDescriptor
    - [x] When err
      - [x] Callback err msg `Failed to delete file`
    - [x] When No err
      - [x] Callback `False`

```javascript
// Delete a file
lib.delete = function(dir,file,callback){

  // Unlink the file from the filesystem
  fs.unlink(lib.baseDir+dir+'/'+file+'.json', function(err){
    callback(err);
  });

};
```

> Testing - Delete file

> Write javascript `test.js` to test file deleting

```javascript
// Dependencies
var _data = require('./lib/data');
var fs = require('fs');

```

> Run script to delete file newfile.json

```bash
$  node test.js
This was the error null

$  ls -al .data/demo/
total 8
drwxrwxr-x 2 jso jso 4096 May 27 18:38 .
drwxrwxr-x 3 jso jso 4096 May 27 17:41 ..
```

> Update test.js to delete not existing file `newfile1.json`

```bash
$  node test.js
This was the error { [Error: ENOENT: no such file or directory, unlink '..../.data/demo/newfile1.json']
  errno: -2,
  code: 'ENOENT',
  syscall: 'unlink',
  path:
   '..../.data/demo/newfile1.json' }
```

[Back to Top](#nodejs---develop-data-library-for-file-manipulation)

---

## List item in directory

> `Function` - List file in directory

- [x] Functions
  - [x] List files in directory
    - [x] `lib.baseDir`/`dir`/
    - [x] function
      - [x] err
      - [x] data
    - [x] When no err and length of data greater than zero
      - [x] Loop through files found in directory
        - [x] Strip file suffix when ends with `.json`
        - [x] Store stripped filename into file list
      - [x] Callback
        - [x] false
	- [x] file list
    - [x] When err
      - [x] Callback err

```javascript
// List all the items in a directory
lib.list = function(dir,callback){
  fs.readdir(lib.baseDir+dir+'/', function(err,data){
    if(!err && data && data.length > 0){
      var trimmedFileNames = [];
      data.forEach(function(fileName){
        trimmedFileNames.push(fileName.replace('.json',''));
      });
      callback(false,trimmedFileNames);
    } else {
      callback(err,data);
    }
  });
};
```

> Testing for directory listing function

```bash
$  node test.js
File in directory [ 'newfile' ]

# Add more files into `.data/demo` folder
$  touch .data/demo/newfile1.json
$  touch .data/demo/newfile2.txt

$  node test.js
File in directory [ 'newfile', 'newfile1', 'newfile2.txt' ]

# Add file `newfile2.json` into folder
$  touch .data/demo/newfile2.json
$  node test.js
File in directory [ 'newfile', 'newfile1', 'newfile2', 'newfile2.txt' ]

```

[Back to Top](#nodejs---develop-data-library-for-file-manipulation)

---
