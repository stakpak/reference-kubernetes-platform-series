data "kubernetes_service_v1" "ingress_service" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}
variable "domain" {
  description = "AWS Route53 hosted zone domain name"
  type        = string
  default = "stakpak.dev"
}
variable "email" {
  description = "Letsencrypt email"
  type        = string
}

data "aws_route53_zone" "default" {
  name = var.domain
}

resource "aws_route53_record" "ingress_record" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = "app.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [
    data.kubernetes_service_v1.ingress_service.status.0.load_balancer.0.ingress.0.hostname
  ]
}


resource "kubernetes_manifest" "cert_issuer" {
  manifest = yamldecode(<<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.email}
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
  YAML
  )

  depends_on = [
    aws_route53_record.ingress_record
  ]
}


data "aws_caller_identity" "current" {}
resource "kubernetes_service_account_v1" "secret_store" {
  metadata {
    namespace = "external-secrets"
    name      = "secret-store"
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/secret-store"
    }
  }
}

resource "kubernetes_manifest" "cluster_secret_store" {
  manifest = yamldecode(<<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-store
spec:
  provider:
    aws:
      service: ParameterStore
      region: eu-north-1
      auth:
        jwt:
          serviceAccountRef:
            namespace: external-secrets
            name: secret-store
  YAML
  )

  depends_on = [
    kubernetes_service_account_v1.secret_store
  ]
}

