#!/bin/bash
# ~/.bashrc_ext
# Maintainer: 1noro <inoro@cover.mozmail..com>

export QT_QPA_PLATFORM=wayland

pacman-fzf() {
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

alias p='sudo pacman'
alias lsp='pacman -Qett --color=always | less -R' # list packages
