---
title: "How to Mock Gin-Gonic for JSON Response"
thumbnailImagePosition: top
thumbnailImage: //res.cloudinary.com/dweyilbvh/image/upload/
coverImage: //res.cloudinary.com/dweyilbvh/image/upload/
coverCaption: This is caption
metaAlignment: center
coverMeta: out
date: 2020-05-10T22:44:31+07:00
categories:
- programming
tags:
- golang
- gin-gonic
- testing
description: "Mocking JSON request-response using gin-gonic server for your daily TDD"
---

Create an HTTP server using [Gin](https://gin-gonic.com/) is quite easy. While developing an application using Gin, I'm stumbled on how to test the JSON response using Gin.

<!--more-->

As always, Google is your friend. After search for some hours, I actually pulled off how to write test using Gin. Let's create a simple application with a single endpoint and it response with JSON `{"message": "Welcome!"}`.

{{< tabbed-codeblock main.go >}}

<!-- tab go -->

package main

import (
    "router/router"
)

func main() {
    r := router.SetupRouter("Welcome")

    r.Run()
}

<!-- endtab -->

{{< /tabbed-codeblock >}}

Now let's create a router file

{{< tabbed-codeblock router.go >}}

<!-- tab go -->

package router

import (
   "github.com/gin-gonic/gin"
)

// For example purpose, let's inject response message here
func SetupRouter(message string) *gin.Engine {
    r := gin.Default()

    r.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": message,
		})
	})

    return r
}

<!-- endtab -->

{{< /tabbed-codeblock >}}

After that, let's create a test file to test our router

{{< tabbed-codeblock router_test.go >}}

<!-- tab go -->

package router

import (
   "encoding/json"
   "net/http"
   "net/http/httptest"
   "testing"

   "github.com/gin-gonic/gin"
   "github.com/stretchr/testify/assert"
)

var tests = []struct {
    message   string
    expectedMessage string
}{
    {"Welcome!", "Welcome!"},
    {"Hello", "Hello"},
}

func doRequest(r http.Handler, method, path string) *httptest.ResponseRecorder {
    req, _ := http.NewRequest(method, path, nil)
    w := httptest.NewRecorder()
    r.ServeHTTP(w, req)

    return w
}

func TestWelcome(t *testing.T) {
    gin.SetMode(gin.TestMode)

    for _, e := range tests {
        // setup router
        router := SetupRouter(e.message)

        // do a GET request to our router
        w := doRequest(router, "GET", "/")

        // assert if we got 200 on every request
        assert.Equal(t, http.StatusOK, w.Code)

        // for simplicity, let's unmarshal the body response to a map of string
        // you should use struct for a real application tho
        var response map[string]string
        err := json.Unmarshal([]byte(w.Body.String()), &response)

        // get the value
        res, exists := response["message"]

        // assert if the response are correct
        assert.Nil(t, err)
        assert.True(t, exists)
        assert.Equal(t, e.message, res)
    }
}

<!-- endtab -->

{{< /tabbed-codeblock >}}

Run the tests with `go test` inside folder or you can run test recursively using `go test ./...`. It will show

```shell
$ go test .
ok      router/router   0.009s
```

# References

- https://medium.com/@craigchilds94/testing-gin-json-responses-1f258ce3b0b1
- https://semaphoreci.com/community/tutorials/test-driven-development-of-go-web-applications-with-gin