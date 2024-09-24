#!/bin/bash
# ~/.bashrc
# Maintainer: 1noro <inoro@cover.mozmail..com>

## COMMON

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
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

# AUTOCOMPLETION
# (https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
if [ -f ~/bin/git-completion.bash ]; then
    . ~/bin/git-completion.bash
fi

if [ -f ~/.bash_completion.d/makefile_completion.sh ]; then
    source ~/.bash_completion.d/makefile_completion.sh
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

# NVM
cdnvm() {
    command cd "$@" || return $?
    nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

    # If there are no .nvmrc file, use the default nvm version
    if [[ ! $nvm_path = *[^[:space:]]* ]]; then

        declare default_version;
        default_version=$(nvm version default);

        # If there is no default version, set it to `node`
        # This will use the latest version on your machine
        if [[ $default_version == "N/A" ]]; then
            nvm alias default node;
            default_version=$(nvm version default);
        fi

        # If the current version is not the default version, set it to use the default version
        if [[ $(nvm current) != "$default_version" ]]; then
            nvm use default;
        fi

    elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
        declare nvm_version
        nvm_version=$(<"$nvm_path"/.nvmrc)

        declare locally_resolved_nvm_version
        # `nvm ls` will check all locally-available versions
        # If there are multiple matching versions, take the latest one
        # Remove the `->` and `*` characters and spaces
        # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
        locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

        # If it is not already installed, install it
        # `nvm install` will implicitly use the newly-installed version
        if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
            nvm install "$nvm_version";
        elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
            nvm use "$nvm_version";
        fi
    fi
}

if [ -f /usr/share/nvm/init-nvm.sh ]; then
    source /usr/share/nvm/init-nvm.sh
elif [ -f "$HOME/.nvm/nvm.sh" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    alias cd='cdnvm'
    cdnvm "$PWD" || exit
fi

# LF
# Change working dir in shell to last dir in lf on exit (adapted from ranger)
# (https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.sh)
if command -v lf &>/dev/null; then
    lfcd() {
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

## FUNCTIONS

history-top() {
    history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr | head -20
}

cd-fzf() {
    #cd "$(find ./* \( -path bin -o -path snap -o -path docker \) -prune -o -print | fzf --multi --preview 'exa --icons -1 {1}')" || return
    #cd "$(find ./* \( -path bin -o -path snap -o -path docker -o -path cache -o -path .git \) -prune -o -print -type d | fzf)" || return
    # EL MEJOR (Global)
    # cd "$(find ./* -type d | fzf --multi --preview 'exa --icons -1 {1}')" || return
    # EL MEJOR (Local)
    # list only current folder dirs
    cd "$(ls -d */ | fzf --multi --preview 'exa --icons -1 {1}')" || return
}

# command to cd to a ~/repos folder
# to bind to a key, use something like: gnome-terminal -- bash -c "CD_REPOS=1 bash"
cd-fzf-repos() {
    REPO=$(ls ~/git | fzf --multi --preview 'exa --icons -1 ~/repos/{1}')
    if [[ -n "$REPO" ]]; then
        cd "$HOME/git/$REPO" || return
    fi
}

# Git push push
gpp() {
    # Check if you're in a Git repository
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # Get the current branch name
        branch_name=$(git symbolic-ref --short HEAD)
        # echo "Current branch: $branch_name"
        git push --set-upstream origin "$branch_name"
    else
        echo "Not in a Git repository."
    fi
}

# docker images remove none
dirn() {
    docker image rm '$(docker images | grep none | awk "{print $3}")'
}

dbash() {
    docker exec -it -u $(id -u):$(id -g) $1 bash
}

dbrash() {
    docker exec -it -u 0:0 $1 bash
}

# kill docker-compose
# killdc() {
#     if ps -a | grep docker-compose > /dev/null; then
#         kill -9 "$(ps -a | grep docker-compose | awk '{print $1}')"
#     else
#         echo "docker-compose is not running"
#     fi
# }

pacman-fzf() {
    pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

## EXPORTS

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

## ALIAS

# - color
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# -- docker
alias di='docker images'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"'
alias wdps="watch -n 1 'docker ps -a --format \"table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\"'"
alias dlog='docker logs -f'
# - sxiv
alias img='sxiv -a' # -a para iniciar la animaciones auto
alias x='sxiv -at'  # -at para iniciar la animaciones auto y abrir en thumbnail mode
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
alias zed='zeditor'
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

## INIT LOGIC

# if CD_REPOS is set to 1, exceute cd-fzf-repos
if [ "$CD_REPOS" = "1" ]; then
    export CD_REPOS=0
    cd-fzf-repos
fi

## EXTRA

# nothing for now...
