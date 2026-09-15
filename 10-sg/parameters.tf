resource "aws_ssm_parameter" "sg_names" {
  count       = length(var.sg_name)
  name        = "/${var.project}/${var.environment}/${var.sg_name[count.index]}"
  description = "storing sg id"
  type        = "String"
  value       = aws_security_group.sg[count.index].id
  overwrite   = true

  tags = {
    Name = "${var.project}-${var.sg_name[count.index]}"
  }
}

