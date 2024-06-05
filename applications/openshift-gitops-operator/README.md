# Red Hat OpenShift GitOps

Install Red Hat OpenShift GitOps.

Do not use the `base` directory directly, as you will need to patch the `channel` based on the version of OpenShift you are using, or the version of the operator you want to use.

The current *overlays* available are for the following channels:

* [latest](operator/overlays/latest)

## Usage

If you have cloned the `sno-rhoai` repository, you can install Red Hat OpenShift GitOps based on the overlay of your choice by running from the root (`sno-rhoai`) directory.

```
oc apply -k applications/openshift-gitops-operator/operator/overlays/latest
```

