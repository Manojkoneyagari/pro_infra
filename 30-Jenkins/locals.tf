locals {

  ami_id             = data.aws_ami.myami.id
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  public_subnet_id   = split(",", data.aws_ssm_parameter.sub_pub_ids.value)[0]
  Jenkins_sgid       = data.aws_ssm_parameter.Jenkins.value
  Jenkins_agent_sgid = data.aws_ssm_parameter.Jenkins_agent.value




}