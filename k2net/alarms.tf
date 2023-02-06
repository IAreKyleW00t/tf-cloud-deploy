##
# CloudWatch Alarms
##
resource "aws_cloudwatch_metric_alarm" "billing_alarm" {
  alarm_name        = "billing-alarm"
  alarm_description = "Billing alarm >= ${var.billing_alarm_threshold} USD"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "14400" # 4 hours
  statistic           = "Maximum"

  threshold     = var.billing_alarm_threshold
  alarm_actions = [aws_sns_topic.billing_alarm_topic.arn]

  dimensions = {
    Currency = "USD"
  }

  tags = var.tags
}

##
# SNS
##
resource "aws_sns_topic" "billing_alarm_topic" {
  name = "billing-alarm-notification"

  tags = merge(var.tags, {
    PartOf = "Billing"
  })
}

resource "aws_sns_topic_subscription" "billing_alarm_email_target" {
  topic_arn = aws_sns_topic.billing_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.billing_alarm_email
}
