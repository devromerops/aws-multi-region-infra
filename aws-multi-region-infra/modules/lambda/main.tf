resource "aws_lambda_function" "backend" {
  function_name = "${var.environment}-backend-function"
  handler       = "lambda_function.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "lambda_function.zip"

  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      RDS_HOST     = var.db_endpoint
      RDS_USER     = var.db_username
      RDS_PASSWORD = var.db_password
    }
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.security_group_id]
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.environment}-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
