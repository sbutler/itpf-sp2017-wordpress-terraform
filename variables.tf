# ===================================================================
# Variables
# ===================================================================

variable "project" {
    type = "string"
    description = "Name of the project; used as a prefix for resources."
}

variable "env" {
    type = "string"
    description = "Environment name (dev, tst, poc, prd, etc)."
}

variable "admin_instance_type" {
    type = "string"
    default = "t2.micro"
    description = "Instance type to use for the administrative endpoint."
}

variable "public_subnets" {
    type = "list"
    description = "Public subnet IDs."
}

variable "private_subnets" {
    type = "list"
    description = "Private subnet IDs."
}

variable "key_name" {
    type = "string"
    description = "SSH key name for the ec2-user."
}


variable "wp_solution_stack" {
    type = "string"
    default = "64bit Amazon Linux 2016.09 v2.3.3 running PHP 5.6"
    description = "WordPress Elastic Beanstalk solution stack."
}

variable "wp_asg_min_size" {
    type = "string"
    default = "1"
    description = "WordPress AutoScaling Group minimum size (number of instances)."
}

variable "wp_asg_max_size" {
    type = "string"
    default = "2"
    description = "WordPress AutoScaling Group maximum size (number of instances)."
}

variable "wp_instance_type" {
    type = "string"
    description = "WordPress instance type for Elastic Beanstalk. See 'describe-configuration-options' for the solution stack."
}

variable "wp_db_instance_class" {
    type = "string"
    description = "WordPress RDS instance type for Elastic Beanstalk."
}

variable "wp_db_allocated_storage" {
    type = "string"
    default = "100"
    description = "WordPress RDS allocated storage size (GB)."
}

variable "wp_db_name" {
  type = "string"
  description = "WordPress DB name."
}

variable "wp_db_adminuser" {
    type = "string"
    description = "WordPress DB master user."
}

variable "wp_db_adminpassword" {
    type = "string"
    description = "WordPress DB master password."
}

variable "wp_db_user" {
    type = "string"
    description = "WordPress DB app user."
}

variable "wp_db_password" {
    type = "string"
    description = "WordPress DB app password."
}

variable "wp_db_connection_max" {
    type = "string"
    default = "100"
    description = "WP DB maximum connection count, before an alarm is triggered."
}

variable "wp_db_backup_window" {
    type = "string"
    default = "05:05-05:59"
    description = "WP DB daily backup window."
}

variable "wp_db_backup_retention" {
    type = "string"
    default = "7"
    description = "WP DB backup retention in days."
}

variable "wp_db_maintenance_window" {
    type = "string"
    default = "Wed:08:05-Wed:08:59"
    description = "WP DB weekly maintenance window."
}

variable "wp_home_url" {
    type = "string"
    description = "WordPress home URL."
}

variable "wp_site_url" {
    type = "string"
    description = "WordPress site URL."
}

variable "wp_content_burstcredit_min" {
    type = "string"
    default = "1000000000000"
    description = "WP Content EFS volume burst credit minimum (in bytes), before an alarm is triggered."
}

variable "wp_content_iolimit_avg" {
    type = "string"
    default = "85"
    description = "WP Content EFS volume I/O limit average (in percent), before an alarm is triggered."
}

variable "wp_eb_managedactions_start" {
    type = "string"
    default = "Wed:08:05"
    description = "Prefered start time for EB managed actions."
}

variable "wp_auth_key" {}
variable "wp_secure_auth_key" {}
variable "wp_logged_in_key" {}
variable "wp_nonce_key" {}
variable "wp_auth_salt" {}
variable "wp_secure_auth_salt" {}
variable "wp_logged_in_salt" {}
variable "wp_nonce_salt" {}
