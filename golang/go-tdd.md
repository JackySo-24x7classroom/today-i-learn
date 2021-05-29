# Test Driven Development - Golang

`Table of Content`

<!-- vim-markdown-toc GFM -->

- [Simple golang program - generates console output and QR code image](#simple-golang-program---generates-console-output-and-qr-code-image)
- [Test Driven Development](#test-driven-development)
	- [Red Green and Refactor](#red-green-and-refactor)
	- [More refactoring](#more-refactoring)
	- [Add versioning with TDD](#add-versioning-with-tdd)
- [Take away](#take-away)
- [Reference](#reference)

<!-- vim-markdown-toc -->

## Simple golang program - generates console output and QR code image

`Initial version`

<pre>└── qrcoded.go</pre>

```golang
package main

// Dependencies
import (
	"fmt"
	"io/ioutil"
)

// Main function running logic
func main() {
	// Print formatted message
	fmt.Println("Hello QR Code")

	// Run GenerateQRCode with supplied QR string
	qrcode := GenerateQRCode("555-2368")
	// Write file with return of GenerateQRCode function
	ioutil.WriteFile("qrcode.png", qrcode, 0644)
}

// GenerateQRCode function but return nil
func GenerateQRCode(code string) []byte {
	return nil
}
```

`Test run this program`

- [x] `go run` program
  - [x] Console output
  - [x] empty QR image file
- [x] `go build` program
  - [x] binary program `qrcoded` generated
- [x] Run program `qrcoded`
  - [x] Console output
  - [x] empty QR image file
- [x] `go clean`
  - [x] Clean up binary program `qrcoded`

<pre>
$  go run qrcoded.go 
Hello QR Code


├── qrcode.png
└── qrcoded.go

$  file qrcode.png
qrcode.png: empty

$  go build qrcoded.go 

├── qrcoded
├── qrcode.png
└── qrcoded.go

$  ./qrcoded 
Hello QR Code

$  go clean

├── qrcode.png
└── qrcoded.go
</pre>

[Back to Top](#test-driven-development---golang)

---

## Test Driven Development

> Test-driven development (TDD) is a strict discipline for creating modular, well-designed and testable code without doing any upfront design. It achieves this by making you work in extremely short cycles: create an automated test, write the minimum amount of code to satisfy that test, and refactor your code to improve the quality. This approach ensures a few nice properties of the resulting code:

1. Starting with a test forces you to think about the intended behavior;
2. Writing code based on a test forces you to write testable code;
3. Immediately refactoring the result forces you to think about your code and how it fits in the larger picture.

- [x] Test Function
  - [x] Run GenerateQRCode function QR string
    - [x] When result == nil
      - [x] Error message `Generated QRCode is nil`
    - [x] When result != nil
      - [x] When length of result == 0
        - [x] Error message `Generated QRCode has no data`

<pre>
├── qrcoded_test.go
└── qrcoded.go
</pre>

`qrcoded_test.go`

```golang
package main

import (
        "testing"
)

// Test function
func TestGenerateQRCodeReturnsValue(t *testing.T) {
	// Run GenerateQRCode function in `qrcoded.go`
	result := GenerateQRCode("555-2368")

	// Assertions of the test - expected values
	if result == nil {
		t.Errorf("Generated QRCode is nil")
	}

	if len(result) == 0 {
		t.Errorf("Generated QRCode has no data")
	}
}
```

`Run Test`

```bash
$  go test -v -cover
=== RUN   TestGenerateQRCodeReturnsValue
    TestGenerateQRCodeReturnsValue: qrcoded_test.go:11: Generated QRCode is nil
    TestGenerateQRCodeReturnsValue: qrcoded_test.go:15: Generated QRCode has no data
--- FAIL: TestGenerateQRCodeReturnsValue (0.00s)
FAIL
coverage: 25.0% of statements
exit status 1
FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.001s
```

`Note` - go test clearly runs the new unit test¹¹. And as expected, it fails. The framework clearly shows the name of the function that fails, the exact lines and the exact messages provided in the test.

> Why fail - nil and no data (See below code in `qrcoded.go`

```golang
func GenerateQRCode(code string) []byte {
	return nil
}
```

> Quick and dirty fix

```golang
func GenerateQRCode(code string) []byte {
	return []byte{0xFF}
	}
```

```diff
$  git diff qrcoded.go
diff --git a/qrcoded.go b/qrcoded.go
index ae912bc..62dbba6 100644
--- a/qrcoded.go
+++ b/qrcoded.go
@@ -13,5 +13,5 @@ func main() {
 }

 func GenerateQRCode(code string) []byte {
-       return nil
+       return []byte{0xFF}
 }
```

`Rerun Test`

```bash
$  go test -v -cover
=== RUN   TestGenerateQRCodeReturnsValue
--- PASS: TestGenerateQRCodeReturnsValue (0.00s)
PASS
coverage: 25.0% of statements
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.001s

$  go run qrcoded.go
Hello QR Code

$  ls -al qrcode.png
-rw-r--r-- 1 jso jso 1 May 29 17:20 qrcode.png

├── qrcoded_test.go
├── qrcode.png
└── qrcoded.go

```
> `GenerateQRCode` function in `qrcoded.go` no more returning nil result, it is `0xFF` and 1-byte size 

```bash
$  od -x qrcode.png
0000000 00ff
0000001
```

[Back to Top](#test-driven-development---golang)

---

### Red Green and Refactor

> TDD test-driven development is characterized by a well-defined cycle, commonly known as the Red/Green/Refactor cycle:
* Red - The cycle starts by writing a test that captures the new requirement; this test is expected to fail. Many tools display test failures in red, hence the name.
* Green - The cycle continues by writing the minimal amount of code necessary to satify the tests.  This name too is derived from the fact that many tools display test success in green. When you start practicing test-driven development, it is a common pitfall to write more than the minimal amount of code. Be aware of this, and keep asking yourself if you are doing more than the minimum required.
* Refactor - The latest step in the cycle is what makes test-driven development a viable process: it forces you to step back, to look at your code, and to improve its structure without adding any functionality. The refactor step is not an optional step¹² – without this step your code will quickly degenerate into a well-tested but incomprehensible mess.

> Let's start TDD

* `Requirement:` the byte slice returned by GenerateQRCode should represent a valid PNG image.

<pre><span style="color:red">Red cycle:</span></pre>

* The first step is to create a new test that captures this requirement. Broadly speaking, there are two ways of approaching this: you can either check if the first eight bytes match the magic header¹³ for PNGs, or you can just go ahead and decode the image – if an error occurs during decoding, you know that the byte slice did not represent a PNG.  See below `Test function code`

- [x] Dependencies
  - [x] bytes
- [x] Test function `TestGenerateQRCodeGeneratesPNG`
  - [x] Run GenerateQRCode
  - [x] New I/O buffer
  - [x] Decode buffer in PNG format
    - [x] when err
      - [x] Error message `Generated QRCode is not a PNG` + err
    - [ ] when No err

```golang
// Dependencies
import (
	"bytes"
	"testing"
	)

func TestGenerateQRCodeGeneratesPNG(t *testing.T) {
	result := GenerateQRCode("555-2368")
	buffer := bytes.NewBuffer(result)

	// Assertions of the test - length of buffer 
	if buffer.Len() == 0 {
		t.Errorf("No QRCode generated")
	} else {
		t.Logf("QRCode generated")
	}
	_, err := png.Decode(buffer)

        // Assertions of the test - PNG decoding error
	if err != nil {
		t.Errorf("Generated QRCode is not a PNG: %s", err)
	} else {
		t.Logf("Generated QRCode is a PNG")
	}
}
```

> Run tests of following code returning in qrcoded.go

1. `return nil`

<pre>
$  go test -v -cover
=== RUN   TestGenerateQRCodeGeneratesPNG
<span style="color:blue">
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:15: No QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:24: Generated QRCode is not a PNG: unexpected EOF
</span>
--- FAIL: TestGenerateQRCodeGeneratesPNG (0.00s)
FAIL
coverage: 25.0% of statements
exit status 1
FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.001s
</pre>

2. `return []byte{0xFF}`

<pre>
$  go test -v -cover
=== RUN   TestGenerateQRCodeGeneratesPNG
<span style="color:blue">
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:17: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:24: Generated QRCode is not a PNG: unexpected EOF
</span>
--- FAIL: TestGenerateQRCodeGeneratesPNG (0.00s)
FAIL
coverage: 25.0% of statements
exit status 1
FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.001s
</pre>

`Note:` - Test has identified file is not PNG

<pre><span style="color:green">Green cycle:</span> Fix the function <b><i>GenerateQRCode</i></b> program code to make run tests all passed</pre>

```golang
func GenerateQRCode(code string) []byte {
	// Generate QR image code
	img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	buf := new(bytes.Buffer)
	// Encode buffer to PNG format
	_ = png.Encode(buf, img)

	// Return buffer bytes
	return buf.Bytes()
}
```

`Run test`

```bash
  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:17: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:26: Generated QRCode is a PNG
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
PASS
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.001s
```

<pre>Green done: - <span style="color:green">Bingo, All tests has been passed.</span></pre>

`Refactor`

> The final step in the cycle is the Refactor step. I’ve said it before and I will say it again: the refactoring step is not optional in test-driven development. Without it, you’re practicing test-first development and that requires a good upfront design. If you’re so inclined, you can see the refactor step as the Prime Directive of test-driven development.

> Each refactor step starts with a question: how can I make this code better at expressing its intent, without changing the functionality?

> In this case, even though the amount of code is still very limited, there are two sore points. The first is the lack of proper error handling. However, correct error handling can be seen as a non-functional requirement, so I will tackle this in the next section using test-driven development.

> The second point is more subtle. If you look at GenerateQRCode, you can see that I am juggling around with a bytes.Buffer in order to satisfy the signature of the png.Encode function. Or, if you look at it from another direction, I have introduced this buffer because GenerateQRCode wants to return a byte slice. And that byte slice is only used to write the image to a file.  This refactoring step will get rid of the buffer. Instead of passing around byte slices, I will convert the code to work with anything that satisfies the io.Writer interface, just like the png.Encode function does.

> Refactor code in main program

1. Instead of using the ioutil.WriteFile function, I now explicitly create a file and make sure it’s closed when the main function exits

2. The GenerateQRCode function now accepts any argument that satisfies the io.Writer interface. This is a common idiom in Go, where byte-oriented input and output is preferrably done through io.Reader and io.Writer

`qrcoded.go`

- [x] Dependencies
  - [x] `os`
- [x] Main function
  - [x] Print formatted message `Hello QR Code`
  - [x] Create OS file `qrcode.png`
  - [x] Defer file close
  - [x] Run function `GenerateQRCode` 
    - [x] Argument #1 - file
    - [x] Argument #2 - QR string
- [x] Function `GenerateQRCode` 
  - [x] Generate QR image
  - [x] Encode image to PNG
  - [x] Save to io.Writer

```golang
package main

import (
	"image"
	"image/png"
	"io"
	"fmt"
	"os"
)

func main() {
	fmt.Println("Hello QR Code")

	file, _ := os.Create("qrcode.png")
	defer file.Close()

	GenerateQRCode(file, "555-2368")
	}

func GenerateQRCode(w io.Writer, code string) {
	img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	_ = png.Encode(w, img)
}
```

`Run tests on refactored main program`

```bash
$  go test -v
# _/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd [_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd.test]
./qrcoded_test.go:10:33: not enough arguments in call to GenerateQRCode
	have (string)
	want (io.Writer, string)
./qrcoded_test.go:10:33: GenerateQRCode("555-2368") used as value
FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd [build failed]
```

***Notes:*** - reporting fail with err `not enough arguments in call to GenerateQRCode`

> The tests in `qrcoded_test.go` still assume that ***GenerateQRCode*** takes one argument and returns a byte buffer

```golang

package main
// Dependencies
import (
        "bytes"
        "testing"
        "image/png"
        )

func TestGenerateQRCodeGeneratesPNG(t *testing.T) {
	// Prepare new buffer
	buffer := new(bytes.Buffer)
	// Add new argument buffer to GenerateQRCode function
	GenerateQRCode(buffer, "555-2368")
        // result := GenerateQRCode("555-2368")
        // buffer := bytes.NewBuffer(result)

        // Assertions of the test - length of buffer
        if buffer.Len() == 0 {
                t.Errorf("No QRCode generated")
	} else {
                t.Logf("QRCode generated")
        }

        _, err := png.Decode(buffer)

        // Assertions of the test - PNG decoding error
        if err != nil {
                t.Errorf("Generated QRCode is not a PNG: %s", err)
	} else {
                t.Logf("Generated QRCode is a PNG")

        }
}
```

`Run tests again` - Looks good this time, all tests are passed

```bash
$  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:19: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:28: Generated QRCode is a PNG
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
PASS
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.002s

```

3. Testing error handling - a new requirement; a non-functional requirement that is to have proper error handling.

> The call to png.Decode can result in an error, but GenerateQRCode does not do anything with that.

> Let's add error handling in `qrcoded.go`'s GenerateQRCode function

<pre>
func GenerateQRCode(w io.Writer, code string) <span style="color:blue">error</span> {
	img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	_ = png.Encode(w, img)
	// return png.Encode(w, img)
}
</pre>

> How we can test for the `error handling when error on png.Encode in GenerateQRCode function?`

> Try the following new test in `qrcoded_test.go`

<pre>
package main

import (
	"bytes"
	"errors"
	"image/png"
	"testing"
)

func TestGenerateQRCodeGeneratesPNG(t *testing.T) {
	buffer := new(bytes.Buffer)
	GenerateQRCode(buffer, "555-2368")

	// Assertions of the test - expected values
	if buffer.Len() == 0 {
		t.Errorf("No QRCode generated")
	}

	_, err := png.Decode(buffer)

	if err != nil {
		t.Errorf("Generated QRCode is not a PNG: %s", err)
	}
}

<span style="color:blue">
type ErrorWriter struct{}

func (e *ErrorWriter) Write(b []byte) (int, error) {
	return 0, errors.New("Expected error")
}

func TestGenerateQRCodePropagatesErrors(t *testing.T) {
	w := new(ErrorWriter)
	err := GenerateQRCode(w, "555-2368")

	if err == nil || err.Error() != "Expected error" {
		t.Errorf("Error not propagated correctly, got %v", err)
	}
}
</span>
</pre>

* This function turns the ErrorWriter into a stub satisfying io.Writer. Its implementation is straightforward: every call to Write will return an error

* These lines define the new test; the result of GenerateQRCode is inspected and asserted to be the expected error

> Run test

```bash
$  go test -v
# _/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd [_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd.test]
./qrcoded_test.go:42:30: GenerateQRCode(w, "555-2368") used as value
FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd [build failed]
```

> Refactor the main code to trigger error in newly added test

<pre>
func GenerateQRCode(w io.Writer, code string) <span style="color:blue">error</span> {
	img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	// _ = png.Encode(w, img)
	png.Encode(w, img)
	return nil
}
</pre>

> Run test

<pre>
$  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:20: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:29: Generated QRCode is a PNG
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
<span style="color:red">
=== RUN   TestGenerateQRCodePropagatesErrors
    TestGenerateQRCodePropagatesErrors: qrcoded_test.go:45: Error not propagated correctly, got <nil>
--- FAIL: TestGenerateQRCodePropagatesErrors (0.00s)
FAIL
</span>
exit status 1
FAIL	`_`/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.002s

</pre>

> Refactor the main code to make it GREEN on tests

<pre>
func GenerateQRCode(w io.Writer, code string) <span style="color:blue">error</span> {
	img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	return png.Encode(w, img)
</pre>

> Run test

<pre>
$  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:20: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:29: Generated QRCode is a PNG
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
<span style="color:green">
=== RUN   TestGenerateQRCodePropagatesErrors
--- PASS: TestGenerateQRCodePropagatesErrors (0.00s)
PASS
</span>
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.002s
</pre>

[Back to Top](#test-driven-development---golang)

---

### More refactoring

> All normal and error output is now handled using the log package instead of fmt. Early exits are taken care of by log.Fatal, which automatically calls os.Exit(1).

`qrcoded.go`

- [x] Dependencies
  - [x] image
  - [x] image/png
  - [x] io
  - [x] log
  - [x] os
- [x] Functions
  - [x] main
    - [x] Print log message `Hello QR Code`
    - [x] Create I/O file `qrcode.png`
      - [x] when err
        - [x] log.Fatal err
      - [ ] when No err
    - [x] Defer file `qrcode.png` close
    - [x] Run function GenerateQRCode
      - [x] on file `qrcode.png`
      - [x] QR code string `555-2368`
      - [x] when err
        - [x] log.Fatal err
      - [ ] when No err
  - [x] GenerateQRCode
    - [x] Generate QR image from input string
    - [x] Return PNG format image and write to file

`qrcoded.go`

```golang
package main

import (
	"image"
	"image/png"
	"io"
	"log"
	"os"
)

func main() {
	log.Println("Hello QR Code")

	file, err := os.Create("qrcode.png")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	err = GenerateQRCode(file, "555-2368")
	if err != nil {
		log.Fatal(err)
	}
}

func GenerateQRCode(w io.Writer, code string) error {
	img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	return png.Encode(w, img)
}
```

`qrcoded_test.go`

> Adding the following check handling

- [x] Function TestGenerateQRCodeGeneratesPNG
  - [x] Buffer length
    - [x] Message `QRCode is generated` when > 0
  - [x] png.Decode
    - [x] Message `Generated QRCode is a PNG encoding` when No err 
- [x] Function TestGenerateQRCodePropagatesErrors
  - [x] GenerateQRCode err
    - [x] Message `No error or an expected error` when err is nil or == initialized `Expected Error`

```golang
package main

import (
	"bytes"
	"errors"
	"image/png"
	"testing"
)

func TestGenerateQRCodeGeneratesPNG(t *testing.T) {
	buffer := new(bytes.Buffer)
	GenerateQRCode(buffer, "555-2368")

	if buffer.Len() == 0 {
		t.Errorf("No QRCode generated")
	} else {
		t.Logf("QRCode is generated")
	}

	_, err := png.Decode(buffer)

	if err != nil {
		t.Errorf("Generated QRCode is not a PNG: %s", err)
	} else {
		t.Logf("Generated QRCode is a PNG encoding")
	}
}

type ErrorWriter struct{}

func (e *ErrorWriter) Write(b []byte) (int, error) {
	return 0, errors.New("Expected error")
}

func TestGenerateQRCodePropagatesErrors(t *testing.T) {
	w := new(ErrorWriter)
	err := GenerateQRCode(w, "555-2368")

	if err == nil || err.Error() != "Expected error" {
		t.Errorf("Error not propagated correctly, got %v", err)
	} else {
		t.Logf("No error or an expected error")
	}
}
```

`Run tests`

<pre>
 $  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:17: QRCode is generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:25: Generated QRCode is a PNG encoding
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
=== RUN   TestGenerateQRCodePropagatesErrors
    TestGenerateQRCodePropagatesErrors: qrcoded_test.go:42: No error or an expected error
--- PASS: TestGenerateQRCodePropagatesErrors (0.00s)
PASS
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.002s
</pre>

`Run program`

```bash
$  go run qrcoded.go
2021/05/29 16:29:09 Hello QR Code

├── qrcoded.go
├── qrcoded_test.go
└── qrcode.png

$  file qrcode.png
qrcode.png: PNG image data, 21 x 21, 8-bit/color RGBA, non-interlaced

$  ls -al qrcode.png
-rw-rw-r-- 1 jso jso 89 May 29 16:29 qrcode.png
```

[Back to Top](#test-driven-development---golang)

---

### Add versioning with TDD

> The first thing versions indicate, is the size of the pattern. For example, a Version 1 QR Code has a pattern of 21x21 modules. 

`Test function` - inital version

```golang
func TestVersionDeterminesSize(t *testing.T) {
	buffer := new(bytes.Buffer)
	GenerateQRCode(buffer, "555-2368", Version(1))

	img, _ := png.Decode(buffer)
	if width := img.Bounds().Dx(); width != 21 {
		t.Errorf("Version 1, expected 21 but got %d", width)
	}
}
```

`Red Run`


```bash
$  go test -v
# _/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd [_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd.test]
./qrcoded_test.go:12:16: too many arguments in call to GenerateQRCode
	have (*bytes.Buffer, string, Version)
	want (io.Writer, string)
./qrcoded_test.go:37:23: too many arguments in call to GenerateQRCode
	have (*ErrorWriter, string, Version)
	want (io.Writer, string)
./qrcoded_test.go:46:23: too many arguments in call to GenerateQRCode
	have (*bytes.Buffer, string, Version)
	want (io.Writer, string)
FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd [build failed]
```

`Add blue colored code in main program qrcoded.go`

<pre>
func main() {
        log.Println("Hello QR Code")

        file, err := os.Create("qrcode.png")
        if err != nil {
                log.Fatal(err)
        }
        defer file.Close()

        err = GenerateQRCode(file, "555-2368"<span style="color:blue">, Version(1)</span>)
        if err != nil {
                log.Fatal(err)
        }
}

func GenerateQRCode(w io.Writer, code string<span style="color:blue">, version Version</span>) error {
	img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	return png.Encode(w, img)
}

<span style="color:blue">type Version int8</span>
</pre>

```bash
$  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:17: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:25: Generated QRCode is PNG encoded
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
=== RUN   TestGenerateQRCodePropagatesErrors
--- PASS: TestGenerateQRCodePropagatesErrors (0.00s)
=== RUN   TestVersionDeterminesSize
--- PASS: TestVersionDeterminesSize (0.00s)
PASS
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.002s
```

`Test for versions`

> New test that tests another version/size combination. But there is a better way, often used in Go testing: it is called a table-driven test.

> Table-driven tests all follow the same pattern: first, they define a ‘table’ where each row describes the input and the expected output of a specific case. Then the test iterates over those rows, applying the unit under test on the input and comparing the result with the expected output: 

```golang
func TestVersionDeterminesSize(t *testing.T) {
        buffer := new(bytes.Buffer)
        GenerateQRCode(buffer, "555-2368", Version(1))

        img, _ := png.Decode(buffer)
        if width := img.Bounds().Dx(); width != 21 {
                t.Errorf("Version 1, expected 21 but got %d", width)
	} else {
                t.Logf("Version 1, expected 21 matched %d", width)
        }
}

func TestVersionDeterminesSize(t *testing.T) {
     table := []struct {
             version  int
             expected int
     }{
             {1, 21},
             {2, 25},
             {6, 41},
             {7, 45},
             {14, 73},
             {40, 177},
     }
//
     for _, test := range table {
             size := Version(test.version).PatternSize()
             if size != test.expected {
                     t.Errorf("Version %2d, expected %3d but got %3d",
                             test.version, test.expected, size)
             }
     }
}
```

`Red run`

```bash
$  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:17: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:25: Generated QRCode is PNG encoded
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
=== RUN   TestGenerateQRCodePropagatesErrors
--- PASS: TestGenerateQRCodePropagatesErrors (0.00s)
=== RUN   TestVersionDeterminesSize
    TestVersionDeterminesSize: qrcoded_test.go:75: Version  1, expected  21 matched  21
    TestVersionDeterminesSize: qrcoded_test.go:72: Version  2, expected  25 but got  21
    TestVersionDeterminesSize: qrcoded_test.go:72: Version  6, expected  41 but got  21
    TestVersionDeterminesSize: qrcoded_test.go:72: Version  7, expected  45 but got  21
    TestVersionDeterminesSize: qrcoded_test.go:72: Version 14, expected  73 but got  21
    TestVersionDeterminesSize: qrcoded_test.go:72: Version 40, expected 177 but got  21
--- FAIL: TestVersionDeterminesSize (0.00s)
FAIL
exit status 1
FAIL	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.003s
```

`Add the following code in main program for test in various versions` 

```golang
func GenerateQRCode(w io.Writer, code string, version Version) error {
	size := 4*int(version) + 17
	// img := image.NewNRGBA(image.Rect(0, 0, 21, 21))
	img := image.NewNRGBA(image.Rect(0, 0, size, size))
	return png.Encode(w, img)
}
```

`Run tests again`

```bash
$  go test -v
=== RUN   TestGenerateQRCodeGeneratesPNG
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:17: QRCode generated
    TestGenerateQRCodeGeneratesPNG: qrcoded_test.go:25: Generated QRCode is PNG encoded
--- PASS: TestGenerateQRCodeGeneratesPNG (0.00s)
=== RUN   TestGenerateQRCodePropagatesErrors
--- PASS: TestGenerateQRCodePropagatesErrors (0.00s)
=== RUN   TestVersionDeterminesSize
    TestVersionDeterminesSize: qrcoded_test.go:75: Version  1, expected  21 matched  21
    TestVersionDeterminesSize: qrcoded_test.go:75: Version  2, expected  25 matched  25
    TestVersionDeterminesSize: qrcoded_test.go:75: Version  6, expected  41 matched  41
    TestVersionDeterminesSize: qrcoded_test.go:75: Version  7, expected  45 matched  45
    TestVersionDeterminesSize: qrcoded_test.go:75: Version 14, expected  73 matched  73
    TestVersionDeterminesSize: qrcoded_test.go:75: Version 40, expected 177 matched 177
--- PASS: TestVersionDeterminesSize (0.00s)
PASS
ok  	_/home1/jso/myob-work/work/aws-cf/git-repo/workspaces/projects/JackySo-24x7classroom/development-tdd/golang-tdd/leanpub-go-tdd	0.004s
```

`Refactor the code`

```golang

func GenerateQRCode(w io.Writer, code string, version Version) error {
	size := version.PatternSize()
	img := image.NewNRGBA(image.Rect(0, 0, size, size))
	return png.Encode(w, img)
}

type Version int8

func (v Version) PatternSize() int {
	return 4*int(v) + 17
}
```

[Back to Top](#test-driven-development---golang)

---

## Take away

* `go build` - Compile the program into an executable.
* `go clean` - Remove all compiled artefacts.
* `go run` - Compile the program, execute it, and clean up the generated executable.

## Reference

* [Github Readme][github]

* Fetch full code - `git clone --recursive https://github.com/publysher/golang-tdd.git`

* Special chapter-{01, 02, 03}- `$ git checkout chapter-01`


[github]: https://github.com/publysher/golang-tdd/blob/master/README.md
