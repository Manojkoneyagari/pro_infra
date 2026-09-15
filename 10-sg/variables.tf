variable "project" {
  type    = string
  default = "Roboshop"
}

variable "environment" {
  type    = string
  default = "dev"
}



variable "sg_name" {
  type = list(any)
  default = [
  "Jenkins", "Jenkins_agent", "Control_plane", "Bastion", "Node", "Public_alb"]

}