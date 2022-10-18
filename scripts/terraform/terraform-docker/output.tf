output "jenkins_endpoint" {
  value = formatlist("http://%s:%s/", aws_instance.DockerEC2.*.public_ip, "8080")
}
