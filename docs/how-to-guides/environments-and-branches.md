# Environments and branches

All branches contain the same code. What differs between clusters lives in
`environments/<env>.yml` and is picked when bootstrapping:

| Environment | Cluster                         | Domain              | Follows                     |
|-------------|---------------------------------|---------------------|-----------------------------|
| `prod`      | the real nodes (`metal/`)       | `jonaskoperdraat.nl` | `master`                    |
| `dev`       | local k3d (`metal/k3d-dev.yaml`) | `127-0-0-1.nip.io`  | the branch you bootstrap from |

## How it works

- The bootstrap renders the ApplicationSets (`*/argocd/applicationsets/*.yaml.j2`)
  with the environment's settings: the Git revision to follow, apps to leave
  out, and the plugin parameters below.
- Every app is rendered by the `helm-env` Argo CD plugin
  (`system/argocd/values.yaml`). It works like Argo CD's built-in Helm
  support, and additionally:
    - replaces `jonaskoperdraat.nl` with the environment's domain in the chart
      sources before rendering
    - adds `values-<env>.yaml` when the app has one
    - sets `.Values.environment` and `.Values.domain`, used by environment
      specific templates such as `system/apps/cert-manager/templates/clusterissuer.yaml`
- The Terraform `external` layers only run for `prod`: their Terraform Cloud
  workspaces belong to production.

## Working on a change

```sh
git switch -c my-change
# edit, commit
git push -u origin my-change
make env=dev switch          # point the dev cluster at the current branch
# test on https://<app>.127-0-0-1.nip.io
git switch master && git merge my-change && git push
```

Create the dev cluster from scratch with `make env=dev`.

The dev cluster uses its own CA. Run `./scripts/trust-dev-ca` to trust it in the
macOS keychain (browsers then accept the dev sites), and again after rebuilding
the cluster. `./scripts/trust-dev-ca --remove` stops trusting it.

Keep environment differences out of commits: put them in
`environments/<env>.yml`, a `values-<env>.yaml` overlay, or a template guarded
with `{{ if eq (.Values.environment | default "prod") "dev" }}`.
