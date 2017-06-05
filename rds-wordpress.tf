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

# WordPress shared database instance.
#
# https://www.terraform.io/docs/providers/aws/r/db_instance.html
resource "aws_db_instance" "wordpress" {
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

    final_snapshot_identifier = "${var.project}-${var.env}-wpdb-final"

    # TODO: remove apply_immediately and uncomment prevent_destroy
    apply_immediately = true
    lifecycle {
        # prevent_destroy = true
    }
}
