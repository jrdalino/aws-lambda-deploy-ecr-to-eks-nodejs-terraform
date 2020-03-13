# Lambda Role
resource "aws_iam_role" "lambda_service_role" {
  name = "${var.lambda_service_role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_service_role_policy" {
  name = "${var.lambda_service_role_policy_name}"
  description = "Provides write permissions to CloudWatch Logs."
  path = "/"  

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",      
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",      
      "Action": [
        "ecr:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",      
      "Action": [
        "codepipeline:PutJobSuccessResult",
        "codepipeline:PutJobFailureResult"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.lambda_service_role.name}"
  policy_arn = "${aws_iam_policy.lambda_service_role_policy.arn}"
}

# Archive
data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "src"
  output_path = "src.zip"
}

# Lambda Function
resource "aws_lambda_function" "lambda_function" {
  function_name    = "${var.lambda_function_name}"

  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}" 

  role             = "${aws_iam_role.lambda_service_role.arn}"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  timeout          = "10"

  environment {
    variables = {
      EKS_CA                = "${var.eks_ca}"
      EKS_CLUSTER_HOST      = "${var.eks_cluster_host}"
      EKS_CLUSTER_NAME      = "${var.eks_cluster_name}"
      EKS_CLUSTER_USER_NAME = "${var.eks_cluster_user_name}"
      EKS_TOKEN             = "${var.eks_token}"
    }
  }  
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "lambda_eks_deployment_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}