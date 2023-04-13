#Create EC2 Instance - Splunk
resource "aws_instance" "splunk-instance" {
  ami           = "ami-0dc9af62644331dc0"
  instance_type = "c4.4xlarge"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
    volume_type = "gp2"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update
                sudo yum install docker -y
                sudo usermod -a -G docker ec2-user
                id ec2-user
                newgrp docker
                sudo systemctl enable docker.service
                sudo systemctl start docker.service
                docker pull splunk/splunk:latest
                docker run -d -p 8000:8000 -e SPLUNK_START_ARGS='--accept-license' -e SPLUNK_PASSWORD='CantseeMe!' splunk/splunk:latest
                EOF

  tags = {
    Name = "Kevin_Mathew_splunkInstance"
  }
}

#Create EC2 Instance - web
/*resource "aws_instance" "web" {
  ami               = "ami-0a695f0d95cefc163"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "main-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.eni.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your first web server > /var/www/html/index.html'
                EOF

  tags = {
    Name = "Web Server"
  }
}
*/
