resource "aws_ebs_volume" "bastion-volume" {
  availability_zone = var.volume-avail-zone
  size              = var.volume-size

  tags = {
    "Name" = "bastion-ebs-volume"
  }
}

resource "aws_ebs_snapshot" "bastion-snapshot" {
  volume_id = aws_ebs_volume.bastion-volume.id

  tags = {
    "Name" = "bastion-ebs-snapshot"
  }
}