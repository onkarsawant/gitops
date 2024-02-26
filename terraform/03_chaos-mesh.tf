# Create an Argo CD chaos-mesh application

resource "kubernetes_manifest" "chaos-mesh" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "chaos-mesh"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "namespace" = "chaoseng"
        "server"    = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "chart" = "chaos-mesh"
        "helm" = {
          # Specify the values file or parameters for the helm chart
          "values" = "dashboard:\n  create: true\ncontrollerManager:\n  serviceAccount: argocd-application-controller\n"
        }
        "repoURL"        = "https://charts.chaos-mesh.org"
        "targetRevision" = "2.6.3"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"    = "false"
          "selfHeal" = "true"
        }
        "syncOptions" = [
          "CreateNamespace=true",
          "Replace=false",
          "Prune=false"
        ]
      }
    }
  }
}


resource "kubernetes_service_account" "chaos-account-cluster-manager" {
  metadata {
    namespace = "default"
    name = "chaos-account-cluster-manager"
  }
}

resource "kubernetes_cluster_role" "chaos-role-cluster-manager" {
    metadata {
      name = "chaos-role-cluster-manager"
    }
    rule {
        api_groups = [""]
        resources = ["pods","namespaces"]
        verbs = ["get","watch","list"]
    }
    rule {
        api_groups =  ["chaos-mesh.org"]
        resources =  [ "*" ]
        verbs = ["get", "list", "watch", "create", "delete", "patch", "update"]
    }
}

resource "kubernetes_cluster_role_binding_v1" "chaos-bind-cluster-manager" {
  metadata {
    name = "chaos-bind-cluster-manager"
  }
  subject {
    kind = "ServiceAccount"
    name = "chaos-account-cluster-manager"
    namespace = "default"
  }
  role_ref {
    kind = "ClusterRole"
    name = "chaos-role-cluster-manager"
    api_group = "rbac.authorization.k8s.io"
  }
}