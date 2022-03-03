terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile    = "default"
  region     = "eu-west-2"
  access_key = <access_key>
  secret_key = <secret_key>
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = <public_key_of_the_machine_this_script_will_run>

}

resource "aws_instance" "gitlab" {
  ami           = "ami-0015a39e4b7c0966f"
  instance_type = "t2.xlarge"
  key_name      = "deployer-key"
  vpc_security_group_ids = <gitlab_specific_security_group_id>

  tags = {
    Name = "GitLab"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} && sleep 60s && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${self.public_ip}, playbook.yml"
  }
}

