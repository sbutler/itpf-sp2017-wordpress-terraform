# ===================================================================
# Data
# ===================================================================

# Validate the public subnet ID's provided.
#
# https://www.terraform.io/docs/providers/aws/d/subnet.html
data "aws_subnet" "public" {
    count = "${length(var.public_subnets)}"

    id = "${element(var.public_subnets, count.index)}"
    state = "available"
}

# Validate the private subnet ID's provided.
#
# https://www.terraform.io/docs/providers/aws/d/subnet.html
data "aws_subnet" "private" {
    count = "${length(var.private_subnets)}"

    id = "${element(var.private_subnets, count.index)}"
    state = "available"
}
