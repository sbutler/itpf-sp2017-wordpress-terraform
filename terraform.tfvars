project = "itpf-wp"
env = "poc"

key_name = "workshop"
safe_cidrs = [
    "128.174.0.0/16",
    "130.126.0.0/16",
    "192.17.0.0/16",
    "72.36.64.0/18",
    "64.22.176.0/20",
    "204.93.0.0/19",
    "141.142.0.0/16",
    "198.17.196.0/25",
]
public_backend = "false"

public_subnets = [
]
private_subnets = [
]

wp_instance_type = "t2.micro"
wp_solution_stack = "64bit Amazon Linux 2017.03 v2.4.0 running PHP 5.6"
wp_asg_min_size = "1"
wp_asg_max_size = "2"
wp_eb_managedactions_start = "Wed:08:05"

wp_db_instance_class = "db.t2.micro"
wp_db_allocated_storage = "5"
wp_db_name = "wordpress"
wp_db_adminuser = "itpf_wp_admin"
wp_db_user = "wordpress"
wp_db_connection_max = "100"

wp_db_backup_window = "05:05-05:59"
wp_db_backup_retention = "7"

wp_db_maintenance_window = "Wed:08:05-Wed:08:59"

wp_content_burstcredit_min = "1000000000000"
wp_content_iolimit_avg = "85"

wp_home_url = "changeme"
wp_site_url = "changeme"

secrets = {
    wp_db_adminpassword = "changeme"
    wp_db_password = "changeme"

    wp_auth_key = "changeme"
    wp_secure_auth_key = "changeme"
    wp_logged_in_key = "changeme"
    wp_nonce_key = "changeme"
    wp_auth_salt = "changeme"
    wp_secure_auth_salt = "changeme"
    wp_logged_in_salt = "changeme"
    wp_nonce_salt = "changeme"
}
