resource "aws_instance" "instance" {
  ami               = local.ec2_ami
  instance_type     = "t2.micro"
  availability_zone = "${local.region}a"
  key_name          = aws_key_pair.key_pair.id
  user_data         = file("install_packets.sh")
  subnet_id         = local.subnet

  vpc_security_group_ids = [aws_security_group.public.id]
  tags                   = merge(var.common_tags, { Name = "Rust Server" })
}

##################
## Public Access
##################
resource "aws_security_group" "public" {
  name        = "access-public-host-test"
  description = "internet source access"
  vpc_id      = local.vpc_id

  tags = merge(var.common_tags, { Name = "access-public-host-test" })
}

resource "aws_security_group_rule" "ssh_from_net" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}
##################
# allowed traffic to net
##################
resource "aws_security_group_rule" "allowed_traffic_to_net" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}

output "Ec2-Master" {
  value = {
    "EC2" : "Access --- ssh -i '${aws_key_pair.key_pair.key_name}.pem' ubuntu@${aws_instance.instance.public_ip}"
  }
}