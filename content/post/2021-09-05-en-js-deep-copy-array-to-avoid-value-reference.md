---
title: "Deep Copy to Avoid Value Reference"
date: 2021-09-05T18:24:58+07:00
thumbnailImage: https://res.cloudinary.com/dweyilbvh/image/upload/v1738084764/dn3dzbdm0wtfaer2dibu.png
coverImage: https://res.cloudinary.com/dweyilbvh/image/upload/v1738085738/njck8bxrjjckwpryjkok.webp
coverCaption: Unsplash image by patrickl
metaAlignment: center
coverMeta: out
categories:
- programming
tags:
- javascript
- nodejs
- frontend
description: "Deep copy an array to avoid its value reference from source object"
---

Playing around application states in ReactJS or VueJS is quite fun. But it's not fun anymore if we (accidentally) mutate the state while doing a search from the state.
<!--more-->

It happens to me when I'm trying to find a sidebar ID from the store of the sidebar tree. Yes, a tree.  Imagine the store if we have a sidebar tree like this

{{< image classes="fancybox center clear fig-100" src="https://codehim.com/wp-content/uploads/2019/03/tree-navigation-with-jquery-1.jpg" title="Sidebar tree example (courtesy: CodeHim)" >}}

and we need to find out the ID of `file2.xml`. Our best approach here is to apply a DFS ([Depth-First Search](https://en.wikipedia.org/wiki/Depth-first_search)) without re-render the sidebar. And here's my first approach to DFS

{{< tabbed-codeblock dfs.js "" >}}
<!-- tab js -->

function dfs(id) {
  const tree = [state.list]

  while (tree.length) {
    const node = tree.shift()

    if (node.id === id) {
      return node
    } else if (node.children.length) {
      tree.unshift(...node.children)
    }
  }
}

<!-- endtab -->
{{< /tabbed-codeblock >}}

if you notice it, we're using `.shift()` and `.unshift()` here. Unfortunately, the sidebar does re-render and it's quite slow. It's because the `.shift()` [time complexity is at `O(n)` at worst](https://stackoverflow.com/a/22615787/2763662)! 


## Using `Array.pop()`
After some research, it seems that we can change from `.shift()` to `.pop()`. Since the `.pop` behavior is different, we need to change the code accordingly

{{< tabbed-codeblock dfs.js "" >}}
<!-- tab js -->

function dfs(id) {
  const tree = [state.list]

  while (tree.length) {
    const node = tree.pop() // change to `.pop`

    if (node.id === id) {
      return node
    } else if (node.children.length) {
      tree.push(...node.children) // push the children to the array so we can iterate it again
    }
  }
}

<!-- endtab -->
{{< /tabbed-codeblock >}}

this change is quite performant compared to use `.shift()` before. But unfortunately, it still does some re-render! The sidebar items somehow got removed and added back themselves. We didn't do a mutation to store, though. What happens?

## The Culprit
Debugging for hours and finally, I found the culprit! We can see that we're doing some assignments to a new variable called `tree` here.

```js

function dfs(id) {
  const tree = [state.list] // <-- this assignment still have value reference to the original
...

```

In the JS world, doing assignments from an array won't cut the value reference to the original array. In this particular case, it's the `state.list`. Here's an example for value reference of an array

{{< tabbed-codeblock array.js "" >}}
<!-- tab js -->

const array = [1, 2, 3, 4];
const newArray = array;

console.log(newArray); // output: [1, 2, 3, 4]

newArray.push(5);
console.log(array); // output: [1, 2, 3, 4, 5]

// 😱 newArray value got altered too
console.log(newArray); // output: [1, 2, 3, 4, 5]

<!-- endtab -->
{{< /tabbed-codeblock >}}

the solution is to deep copy the array. So the nested structure will be copied without any reference to the original. To do the deep copy, we have several methods.

### JSON.stringify + JSON.parse duet

Here is an example of deep copy using these duet 

{{< tabbed-codeblock deep-copy.js "https://gist.github.com/djD-REK/89d1f8d51050f7977d21b629b137140b#file-json-parse-followed-by-json-stringify-as-a-deep-copy-js" >}}
<!-- tab js -->
const tree = JSON.parse(JSON.stringify(state.list))

<!-- endtab -->
{{< /tabbed-codeblock >}}

By far, this is the simplest, yet native approach without using any library. But read these gotchas

{{< alert danger no-icon >}}
“If you do not use Dates, functions, undefined, Infinity, [NaN], RegExps, Maps, Sets, Blobs, FileLists, ImageDatas, sparse Arrays, Typed Arrays or other complex types within your object, a very simple one liner to deep clone an object is: JSON.parse(JSON.stringify(object))” — [StackOverflow answer from Dan Dascalescu](https://stackoverflow.com/a/122704/2763662)
{{< /alert >}}

here is a demonstration of it (copied from this [gist](https://gist.github.com/djD-REK/89d1f8d51050f7977d21b629b137140b#file-json-parse-followed-by-json-stringify-as-a-deep-copy-js))

{{< tabbed-codeblock deep-copy.js "https://gist.github.com/djD-REK/89d1f8d51050f7977d21b629b137140b#file-json-parse-followed-by-json-stringify-as-a-deep-copy-js" >}}
<!-- tab js -->
// Only some of these will work with JSON.parse() followed by JSON.stringify()
const sampleObject = {
  string: 'string',
  number: 123,
  boolean: false,
  null: null,
  notANumber: NaN, // NaN values will be lost (the value will be forced to 'null')
  date: new Date('1999-12-31T23:59:59'),  // Date will get stringified
  undefined: undefined,  // Undefined values will be completely lost, including the key containing the undefined value
  infinity: Infinity,  // Infinity will be lost (the value will be forced to 'null')
  regExp: /.*/, // RegExp will be lost (the value will be forced to an empty object {})
}

console.log(sampleObject) // Object { string: "string", number: 123, boolean: false, null: null, notANumber: NaN, date: Date Fri Dec 31 1999 23:59:59 GMT-0500 (Eastern Standard Time), undefined: undefined, infinity: Infinity, regExp: /.*/ }
console.log(typeof sampleObject.date) // object

const faultyClone = JSON.parse(JSON.stringify(sampleObject))

console.log(faultyClone) // Object { string: "string", number: 123, boolean: false, null: null, notANumber: null, date: "2000-01-01T04:59:59.000Z", infinity: null, regExp: {} }

// The date object has been stringified, the result of .toISOString()
console.log(typeof faultyClone.date) // string

<!-- endtab -->
{{< /tabbed-codeblock >}}

With these gotchas, we'll try next method


### Lodash _.cloneDeep

The [lodash](https://lodash.com/) library is very popular among JS developers. Lodash has several utility functions that make coding in JS easier and cleaner. Using `_.cloneDeep` is quite easy too. Here's an example

{{< tabbed-codeblock clone-deep.js "https://lodash.com/docs/4.17.15#cloneDeep" >}}
<!-- tab js -->
const objects = [{ 'a': 1 }, { 'b': 2 }];
 
const deep = _.cloneDeep(objects);
console.log(deep[0] === objects[0]); // output: false

<!-- endtab -->
{{< /tabbed-codeblock >}}

## Conclusion

Deep copy is the answer for this particular case. If we need to avoid mutation to the original object, we can use this method to avoid that. And here's the final version using deep copy

{{< tabbed-codeblock deep-copy.js "https://gist.github.com/djD-REK/89d1f8d51050f7977d21b629b137140b#file-json-parse-followed-by-json-stringify-as-a-deep-copy-js" >}}
<!-- tab js -->

function dfs(id) {
  const tree = _.cloneDeep(state.list) // only change this line

  while (tree.length) {
    const node = tree.pop()

    if (node.id === id) {
      return node
    } else if (node.children.length) {
      tree.push(...node.children)
    }
  }
}

<!-- endtab -->
{{< /tabbed-codeblock >}}

## References
- https://javascript.plainenglish.io/how-to-deep-copy-objects-and-arrays-in-javascript-7c911359b089
- https://www.samanthaming.com/tidbits/35-es6-way-to-clone-an-array/
- https://stackoverflow.com/questions/122102/what-is-the-most-efficient-way-to-deep-clone-an-object-in-javascript?page=1&tab=votes#tab-top
- https://dev.to/samanthaming/how-to-deep-clone-an-array-in-javascript-3cig
- https://lodash.com/
