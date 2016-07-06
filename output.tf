output "public_ip" {
  value = "${join("," , aws_instance.training_instance.*.public_ip)}"
}

output "public_dns" {
  value = "${join("," , aws_instance.training_instance.*.public_dns)}"
}
output "dns_record" {
 value = "${dnsimple_record.foobar.hostname}"

}
