# Testing

To see this in action, just apply this repo.

```shell
until oc apply -k https://github.com/aszmuda/sno-rhoai/bootstrap/overlays/default; do sleep 3; done
```

### Adding a self-signed custom CA bundle that is separate from the cluster-wide bundle
1. Edit the `/core/rhoai/cluster/overlays/certs/custom-ca-bundle-patch` file and add your CA certs.
   > Replace `customCABundle` value with valid PEM certificate(s).


### Notes:
1. If RHOAI reports errors related to Service Mesh Control Plane readiness, delete the ServiceMeshControlPlane resource and wait a few minutes until RHOAI recreates it.
2. In order to remove `self-provisioning` of projects for users who are not cluster-admins, execute the following commands as `cluster-admin`:
    ```bash
    oc patch clusterrolebinding.rbac self-provisioners -p '{"subjects": null}'
    oc patch clusterrolebinding.rbac self-provisioners -p '{ "metadata": { "annotations": { "rbac.authorization.kubernetes.io/autoupdate": "false" } } }'
    ```
