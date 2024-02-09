#get hosted zone details

data "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
}

#create record set in route 53

resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name = var.record_name
  type = "A"

  alias {
    name = aws_lb.alb.dns_name
    zone_id = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}