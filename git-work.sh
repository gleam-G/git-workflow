#!/bin/bash

set -e

branch="${1:?name}"
choices="feat fix doc epic chore"

trap "cd \"$(pwd)\"" EXIT
cd "$(git rev-parse --show-toplevel)"
source "$(git --exec-path)/git-sh-setup"

if [[ "${branch}" == "${branch%%-*}" ]]; then
  die "should be like <type>-<name>"
fi
if [[ ! " ${choices} " =~ " ${branch%%-*} " ]]; then
  die "type prefix: ${choices// /-, }-"
fi

if [[ -n "$(git branch --list ${branch})" || \
      -n "$(git ls-remote --heads origin ${branch})" ]]; then
  git checkout ${branch}
else
  git checkout -b ${branch}
fi
