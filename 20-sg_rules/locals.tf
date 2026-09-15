locals {
  Bastion_sg       = data.aws_ssm_parameter.Bastion.value
  Jenkins_sg       = data.aws_ssm_parameter.Jenkins.value
  Jenkins_agent_sg = data.aws_ssm_parameter.Jenkins_agent.value
  Node_sg          = data.aws_ssm_parameter.Node.value
  Control_plane_sg = data.aws_ssm_parameter.Control_plane.value
  Public_alb_sg    = data.aws_ssm_parameter.Public_alb.value
}