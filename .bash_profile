#!/bin/bash
# ~/.bash_profile
# Maintainer: 1noro <inoro@cover.mozmail..com>

[[ -f ~/.bashrc ]] && . ~/.bashrc
export GPG_TTY=$(tty)

# RUSTUP
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# SYMFONY-CLI 5
if [ -f "$HOME/.symfony5/bin/symfony" ]; then
    export PATH="$HOME/.symfony5/bin:$PATH"
fi

# GO
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Podman docker-compose
# if [ -f "/usr/lib/systemd/system/podman.service" ]; then
#    export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
# fi

# CUSTOM EXPORTS
export PATH=$HOME/.bin:$HOME/.local/bin:$PATH
#export TERM=xterm-256color
export COLORTERM=truecolor
export EDITOR=nvim
export VISUAL=nvim
export READER=evince
export BROWSER=firefox
export VIDEO=mpv
export IMAGE=sxiv

# JAVA
# export JAVA_HOME=/usr/lib/jvm/default
# yo need to install jdk11-openjdk
# export JAVA_COMPILER=javac
