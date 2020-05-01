---
title: "Squash Multiple Git Commit Into One Commit"
coverImage: https://www.hostinger.co.id/tutorial/wp-content/uploads/sites/11/2017/05/git-1.png
coverCaption: https://www.hostinger.co.id/tutorial/cara-menggunakan-github-perintah-dasar-github
metaAlignment: center
coverMeta: out
date: 2020-05-01T22:20:30+07:00
categories:
- development
tags:
- git
thumbnailImage: https://www.cmslive.co.uk/wp-content/uploads/2015/10/git-version-control.jpg
thumbnailimageposition: top
description: "Squash multiple git commit as one commit for more readable commit"
---

Git is a powerful versioning tool. Most tech companies use Git as their versioning tools (some big companies still using Mercurial and SVN though). It’s also applied to my current company.
<!--more-->

I have a habit to commit on a small chunk and treat it as a “checkpoint”. So whenever I need to revert, it’s easy to do that. Sometimes I want to merge previous commits into a single, just want to make it more compact before pushing it into a remote branch. With Git, this is quite easy to do by using the rebase command.
Let’s say we have a bunch of commit like this

```shell
$ git log --oneline
9b5b3fb fourth commit
92459dd third commit
689b035 second commit
4bda376 first commit
```

Now we want to merge commit second commit, third commit, and fourth commit into a single commit message. We can run a rebase with the interactive (-i) option. This will open up your text editor

```shell
$ git rebase -i HEAD~3
pick 689b035 second commit
pick 92459dd third commit
pick 9b5b3fb fourth commit
# Rebase 4bda376..9b5b3fb onto 4bda376 (3 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

If we want to squash second commit, third commit, and fourth commit, we just need to change the pick on the fourth commit and third commit into squash or s like this

```shell
pick 689b035 second commit
squash 92459dd third commit
squash 9b5b3fb fourth commit
# Rebase 4bda376..9b5b3fb onto 4bda376 (3 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

Saving and quit your text editor will open up a new editor with this content

```shell
# This is a combination of 3 commits.
# This is the 1st commit message:
second commit
# This is the commit message #2:
third commit
# This is the commit message #3:
fourth commit
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
#
# Date:      Sat Feb 31 01:44:13 2020 +0700
#
# interactive rebase in progress; onto 4bda376
# Last commands done (3 commands done):
#    s 92459dd third commit
#    s 9b5b3fb fourth commit
# No commands remaining.
# You are currently rebasing branch 'master' on '4bda376'.
#
# Changes to be committed:
# modified:   README.md
#
```

You can leave it as is or you can change the commit message as you desire. Let’s change the commit message to squashed commit message, then save and quit your text editor. You can check the merged (squashed) commit message again and it will look like this

```shell
bbbecea squashed commit message
4bda376 first commit
```

As you can see, second commit, third commit, and fourth commit is gone and replaced by a new commit message.
Hope you enjoy it 🎉