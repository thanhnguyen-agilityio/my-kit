# templates

Files and folders to copy into a new project, then fill in the `<placeholders>`.

| Template | What it is |
| --- | --- |
| [`my-project/`](my-project/) | A private notes repo, one per project (`my-<project>`): README, onboarding checklist, daily log, people, glossary, architecture, PoC review, questions, decisions, kit harvest and a `CLAUDE.md.template`. |

## my-project

Two kinds of repo:

- **`my-kit`** (this repo): career notes that apply across projects. No client data ever.
- **`my-<project>`**: one private repo per project. Archive or delete it when the project ends.

Things you can reuse go into `kit-harvest.md` in the project repo first. Once a month, remove the client details and move them into `my-kit`.

> Check company policy before you put client notes (names, architecture, PoC links, bugs) on any GitHub account. If it is not allowed, keep `my-<project>` on the company GitLab or only on your machine.

```bash
mkdir -p ~/work/Projects/<project>/my-<project>
cp -R ~/work/my-kit/templates/my-project/. ~/work/Projects/<project>/my-<project>/
mv ~/work/Projects/<project>/my-<project>/CLAUDE.md.template ~/work/Projects/<project>/my-<project>/CLAUDE.md
```

Then follow [`playbooks/git-ssh-setup.md`](../playbooks/git-ssh-setup.md) and [`playbooks/project-first-week.md`](../playbooks/project-first-week.md).
