This is my zmk-config for a totem keyboard with a dongle.

It primarily focuses on local-first building, so if you like the look of it
grab it in case I decide to remove it from Github, as it's only here so I could
get my initial config built

# Building
I am not a fan of having to rely on remote build tools for building my local
keyboard config, so all of the magic in this repo is in the Makefile which
should be able to set up a Linux or macOS build chain and build the dongle
configuration for you.

This assumes that you have the build tools installed, which includes but is
probably not limited to:
* west
* cmake
* ninja

On macOS I installed these via homebrew, but it transpires that the homebrew
install of west does not, for some reason, include pyelftools. You can fix this
by changing directory to your hombrew install of west's libexec/bin, e.g.
`/opt/homebrew/Cellar/west/1.2.0_3/libexec/bin` and installing it directly:

```
> ./python3 -m pip install pyelftools
```

# Caveats
I built this Makefile iteratively whilst figuring out how to do the build
locally, so it should be take with a pinch of salt - there may be parts of it
that are broken! It is also your own responsibility to figure out whether
you're happy with the tools it installs for you (namely the zephyr sdk).
