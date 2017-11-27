# Topics covered

    * A little about IPFS and why its great
    * Getting started with IPFS on WSL (Ubuntu Xenial on Windows)
    * Getting started with Elm
    * A simple example hosting a web application on IPFS

# Why am I doing this?

The future of the internet is the distributed, decentralized web. This is a place where you can control your data, where you can share what you want and only with whom you want, and where we can build applications without a centralized server. This is a place that can't be censored and it can't be stopped by the "authorities."

# What is IPFS and why use it?

IPFS stands for Interplanetary File System. Cool name, right? Basically it is a content addressable file system that you can access using the IPFS protocol or HTTPS over the internet. There is a lot to it, but you can see a summary of the white paper and specification on [github](https://github.com/ipfs/ipfs#quick-summary).

IPFS is also a network of users who voluntarily setup nodes that will forward files to clients who request them from the network, and can even store the files if they want to.

Anyone can join the network as long as they are running a client that conforms to the IPFS protocol and specification.

IPFS makes it possible to publish files, data, and applications that can be accessed by anyone on the internet.

IPFS uses [DHTs (distributed hash tables)](https://stackoverflow.com/questions/144360/simple-basic-explanation-of-a-distributed-hash-table-dht) under the hood.

# Getting started with IPFS on WSL (Windows subsystem for Linux)

I am a Windows user so I figured I might as well setup my IPFS node on [WSL](https://msdn.microsoft.com/en-us/commandline/wsl/faq), but there are [Windows options](https://ipfs.io/docs/install/). I am running **Ubuntu Xenial**.

I am using the [ipfs-go](https://dist.ipfs.io/#go-ipfs) version. You can find the downloads for a variety of platforms there.

This guide is good as of Nov. 26, 2017.

### Download the IPFS install

You'll want to check the download page to get a link to the latest version.

```bash
wget -O go-ipfs.tar.gz https://dist.ipfs.io/go-ipfs/v0.4.13/go-ipfs_v0.4.13_freebsd-amd64.tar.gz
```

### Unzip the tarball

```bash
tar xvfz go-ipfs.tar.gz
```

### Move it into your bin to make it available on the command line

```bash
mv go-ipfs/ipfs /usr/local/bin/ipfs
```

### Check the steps worked

```bash
ipfs help
```

If that is all good we can try initializing our IPFS node, running the daemon to join the IPFS network, and try to use IPFS to share files.

## Get your IPFS node going

You can also follow the guide on the [IPFS site.](https://ipfs.io/docs/getting-started/)

### Initialize the daemon

See the possible options and some helpful info about the daemon.

```bash
ipfs daemon --help
```

The daemon is the IPFS service that communicates with the IPFS network.

This will initialize your IPFS node with the defaults.

```bash
ipfs init
```

### Start the daemon

```bash
ipfs daemon
```

### Check for peers

You can see what peers are on the network with

```bash
ipfs swarm peers
```

This is the default list of peers. You can also add or remove peers to setup a node that only communicates with the peers of your choice.

### Check the web UI

Starting the daemon also starts a web UI that will give you information about your node and your peers. You can get to it with the URL:

`http://localhost:5001/webui`

Awesome, now you have a running node.

### Anti-virus and the firewall

If you are running anti-virus you might end up having weird problems. In my case Malwarebytes blocks outgoing connections on certain IP addresses when I have the daemon running. If you don't allow this IP address, the daemon might show errors and you might not be able to anything with IPFS. In Malwarebytes I add an exception for the IP address. 

If you want to let nodes inside your local network to connect to your node you may need to open your Windows firewall to allow connections on port `4001`.

If your system starts to act really weird and you can't even get any regular sites to load in your browser, try closing your Windows bash consoles and resetting your Wifi or Ethernet connection.

### Add a file to the network

Once you have your daemon running you can add files to share on the network.

Pro tip: Open a new Windows bash console to do the ipfs commands because the daemon will have your console tied up.

### See the help first

```bash
ipfs add --help
```

### Add a file

```bash
ipfs add /path/to/file
```

This creates a hash of the file which can also be considered the address of the file. If you want to share it you can give the hash to a friend and they can use ipfs to get and pin the file or you can use a URL like this:

On your own computer:

`http://localhost:8080/ipfs/QmYFUB23UuUkVqbC84QNLmYUJ9c7zum4yoXPZpArZT16tK`

Or on the internet:

`https://ipfs.io/ipfs/QmYFUB23UuUkVqbC84QNLmYUJ9c7zum4yoXPZpArZT16tK`

If you follow that link you will see a file that I added to the IPFS network.

### More ipfs stuff

There are a ton of things you can do with IPFS. You can see more on the [refernce page.](https://ipfs.io/docs/commands)  

Now that we know a bit about how to work with IPFS we can start to build an application to take advantage of it. 

# Building a simple application with Elm

## What is Elm?

[Elm is a functional programming language](https://guide.elm-lang.org/) that will transpile to Javascript, so you can use it to build web applications. The language is very similar to F#.

### But Marnee, aren't you an F# programmer? Why not Fable?

Yeah Fable and F# are awesome but I figured I might as well try out Elm and see what it has to offer.

# Installing Elm

I will be using the WSL, but you can install Elm on Windows, too. See the [Elm installation guide](https://guide.elm-lang.org/install.html) for more.

## Using npm and nodejs

This can be a bit of a pain on Ubuntu Xenial. When I installed nodejs from apt the version was incompatible with the version of npm I installed with apt. If you run into this you can follow the advice here on the [Stackoverflow question](https://stackoverflow.com/questions/46360567/error-npm-is-known-not-to-run-on-node-js-v4-2-6).

Once you get `npm` installed you can use it to install Elm. I had to use `sudo`, but [this guide](https://www.npmjs.com/package/elm) does not.

```bash
sudo npm install -g elm
```

I also installed elm-test and elm-css

```bash
sudo install -g elm-test

sudo install -g elm-css
```

Elm is compiled and ships with a really nice compiler that gives helful and friendly messages. You can compile any source file like this:

```bash
elm-make source.elm
```

Elm also ships with a web server that helps you make and run your Elm code. To run it you can navigate to the folder where you have your Elm files and then run it with `elm-reactor`.

You can also use `elm-package` to download and install Elm packages.

# Hello World

You can see all of my source code on my [Github](https://github.com/MarneeDear/learning-elm).

I am going to use a structure that would also allow me to use other Javascript frameworks like vue.js. This means I start with two files:

* A .elm file
* An index.html file

## helloworld.elm

The `.elm` will hold our model, view, and update code. The most basic you need is a main entry point like this.

```elm
import Html exposing (text)

main : Html.Html msg
main =
  text "Hello, World!"
```

I used an `index.html` file that loads the helloworld application into it. Find out more from the [Elm guide](https://guide.elm-lang.org/interop/javascript.html).

```elm
<div id="main"></div>
<script src="elm.js"></script>
<script>
    var node = document.getElementById('main');
    var app = Elm.Main.embed(node);
</script>
```

Notice the script reference to `elm.js`. This is the file that is created by elm-make. To make it I go into the folder where `helloworld.elm` lives and run elm-make like this.

```bash
cd /path/to/helloworld

elm-make helloworld.elm --output=elm.js
```

This will create a bunch of the `elm-stuff', elm-package.json which are all of the packages your app will need, and the elm.js file which is everything your app will need to run.

```bash
elm-make helloworld.elm --output=elm.js
Success! Compiled 1 module.
Successfully generated elm.js

$ ll
total 94812
drwxrwxrwx 0 root root    512 Nov 26 17:36 ./
drwxrwxrwx 0 root root    512 Nov 26 12:15 ../
-rwxrwxrwx 1 root root    318 Nov 25 16:53 basic_pattern.elm*
-rwxrwxrwx 1 root root 178612 Nov 26 17:36 elm.js*
-rwxrwxrwx 1 root root    436 Nov 25 16:53 elm-package.json*
drwxrwxrwx 0 root root    512 Nov 25 17:16 elm-stuff/
-rwxrwxrwx 1 root root     85 Nov 25 16:53 helloworld.elm*
-rwxrwxrwx 1 root root    349 Nov 26 17:20 index.html*
```

If I wanted to share this Helloworld with the world all I would have to do now is 

1. Add `elm.js` to `ipfs`
2. Replace the reference to `elm.js` in `index.html` to `<filehash>`
3. Add `index.html` to `ipfs`

And then I can use the ipfs URL to `index.html` to load the page in a browser.

So I did, of course.

```bash
ipfs add /path/to/elm.js

ipfs add /path/to/index.html`
```

And you can see it in action here:

`https://ipfs.io/ipfs/Qma89DNbXCELA1du4rRw6vREzWN7cf2tTe8PqAeqkTK3er`

# Thoughts

