variable "aws_access_key" {}

variable "aws_secret_key" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_launch_configuration" "messos_launch_config" {
  name          = "mesos_config"
  image_id      = "ami-408c7f28"
  instance_type = "t1.micro"

  #iam_instance_profile = ""
  #key_name = ""
  #security_groups = ""
  user_data = ""
}

resource "aws_autoscaling_group" "mesos_ag" {
  availability_zones        = ["us-east-1a"]
  name                      = "mesos_ag"
  max_size                  = 4
  min_size                  = 0
  health_check_grace_period = 300
  desired_capacity          = 0
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.messos_launch_config.name}"

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.mesos_ag.name}"
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_up_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.mesos_ag.name}"
  policy_type            = "SimpleScaling"
}

resource "aws_sns_topic" "sns_asg" {
  name         = "mesos-asg"
  display_name = "Mesos ASG SNS topic"
}

resource "aws_autoscaling_notification" "asg_notify" {
  group_names = ["${aws_autoscaling_group.mesos_ag.name}"]

  notifications = ["autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = "${aws_sns_topic.sns_asg.arn}"
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = "scale_up_mesos"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mesos-cpu-memory"
  namespace           = "Mesos Cluster"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.mesos_ag.name}"
  }

  alarm_description = "This metric monitor Mesos cpu and mem utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "scale_up_mesos"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mesos-cpu-memory"
  namespace           = "Mesos Cluster"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.mesos_ag.name}"
  }

  alarm_description = "This metric monitor Mesos cpu and mem utilization"
  alarm_actions     = ["${aws_autoscaling_policy.scale_down.arn}"]
}
