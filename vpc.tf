data "aws_subnet" "default" {
  availability_zone = "${var.availability_zones[0]}"
  vpc_id            = "${data.aws_security_group.mongodb-cluster.vpc_id}"
}
