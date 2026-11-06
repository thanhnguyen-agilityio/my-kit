# Tailscale setup (company Tailnet)

Connect a workstation to the company Tailnet so you can reach the company GitLab (`gitlab.asoft-python.com`). Do this before [`gitlab-setup.md`](gitlab-setup.md).

Source: company guide ([Artifact](https://claude.ai/artifact/6JMKetaoHsoFzvEQTBc4Mr)). Control server: `https://headscale.agilityio.dev`.

## Before you start

- An active `@asnet.com.vn` Google Workspace account. Personal accounts (`@gmail.com`) are blocked.
- Admin rights on the computer.

## Install and connect

### macOS

1. Install with Homebrew (recommended: the App Store build has connection drops):

   ```sh
   brew install --cask tailscale
   ```

   Other options: `tailscale.com/download/mac` or the Mac App Store. The standalone build may ask you to allow a system extension in System Settings > Privacy & Security.
2. Connect:

   ```sh
   tailscale login --login-server=https://headscale.agilityio.dev
   ```

   Or from the menu bar: Settings > Accounts > down arrow > enter the server URL > Add account (only shown if another tailnet is already added).
3. Sign in with your `@asnet.com.vn` Google account in the browser. The icon shows **Connected**.

### Windows

1. Download and run the installer from `tailscale.com/download/windows`.
2. In PowerShell or Terminal:

   ```powershell
   tailscale login --login-server=https://headscale.agilityio.dev
   ```

   If the browser does not open, copy the link from the terminal.
3. Sign in with your `@asnet.com.vn` account.

### Linux (Ubuntu, Debian, Fedora)

```sh
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale login --login-server=https://headscale.agilityio.dev
```

Open the registration link printed in the terminal and approve with your company account.

## Check

| Check | Command or action | Expected |
| --- | --- | --- |
| IP | `tailscale ip -4` | Address in `100.64.0.0/10` |
| MagicDNS | `nslookup gitlab.asoft-python.com` | `100.64.0.1` |
| GitLab web | Open `https://gitlab.asoft-python.com` | Sign-in page loads |
| Git over SSH | `ssh -T git@gitlab.asoft-python.com` | GitLab welcome message |

## macOS: browser still cannot reach GitLab

First turn on **Use Tailscale DNS settings** (Tailscale Settings > General). If the browser still cannot resolve the host, pin it in `/etc/hosts`:

```sh
echo "100.64.0.1 gitlab.asoft-python.com" | sudo tee -a /etc/hosts
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
dscacheutil -q host -a name gitlab.asoft-python.com   # expect ip_address: 100.64.0.1
```

If Chrome, Edge or Firefox still fail, their secure DNS skips the hosts file. Turn off "Use secure DNS" (Chrome/Edge: Settings > Privacy and security > Security) or set DNS over HTTPS to Off (Firefox).

The IP is fixed in this line. If DevOps changes it, update or delete the line.

## Troubleshooting

| Problem | Fix |
| --- | --- |
| "Unauthorized Domain" or auth denied | Sign in with the `@asnet.com.vn` account. |
| Cannot reach GitLab | Tailscale is ON and **Use Tailscale DNS settings** is on. |
| Wrong control server | `tailscale logout`, then run the login command again. |
| Frequent macOS disconnects | Switch to the Homebrew build, or ask IT if you must keep the App Store build. |

## Access policy

Employee accounts reach GitLab only on HTTPS (443) and SSH (22). Direct device-to-device connections between colleagues are blocked.

## Support

DevOps team: asoft@asnet.com.vn or internal tech channels. Include your OS, the output of `tailscale ip -4`, and a screenshot of the error.
