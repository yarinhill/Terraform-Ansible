output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master.public_ip
}


output "Jenkins-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.jenkins-worker :
    instance.id => instance.public_ip
  }
}

output "LB-DNS-NAME" {
  value = aws_lb.jenkins-app-lb.dns_name
}
