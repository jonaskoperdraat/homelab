# VPN

Devices in the VPN reach the homelab from anywhere, on the same addresses as at
home (`https://<app>.jonaskoperdraat.nl`).

- **Headscale** on the VPS (`make -C metal vps`) coordinates the VPN, and
  relays traffic (DERP) when two devices can't connect directly.
- The **subnet router** in the cluster (`system/apps/tailscale`) makes the
  ingress addresses (`192.168.88.224/27`) reachable. `make system` registers it.
- Devices run the official **Tailscale** app with Headscale as their
  coordination server. Each person is a Headscale user (`headscale_users` in
  `metal/group_vars/vps.yml`).

Run the scripts below from the repository, inside `nix develop`.

## Add a device

### Android, Windows, Linux: with a key

```sh
./scripts/vpn-add-device jonas        # or fenna
```

This prints a single-use key, valid for one hour, also as a QR code: scan it
with the phone's camera and copy the text, so you don't have to type it.

- **Android:** in the Tailscale app, open the settings menu, *Accounts*, then in
  the menu at the top right *Use an alternate server* and enter
  `https://headscale.jonaskoperdraat.nl`. Close the login page if it opens.
  Then again *Accounts*, *Use an auth key*, and paste the key.
- **Windows:** install the [Tailscale client](https://tailscale.com/download/windows),
  then in Command Prompt or PowerShell:
  `tailscale up --login-server https://headscale.jonaskoperdraat.nl --accept-routes --auth-key <key>`.
  Tailscale only runs while you are logged in to Windows; to keep it running,
  enable *Run unattended* under *Preferences* in the tray icon.
- **Linux, command line:**
  `tailscale up --login-server https://headscale.jonaskoperdraat.nl --accept-routes --auth-key <key>`

### iOS, macOS app: through the browser

- **iOS:** in the Tailscale app, tap the account icon, *Log in…*, then in the
  options menu at the top right *Use custom coordination server*, and enter
  `https://headscale.jonaskoperdraat.nl`.
- **macOS:** Option-click the Tailscale icon in the menu bar, *Debug*,
  *Custom Login Server*, *Add Account…*, and enter
  `https://headscale.jonaskoperdraat.nl`.

The browser shows a page with an auth ID (also at the end of its URL,
`…/register/<auth-id>`). Approve it with:

```sh
./scripts/vpn-approve-device jonas <auth-id>
```

The Apple and Android apps use the homelab routes automatically. On Windows and
Linux, `--accept-routes` (above) is needed; on Windows it is also the *Use
Tailscale subnets* option in the tray icon.

## Remove a device, e.g. a lost phone

```sh
./scripts/vpn-remove-device            # list devices
./scripts/vpn-remove-device <name>
```

The device loses access immediately; other devices are not affected. Also end
its sessions in Kanidm, since the apps behind the VPN still have their own
logins.

## Troubleshooting

- `./scripts/headscale nodes list` shows devices, whether they are online, and
  when they were last seen.
- `./scripts/headscale nodes list-routes` should show `192.168.88.224/27` for
  `homelab` under *Approved*, *Available* and *Serving*.
- Re-registering the router: `KUBECONFIG=metal/kubeconfig.yaml ./scripts/vpn-register-router`
  (also run by `make system`).
- Windows device that won't register: quit Tailscale, delete
  `C:\Users\<USERNAME>\AppData\Local\Tailscale`, remove the device
  (`vpn-remove-device`), and add it again.
- Take a snapshot of the VPS in the TransIP control panel before upgrading
  Debian or Headscale. Losing the VPS (`/var/lib/headscale`) means every device
  has to be added again.
