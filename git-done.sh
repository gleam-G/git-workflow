#!/bin/bash

set -e

trap "cd \"$(pwd)\"" EXIT
cd "$(git rev-parse --show-toplevel)"
source "$(git --exec-path)/git-sh-setup"

base="$(git rev-parse --abbrev-ref origin/HEAD)"
base="${1:-${base#origin/}}"
feat="$(git branch --show-current)"
if [[ ${feat} == ${base} ]]; then
  die "land branch on <${base}> is not allowed"
fi

git fetch origin ${base}:${base}
git checkout ${base}
git branch -D ${feat}
git remote prune origin
git pull

