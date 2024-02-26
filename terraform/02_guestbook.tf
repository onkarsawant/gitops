# Create an Argo CD guestbook application

resource "kubernetes_secret" "guestbook-git-ssh-key" {
  metadata {
    name      = "guestbook-git-ssh-key"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }

  }
  type = "Opaque"
  data = {
    "sshPrivateKey" = filebase64("/home/ubuntu/.ssh/id_rsa")
    "type"          = "git"
    "url"           = "git@github.com:argoproj/argocd-example-apps.git"
  }
}

# Create an Argo CD guestbook application
resource "kubernetes_manifest" "guestbook" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = "guestbook"
      "namespace" = "argocd"
    }
    "spec" = {
      "destination" = {
        "namespace" = "development"
        "server"    = "https://kubernetes.default.svc"
      }
      "project" = "default"
      "source" = {
        "repoURL"        = "git@github.com:argoproj/argocd-example-apps.git"
        "path"           = "guestbook"
        "targetRevision" = "HEAD"
      }
      "syncPolicy" = {
        "automated" = {
          "prune"     = "false"
          "selfHeal"  = "true"
        }
        "syncOptions" = [
            "createNamespace=true",
            "replace=false",
            "prune=false"
        ]
      }
    }
  }
}