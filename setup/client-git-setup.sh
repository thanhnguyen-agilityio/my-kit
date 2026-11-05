#!/usr/bin/env bash
# client-git-setup.sh — per-project Git identity + SSH key + signing.
# Idempotent: safe to re-run. See playbooks/git-ssh-setup.md.
#
# Usage:
#   client-git-setup.sh --project togepi --dir ~/work/Projects/i-togepi \
#                       --name "Your Name" --email you@company.com \
#                       [--device macbook] [--owner thanh] [--no-passphrase]

set -euo pipefail

PROJECT="" DIR="" NAME="" EMAIL="" DEVICE="" OWNER="" NO_PASS=0

usage() { sed -n '2,9p' "$0"; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) PROJECT="$2"; shift 2 ;;
    --dir)     DIR="$2"; shift 2 ;;
    --name)    NAME="$2"; shift 2 ;;
    --email)   EMAIL="$2"; shift 2 ;;
    --device)  DEVICE="$2"; shift 2 ;;
    --owner)   OWNER="$2"; shift 2 ;;
    --no-passphrase) NO_PASS=1; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

[[ -z "$PROJECT" || -z "$DIR" || -z "$NAME" || -z "$EMAIL" ]] && usage

# Normalize folder: expand ~, strip trailing slash; includeIf uses "~/..." with a trailing slash.
DIR="${DIR/#\~/$HOME}"; DIR="${DIR%/}"
if [[ "$DIR" == "$HOME"/* ]]; then INCLUDE_DIR="~${DIR#"$HOME"}/"; else INCLUDE_DIR="$DIR/"; fi
DEVICE="${DEVICE:-$(hostname -s | tr '[:upper:]' '[:lower:]')}"
OWNER="${OWNER:-$(whoami)}"

KEY="$HOME/.ssh/id_ed25519_${PROJECT}"
PROJECT_CFG="$HOME/.gitconfig-${PROJECT}"
SIGNERS="$HOME/.ssh/allowed_signers"
GITIGNORE="$HOME/.gitignore_global"

step() { printf '\n\033[1m▸ %s\033[0m\n' "$1"; }

step "Project folder: $DIR"
mkdir -p "$DIR"

step "SSH key: $KEY"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
if [[ -f "$KEY" ]]; then
  echo "  exists, skipping"
else
  if [[ $NO_PASS -eq 1 ]]; then
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY" -N ""
  else
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY"
  fi
  if [[ "$(uname)" == "Darwin" && $NO_PASS -eq 0 ]]; then
    ssh-add --apple-use-keychain "$KEY" || true
  fi
fi

step "Project git config: $PROJECT_CFG"
touch "$PROJECT_CFG"
git config --file "$PROJECT_CFG" user.name "$NAME"
git config --file "$PROJECT_CFG" user.email "$EMAIL"
git config --file "$PROJECT_CFG" user.signingkey "$KEY.pub"
git config --file "$PROJECT_CFG" gpg.format ssh
git config --file "$PROJECT_CFG" commit.gpgsign true
git config --file "$PROJECT_CFG" tag.gpgsign true
git config --file "$PROJECT_CFG" core.sshCommand "ssh -i $KEY -o IdentitiesOnly=yes"
git config --file "$PROJECT_CFG" pull.rebase true

step "includeIf in ~/.gitconfig"
INCLUDE_KEY="includeIf.gitdir/i:${INCLUDE_DIR}.path"
if git config --global --get "$INCLUDE_KEY" >/dev/null 2>&1; then
  echo "  exists, skipping"
else
  git config --global "$INCLUDE_KEY" "$PROJECT_CFG"
  echo "  added: [includeIf \"gitdir/i:${INCLUDE_DIR}\"]"
fi
# Warn about other entries that load the same file (e.g. an old one without the trailing /).
{ git config --global --get-regexp '^includeif\..*\.path$' 2>/dev/null || true; } | while read -r k v; do
  [[ "$v" == "$PROJECT_CFG" || "$v" == "~/.gitconfig-${PROJECT}" ]] || continue
  [[ "$k" == "includeif.gitdir/i:${INCLUDE_DIR}.path" ]] && continue
  k="${k#includeif.}"; k="${k%.path}"
  echo "  warning: [includeIf \"$k\"] also loads $PROJECT_CFG. Remove it from ~/.gitconfig."
done

step "Allowed signers: $SIGNERS"
touch "$SIGNERS"
PUB="$(cat "$KEY.pub")"
grep -qF "$PUB" "$SIGNERS" || echo "$EMAIL $PUB" >> "$SIGNERS"
git config --global gpg.ssh.allowedSignersFile "$SIGNERS"

step "Global gitignore: $GITIGNORE"
touch "$GITIGNORE"
for p in .me CLAUDE.local.md .DS_Store; do
  grep -qxF "$p" "$GITIGNORE" || echo "$p" >> "$GITIGNORE"
done
git config --global core.excludesFile "$GITIGNORE"

TITLE="${OWNER}-${DEVICE}-${PROJECT}-$(date +%Y%m)"
step "Done. Register this public key on GitLab + GitHub"
echo "  Title: $TITLE"
echo "  Key:   $PUB"
command -v pbcopy >/dev/null && { printf '%s' "$PUB" | pbcopy; echo "  (copied to clipboard)"; }
cat <<EOF

Next:
  1. GitLab: Edit profile → SSH Keys → Usage: Authentication & Signing
     GitHub: Settings → SSH and GPG keys → add as Authentication AND Signing
  2. Test:  ssh -i $KEY -T git@<gitlab-host>
            ssh -i $KEY -T git@github.com
  3. Clone with SSH URLs into $DIR
  4. Verify in a repo there: git config --show-origin --get user.email
EOF
