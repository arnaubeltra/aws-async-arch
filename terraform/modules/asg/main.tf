resource "aws_launch_template" "name" {
  name = var.launch_template_name
  description = var.launch_template_description
  image_id = var.image_id
  instance_type = var.instance_type
  key_name = var.key_pair

  block_device_mappings {
    device_name = var.disk_device_name
    ebs {
      volume_size = 30
    }
  }
}