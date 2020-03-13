# Terraform module to provision an AWS Lambda Function

## This creates the following resources:
- Cloudwatch Log Group
- Service Role Policy for Lambda
- Service Role for Lambda
- Lambda Function for Deployment

### CI/CD Pipline Usage
1. Developers commit code to an AWS CodeCommit repository and create pull requests to review proposed changes to the production code. When the pull request is merged into the master branch in the AWS CodeCommit repository, AWS CodePipeline automatically detects the changes to the branch and starts processing the code changes through the pipeline.
2. AWS CodeBuild packages the code changes as well as any dependencies and builds a Docker image. Optionally, another pipeline stage tests the code and the package, also using AWS CodeBuild.
3. The Docker image is pushed to Amazon ECR after a successful build and/or test stage.
4. AWS CodePipeline invokes an AWS Lambda function that includes the Kubernetes Python client as part of the function’s resources. The Lambda function performs a string replacement on the tag used for the Docker image in the Kubernetes deployment file to match the Docker image tag applied in the build, one that matches the image in Amazon ECR.
5. After the deployment manifest update is completed, AWS Lambda invokes the Kubernetes API to update the image in the Kubernetes application deployment.
6. Kubernetes performs a rolling update of the pods in the application deployment to match the docker image specified in Amazon ECR. The pipeline is now live and responds to changes to the master branch of the CodeCommit repository.

## Prerequisites
- Provision an S3 bucket to store Terraform State and DynamoDB for state-lock
using https://github.com/jrdalino/aws-tfstate-backend-terraform
- Configure Lambda to EKS connection details by following instructions in ~/environment/myproject-aws-codepipeline-customer-service-terraform/src/README.md
- aws cli vs AWS Access/Secret Keys
- kubectl
- sed
- jq
- npm

## Usage
- Replace variables in terraform.tfvars
- Replace variables in state_config.tf
- Install node_modules libraries
```
$ cd ~/environment/aws-lambda-deploy-ecr-to-eks-nodejs/src
$ npm install
```
- Copy contents of config_backup to cofig
```
$ cd ~/environment/aws-lambda-deploy-ecr-to-eks-nodejs/src
```
- Setup the Lambda function for Deployment by replacing the values in the config file
```
$ sed -i -e "s#\$EKS_CA#$(aws eks describe-cluster --name myproject-eks --query cluster.certificateAuthority.data --output text)#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_HOST#$(aws eks describe-cluster --name myproject-eks --query cluster.endpoint --output text)#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_NAME#myproject-eks#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_USER_NAME#lambda#g" ./config
```
- Run the following command to check the secrets:
```
$ kubectl get secrets
```
- Run the following command replacing secret name to update your token
```
$ sed -i -e "s#\$TOKEN#$(kubectl get secret $SECRET_NAME -o json | jq -r '.data["token"]' | base64 -D)#g" ./config
```
- Provide admin access for default service account
```
$ kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount=default:default
```
- Running "terraform plan" compresses the /src folder into src.zip and will be uploaded to AWS Lambda when running "terraform apply"
- Initialize, Review Plan and Apply
```
$ terraform init
$ terraform plan
$ terraform apply
```
- Clone empty repository. Make sure CodeCommit Git credentials have bene configured. Note: New repositories are **not** created with their default branch. Once the module has ran you must clone the repository, add files, commit changes locally and then push to initialize the repository.
```
$ cd ~/environment
$ git clone https://git-codecommit.ap-southeast-2.amazonaws.com/v1/repos/myproject-customer-service
```
- Copy code from Github repo to CodeCommit repo
```
$ rsync -rv --exclude=.git ~/environment/myproject-customer-service-python/ ~/environment/myproject-customer-service/
```
- Push Code to CodeCommit to invoke CodePipeline
```
$ cd ~/environment/myproject-customer-service
$ git add .
$ git commit -m "Initial Commit"
$ git push origin master
```

### (Optional) Cleanup
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