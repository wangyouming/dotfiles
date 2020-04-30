#!/bin/bash

git config --global user.name wangyouming

current_email=$(git config --global --get user.email)

if [[ -z "$current_email" ]]
then
    git config --global user.email wangyouming1209@gmail.com
fi

# set vimdiff as diff tool
git config --global merge.tool vimdiff
git config --global merge.conflictstyle diff3
git config --global mergetool.prompt false

# global .gitignore
git config --global core.excludesfile ~/.gitignore_global

# alias
git config --global alias.a add
git config --global alias.br "branch -vv"
git config --global alias.ca "commit --amend"
git config --global alias.can "commit --amend --no-edit"
git config --global alias.ci commit
git config --global alias.cl "clean -dff"
git config --global alias.co checkout
git config --global alias.cp "cherry-pick"
git config --global alias.d difftool
git config --global alias.h help
git config --global alias.p push
git config --global alias.pf "push --force"
git config --global alias.rb "rebase"
git config --global alias.st status
git config --global alias.sub submodule
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

# This makes sure that push pushes only the current branch, and pushes it to the
# same branch pull would pull from
git config --global push.default upstream

# Additional or overridden config for corp projects.
test -d ~/workspace/corp || mkdir -p ~/workspace/corp
git config --global includeIf.gitdir:~/workspace/corp/.path ~/workspace/corp/.gitconfig
corp_config=$HOME/workspace/corp/.gitconfig
if ! git config -f ${corp_config} --get user.name >/dev/null
then
    git config -f ${corp_config} user.name wangyouming
    git config -f ${corp_config} user.email wangyouming1209@gmail.com
fi
