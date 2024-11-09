resource "aws_vpc" "k8s" {
  tags = {
    Name = "k8s VPC"
  }
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.k8s.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "k8s-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.k8s.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "k8s-private"
  }
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id
}

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }

  tags = {
    Name = "k8s"
  }
}

resource "aws_route_table_association" "public_route" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.internet.id
}

#EIP for the master node
resource "aws_eip" "k8s_master" {
  depends_on=[aws_internet_gateway.k8s]
  instance = aws_instance.k8s_master.id
  domain   = "vpc"
}

resource "aws_security_group" "k8s_master" {
  name   = "k8s_master_nodes"  
  vpc_id = aws_vpc.k8s.id
  tags = {
    Name = "k8s-master-sg"
  }
}

resource "aws_security_group_rule" "k8s_master_outbound" {
  # Outbound
  security_group_id = aws_security_group.k8s_master.id
  type= "egress"
  from_port = 0
  to_port = 0
  protocol = "all"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "k8s_master_api" {
  # K8s API server access
  security_group_id = aws_security_group.k8s_master.id
  type= "ingress"
  from_port = 6443
  to_port = 6443
  protocol = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "k8s_master_master" {
  # Inbound from workers
  security_group_id = aws_security_group.k8s_master.id
  type= "ingress"
  from_port = 0
  to_port = 0
  protocol = "all"
  source_security_group_id = aws_security_group.k8s_master.id

}

resource "aws_security_group_rule" "k8s_master_worker" {
  # Inbound from workers
  security_group_id        = aws_security_group.k8s_master.id
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "all"
  source_security_group_id = aws_security_group.k8s_worker.id

}

resource "aws_security_group" "k8s_worker" {
  name   = "k8s_worker_nodes"
  vpc_id = aws_vpc.k8s.id

  # Inbound from master
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "all"
    security_groups = [aws_security_group.k8s_master.id]
  }

  # Inbound from other workers
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "all"
    self      = true
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-worker-sg"
  }
}
