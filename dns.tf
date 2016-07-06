#

# DO NOT DELETE THESE LINES!

#

# Your DNSimple email is:

#

#     sethvargo+terraform@gmail.com

#

# Your DNSimple token is:

#

#     sRFRF5ltrFulE4AB6iRgiRshoIWqiuUF

#

# Your Identity is:

#

#     totaljobs-c51ce410c124a10e0db5e4b97fc2af39

#
provider "dnsimple" {
  token = "sRFRF5ltrFulE4AB6iRgiRshoIWqiuUF"
  email = "sethvargo+terraform@gmail.com"
}

resource "dnsimple_record" "foobar" {
    domain = "terraform.rocks"
    name = "training_instance_long_thing_goes_here"
    value = "${aws_instance.training_instance.0.public_ip}"
    type = "A"
    ttl = 3600
}

