# Testing

To see this in action, just apply this repo.

```shell
until oc apply -k https://github.com/aszmuda/sno-rhoai/bootstrap/overlays/default; do sleep 3; done
```

### Adding a self-signed custom CA bundle that is separate from the cluster-wide bundle
1. Create a patch file called `odh-custom-ca-bundle-patch.yaml` with the following content:
```yaml
spec:
  trustedCABundle:
    managementState: Managed
    customCABundle: |
      -----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----
```
> Please replace the content between the `BEGIN CERTIFICATE` and `END CERTIFICATE` with valid certificate
>
2. Run the following command
```bash
oc patch DSCInitialization default-dsci --type merge --patch-file {{ path to file }}/odh-custom-ca-bundle-patch.yaml
```
> Don't forget to replace `{{ path to file }}` in the above command with a valid file path to your patch file.

### Notes:
1. If RHOAI reports errors related to Service Mesh Control Plane readiness, delete the ServiceMeshControlPlane resource and wait a few minutes until RHOAI recreates it.
2. In order to remove `self-provisioning` of projects for users who are not cluster-admins, execute the following command as `cluster-admin`:
    ```bash
    oc patch clusterrolebinding.rbac self-provisioners -p '{"subjects": null}'
    ```