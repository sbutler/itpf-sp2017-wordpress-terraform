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
        cidr_blocks = [ "${var.safe_cidrs}" ]
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
    publicly_accessible = "${var.public_backend}"

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

    # TODO: remove apply_immediately and uncomment prevent_destroy
    apply_immediately = true
    lifecycle {
        # prevent_destroy = true
    }
}

# Provision a database, user, and grant for wordpress
#
# TODO: provision the database a more secure way
#
# https://www.terraform.io/docs/providers/mysql/r/database.html
# https://www.terraform.io/docs/providers/mysql/r/user.html
# https://www.terraform.io/docs/providers/mysql/r/grant.html
resource "mysql_database" "wordpress" {
    name = "${var.wp_db_name}"
}
resource "mysql_user" "wordpress" {
    user = "${var.wp_db_user}"
    host = "%"
    password = "${data.aws_kms_secret.secrets.wp_db_password}"
}
resource "mysql_grant" "wordpress" {
    user = "${mysql_user.wordpress.user}"
    host = "${mysql_user.wordpress.host}"
    database = "${mysql_database.wordpress.name}"
    privileges = [ "ALL" ]
}
