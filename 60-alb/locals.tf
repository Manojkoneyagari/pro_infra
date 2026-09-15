locals {
  vpc_id            = data.aws_ssm_parameter.vpc_id.value
  public_subnet_id  = split(",", data.aws_ssm_parameter.sub_pub_ids.value)
  

  Public_alb_sg   = data.aws_ssm_parameter.Public_alb.value
  certificate_arn = data.aws_ssm_parameter.certificate_arn.value

}