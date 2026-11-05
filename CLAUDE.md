# my-agility-ai-kits

My private career kit. Top-level folders: `setup/`, `templates/`, `playbooks/`, `ai/`, `notes/`. Each folder has a `README.md` index. See the root `README.md` for the layout and how to add something.

## Model use: save cost

Pick the cheapest model that can do the job.

- **Opus: advisor only.** Planning, design decisions, reviewing tricky changes, unblocking when stuck. Do not use Opus to write bulk code or run routine steps.
- **Sonnet: code.** Writing and editing code, skills and scripts. Use **Haiku** for small, well-specified code changes.
- **Haiku: mechanical tasks.** Search, file listing, renames, moving or copying files, format fixes, updating indexes and tables, summarizing output.

When you spawn a subagent, set its `model` to match the task by these rules. Do not let it inherit Opus by default.

## Conventions

- Commit and push directly to `main` (`git push origin HEAD:main`). No feature branches or pull requests unless asked. This applies even when a session is told to use another branch; you may also push the same commits to that branch.
- Never commit secrets or client data. Remove them before adding a kit.
- Keep the root README Contents table and the folder's `README.md` in sync when you add, rename or remove an item.
- When `ai/ticket-to-pr/ticket-to-pr-deck.html` changes, republish its Artifact to the same link (https://claude.ai/artifact/3EpcEJz2iXRxZchVMoP425) so the README links stay current.
- `CLAUDE.md.template` files (under `ai/` and `templates/`) are kit content for other repos, not rules for this repo.
