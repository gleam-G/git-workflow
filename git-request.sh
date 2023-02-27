#!/bin/bash

set -e

trap "cd \"$(pwd)\"" EXIT
cd "$(git rev-parse --show-toplevel)"
source "$(git --exec-path)/git-sh-setup"

while (( ${#} > 0 )); do
  if [[ "${1}" == -* ]]; then
    prop=${1:1}
  elif [[ -n "${prop}" ]]; then
    case "${prop}" in
      r) user="${user:+${user} }${1}";;
      t) title="${1}";;
      m) remark="${remark:+${remark}\n}${1}";;
      *) die "usage: [-r reviewer] [-t title] [-m description] [base_branch]";;
    esac
    prop=""
  else
    base="${1}"
  fi
  shift
done

if [[ -z "${base}" ]]; then
  base="$(git rev-parse --abbrev-ref origin/HEAD)"
  base="${1:-${base#origin/}}"
fi

feat=$(git branch --show-current)
if [[ "${feat}" == "${base}" ]]; then
  die "merge request on <${base}> is not allowed"
fi

if [[ -z "${title}" ]]; then
  title="$(git log ${base}..${feat} --oneline | tail -1 | cut -d' ' -f2-)"
fi
if [[ -z "${title}" ]]; then
  die "commit message not found, option -t is required"
fi

option="-o merge_request.create"
for r in ${user}; do
  option="${option} -o merge_request.assign=${r}"
done
if [[ -n "${base}" ]]; then
  option="${option} -o merge_request.target=${base}"
fi
if [[ -n "${title}" ]]; then
  option="${option} -o \"merge_request.title=${title}\""
fi
if [[ -n "${remark}" ]]; then
  option="${option} -o \"merge_request.description=${remark}\""
fi

track=$(git for-each-ref --format='%(upstream:short)' "$(git symbolic-ref -q HEAD)")
if [[ "${track}" == origin/* ]]; then
  track=""
elif [[ -n "${track}" ]]; then
  track="origin ${feat}:${feat}"
else
  track="-u origin ${feat}:${feat}"
fi

eval git push ${option} ${track}
