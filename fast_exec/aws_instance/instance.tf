resource "aws_instance" "instance" {
  ami               = local.ec2_ami
  instance_type     = "t2.micro"
  availability_zone = "${local.region}a"
  key_name = aws_key_pair.key_pair.id
  user_data = file("install_docker.sh")

  tags = merge(var.common_tags, { Name = "Rust Server" })
}