Elastic Beanstalk WordPress
===========================

This is an Elastic Beanstalk terraform configuration for WordPress created for
the ITPro Forum workshop. This code is provided as part of the workshop and
will not be regularly updated. You can use it as a base for your own terraform
configuration.

## Environments

This configuration only deploys a single environment. However, it could be
structured to deploy multiple environments. This would be useful if you wanted
to have dev, test, and prod live side-by-side, or if you wanted to use
Green-Blue deployment for your application.

To create multiple environments you would need to edit the `eb-wordpress.tf`
file and duplicate the `aws_elastic_beanstalk_configuration_template` and
`aws_elastic_beanstalk_environment` sections. Be careful about multiple
environments and RDS/EFS resources!

## Variables

Inspect the `varibles.tf` file for a description of all variables used in this
configuration. You can find default or sensible values in `terraform.tfvars`.

Various alarms are set based on the workshop defaults. You would want to change
these in a production environment based on instance type. For example, the alarm
for RDS Connections is about 85% of a `db.t2.micro` sized database.

## Public and Private Subnets

The terraform configuration is setup to allow you to deploy the resources into
both public and private subnets. Public subnets are ones with an Internet
Gateway attached. Private subnets are ones without an Internet Gateway, but
have a NAT Gateway and routing table attached.

The Elastic Loadbalancer must be in a public subnet, but all other resources
(EC2 instances, RDS, and EFS) can be deployed in a private subnet. **This is
the recommended configuration.** You should not give your EC2 instances or RDS
public IP's.

There are some caveats about using the private subnets:

* **RDS provisioning.** The RDS has a `local-exec` provisioner that will run a
  script on your local machine that creates some database tables. This will not
  work from your workstation if RDS is in a private subnet. In this case, you
  must run terraform on an instance in your AWS VPC.
* **EC2 instance SSH.** You will be unable to SSH into your Elastic Beanstalk
  EC2 instances if they are deployed into a private subnet. You should create
  a bastion host in your VPC first, SSH to it, and then SSH to your EC2
  instances.

The default is to take advantage of private subnets for backend resources. You
can change this by setting `public_backend = "true"`. If you do not have any
private subnets in your VPC then you will need to copy your list of public
subnets into the `private_subnets` variable (EFS always deploys into private
subnets).

## Secrets

This configuration has a map called `secrets` that contains values encrypted
using AWS KMS. The map keys are:

* `wp_db_adminpassword`: RDS administrator/master password.
* `wp_db_password`: WordPress database password.
* `wp_auth_key`, `wp_secure_auth_key`, `wp_logged_in_key`, `wp_nonce_key`,
  `wp_auth_salt`, `wp_secure_auth_salt`, `wp_logged_in_salt`, `wp_nonce_salt`:
  cryptographically secure random values used by WordPress to hash or verify
  cookies and form submissions.

To encrypt a value using KMS follow these steps:

1. Create a KMS key in your deployment region with an identifiable name. Give
   your IAM Role and IAM User (for terraform) Use level access.
2. Generate a new password. This password should not use any characters that
   are special to the bash shell. In particular, stay away from double quotes ("),
   dolar signs ($), and back slashes (\\).
3. Run this command: `aws kms encrypt --key-id (YOUR KEY ID) --output text --query CiphertextBlob --plaintext (your password) `. The value that is returned is the encrypted text
   to use in the terraform configuration map for `secrets`.

To help you generate new values for the WordPress salt and nonce keys, you can
run the script `scripts/wp-secret-salts.sh`.

## Prevent Delete

The RDS and EFS resources are marked as preventing deletion. You will need to
comment these lines if you want to easily delete a deployed configuration.
