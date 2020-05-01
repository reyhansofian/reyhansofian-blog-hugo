---
categories:
- tech
coverImage: //res.cloudinary.com/dweyilbvh/image/upload/v1497584063/java-script_pqill1.jpg
coverCaption: "http://ewanvalentine.io/content/images/2017/05/java-script.jpg"
coverMeta: out
date: 2017-06-16T08:16:53+07:00
description: "How template literals behave like a function"
metaAlignment: center
tags:
- javascript
thumbnailImage: //res.cloudinary.com/dweyilbvh/image/upload/c_scale,w_800/v1497584063/java-script_pqill1.jpg
thumbnailImagePosition: top
title: "Javascript's Template Literals"
---

When I'm conducting a workshop for [Facebook Developer Circle Malang](https://www.facebook.com/groups/DevCMalang), one of our participants asking how [gql](https://github.com/apollographql/graphql-tag) works. I know it's called ___template literals___, but how did ___template literals___ can behave like a function (but without parentheses)? 
<!--more-->

Template literals is a new feature in ES6 or ES2015 (it's called "template strings" in prior editions of ES2015).
It allow us to embed expressions, multi-line strings, and string interpolation. There are two kinds of template literals: ___template literals___ and ___tagged template literals___.

# Template Literals

Template literals are enclosed by the back-tick (\` \`) characters with the dollar sign and curly braces as a placeholder (`${expression}`). This placeholder can do string interpolation or expression interpolation.

### String Interpolation

```js
const name = 'Bruce';
const greeting = `Hello there, ${name}!`;
const greetingWithMultilines = `${greeting}
How are you today?`;

console.log(greeting);
console.log(greetingWithMultilines);

// Single line result:
// Hello there, Bruce!

// Multiline result:
// Hello there, Bruce!
// How are you today?
```

### Expression Interpolation

```js
const a = 1;
const b = 5;

console.log(`1 + 5 equals ${a + b}`);

// Result:
// 1 + 5 equals 6
```

# Tagged Template Literals

As per what [MDN](https://developer.mozilla.org/id/docs/Web/JavaScript/Reference/Template_literals) said, 

>Tagged template literals is an advanced form of template literals. Tags allow you to parse template literals with a function. The first argument of a tag function contains an array of string values. The remaining arguments are related to the expressions.

If you notice, ___tagged template literals___'s first argument is containing an array of string! Here's an example

```js
function someFunction(strings, name) {
    console.log('Array of string:', strings);
    console.log('Name parameter:', name);
}

const name = 'Bruce';

someFunction`Hello there, ${name}!`

// Result:
// Array of string: ["Hello there, ", "!"]
// Name parameter: Bruce
```

This is almost the same way how `gql` works (see the [source code](https://github.com/apollographql/graphql-tag/blob/master/src/index.js#L143)).

```js
// XXX This should eventually disallow arbitrary string interpolation, like Relay does
function gql(/* arguments */) {
  var args = Array.prototype.slice.call(arguments);

  var literals = args[0];

  ...
}

const query = gql`
  {
    user(id: 5) {
      firstName
      lastName
    }
  }
`

// query is now a GraphQL syntax tree object
console.log(query);

// {
//   "kind": "Document",
//   "definitions": [
//     {
//       "kind": "OperationDefinition",
//       "operation": "query",
//       "name": null,
//       "variableDefinitions": null,
//       "directives": [],
//       "selectionSet": {
//         "kind": "SelectionSet",
//         "selections": [
//           {
//             "kind": "Field",
//             "alias": null,
//             "name": {
//               "kind": "Name",
//               "value": "user",
//               ...
```