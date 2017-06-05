# ===================================================================
# Resources
# ===================================================================

# Allow connections only from our EB instances to the database.
#
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "wp_db" {
    name_prefix = "${var.project}-${var.env}-wpdb-"
    description = "WordPress DB."
    vpc_id = "${data.aws_subnet.private.0.vpc_id}"

    ingress {
        protocol = "tcp"
        from_port = 3306
        to_port = 3306
        security_groups = [
            "${aws_security_group.wp_instance.id}",
        ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags {
        Name = "${var.project}-${var.env}-wpdb-sg"
    }
}

# Which subnet groups are allowed for the database endpoints?
#
# https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html
resource "aws_db_subnet_group" "wordpress" {
    name = "${var.project}-${var.env}-wp"
    description = "WordPress DB subnet group."
    subnet_ids = [ "${data.aws_subnet.private.*.id}" ]
}

# IAM Role and Policy for database monitoring.
#
# https://www.terraform.io/docs/providers/aws/r/iam_role.html
# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role" "rds_wordpress_monitor" {
    name_prefix = "${var.project}-${var.env}-role-"
    description = "WordPress Database enhanced monitoring role."

    assume_role_policy = "${data.aws_iam_policy_document.rdsmon_assume_role.json}"
}
resource "aws_iam_role_policy_attachment" "rds_wordpress_monitor" {
    role = "${aws_iam_role.rds_wordpress_monitor.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# WordPress shared database instance.
#
# https://www.terraform.io/docs/providers/aws/r/db_instance.html
resource "aws_db_instance" "wordpress" {
    depends_on = [ "aws_iam_role_policy_attachment.rds_wordpress_monitor" ]

    identifier = "${var.project}-${var.env}-wpdb"
    instance_class = "${var.wp_db_instance_class}"
    engine = "mariadb"

    multi_az = false
    vpc_security_group_ids = [ "${aws_security_group.wp_db.id}" ]
    db_subnet_group_name = "${aws_db_subnet_group.wordpress.name}"

    username = "${var.wp_db_adminuser}"
    password = "${data.aws_kms_secret.secrets.wp_db_adminpassword}"

    allocated_storage = "${var.wp_db_allocated_storage}"
    storage_type = "gp2"
    backup_retention_period = "${var.wp_db_backup_retention}"
    backup_window = "${var.wp_db_backup_window}"

    maintenance_window = "${var.wp_db_maintenance_window}"
    auto_minor_version_upgrade = true
    allow_major_version_upgrade = false

    monitoring_role_arn = "${aws_iam_role.rds_wordpress_monitor.arn}"
    monitoring_interval = 30

    final_snapshot_identifier = "${var.project}-${var.env}-wpdb-final"

    apply_immediately = true
    lifecycle {
        prevent_destroy = true
    }
}

# WordPress database event subscription. This sends event to our SNS topic,
# which optionally then emails us or triggers other actions.
#
# https://www.terraform.io/docs/providers/aws/r/db_event_subscription.html
resource "aws_db_event_subscription" "wordpress" {
    name = "${var.project}-${var.env}-wpdb-events"
    sns_topic = "${aws_sns_topic.eb_wordpress.arn}"

    source_type = "db-instance"
    source_ids = [ "${aws_db_instance.wordpress.id}" ]

    event_categories = [
        "availability",
        "deletion",
        "failover",
        "failure",
        "low storage",
        "maintenance",
        "notification",
        "recovery",
        "restoration",
    ]
}
