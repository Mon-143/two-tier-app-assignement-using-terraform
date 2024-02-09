#create an SNS topic

resource "aws_sns_topic" "updates" {
  name = "dev-sns-topic"
}

#create SNS topic subscription
resource "aws_sns_topic_subscription" "notification_topic" {
  topic_arn = aws_sns_topic.updates.arn
  protocol = "email"
  endpoint = var.operator_email
}