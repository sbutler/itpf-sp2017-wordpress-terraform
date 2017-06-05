# ===================================================================
# Resources
# ===================================================================

# Allow connections to our EB instances from SSH, and use this also to allow
# the instances to connect to the database server.
#
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "wp_instance" {
    name_prefix = "${var.project}-${var.env}-wpinstance-"
    description = "WordPress Elastic Beanstalk EC2 instances."
    vpc_id = "${data.aws_subnet.public.0.vpc_id}"

    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = [ "${var.safe_cidrs}" ]
    }

    tags {
        Name = "${var.project}-${var.env}-wpinstance-sg"
    }
}
