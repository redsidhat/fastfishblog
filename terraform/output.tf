output "addresses" {
    value = ["${aws_instance.fastfish.*.public_ip}"]
}
