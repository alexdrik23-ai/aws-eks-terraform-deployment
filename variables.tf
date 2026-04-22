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

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of AWS availability zones to deploy subnets into."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "enable_nat_gateway" {
  description = "Whether to provision NAT Gateways for private subnets."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway (cost-saving; not recommended for prod)."
  type        = bool
  default     = false
}

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
  description = "ARN of the KMS key to use for EKS secret encryption. Required if enable_cluster_encryption is true."
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
  default     = "AL2_x86_64"
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
