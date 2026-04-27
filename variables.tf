# ─────────────────────────────────────────────
# General
# ─────────────────────────────────────────────

variable "aws_region" {
  description = "AWS region where resources will be deployed."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project. Used as a prefix for resource names and tags."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

# ─────────────────────────────────────────────
# VPC / Networking
# ─────────────────────────────────────────────
# The VPC, subnets, NAT gateways, and route tables are created by the
# aws-networking repo. Deploy that repo first with the same project_name
# and environment values, then apply this repo.
# ─────────────────────────────────────────────

# ─────────────────────────────────────────────
# EKS Cluster
# ─────────────────────────────────────────────

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.29"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS API server public endpoint is enabled."
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDRs that can access the public EKS API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_cluster_encryption" {
  description = "Enable envelope encryption for Kubernetes secrets using AWS KMS."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "..."
  type        = string
  default     = ""
}

# ─────────────────────────────────────────────
# EKS Managed Node Group
# ─────────────────────────────────────────────

variable "node_group_name" {
  description = "Name of the EKS managed node group."
  type        = string
  default     = "main"
}

variable "node_instance_types" {
  description = "EC2 instance types for the node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_ami_type" {
  description = "AMI type for the node group (AL2_x86_64, AL2_ARM_64, BOTTLEROCKET_x86_64, etc.)."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_disk_size" {
  description = "Disk size (GiB) for each node."
  type        = number
  default     = 50
}

variable "node_desired_size" {
  description = "Desired number of nodes in the node group."
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of nodes in the node group."
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes in the node group."
  type        = number
  default     = 5
}

variable "node_capacity_type" {
  description = "Capacity type for the node group: ON_DEMAND or SPOT."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.node_capacity_type)
    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

# ─────────────────────────────────────────────
# Add-ons
# ─────────────────────────────────────────────

variable "enable_aws_load_balancer_controller" {
  description = "Install the AWS Load Balancer Controller add-on."
  type        = bool
  default     = false
}

variable "enable_cluster_autoscaler" {
  description = "Install the Cluster Autoscaler add-on."
  type        = bool
  default     = false
}

# ─────────────────────────────────────────────
# Tags
# ─────────────────────────────────────────────

variable "additional_tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
