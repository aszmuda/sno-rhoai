# Testing

To see this in action, just apply this repo.

```shell
until oc apply -k https://github.com/aszmuda/sno-rhoai/bootstrap/overlays/default; do sleep 3; done
```