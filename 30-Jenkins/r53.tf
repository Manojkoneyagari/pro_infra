resource "aws_route53_record" "Jenkins" {
  zone_id         = var.zone_id
  name            = "Jenkins.${var.domain}"
  type            = "A"
  ttl             = "1"
  records         = [aws_instance.Jenkins.public_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "Jenkins_agent" {
  zone_id         = var.zone_id
  name            = "Jenkins_agent.${var.domain}"
  type            = "A"
  ttl             = "1"
  records         = [aws_instance.Jenkins_agent.public_ip]
  allow_overwrite = true
}