# templates

Files and folders to copy into a new project, then fill in the `<placeholders>`.

| Template | What it is |
| --- | --- |
| [`my-i-project/`](my-i-project/) | A private notes repo, one per project (`my-i-<project>`): README, onboarding checklist, daily log, people, glossary, architecture, PoC review, questions, decisions, kit harvest and a `CLAUDE.md.template`. |

## my-i-project

Two kinds of repo:

- **`my-kit`** (this repo): career notes that apply across projects. No client data ever.
- **`my-i-<project>`**: one private repo per project. Archive or delete it when the project ends.

Things you can reuse go into `kit-harvest.md` in the project repo first. Once a month, remove the client details and move them into `my-kit`.

> Check company policy before you put client notes (names, architecture, PoC links, bugs) on any GitHub account. If it is not allowed, keep `my-i-<project>` on the company GitLab or only on your machine.

```bash
mkdir -p ~/work/Projects/<project>/my-i-<project>
cp -R ~/work/my-kit/templates/my-i-project/. ~/work/Projects/<project>/my-i-<project>/
mv ~/work/Projects/<project>/my-i-<project>/CLAUDE.md.template ~/work/Projects/<project>/my-i-<project>/CLAUDE.md
```

Then follow [`setup/git-identity-per-client.md`](../setup/git-identity-per-client.md) and [`playbooks/project-first-week.md`](../playbooks/project-first-week.md).
