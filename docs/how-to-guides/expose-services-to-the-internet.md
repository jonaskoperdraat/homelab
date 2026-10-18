# Expose services to the internet

!!! warning

    This fork no longer uses Cloudflare (DNS is hosted at TransIP), so the
    Cloudflare Tunnel setup below does not apply. Public exposure will move to a
    VPS with Headscale/WireGuard; this page will be rewritten when that is in place.

Apply the `./external` layer to create a tunnel if you haven't already,
then add the following annotations to your `Ingress` object (replace `example.com` with your domain):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    external-dns.alpha.kubernetes.io/target: "homelab-tunnel.example.com"
    external-dns.alpha.kubernetes.io/cloudflare-proxied: "true"
# ...
```
