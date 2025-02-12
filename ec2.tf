

# EC2 Instance
# Launches an EC2 instance for WordPress and sets up user data.

# AMI Data Source
data "aws_ami" "amazon_linux_2023" {
  most_recent = true    # Get the latest version of the AMI
  owners      = ["amazon"]  # Only accept Amazon-owned AMIs

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]  # Filter for Amazon Linux 2023 AMIs
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Hardware Virtual Machine AMIs only
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]  # EBS-backed instances only
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]  # 64-bit x86 architecture only
  }
}

# WordPress EC2 Instance
resource "aws_instance" "wordpress_ec2" {
  ami                    = data.aws_ami.amazon_linux_2023.id  # Use the AMI we filtered above
  instance_type          = "t2.micro"  # Free tier eligible instance type
  subnet_id              = aws_subnet.public_subnet.id  # Place in the public subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # Attach the EC2 security group
  key_name               = "LEO_AWS_KEY"  # Replace with your SSH key pair name

  # TODO: Pass in the 4 variables to the user data script
  #user_data = "${file("wp_rds_install.sh")}"   
  user_data = templatefile("wp_rds_install.sh", {
    DB_USERNAME = var.db_username
    DB_PASSWORD = var.db_password
    DB_NAME     = "wordpressdb"
    RDS_ENDPOINT = aws_db_instance.wordpress_db.endpoint
  })

  tags = {
    Name = "WordPress EC2 Instance"
  }
}