# Atlas Group Homebrew Tap

## What is Homebrew?

Package manager for macOS (or Linux), see more at https://brew.sh

## What is a Tap?

A third-party repository providing installable packages (formulae) on macOS and Linux.

See more at https://docs.brew.sh/Taps

## How do I install packages from here?

```sh
brew install atlas-group/tap/name
```

You can also only add the tap which makes formulae within it available in search results (`brew search` output):

```sh
brew tap atlas-group/tap
```

Note: to clone the tap via SSH you will need to use:

```sh
brew tap atlas-group/tap https://github.com/atlas-group/homebrew-tap
```

While you may search across taps, it is necessary to always use
fully qualified name (incl. the `atlas-group/tap/` prefix)
when referring to formulae in external taps such as this one
outside of search.

## What packages are available?

```sh
brew install atlas-group/tap/rt
brew install atlas-group/tap/sash
```

Both formulae currently require [Docker](https://docs.docker.com/get-docker/).

## Why should I install packages from this tap?

Formulae for the same Atlas Group software may exist in other taps
or the [community-maintained main tap](https://github.com/Homebrew/homebrew-core).
This may raise a question of why would someone prefer one tap over the other.

The _community-maintained tap_ builds software on Homebrew's own infrastructure
according to the local formulae definition.

Formulae _in this tap_ are maintained by the
[ATLAS Group](https://atlas.cs.brown.edu/).

- Formulae are updated as new versions are released
- Issues and contributions can go through the Atlas Group maintainers of this tap

## Contributing

Guidelines for Contributing go here
