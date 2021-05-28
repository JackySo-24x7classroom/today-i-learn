# Golang Unit testing - Basic tests

> Go has a built-in testing command called go test and a package `testing` which combine to give a minimal but complete testing experience. The standard tool-chain also includes benchmarking and statement-based code coverage

> A unit test is a function that tests a specific piece or set of code from a package or program. The job of the test is to determine whether the code in question is working as expected for a given scenario.
* One scenario may be a positive-path test, where the test is making sure the normal execution of the code doesn’t produce an error. This could be a test that validates that the code can insert a job record into the database
successfully. 
* Other unit tests may test negative-path scenarios to make sure the code produces not only an error, but the expected one. This could be a test that makes a query against a database where no results are found, or performs an invalid update against a database.
> In both cases, the test would validate that the error is reported and the correct error context is provided. In the end, `the code you write must be predictable` no matter how it’s called or executed. 

>  There are several ways in Go to write unit tests.
- [x] Basic tests test a specific piece of code for a single set of parameters and result.
- [ ] Table tests also test a specific piece of code, but the test validates itself against multiple parameters and results.
- [ ] There are also ways to mock external resources that the test code needs, such as databases or web servers. This helps to simulate the existence of these resources during testing without the need for them to be available.
- [ ] when building your own web services, there are ways to test calls coming in to the service without ever needing to run the service itself.

## `Basic tests`

<details><summary><i>Click to see go code</i></summary><br>

```golang
// Sample test to show how to write a basic unit test.
package listing01

import (
	"net/http"
	"testing"
)

const checkMark = "\u2713"
const ballotX = "\u2717"

// TestDownload validates the http Get function can download content.
func TestDownload(t *testing.T) {
	url := "https://www.manning.com/"
	statusCode := 200

	t.Log("Given the need to test downloading content.")
	{
		t.Logf("\tWhen checking \"%s\" for status code \"%d\"",
			url, statusCode)
		{
			resp, err := http.Get(url)
			if err != nil {
				t.Fatal("\t\tShould be able to make the Get call.",
					ballotX, err)
			}
			t.Log("\t\tShould be able to make the Get call.",
				checkMark)

			defer resp.Body.Close()

			if resp.StatusCode == statusCode {
				t.Logf("\t\tShould receive a \"%d\" status. %v",
					statusCode, checkMark)
			} else {
				t.Errorf("\t\tShould receive a \"%d\" status. %v %v",
					statusCode, ballotX, resp.StatusCode)
			}
		}
	}
}
```

</details>

```bash
$  go test -v
=== RUN   TestDownload
    TestDownload: listing01_test.go:18: Given the need to test downloading content.
    TestDownload: listing01_test.go:20: 	When checking "https://www.manning.com/" for status code "200"
    TestDownload: listing01_test.go:28: 		Should be able to make the Get call. ✓
    TestDownload: listing01_test.go:34: 		Should receive a "200" status. ✓
--- PASS: TestDownload (1.25s)
PASS
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/projects-github/go-in-action-code/chapter9/listing01	1.248s
```

`Note`

* The Go testing tool will only look at files that end in `_test.go`

	```bash
	$  tree listing01
	listing01
	└── listing01_test.go
	```

* The testing package provides the support we need from the testing framework to report the output and status of any test

	```golang
	import (
	        "testing"
	)
	```

* Two constants that contain the characters for the check mark and X mark that will be used when writing test outpu

	```golang
	const checkMark = "\u2713"
	const ballotX = "\u2717"
	```

* The name of the test function is `TestDownload`. A test function must be an exported function that begins with the word `Test`, not only must the function start with the word Test, it must have a signature that accepts a `pointer of type testing.T` and returns no value

	```golang
	 // TestDownload function
	func TestDownload(t *testing.T) {
	...
	}
	```

* `t.Log method` is used to write a message to the test output. There’s also a format version of this method called `t.Logf`. If the verbose option (-v) isn’t used when calling go test, we won’t see any test output unless the test fails. 


	```golang
	t.Log("Given the need to test downloading content.")

	t.Logf("\tWhen checking \"%s\" for status code \"%d\"",
	url, statusCode)
	{
	```

	> `go test` with and without `-v` option for `PASS` and `FAIL` cases

	```bash
	$  go test
	PASS
	ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/projects-github/go-in-action-code/chapter9/listing01	1.245s

	$  go test -v
	=== RUN   TestDownload
	    TestDownload: listing01_test.go:18: Given the need to test downloading content.
	    TestDownload: listing01_test.go:20: 	When checking "https://www.manning.com/" for status code "200"
	    TestDownload: listing01_test.go:28: 		Should be able to make the Get call. ✓
	    TestDownload: listing01_test.go:34: 		Should receive a "200" status. ✓
	--- PASS: TestDownload (0.56s)
	PASS
	ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/projects-github/go-in-action-code/chapter9/listing01	0.564s

	$  go test
	--- FAIL: TestDownload (1.24s)
	    listing01_test.go:18: Given the need to test downloading content.
	    listing01_test.go:20: 	When checking "http://www.goinggo.net/feeds/posts/default?alt=rss" for status code "200"
	    listing01_test.go:28: 		Should be able to make the Get call. ✓
	    listing01_test.go:37: 		Should receive a "200" status. ✗ 404
	FAIL
	exit status 1
	FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/projects-github/go-in-action-code/chapter9/listing01	1.246s
	```

* Get function from the http package to make a request to the web server. After the Get call returns, the error value is checked to see if the call was successful or not. In either case, we state what the result of the test should be. If the call failed, we write an X as well to the test output along with the error. If the test succeeded, we write a check mark.  If the call to Get does fail, the use of the `t.Fatal` method lets the testing framework know this unit test has failed. The t.Fatal method not only reports the unit test has failed, but also writes a message to the test output and then stops the execution of this particular test function. If there are other test functions that haven’t run yet, they’ll be executed. A formatted version of this method is named t.Fatalf. When we need to report the test has failed but don’t want to stop the execution of the particular test function, we can use the `t.Error` family of methods.
`Note` -  When we need to report the test has failed but don’t want to stop the execution of the particular test function, we can use the `t.Error` family of methods.

* Status code from the response is compared with the status code we expect to receive. Again, we state what the result of the test should be. If the status codes match, then we use the t.Logf method; otherwise, we use the t.Errorf method. Since the t.Errorf method doesn’t stop the execution of the test function, if there were more tests to conduct after it, the unit test would continue to be executed. If the t.Fatal or t.Error functions aren’t called by a test function, the test will be considered as passing 

	```golang
	{
		resp, err := http.Get(url)
		if err != nil {
			t.Fatal("\t\tShould be able to make the Get call.",
				ballotX, err)
		}
		t.Log("\t\tShould be able to make the Get call.",
			checkMark)

		defer resp.Body.Close()

		if resp.StatusCode == statusCode {
			t.Logf("\t\tShould receive a \"%d\" status. %v",
				statusCode, checkMark)
		} else {
			t.Errorf("\t\tShould receive a \"%d\" status. %v %v",
				statusCode, ballotX, resp.StatusCode)
		}
	}
	```



---

[Golang basics - writing unit tests]: https://blog.alexellis.io/golang-writing-unit-tests/

[Golang basics - fetch JSON from an API]: https://blog.alexellis.io/golang-json-api-client/

[5 keys to create a killer CLI in Go]: https://blog.alexellis.io/5-keys-to-a-killer-go-cli/
