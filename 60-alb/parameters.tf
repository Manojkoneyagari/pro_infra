resource "aws_ssm_parameter" "Public_alb_arn" {
  name        = "/${var.project}/${var.environment}/Public_alb_arn"
  description = " storing alb arn in ssm"
  type        = "String"
  value       = aws_lb.public_alb.arn

}
