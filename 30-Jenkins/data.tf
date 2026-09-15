data "aws_ami" "myami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}


data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "Jenkins" {
  name = "/${var.project}/${var.environment}/Jenkins"
}

data "aws_ssm_parameter" "Jenkins_agent" {
  name = "/${var.project}/${var.environment}/Jenkins_agent"
}
data "aws_ssm_parameter" "sub_pub_ids" {
  name = "/${var.project}/${var.environment}/sub_pub_ids"
}

data "aws_ssm_parameter" "sub_pri_ids" {
  name = "/${var.project}/${var.environment}/sub_pri_ids"
}
