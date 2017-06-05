# ===================================================================
# Resources
# ===================================================================

# Security group that allows NFSv4 from various other security groups.
#
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "wpcontent" {
    name_prefix = "${var.project}-${var.env}-wpcontent-"
    description = "WordPress Elastic FileSystem wpcontent mount targets."
    vpc_id = "${data.aws_subnet.private.0.vpc_id}"

    ingress {
        protocol = "tcp"
        from_port = 2049
        to_port = 2049
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
        Name = "${var.project}-${var.env}-wpcontent-sg"
    }
}

# The EFS for wp-content and mount targets in the private subnets.
#
# https://www.terraform.io/docs/providers/aws/r/efs_file_system.html
resource "aws_efs_file_system" "wpcontent" {
    tags {
        Name = "${var.project}-${var.env}-wpcontent"
    }

    # TODO: uncomment prevent_destroy
    lifecycle {
        #prevent_destroy = true
    }
}
# https://www.terraform.io/docs/providers/aws/r/efs_mount_target.html
resource "aws_efs_mount_target" "wpcontent" {
    count = "${length(var.private_subnets)}"

    file_system_id = "${aws_efs_file_system.wpcontent.id}"
    subnet_id = "${element(var.private_subnets, count.index)}"
    security_groups = [ "${aws_security_group.wpcontent.id}" ]
}
