# Nodejs - console log with timestamp and time ran

> Wondering how to add timestamp in console log when running nodejs?

* Use `console-stamp`

```javascript
/*
 * Using setTimeout to demonstrate event loop
 *
 */

// Dependencies
// npm install console-stamp --save
require('console-stamp')(console, '[HH:MM:ss.l]');

// add timestamps in front of log messages
// First 
console.log('First');

// Last
setTimeout(() => {
  console.log('Last');
}, 1000);

// Second Last
setTimeout(() => {
console.log('Second Last');
}, 200);

console.log('Last');
```

> Result

```bash
$  node flow.js
[[11:47:10.156]] [LOG]   First
[[11:47:10.159]] [LOG]   Last
[[11:47:10.361]] [LOG]   Second Last
[[11:47:11.160]] [LOG]   Last
```

* Use `log-timestamp`

```javascript
/*
 * Using setTimeout to demonstrate event loop
 *
 */

// Dependencies
// npm install log-timestamp --save
require('log-timestamp');

// add timestamps in front of log messages
// First 
console.log('First');

// Last
setTimeout(() => {
  console.log('Last');
}, 1000);

// Second Last
setTimeout(() => {
console.log('Second Last');
}, 200);

console.log('Last');
```

> Result

```bash
$  node flow.js
[2021-06-03T01:55:38.757Z] First
[2021-06-03T01:55:38.760Z] Last
[2021-06-03T01:55:38.962Z] Second Last
[2021-06-03T01:55:39.761Z] Last
```

***Install dependencies***

<details><summary><b>Show Makefile code</b></summary><br>

```cmake

console-stamp: ## Add console-stamp
ifndef GLOBAL
        @npm install $@ --save
else
        @sudo npm install $@ --save --global
endif

log-timestamp: ## Add log-timestamp
ifndef GLOBAL
        @npm install $@ --save
else
        @sudo npm install $@ --save --global
endif
```

</details>

> Usages and examples

```bash
$  make

 Choose a command run:

console-stamp                            Add console-stamp
log-timestamp                            Add log-timestamp

$  make console-stamp GLOBAL=true

added 8 packages, and audited 9 packages in 2s

2 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
npm notice
npm notice New minor version of npm available! 7.10.0 -> 7.15.1
npm notice Changelog: https://github.com/npm/cli/releases/tag/v7.15.1
npm notice Run npm install -g npm@7.15.1 to update!
npm notice


$  make log-timestamp

added 2 packages, and audited 12 packages in 2s

2 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

---

> Wondering how to add time running to have better observability when diagnosing performance

> Add `start time` and compare at run ends

**Code**

```javascript
/*
 * Using setTimeout to demonstrate event loop and capture time ran
 *
 */

// Dependencies
// npm install log-timestamp --save
require('log-timestamp');

// add timestamps in front of log messages
const start = Date.now();
console.log('First');
setTimeout(() => {
  console.log(`Last, after: ${Date.now() - start}ms`);
}, 100);
console.log('Second');
```

```bash
$  node flow-event.js
[2021-06-03T02:21:32.812Z] First
[2021-06-03T02:21:32.815Z] Second
[2021-06-03T02:21:32.916Z] Last, after: 104ms
$  node flow-event.js
[2021-06-03T02:21:40.055Z] First
[2021-06-03T02:21:40.058Z] Second
[2021-06-03T02:21:40.158Z] Last, after: 103ms
$  node flow-event.js
[2021-06-03T02:21:47.132Z] First
[2021-06-03T02:21:47.135Z] Second
[2021-06-03T02:21:47.237Z] Last, after: 105ms
$  node flow-event.js
[2021-06-03T02:21:51.427Z] First
[2021-06-03T02:21:51.430Z] Second
[2021-06-03T02:21:51.531Z] Last, after: 104ms
```

---
