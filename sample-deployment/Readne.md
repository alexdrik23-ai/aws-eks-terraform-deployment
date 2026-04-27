# Sample App — EKS Deployment Guide

## Folder Structure

```
sample-app/
├── app.js                          # Node.js app
├── Dockerfile                      # Container image
├── README.md
└── sample-deployment/
    ├── 00-namespace.yaml           # Namespace: sample-app
    ├── 01-deployment.yaml          # 2 replicas
    ├── 02-service.yaml             # ClusterIP on port 80
    └── 03-ingress.yaml             # AWS ALB (internet-facing)
```

---

## Prerequisites

- EKS cluster running with node group
- `kubectl` configured (`aws eks update-kubeconfig`)
- AWS Load Balancer Controller installed on the cluster
- An ECR repo to push the image to

---

## Step 1 — Connect kubectl to your cluster

```bash
aws eks update-kubeconfig --region <YOUR_REGION> --name my-eks-cluster
kubectl get nodes   # should list your nodes
```

---

## Step 2 — Create an ECR repo and push the image

```bash
# Create the repo
aws ecr create-repository --repository-name sample-app --region <YOUR_REGION>

# Authenticate Docker to ECR
aws ecr get-login-password --region <YOUR_REGION> \
  | docker login --username AWS \
    --password-stdin <ACCOUNT_ID>.dkr.ecr.<YOUR_REGION>.amazonaws.com

# Build, tag, and push
docker build -t sample-app .
docker tag sample-app:latest <ACCOUNT_ID>.dkr.ecr.<YOUR_REGION>.amazonaws.com/sample-app:latest
docker push <ACCOUNT_ID>.dkr.ecr.<YOUR_REGION>.amazonaws.com/sample-app:latest
```

---

## Step 3 — Update the image in the deployment

Edit `sample-deployment/01-deployment.yaml` and replace:

```
image: YOUR_ECR_REPO_URI:latest
```

With your actual ECR URI:

```
image: 123456789.dkr.ecr.us-east-1.amazonaws.com/sample-app:latest
```

---

## Step 4 — Deploy everything

```bash
kubectl apply -f sample-deployment/
```

Check rollout:

```bash
kubectl rollout status deployment/sample-app -n sample-app
kubectl get pods -n sample-app
```

---

## Step 5 — Get the ALB DNS and test in browser

```bash
kubectl get ingress -n sample-app
```

Look for the ADDRESS column — it will look like:

```
k8s-sampleap-sampleap-xxxxxxxxxx.us-east-1.elb.amazonaws.com
```

Wait ~2 minutes for the ALB to provision, then open that URL in your browser.

---

## Troubleshooting

**ALB not provisioning:**
Make sure the AWS Load Balancer Controller is installed and your subnets have the correct EKS tags (`kubernetes.io/role/elb = 1`). These were already applied by the networking Terraform repo.

**ImagePullBackOff:**
Your node group IAM role needs `AmazonEC2ContainerRegistryReadOnly` policy attached, or you need to add an ECR pull-through cache / image pull secret.

**Pods not ready:**

```bash
kubectl describe pod -n sample-app
kubectl logs -n sample-app -l app=sample-app
```
