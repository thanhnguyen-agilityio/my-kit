# setup

How to set up machines, tools and accounts.

| File | What it is |
| --- | --- |
| [`client-git-setup.sh`](client-git-setup.sh) | Sets up a git identity per client folder: SSH key, `~/.gitconfig-<project>`, `includeIf`, SSH signing, global gitignore. Safe to rerun. Guide: [`playbooks/git-ssh-setup.md`](../playbooks/git-ssh-setup.md). |
| [`tailscale-setup.md`](tailscale-setup.md) | Connect to the company Tailnet (Headscale, `@asnet.com.vn` sign-in) to reach company GitLab. macOS, Windows, Linux, checks, hosts-file fix, troubleshooting. |
| [`gitlab-setup.md`](gitlab-setup.md) | Sign in to company GitLab with `glab`, then branches, pull/push, merge requests, issues and pipelines from the terminal. Needs Tailscale first. |
