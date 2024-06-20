output "zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "frontend_record_fqdn" {
  value = aws_route53_record.frontend.fqdn
}