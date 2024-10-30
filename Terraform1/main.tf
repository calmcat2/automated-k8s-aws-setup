resource "aws_instance" "k8s_master" {
  tags = {
    Name    = "k8s-master01"
    Service = "one-click-k8s"
    Env     = "dev"
    Role    = "k8s-master"
    Team    = "dev"
  }
  instance_type               = var.master_machine_type
  vpc_security_group_ids      = [aws_security_group.k8s_master.id]
  subnet_id                   = aws_subnet.public.id
  key_name                    = var.key_name
  ami                         = var.k8s_ami
  user_data                   = file("user_data/node_init.sh")
  associate_public_ip_address = true

}
resource "aws_instance" "k8s_workers" {
  count = var.node_nums
  tags = {
    Name    = "worker-${count.index}"
    Service = "one-click-k8s"
    Env     = "dev"
    Role    = "k8s-worker"
    Team    = "dev"
  }
  instance_type               = var.worker_machine_type
  vpc_security_group_ids      = [aws_security_group.k8s_worker.id]
  subnet_id                   = aws_subnet.public.id
  key_name                    = var.key_name
  ami                         = var.k8s_ami
  user_data                   = file("user_data/node_init.sh")
  associate_public_ip_address = true

}

resource "local_file" "inventory" {
  filename = "ansible/inventory.ini"
  content = templatefile("${path.module}/templates/inventory.tpl", {
    k8s-master_ips  = aws_instance.k8s_master.public_ip
    worker-node_ips = aws_instance.k8s_workers[*].public_ip
    }
  )
}
