packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

source "amazon-ebs" "linux" {
  ami_name      = "learn-packer-linux-aws-jenkins-test-eric-2"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0feffd3727846f4a7"
  ssh_username  = "ec2-user"
}

build {
  name    = "learn-packer-linux-aws-simon-test"
  sources = ["source.amazon-ebs.linux"]

  provisioner "shell" {
    execute_command= "{{.Vars}} bash '{{.Path}}'"
    inline = [
      "sudo yum update",
      "sudo amazon-linux-extras install epel -y",
      "sudo yum install --enablerepo=epel ufw -y",
      "sudo amazon-linux-extras enable nginx1",
      "sudo yum install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo ufw allow proto tcp from any to any port 22,80,443",
      "echo 'y' | sudo ufw enable"
    ]
  }

  post-processor "vagrant" {}
  post-processor "compress" {}
}
