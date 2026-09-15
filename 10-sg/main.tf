resource "aws_security_group" "sg" {
  count = length(var.sg_name)

  name        = "${var.project}-${var.sg_name[count.index]}"
  description = "Allow all outbound traffic to outside"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "${var.project}-${var.sg_name[count.index]}"
  }
}