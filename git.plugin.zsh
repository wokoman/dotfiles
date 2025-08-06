#!/bin/sh

# Functions

function git_default_branch() {
  command git rev-parse --git-dir &>/dev/null || return

  local default_branch=$(command git config --get init.defaultBranch)
  if [[ -n $default_branch ]] && command git show-ref -q --verify refs/heads/$default_branch; then
    echo $default_branch
  elif command git show-ref -q --verify refs/heads/main; then
    echo main
  else
   echo master
  fi
}

function git_current_branch() {
  command git rev-parse --git-dir &>/dev/null || return

  local ref=$(git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

function git_rename_branch() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

# Aliases

## Status
alias gst="git status"
alias gss="git status -s"

## Branch
alias gb="git branch -vv"
alias gba="git branch -a -v"
alias gbd="git branch -d"
alias gbd!="git branch -D"
alias gbage="git for-each-ref --sort=committerdate refs/heads/ --format=\"%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))\""
alias gbsup="git branch --set-upstream-to=origin/$(git_current_branch)"
alias gbmv="git_rename_branch"

## Local Files
alias ga="git add"
alias gaa="git add --all"
alias gau="git add --update"
alias gapa="git add --patch"
alias grm="git rm"
alias grmc="git rm --cached"
alias grs="git restore"
alias grss="git restore --source"
alias grst="git restore --staged"
alias grst!="git restore --staged --worktree"

## Clean
alias gclean="git clean -di"
alias gclean!="git clean -dfx"
alias gclean!!="git reset --hard; git clean -dfx"

## Reset
alias grh="git reset HEAD~1"
alias grh!="git reset --hard HEAD~1"

## Commit
alias gc="git commit -v"
alias gc!="git commit -v --amend"
alias gcn!="git commit -v --amend --no-edit"
alias gca="git commit -v -a"
alias gca!="git commit -v -a --amend"
alias gcan!="git commit -v -a --amend --no-edit"
alias gcv="git commit -v --no-verify"
alias gcav="git commit -v -a --no-verify"
alias gcav!="git commit -v -a --no-verify --amend"
alias gcm="git commit -m"
alias gcam="git commit -a -m"

## Checkout
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcom="git checkout $(git_default_branch)"
alias gco-="git checkout @{-1}"
alias gsw="git switch"
alias gswc="git switch -c"
alias gswm="git switch $(git_default_branch)"
alias gsw-="git switch @{-1}"

## Fetch
alias gf="git fetch"
alias gfa="git fetch --all --prune"
alias gfo="git fetch origin"

## Push
alias gp="git push"
alias gp!="git push --force-with-lease"
alias gpo="git push origin"
alias gpo!="git push --force-with-lease origin"
alias gpv="git push --no-verify"
alias gpv!="git push --no-verify --force-with-lease"
alias ggp="git push origin $(git_current_branch)"
alias ggp!="git push --force-with-lease origin $(git_current_branch)"
alias ggpu="git push --set-upstream origin $(git_current_branch)"
alias gpoat="git push origin --all && git push origin --tags"

## Pull
alias gpl="git pull"
alias ggpl="git pull origin $(git_current_branch)"
alias gplr="git pull --rebase"
alias gplra="git pull --rebase --autostash"

## Diff
alias gd="git diff"
alias gds="git diff --stat"
alias gdc="git diff --cached"
alias gdsc="git diff --stat --cached"
alias gdt="git diff-tree --no-commit-id --name-only -r"
alias gdw="git diff --word-diff"
alias gdwc="git diff --word-diff --cached"
alias gdto="git difftool"

## Log
alias glo="git log --pretty=format:\"%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s\" --date=short"
alias glg="git log --stat"
alias glgg="git log --graph"
alias glgga="git log --graph --decorate --all"
alias glom="git log --oneline --decorate --color $(git_default_branch).."
alias gcount="git shortlog -sn"

## Rebase
alias grb="git rebase"
alias grbi="git rebase --interactive"
alias grba="git rebase --abort"
alias grbc="git rebase --continue"
alias grbs="git rebase --skip"
alias grbm="git rebase $(git_default_branch)"
alias grbmi="git rebase $(git_default_branch) --interactive"

## Stash & Work in Progress
alias gsta="git stash"
alias gstd="git stash drop"
alias gstl="git stash list"
alias gstp="git stash pop"
alias gsts="git stash show --text"
alias gwip="git add -A; git rm (git ls-files --deleted) 2> /dev/null; git commit -m \"--wip--\" --no-verify"
alias gunwip="git log -n 1 | grep -q -c \"--wip--\" && git reset HEAD~1"

## Cherry-pick
alias gcp="git cherry-pick"
alias gcpa="git cherry-pick --abort"
alias gcpc="git cherry-pick --continue"
alias gcps="git cherry-pick --skip"

## Bisect
alias gbs="git bisect"
alias gbss="git bisect start"
alias gbsb="git bisect bad"
alias gbsg="git bisect good"
alias gbsr="git bisect reset"

## Remote
alias gr="git remote -vv"
alias gra="git remote add"
alias grmv="git remote rename"
alias grpo="git remote prune origin"
alias grrm="git remote remove"
alias grset="git remote set-url"
alias grup="git remote update"

## Tag
alias gt="git tag"
alias gtl="git tag --list"
alias gtd="git tag -d"
alias gtv="git tag | sort -V"

## Miscellaneous
alias g="git"
alias gcl="git clone"
alias gm="git merge"
alias gbl="git blame -b -w"
alias gcf="git config"
alias gcfl="git config --list"
