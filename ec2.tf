data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/*16.04-amd64-server-*20170307"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "mastodon" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"

  key_name = "${var.key_name}"

  vpc_security_group_ids = [
    "${var.security_group_id}",
  ]

  subnet_id = "${var.subnet_id}"

  root_block_device {
    delete_on_termination = true
    volume_size           = 128
  }

  tags {
    Name = "${var.instance_name}"
  }

  user_data = "${file("${path.module}/deploy.sh")}"
}

data "template_file" "deploy" {
  template = "${file("${path.module}/deploy.sh")}"

  vars {
    local_domain      = "${var.subdomain}${data.aws_route53_zone.selected.name}"
    smtp_server       = "${var.smtp_server}"
    smtp_login        = "${var.smtp_login}"
    smtp_password     = "${var.smtp_password}"
    smtp_from_address = "${var.smtp_from_address}"
  }
}

output "mastodon-ip" {
  value = "${aws_instance.mastodon.public_ip}"
}

output "mastodon-private-ip" {
  value = "${aws_instance.mastodon.private_ip}"
}
