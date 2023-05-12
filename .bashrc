#!/bin/bash
# ~/.bashrc
# Maintainer: 1noro <ppuubblliicc@protonmail..com>

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# VTE (FOR TILIX)
#if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        #source /etc/profile.d/vte.sh
#fi

# PROMPT
# - bash prompt
# parse_git_branch() {
#     if [[ -d ".git" ]]; then
#         git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
#     fi
# }
# export PS1="\[\033[38;5;9m\][\[$(tput sgr0)\]\[\033[38;5;11m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;6m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;13m\]\W\[$(tput sgr0)\]\[\033[38;5;11m\]\$(parse_git_branch)\[$(tput sgr0)\]\[\033[38;5;9m\]]\[$(tput sgr0)\]\\$\[$(tput sgr0)\] "

# - starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init bash)"
fi

# AUTOCOMPLETION
# (https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
if [ -f ~/bin/git-completion.bash ]; then
  . ~/bin/git-completion.bash
fi

# PACMAN UPDATE REMINDER
# FLAG="/tmp/check_updates.flag"
# if command -v pacman &> /dev/null; then
#     if [[ $(pacman -Qu) ]]; then
#         if [ ! -f $FLAG ]; then
#             echo "sudo pacman -Syyu" >> ~/.histfile
#             touch $FLAG
#         fi
#         echo -e "Have you checked the \e[92m\e[1mupdates\e[0m yet?"
#     fi
# fi

# LF
# Change working dir in shell to last dir in lf on exit (adapted from ranger)
# (https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh)
if command -v lf &> /dev/null; then
    lfcd () {
        tmp="$(mktemp)"
        lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
            dir="$(cat "$tmp")"
            rm -f "$tmp"
            if [ -d "$dir" ]; then
                if [ "$dir" != "$(pwd)" ]; then
                    #cd "$dir"
                    cd "$dir" || return
                fi
            fi
        fi
    }

    # bind <C-o> to lfcd command
    bind '"\C-o":"lfcd\C-m"'
fi

# FUNCTIONS
history-top() {
    history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr | head -20
}

cd-fzf() {
    cd "$(find ./* -type d | fzf --multi --preview 'exa --icons -1 {1}')" || return
}

# docker images remove none
dirn() {
    docker image rm '$(docker images | grep none | awk "{print $3}")'
}

pacman-fzf() {
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

# EXPORTS
# > The most global exports are in the .bash_profile file
export HISTSIZE=10000
export HISTFILESIZE=10000
# para que las aplicaciones qt usen wayland (creo que no funciona muy bien)
export QT_QPA_PLATFORM=wayland

#complete -c man which
complete -cf sudo

# BINDS
bind '"\C-g":"cd-fzf\C-m"'
bind '"\C-e":"code .\C-m"'

# ALIAS
# - color
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# -- docker
alias di='docker images'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"'
# - sxiv
alias img='sxiv -a' # -a para iniciar la animaciones auto
alias x='sxiv -at' # -at para iniciar la animaciones auto y abrir en thumbnail mode
# - quick access
alias m='make'
alias b='xkbbell'
alias e='$EDITOR'
alias v='$EDITOR'
alias vc='nvim ~/.config/nvim/init.vim'
alias p='sudo pacman'
alias lsp='pacman -Qett --color=always | less -R' # list packages
alias SS='sudo systemctl'
alias j='journalctl -xe'
alias Sjf='sudo journalctl -p 3 -xb'
alias yt="yt-dlp --add-metadata -i -o '%(upload_date)s-%(title)s.%(ext)s'"
alias yt2mp3="yt-dlp -f 'ba' -x --audio-format mp3"
alias fuck='sudo !!'
# alias pandoc="docker run --rm --volume \"$(pwd):/data\" --user $(id -u):$(id -g) pandoc/latex"
# - git
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gco='git checkout'
alias gcm='git checkout master'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias glg='git log --stat --max-count=5'
alias glgg='git log --graph --max-count=5'
alias gss='git status -s'
alias ga='git add'
alias gm='git merge'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
# - alias for the contemporary-z program
alias z='. ~/.local/share/cz/cz.sh'

