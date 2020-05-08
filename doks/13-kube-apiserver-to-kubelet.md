# RBAC for Kubelet Authorization
In this section you will configure RBAC permissions to allow the Kubernetes API Server to access the Kubelet API on each worker node.  
Access to the Kubelet API is required for retrieving metrics, logs, and executing commands in pods.

Create the system:kube-apiserver-to-kubelet ClusterRole with permissions to access the Kubelet API.

    cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
    apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: ClusterRole
    metadata:
      annotations:
        rbac.authorization.kubernetes.io/autoupdate: "true"
      labels:
        kubernetes.io/bootstrapping: rbac-defaults
      name: system:kube-apiserver-to-kubelet
    rules:
      - apiGroups:
          - ""
        resources:
          - nodes/proxy
          - nodes/stats
          - nodes/log
          - nodes/spec
          - nodes/metrics
        verbs:
          - "*"
    EOF
    
Bind the system:kube-apiserver-to-kubelet ClusterRole to the kubernetes user:

    cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
    apiVersion: rbac.authorization.k8s.io/v1beta1
    kind: ClusterRoleBinding
    metadata:
      name: system:kube-apiserver
      namespace: ""
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: system:kube-apiserver-to-kubelet
    subjects:
      - apiGroup: rbac.authorization.k8s.io
        kind: User
        name: kube-apiserver
    EOF
    
Next: [DNS Addon](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/14-dns-addon.md)
