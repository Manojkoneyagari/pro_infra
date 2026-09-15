resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.project}/${var.environment}/vpc_id"
  description = "storing vpc id"
  type        = "String"
  value       = aws_vpc.main.id
  overwrite   = true

  tags = {
    Name = "${var.project}-${var.environment}-vpc_id"
  }
}

resource "aws_ssm_parameter" "sub_pub_ids" {
  name        = "/${var.project}/${var.environment}/sub_pub_ids"
  description = "storing public subnet ids"
  type        = "String"
  value       = join(",", aws_subnet.public_sub[*].id)
  overwrite   = true

  tags = {
    Name = "${var.project}-${var.environment}-sub_pub_ids"
  }
}

resource "aws_ssm_parameter" "sub_pri_ids" {
  name        = "/${var.project}/${var.environment}/sub_pri_ids"
  description = "storing private subnet ids"
  type        = "String"
  value       = join(",", aws_subnet.private_sub[*].id)
  overwrite   = true

  tags = {
    Name = "${var.project}-${var.environment}-sub_pri_ids"
  }
}