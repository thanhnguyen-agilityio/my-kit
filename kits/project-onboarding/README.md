Internal to Agility. Do not share publicly.

# project-onboarding

What to set up on day one of a new client project, so you are productive fast and nothing from the client ends up mixed into your career kit.

It has no client data. Fill in the `<placeholders>`.

## What's inside

| Path | What it is |
| --- | --- |
| [`playbooks/git-identity-per-client.md`](playbooks/git-identity-per-client.md) | A separate git identity (name, email, SSH key, signing) per client folder, with `includeIf`. Includes the SSH key naming rule, the usual mistakes and how to check the setup. |
| [`playbooks/first-week.md`](playbooks/first-week.md) | Day 0 to week 1: local layout, reading Slack and the repo, testing the PoC, the "My understanding of `<product>`" one-pager. |
| [`templates/my-i-project/`](templates/my-i-project/) | Scaffold for a private notes repo, one per project (`my-i-<project>`): README, onboarding checklist, daily log, people, glossary, architecture, questions, decisions, kit harvest and a `CLAUDE.md.template`. |

## Two kinds of repo

- **`my-kit`**: career notes that apply across projects. No client data ever.
- **`my-i-<project>`**: one private repo per project. Archive or delete it when the project ends.

Things you can reuse go into `kit-harvest.md` in the project repo first. Once a month, remove the client details and move them into `my-kit`.

> Check company policy before you put client notes (names, architecture, PoC links, bugs) on any GitHub account. If it is not allowed, keep `my-i-<project>` on the company GitLab or only on your machine.

## Quick start

```bash
mkdir -p ~/work/Projects/<project>
cp -R kits/project-onboarding/templates/my-i-project ~/work/Projects/<project>/my-i-<project>
mv ~/work/Projects/<project>/my-i-<project>/CLAUDE.md.template ~/work/Projects/<project>/my-i-<project>/CLAUDE.md
```

Then follow [`playbooks/git-identity-per-client.md`](playbooks/git-identity-per-client.md) and [`playbooks/first-week.md`](playbooks/first-week.md).

## Source

Built while onboarding to project togepi (November 2026). The onboarding checklist will get better after each project.
