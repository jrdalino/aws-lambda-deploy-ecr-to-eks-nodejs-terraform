# General
aws_region  = "ap-southeast-1"
aws_account = "707538076348"

# Lambda
lambda_service_role_name        = "deploy-ecr-to-eks-nodejs-lambda-service-role"
lambda_service_role_policy_name = "deploy-ecr-to-eks-nodejs-lambda-service-role-policy"
lambda_function_name            = "deploy-ecr-to-eks-nodejs"

# EKS
# $ aws eks describe-cluster --name myproject-eks --query cluster.certificateAuthority.data --output text
eks_ca = "$EKS_CA"

# $ aws eks describe-cluster --name myproject-eks --query cluster.endpoint --output text
eks_cluster_host = "$EKS_CLUSTER_HOST"
eks_cluster_name = "myproject-eks"
eks_cluster_user_name = "lambda"

# $ kubectl get secrets
# $ kubectl get secret $SECRET_NAME -o json | jq -r '.data["token"]' | base64 -D
eks_token = "$TOKEN"
