# Terraform module to provision an AWS Lambda Function for EKS Deployment

## This creates the following resources:
- Cloudwatch Log Group
- Service Role Policy for Lambda
- Service Role for Lambda
- Lambda Function for Deployment

## CI/CD Pipline Usage
1. AWS CodePipeline invokes an AWS Lambda function that includes the Kubernetes Python client as part of the function’s resources. The Lambda function performs a string replacement on the tag used for the Docker image in the Kubernetes deployment file to match the Docker image tag applied in the build, one that matches the image in Amazon ECR.
2. After the deployment manifest update is completed, AWS Lambda invokes the Kubernetes API to update the image in the Kubernetes application deployment.
3. Kubernetes performs a rolling update of the pods in the application deployment to match the docker image specified in Amazon ECR. The pipeline is now live and responds to changes to the master branch of the CodeCommit repository.

## Prerequisites
- Provision an S3 bucket to store Terraform State and DynamoDB for state-lock
using https://github.com/jrdalino/aws-tfstate-backend-terraform
- aws cli
- kubectl
- sed
- jq
- npm

## Usage
- Install ~/src/node_modules libraries
```
$ cd ~/environment/aws-lambda-deploy-ecr-to-eks-nodejs-terraform/src
$ npm install
```
- Replace variables in ~/src/config file
```
$ cd ~/environment/aws-lambda-deploy-ecr-to-eks-nodejs-terraform/src
$ sed -i -e "s#\$EKS_CA#$(aws eks describe-cluster --name myproject-eks --query cluster.certificateAuthority.data --output text)#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_HOST#$(aws eks describe-cluster --name myproject-eks --query cluster.endpoint --output text)#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_NAME#myproject-eks#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_USER_NAME#lambda#g" ./config
$ kubectl get secrets
$ sed -i -e "s#\$TOKEN#$(kubectl get secret $SECRET_NAME -o json | jq -r '.data["token"]' | base64 -D)#g" ./config
```
- Replace variables in terraform.tfvars
```
$ cd ~/environment/aws-lambda-deploy-ecr-to-eks-nodejs-terraform
$ sed -i -e "s#\$EKS_CA#$(aws eks describe-cluster --name myproject-eks --query cluster.certificateAuthority.data --output text)#g" ./terraform.tfvars
$ sed -i -e "s#\$EKS_CLUSTER_HOST#$(aws eks describe-cluster --name myproject-eks --query cluster.endpoint --output text)#g" ./terraform.tfvars
$ kubectl get secrets
$ sed -i -e "s#\$TOKEN#$(kubectl get secret $SECRET_NAME -o json | jq -r '.data["token"]' | base64 -D)#g" ./terraform.tfvars
```
- Replace variables in state_config.tf
- Provide admin access for default service account
```
$ kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
```
- Initialize, Review Plan and Apply. Note:. Running "terraform plan" compresses the /src folder into src.zip and will be uploaded to AWS Lambda when running "terraform apply"
```
$ cd ~/environment/aws-lambda-deploy-ecr-to-eks-nodejs-terraform
$ terraform init
$ terraform plan
$ terraform apply
```
- Note: Using *.backup remove secrets from terraform.tfvars and config before pushing to git

## (Optional) Cleanup
```
$ terraform destroy
```

## Inputs
| Name | Description |
|------|-------------|

## Outputs
| Name | Description |
|------|-------------|

## (In Progress) Module Usage

## References
- https://medium.com/@BranLiang/step-by-step-to-setup-continues-deployment-kubernetes-on-aws-with-eks-code-pipeline-and-lambda-61136c84bbcd
- https://docs.aws.amazon.com/code-samples/latest/catalog/lambda_functions-codepipeline-MyCodePipelineFunction.js.html
- https://github.com/karthiksambandam/aws-eks-cicd-essentials/blob/master/Lab1.md#setup-lambda-for-deployment