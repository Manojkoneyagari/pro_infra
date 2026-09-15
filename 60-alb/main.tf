resource "aws_lb" "public_alb" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.Public_alb_sg]
  subnets            = local.public_subnet_id

  enable_deletion_protection = false

  tags = {
    Project = "Roboshop"
    environment = var.environment
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.certificate_arn


  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hi, I am from HTTPS Frontend ALB</h1>"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = "*.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_lb.public_alb.dns_name
    zone_id                = aws_lb.public_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_target_group" "app1" {
  name        = "${var.project}-tg-app1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id # Replace with your real VPC ID
  target_type = "ip"         # Options: instance, ip, lambda, alb

  health_check {
    enabled             = true
    path                = "/"
    port                = 80 # Uses target group port (80)
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299" # Accepts any successful 2xx status code
  }

}

resource "aws_lb_listener_rule" "app1" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1.arn
  }

  condition {
    host_header {
      values = ["app1.${var.domain}"] # app1-dev.daws90s.shop
    }
  }
}

resource "aws_lb_target_group" "app2" {
  name        = "${var.project}-tg-app2"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id # Replace with your real VPC ID
  target_type = "ip"         # Options: instance, ip, lambda, alb

  health_check {
    enabled             = true
    path                = "/"
    port                = 80 # Uses target group port (80)
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299" # Accepts any successful 2xx status code
  }

}

resource "aws_lb_listener_rule" "app2" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app2.arn
  }

  condition {
    host_header {
      values = ["app2.${var.domain}"] # app1-dev.daws90s.shop
    }
  }


}