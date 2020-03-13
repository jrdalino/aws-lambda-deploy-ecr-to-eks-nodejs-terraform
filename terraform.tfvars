# General
aws_region  = "ap-southeast-2"
aws_profile = "leon.tanner@excelian.com"
aws_account = "222337787619"

# Lambda
lambda_service_role_name        = "myproject-customer-service-lambda-service-role"
lambda_service_role_policy_name = "myproject-customer-service-lambda-service-role-policy"
lambda_function_name            = "myproject-customer-service-lambda"

# EKS
# $ aws eks describe-cluster --name myproject-eks --query cluster.certificateAuthority.data --output text
eks_ca = "<REPLACE_ME>"

# $ aws eks describe-cluster --name myproject-eks --query cluster.endpoint --output text
eks_cluster_host = "<REPLACE_ME>"
eks_cluster_name = "myproject-eks"
eks_cluster_user_name = "lambda"

# $ kubectl get secrets
# $ kubectl get secret $SECRET_NAME -o json | jq -r '.data["token"]' | base64 -D
eks_token = "<REPLACE_ME>"