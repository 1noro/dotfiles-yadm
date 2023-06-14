#!/bin/bash
# ~/.bash_profile
# Maintainer: 1noro <ppuubblliicc@protonmail..com>

[[ -f ~/.bashrc ]] && . ~/.bashrc
export GPG_TTY=$(tty)

# RUSTUP
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# GO
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# CUSTOM EXPORTS
export PATH=$HOME/.local/bin:$PATH
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
