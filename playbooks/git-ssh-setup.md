# Playbook: Per-client Git identity & SSH setup

> Goal: every client project gets its own Git identity (name, email, SSH key, commit signing),
> applied automatically by folder — so you never push with the wrong email or key.
> Script: `setup/client-git-setup.sh`

## The model

Each client project lives in one folder that holds two repos:

```
~/work/Projects/<project>/
├── <client-repo>/        # client code (e.g. GitLab) — owned by the client
└── my-<project>/         # my private notes for this project (e.g. company GitHub)
```

Everything under `~/work/Projects/<project>/` automatically uses:

- the client email
- a dedicated SSH key: `~/.ssh/id_ed25519_<project>`
- SSH commit signing with that same key

Other folders keep the default global identity.

## Rules

1. **One key per project per device.** Never copy private keys between machines.
   A new machine means a new key, registered as a new entry on GitLab/GitHub.
2. **Key title convention:** `<owner>-<device>-<project>-<yyyymm>`
   e.g. `thanh-macbook-acme-202611`. When a device is lost or a project ends,
   you know exactly which keys to revoke.
3. **Use a passphrase** and let the agent / macOS Keychain remember it.
4. **Never store keys, tokens or passwords in any repo** (kit or project notes).
   Use a password manager.
5. **SSH keys for humans, tokens for machines.** Add the SSH key to your user account.
   Use Personal Access Tokens only for API, CLI tools, scripts or when SSH is blocked.

## Setup

### 1. Run the script

```bash
~/work/my-kit/setup/client-git-setup.sh \
  --project togepi \
  --dir ~/work/Projects/i-togepi \
  --name "Your Name" \
  --email you@company.com
```

It is idempotent (safe to re-run). It:

- generates `~/.ssh/id_ed25519_<project>` if missing
- writes `~/.gitconfig-<project>` (user, signing, sshCommand)
- adds an `includeIf` entry to `~/.gitconfig`
- adds the key to `~/.ssh/allowed_signers` (local signature verification)
- ensures `~/.gitignore_global` ignores `.me`, `CLAUDE.local.md`, `.DS_Store`
- prints the public key and the suggested key title

### 2. Register the public key on both hosts

Copy the key: `pbcopy < ~/.ssh/id_ed25519_<project>.pub`

| Host | Where | Usage |
|---|---|---|
| Client GitLab | Edit profile → SSH Keys | **Authentication & Signing** |
| Company GitHub (notes repo) | Settings → SSH and GPG keys | Add twice: **Authentication** key and **Signing** key |

For "Verified" commits, the commit email must be a verified email on that account.

### 3. Clone with SSH URLs

```bash
cd ~/work/Projects/<project>
git clone git@<gitlab-host>:<group>/<repo>.git <client-repo>
git clone git@github.com:<org>/my-<project>.git
```

If a repo was cloned with HTTPS: `git remote set-url origin git@...`

### 4. Link notes into the client repo (optional)

```bash
cd ~/work/Projects/<project>/<client-repo>
ln -s ../my-<project> .me      # ignored globally, never committed
```

### 5. Verify

```bash
cd ~/work/Projects/<project>/<client-repo>
git config --show-origin --get user.email        # → from ~/.gitconfig-<project>
git config --show-origin --get core.sshCommand
ssh -i ~/.ssh/id_ed25519_<project> -T git@<gitlab-host>
ssh -i ~/.ssh/id_ed25519_<project> -T git@github.com

git status                                       # .me must not appear

# Test signing in a throwaway repo, not in the client repo
git init ~/work/Projects/<project>/_signing-test && cd $_
git commit --allow-empty -m "test signing"
git log --show-signature -1                      # → Good "git" signature
cd .. && rm -rf _signing-test
```

The script warns if `~/.gitconfig` still has an older `includeIf` for the same file (for example one without the trailing `/`). Delete that block by hand.

## New machine (about 10 minutes)

A new machine has no SSH key yet, so clone `my-kit` over HTTPS first.

```bash
gh auth login
git clone https://github.com/<you>/my-kit.git ~/work/my-kit
~/work/my-kit/setup/client-git-setup.sh --project <project> --dir ~/work/Projects/<project> \
  --name "<Your Name>" --email <work-email> --owner <you> --device <new-device>
```

Then register the **new** public key (title `<you>-<new-device>-<project>-<yyyymm>`), and clone the repos with SSH URLs (steps 2 to 4). Never copy the private key from another machine.

## Gotchas (learned the hard way)

- **`includeIf "gitdir:..."` needs a trailing `/`.** Without it, Git matches only
  that exact `.git` path, so nested repos get nothing. Use `gitdir/i:~/work/Projects/<project>/`.
- **Use `gitdir/i`** (case-insensitive) on macOS, where `Projects` and `projects` are the same folder.
- **Put `includeIf` at the end of `~/.gitconfig`**, so it overrides the default `[user]`.
- **`core.sshCommand` applies to every repo in the folder.** If the notes repo is on an account
  that does not have this key, push fails with `Permission denied`. Either add the key to that
  account (preferred) or override in that repo:
  `git config core.sshCommand "ssh -i ~/.ssh/<other-key> -o IdentitiesOnly=yes"`.
- `IdentitiesOnly=yes` stops SSH from trying every key in the agent (some servers reject
  after too many attempts).

## Offboarding (end of project)

- [ ] Revoke the key on GitLab and GitHub (search by key title)
- [ ] Delete `~/.ssh/id_ed25519_<project>*` and its line in `~/.ssh/allowed_signers`
- [ ] Remove the `includeIf` block and `~/.gitconfig-<project>`
- [ ] Revoke any access tokens created for the project
- [ ] Archive the notes repo after the final harvest
