# ===================================================================
# Outputs
# ===================================================================

output "wp_db_hostname" {
    value = "${aws_db_instance.wordpress.address}"
}

output "wp_hostname" {
    value = "${aws_elastic_beanstalk_environment.wordpress.cname}"
}
