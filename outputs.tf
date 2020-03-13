# Lambda
output "lambda_service_role_arn" {
  value = "${aws_iam_role.lambda_service_role.arn}"
}

output "lambda_function_arn" {
  value = "${aws_lambda_function.lambda_function.arn}"
}