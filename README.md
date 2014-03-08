#jijo-kissaten

What is this, a maid cafe?

##Introduction

Currently my experiment playground.  I think this is going to become
some kind of image curation platform or something along that line, with
a focus (at least for my instance) on the various moe-based subcultures
and maybe meme things, but certainly doesn't have to be limited to that.
Heck, if this works it could be a scientific platform for building
ontologies and doing science, but that's work.

##Installation

(This assumes ghc is already installed.)

Update the package listing, ensure you got cabal 1.18 and get yesod
installed.

```sh
$ cabal update
$ cabal install yesod-platform yesod-bin --max-backjumps=-1 --reorder-goals
```

Then clone the repository, initialize the sandbox

```sh
$ git clone https://github.com/metatoaster/jijo-kissaten.git
$ cd jijo-kissaten
$ cabal sandbox init
$ cabal install --only-dependencies
$ cabal build
```

Once that's done, with the build completing successfully, try running
the test case with

```sh
$ yesod test
```

Or start the development server.

```sh
$ yesod devel
```
