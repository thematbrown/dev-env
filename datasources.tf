data "aws_ami" "instance_ami" {
  most_recent = true
  owners = ["099720109477"]

  filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }
}