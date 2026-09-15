
# 22 on Bastion ec2
resource "aws_security_group_rule" "Bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.Bastion_sg
}

# 8080 on Jenkins ec2
resource "aws_security_group_rule" "Jenkins_public" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.Jenkins_sg
}

# 22 on Jenkins ec2
resource "aws_security_group_rule" "Jenkins_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.Jenkins_sg
}

resource "aws_security_group_rule" "Jenkins_agent_jenkins" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.Jenkins_sg
  security_group_id        = local.Jenkins_agent_sg
}

resource "aws_security_group_rule" "Jenkins_agent_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.Jenkins_agent_sg
}

#Internal traffic from VPC
resource "aws_security_group_rule" "Node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = local.Node_sg
}

resource "aws_security_group_rule" "Node_control_plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = local.Control_plane_sg
  security_group_id        = local.Node_sg
}

resource "aws_security_group_rule" "control_plane_Node" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = local.Node_sg
  security_group_id        = local.Control_plane_sg
}

resource "aws_security_group_rule" "control_plane_Bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.Bastion_sg
  security_group_id        = local.Control_plane_sg
}

resource "aws_security_group_rule" "public_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.Public_alb_sg
}

resource "aws_security_group_rule" "public_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.Public_alb_sg
}

resource "aws_security_group_rule" "Control_plane_jenkins_agent" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = local.Jenkins_agent_sg
  security_group_id        = local.Control_plane_sg
}