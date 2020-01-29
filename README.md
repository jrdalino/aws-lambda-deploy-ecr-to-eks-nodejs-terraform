# AWS Lambda Function for EKS Deployment

## Usage:

- Setup Lambda for deployment:
```
$ sed -i -e "s#\$EKS_CA#$(aws eks describe-cluster --name tf-eks --query cluster.certificateAuthority.data --output text)#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_HOST#$(aws eks describe-cluster --name tf-eks --query cluster.endpoint --output text)#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_NAME#tf-eks#g" ./config
$ sed -i -e "s#\$EKS_CLUSTER_USER_NAME#lambda#g" ./config
```

- Run the following command to check the scerets:
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

## References:
- https://medium.com/@BranLiang/step-by-step-to-setup-continues-deployment-kubernetes-on-aws-with-eks-code-pipeline-and-lambda-61136c84bbcd
- https://docs.aws.amazon.com/code-samples/latest/catalog/lambda_functions-codepipeline-MyCodePipelineFunction.js.html
- https://github.com/karthiksambandam/aws-eks-cicd-essentials/blob/master/Lab1.md#setup-lambda-for-deployment
