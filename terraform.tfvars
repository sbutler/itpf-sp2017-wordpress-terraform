project = "itpf-wp"
env = "poc"
key_name = "workshop"

public_subnets = [
    "subnet-2af03143",
    "subnet-735b470b",
    "subnet-b6af9dfc",
]
private_subnets = [
    "subnet-2af03143",
    "subnet-735b470b",
    "subnet-b6af9dfc",
]

wp_instance_type = "t2.micro"
wp_eb_managedactions_start = "Wed:08:05"

wp_db_instance_class = "db.t2.micro"
wp_db_allocated_storage = "5"
wp_db_name = "wordpress"
wp_db_adminuser = "itpf-wp-admin"
wp_db_user = "wordpress"

wp_db_backup_window = "05:05-05:59"
wp_db_backup_retention = "7"

wp_db_maintenance_window = "Wed:08:05-Wed:08:59"

wp_home_url = "changeme"
wp_site_url = "changeme"

wp_auth_key = "changeme"
wp_secure_auth_key = "changeme"
wp_logged_in_key = "changeme"
wp_nonce_key = "changeme"
wp_auth_salt = "changeme"
wp_secure_auth_salt = "changeme"
wp_logged_in_salt = "changeme"
wp_nonce_salt = "changeme"

wp_db_adminpassword = "changeme"
wp_db_password = "changeme"
