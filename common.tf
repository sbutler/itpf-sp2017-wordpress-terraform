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

# Decrypt secrets using the AWS KMS system. You should specify the encypted
# values in the "secrets" map variable and they will be available here.
#
# https://www.terraform.io/docs/providers/aws/d/kms_secret.html
data "aws_kms_secret" "secrets" {
    secret {
        name = "wp_db_adminpassword"
        payload = "${var.secrets["wp_db_adminpassword"]}"
    }
    secret {
        name = "wp_db_password"
        payload = "${var.secrets["wp_db_password"]}"
    }

    secret {
        name = "wp_auth_key"
        payload = "${var.secrets["wp_auth_key"]}"
    }
    secret {
        name = "wp_secure_auth_key"
        payload = "${var.secrets["wp_secure_auth_key"]}"
    }
    secret {
        name = "wp_logged_in_key"
        payload = "${var.secrets["wp_logged_in_key"]}"
    }
    secret {
        name = "wp_nonce_key"
        payload = "${var.secrets["wp_nonce_key"]}"
    }
    secret {
        name = "wp_auth_salt"
        payload = "${var.secrets["wp_auth_salt"]}"
    }
    secret {
        name = "wp_secure_auth_salt"
        payload = "${var.secrets["wp_secure_auth_salt"]}"
    }
    secret {
        name = "wp_logged_in_salt"
        payload = "${var.secrets["wp_logged_in_salt"]}"
    }
    secret {
        name = "wp_nonce_salt"
        payload = "${var.secrets["wp_nonce_salt"]}"
    }

}
