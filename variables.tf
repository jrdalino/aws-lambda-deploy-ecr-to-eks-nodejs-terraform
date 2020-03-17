# General
variable "aws_region" {
  type        = "string"
  description = "Used AWS Region."    
}

variable "aws_account" {
  type        = "string"
  description = "Used AWS Account."    
}

# Lambda
variable "lambda_service_role_name" {
  type        = "string"
  description = "Lambda Service Role name."
}

variable "lambda_service_role_policy_name" {
  type        = "string"
  description = "Lambda Service Role Policy name."
}

variable "lambda_function_name" {
  type        = "string"
  description = "Lambda Function name."    
}

# EKS
variable "eks_ca" {
  type = "string"
}

variable "eks_cluster_host" {
  type = "string"
}

variable "eks_cluster_name" {
  type = "string"
}

variable "eks_cluster_user_name" {
  type = "string"
}

variable "eks_token" {
  type = "string"
}