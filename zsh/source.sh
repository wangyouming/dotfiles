#!/usr/bin/env zsh

export EDITOR=vim
export GIT_EDITOR=vim
export MANPAGER="vim -M +MANPAGER -"
export FZF_DEFAULT_COMMAND='rg --files --sortr modified'

platform=$(uname)

[[ -d ~/.local/bin ]] && [[ $PATH != "$HOME/.local/bin"* ]] && \
    export PATH=~/.local/bin:`echo $PATH | sed "s!:$HOME/.local/bin!!"`

if [[ $PATH != "$HOME/bin"* ]]; then
  PATH=~/bin:/usr/local/bin:/usr/local/sbin:`echo $PATH|sed -e "s!:$HOME/bin!!" -e "s!/usr/local/bin!!"`
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export WORKON_HOME=$HOME/.virtualenvs

export VIRTUALENVWRAPPER_PYTHON=$(which python3)

source $(which virtualenvwrapper.sh)

alias ll='ls -l'
alias la='ls -a'
alias vi='vim'
alias gv='gvim'
alias grep='grep --color=auto'
alias py='python'
alias py3='python3'
alias -s js=vi
alias -s c=vi
alias -s java=vi
alias -s txt=vi
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'

function gi() { curl -sLw n https://www.gitignore.io/api/$@ ;}
