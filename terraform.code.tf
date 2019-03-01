# ************************
# vars.tf
# ************************

variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "AMIS" {
  type = "map"
  default = {
    # *******************************************
    # https://cloud-images.ubuntu.com/locator/ec2/
    #
    #   N. Virginia => us-east-1
    #   OS        => UBUNTU Xenial 16.04 LTS
    #   AMI_ID    => ami-245f7fcf
    #
    #   AMI shortcut (AMAZON MACHINE IMAGE)
    #
    # *******************************************
    us-east-1 = "ami-035be7bafff33b6b6"
  }
}

# ************************
# provider.tf
# ************************
provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region = "${var.AWS_REGION}"
}


# ************************
# instance.tf
# ************************
resource "aws_instance" "SELENIUM" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  tags { Name = "SELENIUM" }
  instance_type = "t2.micro"
  provisioner "local-exec" {
     command = "echo ${aws_instance.SELENIUM.private_ip} >> private_ips.txt"
  }
}
output "ip" {
    value = "${aws_instance.SELENIUM.public_ip}"
}
