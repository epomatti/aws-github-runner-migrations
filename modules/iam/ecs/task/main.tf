resource "aws_iam_role" "ecs_task" {
  name = "ecsTaskRole-Prisma"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Condition = {
          ArnLike = {
            "aws:SourceArn" : "arn:aws:ecs:${var.aws_region}:${var.aws_account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" : "${var.aws_account_id}"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "cw_logs" {
  name = "SonicaECSFargateTaskCloudWatchPolicy-Prisma"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
        ]
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cw_logs" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = aws_iam_policy.cw_logs.arn
}
