# Stakpak Reference Kubernetes Platform

A subjective reference architecture for a production ready Kubernetes-based
application platform.

Within each layer items are ordered chronologically. We recommend you fullfill
items at the top of the list before making your way down, you may wish to skip
some items at the end of each list depending on your own requirements.

Next to each list item we recommend between parenthesis "`()`" our goto
technology to implement this item, but it is a matter of preference, there are
multiple tools that can fullfill each requirement (the blessing and the curse of
the cloud-native landscape).

## The Demo App

[GoogleCloudPlatform/microservices-demo](https://github.com/GoogleCloudPlatform/microservices-demo/tree/main)
![app](https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/docs/img/architecture-diagram.png)

## 00 Foundation

- VPC
- Subnets
- IAM
- DNS
- Cluster
- NAT

## 10 Platform

1. Gateway/Ingress
   ([`Ingress Nginx`](https://kubernetes.github.io/ingress-nginx))
2. Secret Management
   ([`External Secret Operator`](https://external-secrets.io/latest/))
3. Certificate Management ([`Cert Manager`](https://cert-manager.io/))
4. Continous Delivery ([`Argo CD`](https://argo-cd.readthedocs.io/en/stable/))
5. Cluster Autoscaling

## 20 Observability

1. Visualization ([`Grafana`](https://grafana.com/oss/grafana/))
2. Logging ([`Grafana Loki`](https://grafana.com/oss/loki/))
3. Metrics ([`Prometheus`](https://prometheus.io/))
4. Auto-instrumented Tracing ([`Pixie`](https://px.dev/))
5. Tracing ([`Grafana Tempo`](https://grafana.com/oss/tempo/) &
   [`Open Telemetry`](https://opentelemetry.io/))

## 30 Resilience

1. Volume Backups (native cloud backups or [`Longhorn`](https://longhorn.io/) or
   [`Velero`](https://velero.io/))
2. API/etcd Backups ([`Velero`](https://velero.io/))

## 40 FinOps

1. Event-driven Autoscaling ([`KEDA`](https://keda.sh/))
2. Optimized Cluster Autoscaling ([`AWS:Karpenter`](https://karpenter.sh/))
3. Cost Monitoring ([`OpenCost`](https://www.opencost.io/))

## 50 Security

1. Configuration Security ([`Kyverno`](https://kyverno.io/))
2. Image Security ([`Trivy`](https://trivy.dev/))
3. Cloud Security Posture
   ([`Prowler`](https://github.com/prowler-cloud/prowler))
4. CIS Benchmarks ([`Trivy`](https://trivy.dev/))
5. Service Mesh ([`Cilium`](https://cilium.io/))
6. Runtime Monitoring ([`Falco`](https://falco.org/))
7. MicroVM Isolation ([`Firecracker`](https://firecracker-microvm.github.io/))

## 60 Developer Self-Service

1. Workflows & Runbooks
   ([`Argo Workflows`](https://argoproj.github.io/argo-workflows/))
2. Service Catalog

## 70 IaaS Management

1. Cloud Resources ([`Crossplane`](https://www.crossplane.io/))
2. DNS ([`External DNS`](https://github.com/kubernetes-sigs/external-dns))
3. Cluster Fleet ([`Cluster API`](https://cluster-api.sigs.k8s.io/) or
   [`Gardener`](https://gardener.cloud/))

## 80 Container Optimized OS

1. AWS ([`Bottlerocket`](https://github.com/bottlerocket-os/bottlerocket))
2. Anywhere ([`Fedora CoreOS`](https://fedoraproject.org/coreos/))
