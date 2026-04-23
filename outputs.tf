# ─────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────

output "vpc_id" {
  description = "ID of the VPC (created by aws-networking)."
  value       = data.aws_vpc.networking.id
}

output "private_subnets" {
  description = "List of private subnet IDs."
  value       = data.aws_subnets.private.ids
}

output "public_subnets" {
  description = "List of public subnet IDs."
  value       = data.aws_subnets.public.ids
}

# ─────────────────────────────────────────────
# EKS Cluster
# ─────────────────────────────────────────────

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint URL of the EKS control plane."
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "Kubernetes version running on the cluster."
  value       = aws_eks_cluster.main.version
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the cluster."
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "cluster_iam_role_arn" {
  description = "ARN of the IAM role used by the EKS cluster."
  value       = aws_iam_role.eks_cluster.arn
}

# ─────────────────────────────────────────────
# OIDC / IRSA
# ─────────────────────────────────────────────

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider (used for IRSA)."
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC provider."
  value       = aws_iam_openid_connect_provider.eks.url
}

# ─────────────────────────────────────────────
# Node Group
# ─────────────────────────────────────────────

output "node_group_arn" {
  description = "ARN of the EKS managed node group."
  value       = aws_eks_node_group.main.arn
}

output "node_iam_role_arn" {
  description = "ARN of the IAM role used by the worker nodes."
  value       = aws_iam_role.eks_nodes.arn
}
