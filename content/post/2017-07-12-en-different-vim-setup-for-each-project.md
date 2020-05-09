---
categories:
  - programming
coverImage: //res.cloudinary.com/dweyilbvh/image/upload/v1499823190/vim8_owyvqx.png
coverMeta: out
date: 2017-07-12T08:25:31+07:00
description: "Local .vimrc for different projects to make you more productive"
metaAlignment: center
tags:
  - vim
thumbnailImage: //res.cloudinary.com/dweyilbvh/image/upload/c_scale,w_750/v1499823190/vim8_owyvqx.png
thumbnailImagePosition: top
title: Different Vim Settings for Each Project
---

Sometimes, we need to have a different Vim settings across projects. We can achieve it by kept specific settings for each projects in a `.vimrc.local`.

<!--more-->

In my case, I have different ESLint rules across my Javascript projects and some of them have autofix code on each save. By using this approach, I can differentiate the settings in `.vimrc.local` and place it on the root of each projects.

First, let's put this code at the end of your global `.vimrc`

```sh
if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
```

This code will try to source the `.vimrc.local` on the project and won't source the local vimrc if there's none.

As an example, on one of my Javascript project, I use [AirBnB's ESLint config](https://www.npmjs.com/package/eslint-config-airbnb). And my another Javascript project using [Create React App ESLint config](https://www.npmjs.com/package/eslint-config-react-app) and I want autofix code on each for this project.

```sh
let g:neoformat_javascript_prettier = {
            \ 'exe': 'prettier',
            \ 'args': ['--single-quote'],
            \ 'replace': 0,
            \ 'stdin': 1,
            \ 'no_append': 1
            \ }

let g:neoformat_enabled_javascript = ['prettier']

autocmd FileType javascript set formatprg=prettier\ --stdin
autocmd BufWritePre *.js :Neoformat prettier
```

With this approach, I can manage my Vim's behavior between projects.
