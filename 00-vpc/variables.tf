variable "project" {
  type    = string
  default = "Roboshop"
}

variable "environment" {
  type    = string
  default = "dev"
}


variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "public_cidr" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_cidr" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]

}

variable "aznames" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]

}