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


variable "public_subnets" {
    type = "list"
    description = "Public subnet IDs."
}

variable "private_subnets" {
    type = "list"
    description = "Private subnet IDs."
}


variable "ssh_allowed_cidrs" {
    type = "list"
    description = "List of allowed CIDR's for SSH to the instances"
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

variable "wp_db_user" {
    type = "string"
    description = "WordPress DB app user."
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

# Secrets for:
#   wp_db_adminpassword
#   wp_db_password
variable "secrets" {
    type = "map"
    description = "A map of all the encrypted secrets used in this configuration."
}
