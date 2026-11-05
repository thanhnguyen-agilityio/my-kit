# First week on a new project

## Day 0 (about 1 hour): set up

1. Local layout and git identity: [`playbooks/git-ssh-setup.md`](git-ssh-setup.md) (run `setup/client-git-setup.sh`).
2. Create the notes repo from [`templates/my-i-project/`](../templates/my-i-project/).
3. Link it from the client repo so Claude and you can find it there: `ln -s ../my-i-<project> .me` (ignored globally).
4. Never store credentials in the notes repo, PoC logins included. Use a password manager.

## Days 1–3: learn on purpose

**Slack channel**
- Read the history and pinned messages from the start.
- Write down who the PM, tech lead and client stakeholders are in `people.md`, and new terms in `glossary.md`.
- Write down decisions already made in `decisions.md`, with a link to the message.

**Repo**
- Clone it and run it locally from the README. Note every place you get stuck. Fixing the README or setup script is your first MR: quick, useful, and it shows the team you care.
- Map the stack, services, DB, CI/CD, environments and who reviews MRs in `architecture.md`.
- Read the 10–20 latest MRs to learn the code style and how the team reviews.

**PoC app**
- Use it as an end user. Go through every main flow. Write down bugs, odd UX and business logic questions in `poc-review.md`.
- Compare the PoC with the code: which flows are real and which are mocked.

## End of week 1: "My understanding of `<product>`"

One page: goals, architecture, risks, open questions. Send it to your lead to check. You find your wrong ideas early, and the team sees the level you think at.

## Every day, every month

- Every day: 3 lines in `log.md` (did / learned / blocked).
- When you find something reusable (checklist, script, prompt, pattern): one line in `kit-harvest.md`.
- Once a month, 30 minutes: remove client details from those items and move them to `my-kit`.
