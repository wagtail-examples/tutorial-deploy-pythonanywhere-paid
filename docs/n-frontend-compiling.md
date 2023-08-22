# Set up Webpack and client side code compilation

This is a minimal setup for compiling client side code with Webpack.

It will compile all files in `client/styles` css, `client/scripts` javascript and output them to `webapp/static` as `bundle.css` and `bundle.js`.

## Setup node and NPM

First lets make sure the node version used will always be the intended version `18`.

In the root of your project run:

```bash
echo 18 > .nvmrc
```

### Install NVM (node version manager)

Instructions can be viewed at [https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm) where you can choose your preferred installation method. I used `brew` on MacOS.

```bash
brew install nvm
```

### Install node

```bash
nvm install
```

If you don't have the correct version of node installed a message will tell you that and you can install it with:

```bash
nvm install 18
```

### Initialize NPM

```bash
npm init
```

This will create a `package.json` file in the root of your project.

Then install the required packages by running:

```bash
npm install --save-dev \
    @babel/preset-env \
    babel-loader \
    browser-sync-webpack-plugin \
    css-loader \
    mini-css-extract-plugin \
    sass \
    sass-loader \
    webpack \
    webpack-cli \
    webpack-dev-server
```

This will have created a `node_modules` directory in the root of your project. That's not a file we need to commit to the repository so add it to the `.gitignore` file.

```bash
echo "node_modules" >> .gitignore
```

## Add Webpack configuration

You can read more about Webpack at [https://webpack.js.org/](https://webpack.js.org/).

Create a file `webpack.config.js` in the root of your project with the following content:

```bash
touch webpack.config.js
```

```javascript
const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const BrowserSyncPlugin = require("browser-sync-webpack-plugin");

module.exports = {
  mode: "production", // or "development"
  entry: path.resolve(__dirname, "./client/scripts/index.js"),
  output: {
    path: path.resolve(__dirname, "./webapp/static/webapp"),
    filename: "bundle.js",
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"],
          },
        },
      },
      {
        test: /\.scss$/,
        use: [MiniCssExtractPlugin.loader, "css-loader", "sass-loader"],
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: "bundle.css",
    }),
    new BrowserSyncPlugin({
      host: "localhost",
      port: 3000,
      proxy: "http://127.0.0.1:8000/", // the port your django app will be running on in development
      files: ["./**/*.html"],
    }),
  ],
};
```

## Add client side code

Create a directory called `client` in the root of your project with the following folders:

```bash
mkdir -p client/{scripts,styles}
```

### Add styles

Create a file `client/styles/index.scss` with the following content:

```bash
touch client/styles/index.scss
```

```scss
body {
  background-color: grey;
}
```

### Add javascript

Create a file `client/scripts/index.js` with the following content:

```bash
touch client/scripts/index.js
```

```javascript
console.log("Hello world!");
```

## Add scripts to package.json

Add the following scripts to the `package.json` file:

```json
"scripts": {
  "build": "webpack --mode production",
  "start": "webpack --mode development --watch"
},
```

## Run Webpack

To compile the client side code during development run:

```bash
npm run start # which will compile and watch for changes
```

To compile the client side code for production run:

```bash
npm run build # which will compile and minify the code
```

Running either of these commands will create a `webapp/static/webapp` directory with the compiled files `bundle.css` and `bundle.js`.

## Update the base template to use the compiled files

Open the `webapp/templates/base.html` file and update the `head` section to include the compiled css and javascript files:

```html
<!-- change -->
<link rel="stylesheet" type="text/css" href="{% static 'css/webapp.css' %}">
<!-- to -->
<link rel="stylesheet" type="text/css" href="{% static 'webapp/bundle.css' %}">
```

```html
<!-- change -->
<script src="{% static 'js/webapp.js' %}"></script>
<!-- to -->
<script src="{% static 'webapp/bundle.js' %}"></script>
```

Remove the `webapp/static/css` and `webapp/static/js` directories and file as they are no longer needed.

```bash
rm -rf webapp/static/css webapp/static/js
```

## Run the development server

```bash
pipenv run python manage.py runserver
```

Open your browser at [http://localhost:3000](http://localhost:3000) and you should see the home page with a grey background and a message in the console.

Try changing the background color in `client/styles/index.scss` and you should see the changes in the browser without having to refresh the page.

Up Next - [Some TODO's](./m-todos.md)

## 😜 Just for fun

Create a file `client/scripts/logo.js` with the following content:

```javascript
class Logo {
  constructor() {
        this.logo = document.getElementsByClassName('logo')[0];
        this.header = document.getElementsByClassName('header')[0];
    }

    init() {
      setTimeout(() => {
        this.logo.classList.add('logo--fade-in');
            this.header.classList.add('header--slope');
        }, 1000);
    }
}

module.exports = Logo;
```

Update `client/scripts/index.js` to the following:

```javascript
import "../styles/index.scss";
import Logo from "./logo.js";

const logo = new Logo();
logo.init();
```

Create a file `client/styles/_vars.scss` with the following content:

```scss
$background-color: #43b1b0;
$foreground-color: #fff;
```

Alter the `client/styles/index.scss` file to the following:

```scss
@import "./vars";

body {
  background-color: $background-color;
}

h2, a {
  color: $foreground-color !important;
}

svg .egg {
  fill: $foreground-color;
}

.logo--fade-in {
  animation: fade-in 1s ease-out;
  animation-fill-mode: forwards;
  svg g {
    fill: white;
  }
}

@keyframes fade-in {
  0% {
    opacity: 0.2;
    transform: scale(1);
  }
  75% {
    opacity: 0.8;
    transform: scale(1.8) translateX(10%);
  }
  100% {
    opacity: 1;
    transform: scale(1.4) translateX(0) translateY(20px) rotate(0deg);
  }
}

.header--slope {
  animation: slope 1s ease-in-out;
  animation-fill-mode: forwards;  
}

@keyframes slope {
  0% {
    transform: rotate(0deg);
  }
  90% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(-2deg);
  }
}
```

Up Next - [Use pre-commit to ensure static assets are production ready](./o-static-compiled-pre-commit.md)
