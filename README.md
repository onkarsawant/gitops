# GitOps Repository

This repository contains configurations and tooling for managing applications with GitOps practices. It utilizes ArgoCD for continuous deployment and Terraform for infrastructure management.

## ArgoCD Applications

The `app` directory contains ArgoCD Application YAML files. These YAML files define the applications to be managed by ArgoCD. They describe the source, destination, sync policy, and other settings for each application.

To apply these application configurations using `kubectl`, navigate to the `app` directory and run:

```bash
kubectl apply -f .
```

## Deploying using Terraform

The terraform directory contains Terraform configurations for managing ArgoCD and its applications. These configurations automate the installation of ArgoCD and manage applications using Helm charts.

This will help you deploy :
- ArgoCD application in namespace argocd
- Sample guestbook application
- Chaos-mesh Helm chart 
- Simple Python logging application

To deploy ArgoCD and manage applications using Terraform, navigate to the terraform directory and execute the following commands:

```bash
terraform init
terraform apply
```
