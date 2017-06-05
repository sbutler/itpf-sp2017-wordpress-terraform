# ===================================================================
# Data
# ===================================================================

# Latest Amazon Linux image.
#
# https://www.terraform.io/docs/providers/aws/d/ami.html
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
        name = "name"
        values = [ "amzn-ami-*-gp2" ]
    }
    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }
    filter {
        name = "architecture"
        values = [ "x86_64" ]
    }
}

# IAM Policy which allows our EC2 instances to assume a role.
#
# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
data "aws_iam_policy_document" "ec2_assume_role" {
    statement {
        effect = "Allow"
        actions = [ "sts:AssumeRole" ]
        principals {
            type = "Service"
            identifiers = [ "ec2.amazonaws.com" ]
        }
    }
}

# IAM Policy which allows our EB service to assume a role.
#
# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
data "aws_iam_policy_document" "eb_assume_role" {
    statement {
        effect = "Allow"
        actions = [ "sts:AssumeRole" ]
        principals {
            type = "Service"
            identifiers = [ "elasticbeanstalk.amazonaws.com" ]
        }
        condition {
            test = "StringEquals"
            variable = "sts:ExternalId"
            values = [ "elasticbeanstalk" ]
        }
    }
}

# IAM Policy which allows our RDS instances to assume a role for monitoring.
#
# https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html
data "aws_iam_policy_document" "rdsmon_assume_role" {
    statement {
        effect = "Allow"
        actions = [ "sts:AssumeRole" ]
        principals {
            type = "Service"
            identifiers = [ "monitoring.rds.amazonaws.com" ]
        }
    }
}


# ===================================================================
# Resources
# ===================================================================

# Security group that will allow SSH from approved IP ranges.
#
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group" "ssh_allowed" {
    ingress {
        protocol = "tcp"
        from_port = 20
        to_port = 20
        cidr_blocks = [ "${var.ssh_allowed_cidrs}" ]
    }
}
