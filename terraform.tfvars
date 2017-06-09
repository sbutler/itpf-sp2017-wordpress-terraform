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
#public_backend = "true"

public_subnets = [
    "subnet-2af03143",
    "subnet-735b470b",
    "subnet-b6af9dfc",
]
private_subnets = [
    "subnet-3a750453",
    "subnet-1e51ee65",
    "subnet-1bff3056",
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
    wp_db_adminpassword = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywEZ+FD6722p7Y4mAPZfsPGcAAAAazBpBgkqhkiG9w0BBwagXDBaAgEAMFUGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMPe2IC8cyZ94iyK/PAgEQgCiiifq3Na1djJsbP6M3fGCKoZUPIfti3/FNjKF+mvXIcYaVOTMFiLDD"
    wp_db_password = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywEzyhyTFKh/vVcVU3on0G+WAAAAazBpBgkqhkiG9w0BBwagXDBaAgEAMFUGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMyeDYa+e1hLp9/9oGAgEQgCiCk/HksvAw1/QOcuqdC55F73NgxqgGKADz9OeY/qzW851kc5W+w/J4"

    wp_auth_key = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywGJHK8Mg7BpzxQeG3DziPrxAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDO9vDJfyz31tSupmFAIBEIBbW3wYdi9jX8zy6vh/T12Lw7rRYByTXq9t94UzH7pzPHKdqCMcIvHRg7DjBI8lBvcQ8KACWYILPqiE8nfpJhIthVVwM96nb5scUyqb0k/ATOFmPzVRKDrm7eoncQ=="
    wp_secure_auth_key = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywGp0tVXXhpPmDMfKlzHEEUyAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDF/MfS35juPZGlt3qgIBEIBbXYfd06Us8JePSUQPRlupmZLheNFvXJEnC/vfFF+ouZHOqDT9knzMc/QbLwhkT3vJrahht1w20J7Ez6uTBLbiNYWJbS7cl3t1YgXtBhzS1BXL2yYa5EiUdmXdCA=="
    wp_logged_in_key = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywFDcM6x/FbuRe+gr8Q3cCdhAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDBGCIpm3VEhqYRFKowIBEIBbamoIB1TwxvuwHTW4P7QiVNAsJ4hUkmra8o7ll7mC263due96XjMANHMXg1SB3uHeoLbFCuPsLi+3Fy87JvAvVDxHt16dJEsR68SlkgmHe5ONXgOyN+Hsf8rSQg=="
    wp_nonce_key = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywHMSrJNXpBcZoht/bB77vAcAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDE1V8ingORkSM3PZnwIBEIBbKsOeUEv6giEmpB8GfZbnjhEdSYGIUrao8EBusvEjN5Ee4W7ShSSEqEHXCrBCeFWibMzkch+l1bVCzTTeLAwlwc/7Oolc0V8kvdcDx+gxLJDDzzBHZmvVqs0KqQ=="
    wp_auth_salt = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywHpS72ICt69memtYfRfydNQAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDL2KGPZxMmobcEJfBwIBEIBbfikJWolZrjzash7BoWcH8W+6YkHdIHxxKA4Lni5s2ocj2OUbc9limhZ6Hs0Vozwljf6J80Df1iK+Kbq5U0H1yQW73GvPZbZji0nd4XxSh1o034xvGeQXuA5Jng=="
    wp_secure_auth_salt = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywHdOVH5RQ0WnbtvQxYyInXiAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDD2QFMwDl2MWjdob2gIBEIBbSPfvO1FvTEV0YW+ZJpszKqydYuJ9GZvLS1cpjwtlcCuwXq7vOaKMLa84Drv0f6tIXFSpOFttSuNj+huihjnC+W1LfTBEnuEyVg2Dbfj6xJ/ORIoSiUKXr7/Hig=="
    wp_logged_in_salt = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywGQDimXjr3F5ifxp4p/a9AkAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDK1PcTKxIJ0VkZW1wwIBEIBbHrQUfk+p9FvORRuoLm10ln3yL5/73c+3BVSytu1RXz58GCoy2ZPUotBZ0rdOZ4U0ZRoESbYaVVvgVd5yMI37bCH9d52h4u5zxZuIAGWsV2JYSaomQAqMp573mg=="
    wp_nonce_salt = "AQICAHg5ZUe7OdPm2J/uET9WR8OE4zyZB59HG46zZ9NgqrrAywHcx7hI2PXuAF8pn2OUGa3XAAAAojCBnwYJKoZIhvcNAQcGoIGRMIGOAgEAMIGIBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDMahJRJmJ1hFG2ojCQIBEIBbxV3pPcJDqUY3T1auLVvWrLW91fvcGt5txojUqccQK/wO5clFY7HMplyi9kWVnaqwm2fJcFhjCIWVE26BgCoLK2i1rMVrDP0an8zgc59f8NIEtvW//zddsE913A=="
}
