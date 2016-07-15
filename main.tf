provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "example" {
  ami           = "ami-0d729a60"
  instance_type = "t1.micro"
}
