---
title: "Installing Gollum on OSX Catalina"
date: 2020-01-23T16:32:22+07:00
draft: false
categories:
- development
coverImage: https://www.wallpaperflare.com/static/674/874/537/guardians-of-middle-earth-gollum-the-lord-of-the-rings-smeagol-wallpaper.jpg
coverCaption: https://www.wallpaperflare.com/static/674/874/537/guardians-of-middle-earth-gollum-the-lord-of-the-rings-smeagol-wallpaper.jpg
coverMeta: out
description: "How to solve Ruby Gem Gollum installation on OSX Catalina"
metaalignment: center
tags:
- osx
thumbnailimage: http://www.eggplante.com/wp-content/uploads/2019/03/gollum-750x400.jpg
thumbnailimageposition: top
---

I’m working on a wiki page on Gitlab. In this particular case, I need to attach a file into the wiki. Which can’t be done using web editor on Gitlab. So I’m trying to edit it locally. In short, I need to pull the wiki and install Gollum on my laptop. Unfortunately, it didn’t go smoothly like a banana (?).
<!--more-->

The worst part is this
{{< image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/2000/1*R5mLq4A8VptfTlbIEhSL7g.png" title="Installation failed due to missing header" >}}

After some research, this error caused by missing C headers on my OS. In OSX 10.15 (Catalina), the Xcode path is renewed. And also apparently Apple stopped shipping (some of) the C header files for Ruby and split them in a separate package. Looking for answers, I’m trying a couple of methods:
1. Switch the Xcode to CommandLineTools and switch back to App (https://github.com/castwide/vscode-solargraph/issues/78#issuecomment-552675511). It doesn’t work
2. Find the headers package on `/Library/Developer/CommandLineTools/Packages` folder. But it does not exist on Catalina. It doesn't work.
3. Export the **CPATH** to `export CPATH="$(xcrun --show-sdk-path)/usr/include”` and add it to your shell profile to make it persists (https://stackoverflow.com/a/57949803/2763662). IT WORKS! 🎉

**TL;DR;**

If you’re running OSX Catalina and got the missing header error message, you should try exporting CPATH variable to the Xcode headers package path.

