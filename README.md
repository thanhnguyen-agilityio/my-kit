# my-agility-ai-kits

Internal to Agility. Do not share publicly.

My career kit: setup guides, templates, playbooks, AI kits and notes I can reuse on any project. Nothing here holds client data. Project-specific notes live in a separate `my-<project>` repo and are moved here only after client details are removed.

## Layout

| Folder | What goes there |
| --- | --- |
| [`setup/`](setup/) | How to set up machines, tools and accounts |
| [`templates/`](templates/) | Files and folders to copy into a new project |
| [`playbooks/`](playbooks/) | Step-by-step guides for things that happen on every project |
| [`ai/`](ai/) | AI kits: Claude Code skills, commands, prompts, rules files |
| [`notes/`](notes/) | Lessons and thoughts that apply across projects |

## Contents

| Item | Source | What it is |
| --- | --- | --- |
| [`setup/client-git-setup.sh`](setup/client-git-setup.sh) | Project togepi | Script: a git identity per client folder (SSH key, `includeIf`, SSH signing). Safe to rerun. |
| [`playbooks/git-ssh-setup.md`](playbooks/git-ssh-setup.md) | Project togepi | Guide for the script: key rules and naming, register keys, check, gotchas, offboarding. |
| [`templates/my-project/`](templates/my-project/) | Project togepi | Scaffold for a private notes repo, one per project: onboarding checklist, log, people, glossary, architecture, decisions, kit harvest, `CLAUDE.md`. |
| [`playbooks/project-first-week.md`](playbooks/project-first-week.md) | Project togepi | Day 0 to week 1 on a new project, ending with a "My understanding of `<product>`" one-pager. |
| [`ai/ticket-to-pr/`](ai/ticket-to-pr/) | Project smoliv | Ticket to pull request with human gates. Claude Code skills and one command for a 5-step flow: grill, plan (sync issue, plan), implement, review (self-review, team review, fix), open PR. [Talk deck](https://claude.ai/artifact/3EpcEJz2iXRxZchVMoP425). |

## Adding something

1. Pick the folder from the layout table. An item with more than one file gets its own subfolder with a `README.md`: what it is, how to use or install it, where it came from.
2. Remove client data and secrets first.
3. Add a row to the folder's `README.md` and to the Contents table above.
