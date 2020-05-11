---
title: "Live Reload Golang Development With Gin"
thumbnailImage: https://i.imgur.com/UjsWOzU.gif
coverImage: https://stackify.com/wp-content/uploads/2018/09/Learn-Go_-Tutorials-for-Beginners-Intermediate-and-Advanced-programmers-1280x720.jpg
coverCaption: https://stackify.com/wp-content/uploads/2018/09/Learn-Go_-Tutorials-for-Beginners-Intermediate-and-Advanced-programmers-1280x720.jpg
metaAlignment: center
coverMeta: out
date: 2020-05-09T08:24:28+07:00
categories:
  - programming
tags:
  - golang
  - gin
  - tools
description: "Developing Golang application with live-reload on save with Gin."
---

Coming from NodeJS land, I'm always relying on Nodemon to have live-reload my development server while developing. Long story short, I got a project that uses Golang as a drop-in replacement, and reloading the development server is PITA. I need to restart my development server every time I have changed inside my code.

<!--more-->

After looking at some libraries like [CompileDaemon](https://github.com/githubnemo/CompileDaemon), [Air](https://github.com/cosmtrek/air), [Realize](https://github.com/oxequa/realize), even [Nodemon](https://nodemon.io/)!. At first, I'm trying CompileDaemon but it doesn't do the live-reload on save (maybe I didn't configure it properly 🤷‍♂️). And then trying Air and Realize, but these libraries need a configuration file to make it works. Unfortunately, this didn't meet my expectation where I don't need an extra configuration file to use that.

And then I found [Gin](https://github.com/codegangsta/gin) after some search. Simple yet powerful. Just like CompileDaemon but with extra features (personally, I like the `--notifications` flag where it will send a notification to our desktop). Here are some options we use for Gin

```shell
   --laddr value, -l value       listening address for the proxy server
   --port value, -p value        port for the proxy server (default: 3000)
   --appPort value, -a value     port for the Go web server (default: 3001)
   --bin value, -b value         name of generated binary file (default: "gin-bin")
   --path value, -t value        Path to watch files from (default: ".")
   --build value, -d value       Path to build files from (defaults to same value as --path)
   --excludeDir value, -x value  Relative directories to exclude
   --immediate, -i               run the server immediately after it's built
   --all                         reloads whenever any file changes, as opposed to reloading only on .go file change
   --godep, -g                   use godep when building
   --buildArgs value             Additional go build arguments
   --certFile value              TLS Certificate
   --keyFile value               TLS Certificate Key
   --logPrefix value             Setup custom log prefix
   --notifications               enable desktop notifications
   --help, -h                    show help
   --version, -v                 print the version
```

The downside for Gin is it needs a proxy server for as the front server (is it the right term?).

## Examples

### Running Go server on port 8080

This will create a proxy server on port 3000 and it will listen to the application port on 8080. With this setting, you need to send the request to the proxy server (port 3000) instead of directly to the Go server (port 8080).

```shell
# This will run all main package
$ gin --appPort 8080

## Output
[gin] Listening on port 3000
[gin] Building...
[gin] Build finished
```

### Running Go server on port 8080 and proxy server on 5000

This will create a proxy server on port 5000 and it will listen to the application port on 8080. With this setting, you need to send the request to the proxy server (port 5000) instead of directly to the Go server (port 8080).

```shell
# This will run all main package
$ gin --appPort 8080 --port 5000

## Output
[gin] Listening on port 5000
[gin] Building...
[gin] Build finished
```

### Running Go server immediately after Gin build run successfully

There are some peoples encountered this problem where they can't make an API request to the server after Gin build. This is Gin's default behavior where it uses `time.Sleep(100 * time.Millisecond)` on its `build` function. We can solve this using `--immediate` flag so the server will immediately run after a successful build.

```shell
# This will run all main package
$ gin --appPort 8080 --port 5000 --immediate

# or
$ gin --appPort 8080 --port 5000 -i

## Output
[gin] Listening on port 5000
[gin] Building...
[gin] Build finished
```

### Send desktop notification on build

I love this feature. With the desktop notification, we know if the build succeeded or failed. So we don't need to switch to your IDE and terminal back and forth. We can use `--notifications` flag for this.

```shell
# This will run all main package
$ gin --appPort 8080 --port 5000 --immediate --notifications

## Output
[gin] Listening on port 5000
[gin] Building...
[gin] Build finished
```

**Preview**

{{< image classes="fancybox center clear fig-100" src="https://res.cloudinary.com/dweyilbvh/image/upload/v1588993429/Screen_Shot_2020-05-09_at_10.01.44_AM_qzligo.png" title="Build started" >}}
{{< image classes="fancybox center clear fig-100" src="https://res.cloudinary.com/dweyilbvh/image/upload/v1588993429/Screen_Shot_2020-05-09_at_10.01.34_AM_w4i2c4.png" title="Build success" >}}
{{< image classes="fancybox center clear fig-100" src="https://res.cloudinary.com/dweyilbvh/image/upload/v1588993700/Screen_Shot_2020-05-09_at_10.06.04_AM_t9yo1y.png" title="Build failed" >}}
