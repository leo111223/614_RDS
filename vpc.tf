# VPC and Networking Resources
# Create a VPC, subnets, and related networking infrastructure for WordPress.

# VPC
resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "WordPress VPC"
  }
}