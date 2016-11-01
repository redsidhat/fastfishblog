data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/ebs/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["paravirtual"]
  }  
}

resource "aws_instance" "fastfish" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t1.micro"
    key_name = "ubuntu_forerunners"
    associate_public_ip_address = "true"
    tags {
        Name = "test"
    }
}
