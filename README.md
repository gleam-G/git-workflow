Git Workflow Scripts
====================

Clone this repo, `cd` to this dir and create symlinks in one dir of `$PATH`:

```bash
for cmd in git-*.sh; do ln -s "$(pwd)/${cmd}" /usr/local/bin/${cmd%.sh}; done
```

Then you can invoke the following commands:

- `git work`: start a new branch

- `git request`: create merge request

- `git update`: rebase on main branch

  If you encounter conflicts, resolve it and `git rebase --continue`

- `git done`: prune working branch
