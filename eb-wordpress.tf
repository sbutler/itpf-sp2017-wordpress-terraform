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

# IAM Role, Policy, and Profile for the EB instances. This doesn't provide
# anything for our app, but is required for EB to work.
#
# https://www.terraform.io/docs/providers/aws/r/iam_role.html
# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
# https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html
resource "aws_iam_role" "eb_wordpress_instance" {
    name_prefix = "${var.project}-${var.env}-role-"
    description = "WordPress EB instance role."

    assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_role.json}"
}
resource "aws_iam_role_policy_attachment" "eb_wordpress_instance_webtier" {
    role = "${aws_iam_role.eb_wordpress_instance.name}"
    policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}
resource "aws_iam_instance_profile" "eb_wordpress" {
    name_prefix = "${var.project}-${var.env}-profile-"
    role = "${aws_iam_role.eb_wordpress_instance.name}"
}

# IAM Role and Policy for the EB service. This doesn't provide anything for our
# app, but is required for EB to work.
#
# https://www.terraform.io/docs/providers/aws/r/iam_role.html
# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role" "eb_wordpress_service" {
    name_prefix = "${var.project}-${var.env}-role-"
    description = "WordPress EB service role."

    assume_role_policy = "${data.aws_iam_policy_document.eb_assume_role.json}"
}
resource "aws_iam_role_policy_attachment" "eb_wordpress_service_healthcheck" {
    role = "${aws_iam_role.eb_wordpress_service.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}
resource "aws_iam_role_policy_attachment" "eb_wordpress_service" {
    role = "${aws_iam_role.eb_wordpress_service.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# Parent resource for all of the EB components.
#
# https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_application.html
resource "aws_elastic_beanstalk_application" "wordpress" {
    name = "${var.project}-${var.env}-wpapp"
    description = "WordPress Elastic Beanstalk Application."
}

# WordPress EB configuration template. We can apply this to multiple
# environments later. The main purpose of separateing it out is that we can
# decide when to apply it to our environment after terraform has run.
#
# There are many settings here that change the environment. Only set generic
# options that work with both an empty stack and our app. For example, do not
# set a specific health check URL that won't be present until our app has been
# deployed (do that in the app .ebextensions).
#
# Options reference:
# http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html
#
# https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_configuration_template.html
resource "aws_elastic_beanstalk_configuration_template" "wordpress" {
    name = "${var.project}-${var.env}-wpcfgtpl"
    description = "WordPress Elastic Beanstalk configuration template."

    application = "${aws_elastic_beanstalk_application.wordpress.name}"
    solution_stack_name = "${var.wp_solution_stack}"

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "EFS_WPCONTENT_ID"
        value = "${aws_efs_file_system.wpcontent.id}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_HOME"
        value = "${var.wp_home_url}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_SITEURL"
        value = "${var.wp_site_url}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_DB_NAME"
        value = "${var.wp_db_name}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_DB_USER"
        value = "${var.wp_db_user}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_DB_PASSWORD"
        value = "${data.aws_kms_secret.secrets.wp_db_password}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_DB_HOSTNAME"
        value = "${aws_db_instance.wordpress.address}"
    }

    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_AUTH_KEY"
        value = "${data.aws_kms_secret.secrets.wp_auth_key}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_SECURE_AUTH_KEY"
        value = "${data.aws_kms_secret.secrets.wp_secure_auth_key}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_LOGGED_IN_KEY"
        value = "${data.aws_kms_secret.secrets.wp_logged_in_key}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_NONCE_KEY"
        value = "${data.aws_kms_secret.secrets.wp_nonce_key}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_AUTH_SALT"
        value = "${data.aws_kms_secret.secrets.wp_auth_salt}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_SECURE_AUTH_SALT"
        value = "${data.aws_kms_secret.secrets.wp_secure_auth_salt}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_LOGGED_IN_SALT"
        value = "${data.aws_kms_secret.secrets.wp_logged_in_salt}"
    }
    setting {
        namespace = "aws:elasticbeanstalk:application:environment"
        name = "WP_NONCE_SALT"
        value = "${data.aws_kms_secret.secrets.wp_nonce_salt}"
    }


    # ==== AutoScaling ASG ====
    setting {
        namespace = "aws:autoscaling:asg"
        name = "MinSize"
        value = "${var.wp_asg_min_size}"
    }
    setting {
        namespace = "aws:autoscaling:asg"
        name = "MaxSize"
        value = "${var.wp_asg_max_size}"
    }


    # ==== AutoScaling ASG Trigger ====
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "MeasureName"
        value = "Latency"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "Statistic"
        value = "Average"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "Unit"
        value = "Seconds"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "LowerThreshold"
        value = "2"
    }
    setting {
        namespace = "aws:autoscaling:trigger"
        name = "UpperThreshold"
        value = "6"
    }


    # ==== AutoScaling Launch Configuration ====
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "EC2KeyName"
        value = "${var.key_name}"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = "${aws_iam_instance_profile.eb_wordpress.arn}"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "InstanceType"
        value = "${var.wp_instance_type}"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "SecurityGroups"
        value = "${aws_security_group.wp_instance.id}"
    }
    setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "SSHSourceRestriction"
        value = "tcp, 22, 22, 0.0.0.0/32"
    }


    # ==== EC2 VPC ====
    setting {
        namespace = "aws:ec2:vpc"
        name = "VPCId"
        value = "${data.aws_subnet.public.0.vpc_id}"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "Subnets"
        value = "${join(",", data.aws_subnet.private.*.id)}"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "ELBSubnets"
        value = "${join(",", data.aws_subnet.public.*.id)}"
    }
    setting {
        namespace = "aws:ec2:vpc"
        name = "AssociatePublicIpAddress"
        value = "${var.public_backend}"
    }


    # ==== Elastic Beanstalk CloudWatch logs ====
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "StreamLogs"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:cloudwatch:logs"
        name = "RetentionInDays"
        value = "90"
    }


    # ==== Elastic Beanstalk environment ====
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "ServiceRole"
        value = "${aws_iam_role.eb_wordpress_service.name}"
    }


    # ==== Elastic Beanstalk Command ====
    setting {
        namespace = "aws:elasticbeanstalk:command"
        name = "DeploymentPolicy"
        value = "RollingWithAdditionalBatch"
    }


    # ==== Elastic Beanstalk Environment ====
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "EnvironmentType"
        value = "LoadBalanced"
    }
    setting {
        namespace = "aws:elasticbeanstalk:environment"
        name = "LoadBalancerType"
        value = "classic"
    }


    # ==== Elastic Beanstalk Health Reporting System ====
    setting {
        namespace = "aws:elasticbeanstalk:healthreporting:system"
        name = "SystemType"
        value = "enhanced"
    }


    # ==== Elastic Beanstalk host manager ====
    setting {
        namespace = "aws:elasticbeanstalk:hostmanager"
        name = "LogPublicationControl"
        value = "true"
    }


    # ==== Elastic Beanstalk Managed Actions ====
    setting {
        namespace = "aws:elasticbeanstalk:managedactions"
        name = "ManagedActionsEnabled"
        value = "true"
    }
    setting {
        namespace = "aws:elasticbeanstalk:managedactions"
        name = "PreferredStartTime"
        value = "${var.wp_eb_managedactions_start}"
    }


    # ==== Elastic Beanstalk Managed Actions Platform Update ====
    setting {
        namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
        name = "UpdateLevel"
        value = "minor"
    }
}

# Actual environment we will deploy the WordPress application into.
#
# https://www.terraform.io/docs/providers/aws/r/elastic_beanstalk_environment.html
resource "aws_elastic_beanstalk_environment" "wordpress" {
    depends_on = [
        "aws_efs_mount_target.wpcontent",
        "aws_iam_role_policy_attachment.eb_wordpress_instance_webtier",
        "aws_iam_role_policy_attachment.eb_wordpress_service_healthcheck",
        "aws_iam_role_policy_attachment.eb_wordpress_service",
    ]

    name = "${var.project}-${var.env}-wpenv"
    cname_prefix = "${var.project}-${var.env}-wpenv"
    description = "WordPress ${var.env} environment."

    application = "${aws_elastic_beanstalk_application.wordpress.name}"
    template_name = "${aws_elastic_beanstalk_configuration_template.wordpress.name}"
}
