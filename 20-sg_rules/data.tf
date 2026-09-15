data "aws_ssm_parameter" "Bastion" {
  name = "/${var.project}/${var.environment}/Bastion"
}

data "aws_ssm_parameter" "Jenkins" {
  name = "/${var.project}/${var.environment}/Jenkins"
}

data "aws_ssm_parameter" "Jenkins_agent" {
  name = "/${var.project}/${var.environment}/Jenkins_agent"
}

data "aws_ssm_parameter" "Node" {
  name = "/${var.project}/${var.environment}/Node"
}

data "aws_ssm_parameter" "Control_plane" {
  name = "/${var.project}/${var.environment}/Control_plane"
}

data "aws_ssm_parameter" "Public_alb" {
  name = "/${var.project}/${var.environment}/Public_alb"
}

data "http" "my_public_ip" {
  url = "https://ipv4.icanhazip.com"
}