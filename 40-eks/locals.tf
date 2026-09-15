locals {

  ami_id              = data.aws_ami.myami.id
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
  public_subnet_id    = split(",", data.aws_ssm_parameter.sub_pub_ids.value)[0]
  private_subnet_id   = split(",", data.aws_ssm_parameter.sub_pri_ids.value)
  Node_sg_id          = data.aws_ssm_parameter.Node_sg.value
  Control_plane_sg_id = data.aws_ssm_parameter.Control_plane.value




}