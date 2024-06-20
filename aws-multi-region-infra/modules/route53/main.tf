resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "${var.environment}-zone"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.frontend_record_name
  type    = "A"

  alias {
    name                   = var.elb_dns_name
    zone_id                = var.elb_zone_id
    evaluate_target_health = true
  }
}
