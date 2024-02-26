# Create an Argo CD pylogger application

resource "kubernetes_secret" "pylogger-git-ssh-key" {
  metadata {
    name      = "pylogger-git-ssh-key"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }
  type = "Opaque"
  data = {
    "sshPrivateKey" = filebase64("/home/ubuntu/.ssh/id_rsa")
    "type"          = "git"
    "url"           = "git@github.com:onkarsawant/pylogger.git"
  }
}

# Create an Argo CD pylogger application
resource "kubernetes_manifest" "pylogger" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "pylogger"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "namespace" = "development"
        "server"    = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "repoURL"        = "git@github.com:onkarsawant/pylogger.git"
        "path"           = "kubernetes"
        "targetRevision" = "main"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"     = "false"
          "selfHeal"  = "true"
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