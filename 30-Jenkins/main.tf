resource "aws_instance" "Jenkins" {
  ami                    = local.ami_id
  instance_type          = var.instance_type_jenkins
  subnet_id              = local.public_subnet_id
  vpc_security_group_ids = [local.Jenkins_sgid]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = file("Jenkins.sh")




  root_block_device {
    volume_size = 40
    volume_type = "gp3"
  }

  connection {
    type        = "ssh"
    host        = aws_instance.Jenkins.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    source      = "~/.ssh/id_rsa"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-Jenkins"
    }
  )

}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
  #public_key = file(var.pub_key_path)
}

resource "aws_instance" "Jenkins_agent" {
  ami                    = local.ami_id
  instance_type          = var.instance_type_jenkins_agent
  subnet_id              = local.public_subnet_id
  vpc_security_group_ids = [local.Jenkins_agent_sgid]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = file("Jenkins_agent.sh")




  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }


  tags = merge(
    {
      Name = "${var.project}-${var.environment}-Jenkins_agent"
    }
  )

}
