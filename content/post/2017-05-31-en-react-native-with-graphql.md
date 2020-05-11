---
title: "React Native with GraphQL"
thumbnailImage: //res.cloudinary.com/dweyilbvh/image/upload/v1496287727/react-apollo_tazzsm.png
coverImage: //res.cloudinary.com/dweyilbvh/image/upload/v1496287727/react-apollo_tazzsm.png
coverCaption: "https://cdn1.sysgears.com/images/blog/banners/apollo!-react-graphql-457c041c1c34868d9076f2433d761fad.png"
metaAlignment: center
coverMeta: out
date: 2017-05-31T09:26:13+07:00
categories:
  - programming
tags:
  - javascript
  - react-native
  - react
description: "React Native apps with Expo.io and GraphQL (React-Apollo). Less pain, less code."
---

> TL;DR; React Native apps with Expo.io and GraphQL (React-Apollo). Less pain, less code.

<!--more-->

Here at [Facebook Developer Circle Malang](https://www.facebook.com/groups/DevCMalang), we held React Native workshop using [Expo.io](https://expo.io/) and [Lumen](https://lumen.laravel.com/). Everyone (including me) are encouraged to create a mobile apps using React Native. And then I had an idea using some kind of RESTful API like [swapi.co](http://swapi.co) or [pokeapi.co](http://pokeapi.co) but with GraphQL. After hours of researching, I decided to use [Starwars GraphQL server](http://graphql.org/swapi-graphql/) from [GraphQL.org](http://graphql.org/).

My stack will be looks like this:

- Expo
- [React Navigation](https://github.com/react-community/react-navigation) (for screen navigation)
- [React Apollo](https://github.com/apollographql/react-apollo) (This awesome package has `graphql` and `gql` in it)

Quite simple, huh?! OK, let's code!

## Integrating Apollo Provider with React Navigation

First, define your route and add it to React Navigation's `StackNavigator`. Example:

```js
// main.js

import { StackNavigator } from "react-navigation";

import App from "./src/App";
import Film from "./src/Film";
import FilmDetail from "./src/Film/FilmDetail";

const routes = {
  Home: {
    name: "Home",
    screen: App,
  },
  Film: {
    name: "Film",
    screen: Film,
  },
  FilmDetail: {
    name: "FilmDetail",
    screen: FilmDetail,
  },
};

const MainApp = StackNavigator(routes);
```

Second, in main entrypoint file (mine is `main.js`), import `ApolloClient`, `ApolloProvider`, `createNetworkInterface` from `react-apollo` module and initialize an `ApolloClient`.

```js
// main.js

import {
  ApolloClient,
  ApolloProvider,
  createNetworkInterface,
} from "react-apollo";

const client = new ApolloClient({
  networkInterface: createNetworkInterface({
    uri: "GRAPHQL_SERVER_ENDPOINT",
  }),
});
```

And then, crate a class for wrapping your router with `ApolloProvider` and register it as your root component.

```js
// main.js

class AppContainer extends React.Component {
  render() {
    return (
      <ApolloProvider client={client}>
        <MainApp />
      </ApolloProvider>
    );
  }
}

Expo.registerRootComponent(AppContainer);
```

So the full code for the main entrypoint looks like this:

```js
// main.js

import Expo from "expo";
import React from "react";
import { StackNavigator } from "react-navigation";

import App from "./src/App";
import Film from "./src/Film";
import FilmDetail from "./src/Film/FilmDetail";

const routes = {
  Home: {
    name: "Home",
    screen: App,
  },
  Film: {
    name: "Film",
    screen: Film,
  },
  FilmDetail: {
    name: "FilmDetail",
    screen: FilmDetail,
  },
};

const MainApp = StackNavigator(routes);

class AppContainer extends React.Component {
  render() {
    return (
      <ApolloProvider client={client}>
        <MainApp />
      </ApolloProvider>
    );
  }
}

Expo.registerRootComponent(AppContainer);
```

## GraphQL Query on Component

If you're not familiar with GraphQL query, you might want to read [GraphQL Query documentation](http://graphql.org/learn/queries/) first. On this example, we just do a query to get a detail with an [argument](http://graphql.org/learn/queries/#arguments) and [variable](http://graphql.org/learn/queries/#variables) from Starwars API.

With GraphQL, we can specify which field(s) do we need just like `SELECT` in SQL query. We just need `title`, `openingCrawl`, `director`, `producers`, and `releaseDate` fields for this example. With GraphQL, we can query like this

```js
film(id: $id) {
  title
  openingCrawl
  director
  producers
  releaseDate
}
```

We just need to specify the object name (it's `film` in this example), arguments (it's `id: $id`), and fields (within curly braces). Please do note that we need to add either comma, new line or even space for each fields. Valid query example

```js

// With comma
film(id: $id) { title,episodeID, openingCrawl, director }

// With new line
film(id: $id) {
  title
  openingCrawl
  director
  producers
  releaseDate
}

// With space
film(id: $id) { title openingCrawl director producers releaseDate }
```

You can pick your flavor. Personally, I like the one with new line. It's much more readable if we deals with lots of fields later. Let's go ahead.

Now we can wrap the object with a `query` statement

```js
query($id: ID!) {
  film(id: $id) {
    title
    openingCrawl
    director
    producers
    releaseDate
  }
}
```

If you're looking at the `query` statement, it has `$id` and `ID!` on its parameter (just like a normal function pattern). Basically, GraphQL has a [type system](http://graphql.org/learn/schema/#type-system) which mean that we need to specify the type for each of its paramater.

So, we can say that `query` statement has a parameter called `$id` which has type of `ID` ([GraphQL built-in type](http://graphql.org/learn/schema/#scalar-types)). And the exclamation mark (`ID!`) means that the field is non-nullable or required.

And if you're looking at the `film` object, it also has a parameter called `id`. We can passing the arguments from `query` statement to the `film` object (just like normal function) just like the code above.

OK, so how do we get the `$id`? React-Apollo comes with a handy way how to get the variable(s). Please refer to this [page](http://dev.apollodata.com/react/api-queries.html#graphql-config-options-variables). Basically, React-Apollo is just a High Order Component for React. The `graphql` container has a pattern like this

> # graphql(query, [config])(component)

As you can see, the first parameter of the container is the query and the second is the config. We can get the `$id` from the config. **Note: since React Native support `decorators` syntax, I will use it.**

```js
@graphql(gql`
    query($id: ID!) {
      film(id: $id) {
        title
        openingCrawl
        director
        producers
        releaseDate
      }
    }
`, {
  options: (props) => ({
    variables: {
      id: props.navigation.state.params.id, // navigation object comes from React Navigation
    },
  }),
})
```

You'll notice that we specify the variables called `id` on the `options` section. It will get injected into the query and will be read by grapqhl query as `$id` on runtime. The code will looks like this

```js
// FilmDetail.js
import React, { Component, PropTypes } from "react";
import { gql, graphql } from "react-apollo";
import { Text, View } from "react-native";

@graphql(
  gql`
    query($id: ID!) {
      film(id: $id) {
        title
        openingCrawl
        director
        producers
        releaseDate
      }
    }
  `,
  {
    options: (props) => ({
      variables: {
        id: props.navigation.state.params.id,
      },
    }),
  }
)
class FilmDetail extends Component {
  static navigationOptions = ({ navigation }) => ({
    title: navigation.state.params.title,
  });

  render() {
    const { film } = this.props.data;

    return (
      <View style={styles.container}>
        <Text style={styles.title}>{film.title}</Text>
        <View style={styles.rowContainer}>
          <Text style={styles.bold}>Released Date:</Text>
          <Text> {moment(film.releaseDate).format("DD MMMM Y")}</Text>
        </View>
        <View style={styles.rowContainer}>
          <Text style={styles.bold}>Director:</Text>
          <Text> {film.director}</Text>
        </View>
        <View style={styles.rowContainer}>
          <Text style={styles.bold}>Producers:</Text>
          <Text> {film.producers.join(", ")}</Text>
        </View>
        <View style={styles.openingCrawlContainer}>
          <Text style={styles.openingCrawlText}>{film.openingCrawl}</Text>
        </View>
      </View>
    );
  }
}

export default FilmDetail;
```

React-Apollo will wrap the query result inside the `props.data`. If you want to get the result, you can access it via `this.props.data` object. For this example, we have `film` object for the query. React-Apollo will inject the `film` object into `props.data`. So we can access it by using `this.props.data.film`.

```js
render() {
  const { film } = this.props.data; // we can also perform destructuring here

  return (
    <View style={styles.container}>
      <Text style={styles.title}>{film.title}</Text>
      <View style={styles.rowContainer}>
        <Text style={styles.bold}>Released Date:</Text><Text> {moment(film.releaseDate).format('DD MMMM Y')}</Text>
      </View>
      <View style={styles.rowContainer}>
        <Text style={styles.bold}>Director:</Text><Text> {film.director}</Text>
      </View>
      <View style={styles.rowContainer}>
        <Text style={styles.bold}>Producers:</Text><Text> {film.producers.join(', ')}</Text>
      </View>
      <View style={styles.openingCrawlContainer}>
        <Text style={styles.openingCrawlText}>{film.openingCrawl}</Text>
      </View>
    </View>
  );
}
```

The `data` prop has some other useful properties which can be accessed directly from `data`. For example, [`data.loading`](http://dev.apollodata.com/react/api-queries.html#graphql-query-data-loading) or [`data.error`](http://dev.apollodata.com/react/api-queries.html#graphql-query-data-error). Please do check the `data.loading` and `data.error` before render the page. Logically, you can show the loading bar if `data.loading` is `true` or you can show the error message if `data.error` is not `null`.

You can check the fully working example on [here](https://github.com/reyhansofian/expo-swapi-graphql)
