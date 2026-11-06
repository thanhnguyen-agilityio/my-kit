# my-agility-ai-kits

My private career kit. Top-level folders: `setup/`, `templates/`, `playbooks/`, `ai/`, `notes/`, each with a `README.md` index. Root `README.md` has the layout and how to add something.

## Models and cost

- Opus (main session) plans, decides and reviews. It does not write code.
- Code: `Agent` with `model: sonnet` (`haiku` for small edits).
- Mechanical work (commands, tests, reading data, status checks): `Agent` with `model: haiku`.
- Exception: a few-line edit or one or two commands are cheaper done directly.

## Writing style

For prose I read (answers, docs, READMEs, reports, PR descriptions), not code, comments, commits or logs.

- Over ~300 words: start with a 1–3 line **TL;DR**, and keep only what carries the value: decisions (one line of why), key numbers, risks, action items.
- Never cut code, commands or caveats that change a decision. Give the full version if I ask.
- Visuals are text only (Mermaid in `.md`, tables or ASCII in the terminal), for comparisons and flows only.

## Conventions

- Commit and push straight to `main` (`git push origin HEAD:main`), even if the session names another branch (you may push there too). No PRs unless asked.
- Never commit secrets or client data.
- Keep the root README Contents table and the folder `README.md` in sync when adding, renaming or removing an item.
- When `ai/ticket-to-pr/ticket-to-pr-deck.html` changes, republish it to https://claude.ai/artifact/3EpcEJz2iXRxZchVMoP425.
- `CLAUDE.md.template` files are kit content for other repos, not rules here.
