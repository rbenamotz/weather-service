resource "aws_sqs_queue" "deadletter_queue" {
  name                      = "${local.function_name}-deadletter-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sqs_queue" "weather_usage_queue" {
  name                      = "${local.function_name}-queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 300
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_queue.arn
    maxReceiveCount     = 4
  })
}

resource "aws_sqs_queue_policy" "policy" {
  queue_url = aws_sqs_queue.weather_usage_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.weather_usage_queue.arn}"
    }
  ]
}
POLICY
}