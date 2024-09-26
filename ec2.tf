resource "aws_instance" "web" {
  ami           = "ami-0b4f379183e5706b9" #devops-practice
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = "Provisioners"
  }

  provisioner "local-exec" {
    command = "echo this will execute at the time of destroy, you can trigger other system like gmail and sending alerts"

  }

  provisioner "local-exec" {
    command = "echo the server IP address is: ${self.private_ip} > inventory" #self = aws_instance.web
  }
#   provisioner "local-exec" {
#     command = "ansible-playbook -i inventory web.yaml" 
#}
  provisioner "local-exec" {
    when = destroy
    command = "echo this will execute at the time of destroy, you can trigger other system like gmail and sending alerts"
    
  }

  connection {
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = self.public_ip
   }

   provisioner "remote-exec" {
     inline = [ 
        "echo 'this is from remote exec' > /tmp/remote.txt",
        "sudo yum install nginx -y",
        "sudo systemctl start nginx"
      ]
   }

}

resource "aws_security_group" "web" {
  name = "provisioners"
  
  ingress {
    description = "allow all ports"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow 80 port"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "provisioners"
  }
}
