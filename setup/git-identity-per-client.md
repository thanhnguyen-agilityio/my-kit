# Git identity per client

Goal: every repo under one client folder commits with that client's email and pushes and signs with that client's SSH key, automatically. Repos outside the folder keep your default identity.

## 1. Layout

```
~/work/Projects/<project>/
├── <client-repo>/       # cloned from the client's GitLab/GitHub
└── my-i-<project>/      # your private notes (see the note in step 6)
```

## 2. Create a dedicated SSH key

```bash
ssh-keygen -t ed25519 -C "<work-email>" -f ~/.ssh/id_ed25519_<project>
```

Set a passphrase and add it to the macOS keychain: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519_<project>`.

## 3. Add the public key to the client's git host

Use an **SSH key on your user account**. Do not use an access token for daily work.

| Use | What to use |
| --- | --- |
| Clone, pull, push, signed commits | SSH key on your user account |
| Port 22 is blocked | HTTPS remote + personal access token (`read_repository`, `write_repository`) |
| API, `glab`/`gh` CLI, MCP, scripts | Personal access token with the smallest scope, kept in a password manager |
| CI or bots | Project/group access token. It creates a bot user, so commits are not under your name |

GitLab: Avatar → Edit profile → SSH Keys → Add new key.

```bash
pbcopy < ~/.ssh/id_ed25519_<project>.pub     # the .pub file, never the private key
```

- **Usage type:** Authentication & Signing (one key does both).
- **Expiration:** follow company policy, usually the end of the project or 1 year.
- **Title:** see the naming rule below.

### SSH key naming rule

```
<owner>-<device>-<project>-<yyyymm>
```

Example: `thanh-macbook-<project>-202611`

| Part | Why |
| --- | --- |
| owner | Admins can see whose key it is |
| device | If you lose or replace a laptop, you know which key to revoke |
| project | Matches the file name `id_ed25519_<project>` |
| yyyymm | Shows when to rotate it |

## 4. `~/.gitconfig-<project>`

```ini
# Loaded only for repos under ~/work/Projects/<project>/ (via includeIf in ~/.gitconfig)
[user]
    name = <Your Name>
    email = <email-on-client-git-host>
    signingkey = ~/.ssh/id_ed25519_<project>.pub
[gpg]
    format = ssh
[commit]
    gpgsign = true
[tag]
    gpgsign = true
[core]
    # Use the dedicated SSH key for this client's git host
    sshCommand = ssh -i ~/.ssh/id_ed25519_<project> -o IdentitiesOnly=yes
[pull]
    rebase = true
```

The email must match an email on your account on that host. If it does not, commits are not linked to you and signatures do not show "Verified".

## 5. `~/.gitconfig`

Put the `includeIf` block **at the end**, after your default `[user]`. Git uses the last value it reads, so the client config wins.

```ini
[user]
    name = <Your Name>
    email = <default-email>
[core]
    excludesFile = ~/.gitignore_global
[includeIf "gitdir/i:~/work/Projects/<project>/"]
    path = ~/.gitconfig-<project>
```

**The trailing `/` is required.** Git matches the pattern against the repo's `.git` path (`.../<client-repo>/.git`):

- `gitdir:~/work/Projects/<project>` (no `/`) only matches that exact path, so repos inside it do **not** match. `git config user.name` comes back empty.
- `gitdir:~/work/Projects/<project>/` (with `/`) gets `**` added, so every repo inside matches.

Use `gitdir/i` (case-insensitive). The macOS file system ignores case by default, so `cd ~/work/projects/...` still matches.

Global ignores for your personal files in client repos:

```bash
echo ".me" >> ~/.gitignore_global
echo "CLAUDE.local.md" >> ~/.gitignore_global
git config --global core.excludesFile ~/.gitignore_global
```

## 6. Your notes repo is in the client folder too

`my-i-<project>` is under `~/work/Projects/<project>/`, so it also gets the client's `sshCommand`. If it lives on a different host (for example GitHub), push fails with `Permission denied`. Pick one fix:

- **A. Same identity on both hosts.** If both accounts belong to your company identity, add `id_ed25519_<project>.pub` to the other host too, as both an Authentication key and a Signing key.
- **B. Override in that repo.** Repo config is read after the global config, so it wins:

  ```bash
  cd ~/work/Projects/<project>/my-i-<project>
  git config core.sshCommand "ssh -i ~/.ssh/<other-key> -o IdentitiesOnly=yes"
  git config user.signingkey ~/.ssh/<other-key>.pub
  git config user.email <email-on-other-host>
  ```
- **C. Move it out.** Keep it in `~/work/_me/my-i-<project>` and add a link from the client repo: `ln -s ~/work/_me/my-i-<project> .me` (`.me` is already ignored globally).

## 7. Check it

```bash
cd ~/work/Projects/<project>/<client-repo>
git rev-parse --git-dir                         # .git, so this is a real repo
git config --show-origin --get user.name        # file:.../.gitconfig-<project>  <Your Name>
git config --show-origin --get user.email
git config --show-origin --get core.sshCommand
ssh -i ~/.ssh/id_ed25519_<project> -T git@<git-host>   # "Welcome to GitLab, @<you>!"
git remote -v                                   # must be git@..., not https://
```

If the remote is HTTPS, change it:

```bash
git remote set-url origin git@<git-host>:<group>/<repo>.git
```

If the values are still empty, see whether the include file is loaded at all:

```bash
git config --list --show-origin | grep -i <project>
```

Optional, so `git log --show-signature` can verify your own commits on your machine:

```bash
echo "<email> $(cat ~/.ssh/id_ed25519_<project>.pub)" >> ~/.ssh/allowed_signers
git config --file ~/.gitconfig-<project> gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

## Common mistakes

| Symptom | Cause |
| --- | --- |
| `git config user.name` is empty in the client repo | No trailing `/` in `gitdir:` |
| Default email instead of client email | `includeIf` comes before the default `[user]` |
| Works with `~/work/Projects`, not with `~/work/projects` | Used `gitdir:` instead of `gitdir/i:` |
| `Permission denied (publickey)` on the notes repo | It gets the client's `sshCommand`, see step 6 |
| Commits are not "Verified" | Key not added as a Signing key, or commit email is not on the account |
