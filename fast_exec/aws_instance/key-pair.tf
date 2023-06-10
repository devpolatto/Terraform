resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = local.instance_name
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./${aws_key_pair.key_pair.key_name}.pem"
  }

  tags = merge(var.common_tags, { Name = "key-pair - ${local.instance_name}" })
}