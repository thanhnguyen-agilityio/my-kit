# GitLab setup (company GitLab with glab)

Sign in to the company GitLab (`gitlab.asoft-python.com`) with the `glab` CLI, then work with repos, branches, merge requests, issues and pipelines from the terminal.

Source: company guide ([Artifact](https://claude.ai/artifact/X8ptfDfdHoc6q63pjp6pzM)). GitLab is only reachable over the company Tailnet: do [`tailscale-setup.md`](tailscale-setup.md) first.

## 1. Before you start

- `git` and `glab` installed (step 2).
- An SSH key added to your GitLab profile, so SSH clones work. For a separate key per org, see [`playbooks/git-ssh-setup.md`](../playbooks/git-ssh-setup.md).
- A personal access token with the `api` and `write_repository` scopes: `https://gitlab.asoft-python.com/-/user_settings/personal_access_tokens` (on GitLab 18.8 and earlier, use the legacy page the login prompt shows).

glab stores the token in the OS keyring. Keep it private. If it leaks, revoke it in GitLab and run `glab auth login` again.

## 2. Install glab

| OS | Command |
| --- | --- |
| macOS | `brew install glab` |
| Linux | `brew install glab`, or `sudo dpkg -i glab_<version>_linux_amd64.deb` / `sudo rpm -i glab_<version>_linux_amd64.rpm` from the glab releases page |
| Windows | `scoop install glab` or `choco install glab` (admin), or put `glab.exe` on `PATH` |

Check: `glab --version` and `git --version`.

## 3. Sign in

```sh
glab auth login --hostname gitlab.asoft-python.com --git-protocol ssh --api-protocol https
```

If you run plain `glab auth login`, answer the prompts:

| Prompt | Answer |
| --- | --- |
| Instance | Self-Managed |
| GitLab, API and SSH hostname | `gitlab.asoft-python.com` |
| Authentication | Token |
| Container registry domains | `gitlab.asoft-python.com,gitlab.asoft-python.com:443` |
| Git protocol / API protocol | SSH / HTTPS |

```sh
glab auth status                                      # check
glab config set -g host gitlab.asoft-python.com       # make it the default host
glab auth logout --hostname gitlab.asoft-python.com   # sign out
```

## 4. Repositories

```sh
glab repo clone group/project
glab repo view group/project        # add -w to open in the browser
glab mr list -R group/project       # -R targets another repo
```

## 5. Branches

Name branches `feature/`, `fix/` or `chore/`, plus the ticket ID if there is one.

```sh
git checkout main
git pull --rebase origin main
git checkout -b feature/login-page
git push -u origin feature/login-page

git branch -a                        # list
git push origin --delete <branch>    # delete remote branch
```

## 6. Pull and push

```sh
git pull --rebase origin main   # update your branch
git push
git push --force-with-lease     # after a rebase
git fetch --prune               # clean stale remote branches
```

Use `--force-with-lease`, never `--force`. Never force-push to `main`.

## 7. Merge requests

```sh
glab mr create                       # interactive
glab mr create --fill --draft
glab mr create --source-branch feature/login-page --target-branch main \
  --title "..." --description "..." --draft --remove-source-branch

glab mr list --assignee=@me          # or --reviewer=@me
glab mr view 42
glab mr checkout 42
glab mr diff 42
glab mr note 42 -m "..."

glab mr approve 42
glab mr update 42 --ready
glab mr merge 42 --when-pipeline-succeeds --remove-source-branch
glab mr close 42
```

Team flow: branch from `main` > push with `-u` > open a draft MR > keep the pipeline green > request review > mark ready > approval > merge when the pipeline passes.

## 8. Issues

```sh
glab issue create --title "..." --description "..." --label bug
glab issue list --assignee=@me
glab issue view 15
glab issue note 15 -m "..."
glab issue close 15
```

## 9. Pipelines

```sh
glab ci status
glab ci view
glab ci list
glab ci trace    # stream job logs
glab ci retry
```

## 10. Other

```sh
glab api projects
glab api "projects/:id/merge_requests?state=opened"
glab config get git_protocol
glab completion -s zsh > "${fpath[1]}/_glab"
```

Flags change between releases: check `glab <command> --help`.

## Support

Ask in the team channel. Include the exact command, the full error, `glab --version` and `glab auth status`.
