
data "aws_ssm_parameter" "Public_alb" {
  name = "/${var.project}/${var.environment}/Public_alb"
}

data "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project}/${var.environment}/certificate_arn"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "sub_pub_ids" {
  name = "/${var.project}/${var.environment}/sub_pub_ids"
}

data "aws_ssm_parameter" "sub_pri_ids" {
  name = "/${var.project}/${var.environment}/sub_pri_ids"
}
