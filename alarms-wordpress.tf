# ===================================================================
# Resources
# ===================================================================

# Alarms to monitor critical resource metrics, which will signal a problem
# with some aspect of how we've provisioned infrastructure (instance type,
# stored data, etc).
#
# https://www.terraform.io/docs/providers/aws/r/cloudwatch_metric_alarm.html

# Monitor the bust credit limit. If it falls too low that means we are far
# exceeding the provisioned rate for our EFS. One solution would be to just add
# more data, or more caching.
#
# http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/efs-metricscollected.html
resource "aws_cloudwatch_metric_alarm" "wordpress_efs_burstcredit" {
    alarm_name = "${var.project}-${var.env}-wpcontent-burstcredit"
    alarm_description = "WP-Content EFS volume burst credit balance check."

    namespace = "AWS/EFS"
    dimensions {
        FileSystemId = "${aws_efs_file_system.wpcontent.id}"
    }

    metric_name = "BurstCreditBalance"
    comparison_operator = "LessThanOrEqualToThreshold"
    statistic = "Minimum"
    threshold = "${var.wp_content_burstcredit_min}"
    unit = "Bytes"
    evaluation_periods = 3
    period = 300

    alarm_actions = [
        "${aws_sns_topic.eb_wordpress.arn}",
    ]
    ok_actions = [
        "${aws_sns_topic.eb_wordpress.arn}",
    ]
}

# Monitor our I/O limit.
#
# http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/efs-metricscollected.html
resource "aws_cloudwatch_metric_alarm" "wordpress_efs_iolimit" {
    alarm_name = "${var.project}-${var.env}-wpcontent-iolimit"
    alarm_description = "WP-Content EFS volume I/O limit check."

    namespace = "AWS/EFS"
    dimensions {
        FileSystemId = "${aws_efs_file_system.wpcontent.id}"
    }

    metric_name = "PercentIOLimit"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    statistic = "Average"
    threshold = "${var.wp_content_iolimit_avg}"
    unit = "Percent"
    evaluation_periods = 1
    period = 300

    alarm_actions = [
        "${aws_sns_topic.eb_wordpress.arn}",
    ]
    ok_actions = [
        "${aws_sns_topic.eb_wordpress.arn}",
    ]
}

# Monitor the database connection limits. The maximum number of connections will
# depend on the size of the DB instance provisioned. When we get too high it
# means we need to either provision a larger database or fix caching.
#
# http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/rds-metricscollected.html
resource "aws_cloudwatch_metric_alarm" "wordpress_rds_connections" {
    alarm_name = "${var.project}-${var.env}-db-connections"
    alarm_description = "WP DB connection count check."

    namespace = "AWS/RDS"
    dimensions {
        DBInstanceIdentifier = "${aws_db_instance.wordpress.id}"
    }

    metric_name = "DatabaseConnections"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    statistic = "Maximum"
    threshold = "${var.wp_db_connection_max}"
    unit = "Count"
    evaluation_periods = 3
    period = 300

    alarm_actions = [
        "${aws_sns_topic.eb_wordpress.arn}",
    ]
    ok_actions = [
        "${aws_sns_topic.eb_wordpress.arn}",
    ]
}
