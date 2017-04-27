resource aws_route53_record "mastodon-domain" {
  zone_id = "${var.zone_id}"

  name = "${var.subdomain}"
  type = "CNAME"

  ttl = 300

  records = [
    "${aws_instance.mastodon.public_dns}",
  ]
}

output "mastodon-record-id" {
  value = "${aws_route53_record.mastodon-domain.id}"
}
