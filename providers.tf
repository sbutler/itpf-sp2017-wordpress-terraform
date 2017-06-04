# ===================================================================
# Providers
# ===================================================================

terraform {
    required_version = ">= 0.9.5"
}

# https://www.terraform.io/docs/providers/aws/
provider "aws" {
    # These values are pulled from the awscli configuration. Be careful about
    # specifying them here. You would not want these stored in the code
    # repository.
    #
    # access_key = "changeme"
    # secret_key = "changeme"
    #
    # Instead of specifying the above keys, consider configuring the AWS CLI:
    #
    # http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

    region = "us-east-2"
}


# ===================================================================
# Data
# ===================================================================

# Provides the current region, if needed, to the configuration
#
# https://www.terraform.io/docs/providers/aws/d/region.html
data "aws_region" "current" {
    current = true
}

# Provides the current account, if needed, to the configuration
#
# https://www.terraform.io/docs/providers/aws/d/caller_identity.html
data "aws_caller_identity" "current" {}
