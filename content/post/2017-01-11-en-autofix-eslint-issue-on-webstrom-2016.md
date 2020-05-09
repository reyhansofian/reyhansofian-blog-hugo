---
title: "Autofix ESLint Issue on Webstrom 2016"
thumbnailImagePosition: top
thumbnailImage: https://boundingintocomics.com/files/2019/09/2019.09.18-05.47-boundingintocomics-5d826db3a30f6.png
coverImage: https://instazood.com/wp-content/uploads/2019/07/instagram_issue_sory_something_went_wrong-1050x550.jpg
coverCaption: https://instazood.com/blog/how-to-fix-instagram-issue-sorry-something-went-wrong/
metaAlignment: center
coverMeta: out
date: 2017-01-11T23:33:37+07:00
categories:
  - programming
tags:
  - webstrom
  - tips
description: "Autofix ESLint issue on NodeJS applications using Webstrom's File Watcher"
---

Currently, I and my team are working on a Javascript application using NodeJS and ReactJS. We use ESLint to use a coding standard with AirBnB config. We’re satisfied with it so far.

<!--more-->

I’m using Webstorm 2016 for code. Great features. But something is missing on it. On Visual Studio Code and Atom, we can fix the ESLint issue on save. But not it Webstorm 2016. It’s still a requested feature based on this [Stackoverflow answer](http://stackoverflow.com/a/29231841/2763662).

However, Webstorm provides a plugin called File Watcher. This plugin will **“watch”** changes on our code and will run a specific task if there’s a change. For more information, please refer [here](https://www.jetbrains.com/help/webstorm/2016.3/file-watchers.html). I’m using File Watcher to auto fix ESLint issue on our code. This is how I set up a File Watcher:

1. Install a **File Watcher** plugin. You can find it on **Preferences** > **Plugins** > **Search for “File Watchers"**. Check it and click **Apply** button. You need to restart Webstorm afterward

{{< image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*-LJSlJ4NHxX2bpBoG5vF_g.png" title="Preferences > Plugins > Search for \"File Watchers\"" >}}

2. Go to **Preferences** > **Tools** > **File Watchers**. Create a new **File Watcher** by clicking the **+** button. Choose custom template

{{< image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*jnQ-CyXK3lrbOvIw96QL6Q.png" >}}

3. Change the **File Type** to **Javascript**
4. Adjust your **Scope** to your project directory or whatever folder you want to include
5. Add ESLint binary path on the **Watcher Settings** > **Program**. If you install ESLint locally (per project), you can find ESLint on `node_modules/bin` and the path will look like this

```shell
$ProjectFileDir$/node_modules/.bin/ESLint
```

If you install ESLint globally (and/or use nvm), you can check ESLint path by executing which ESLint on the terminal. Since I’m using nvm, my ESLint path looks like this

```shell
/Users/vicz/.nvm/versions/node/v7.0.0/bin/ESLint
```

6. Add `--fix $FileName$` to **Watcher Settings** > **Arguments**
7. Click on the **Watcher Settings** > **Other Options** to expand hidden options and add `$FileDir` to **Watcher Settings** > **Other Options** > **Working Directory**
8. Uncheck the **Immediate file synchronization**

{{< image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*9kmjeSMC4leS8VkrYx65PQ.png" >}}

> **_References:_** \
> https://stackoverflow.com/questions/29221136/lint-only-on-save-intellij-webstorm \
> https://stackoverflow.com/questions/38883634/how-can-i-run-ESLint-fix-on-my-javascript-in-intellij-idea-webstorm-other-je \
> https://www.jetbrains.com/help/webstorm/2016.3/file-watchers.html
