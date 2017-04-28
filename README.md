# Mastodon on AWS with Terraform
Terraform module for mastodon service deploy

Will deploy an ec2 instance with mastodon and run the service.

## Requirements

- AWS account
    - EC2
    - domain with Route53
- Terraform

## Usage

```terraform
module "mastodon" {
  source            = "github.com/ademilly/mastodon-aws-terraform?ref=v1.01"
  key_name          = "YOUR KEY"
  instance_type     = "SOME INSTANCE TYPE"
  instance_name     = "SOME NAME"
  smtp_server       = "SMTP SERVER"
  smtp_login        = "SMTP LOGIN"
  smtp_password     = "SMTP PASSWORD"
  smtp_from_address = "SMTP FROM ADDRESS"
  subnet_id         = "SOME SUBNET ID"
  security_group_id = "SOME SECURITY GROUP ID"
  zone_id           = "SOME ROUTE53 ZONE ID"
  domain            = "YOUR DOMAIN NAME" (example: mastodon.mydomain.com)
  subdomain         = "YOUR SUBDOMAIN NAME" (example: mastodon)
}
```