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

resource "aws_eip" "k8s_master" {
  depends_on=[aws_internet_gateway.k8s]
  instance = aws_instance.k8s_master.id
  domain   = "vpc"
}

resource "aws_security_group" "k8s_master" {
  name   = "k8s_master_nodes"  
  vpc_id = aws_vpc.k8s.id
  revoke_rules_on_delete = true
  tags = {
    Name = "k8s-master-sg"
  }
}

#outbound rule for master nodes
resource "aws_vpc_security_group_egress_rule" "k8s_master_outbound" {
  # Outbound
  security_group_id = aws_security_group.k8s_master.id
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# Access to port 6443 temporarily open to all, may need manual change since the end users' IP is unknown
resource "aws_vpc_security_group_ingress_rule" "k8s_master_api" {
  security_group_id = aws_security_group.k8s_master.id

  #referenced_security_group_id = aws_security_group.k8s_worker.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 6443
  ip_protocol = "tcp"
  to_port     = 6443
}

# Inbound traffic from other masters and self
resource "aws_vpc_security_group_ingress_rule" "k8s_master_master" {
  security_group_id = aws_security_group.k8s_master.id

  referenced_security_group_id = aws_security_group.k8s_master.id
  ip_protocol = "-1"

}

# Inbound traffic from workers for flannel networking
resource "aws_vpc_security_group_ingress_rule" "k8s_master_worker_flannel1" {
  security_group_id = aws_security_group.k8s_master.id

  referenced_security_group_id = aws_security_group.k8s_worker.id
  ip_protocol = "udp"
  from_port = 8285
  to_port = 8285

}
resource "aws_vpc_security_group_ingress_rule" "k8s_master_worker_flannel2" {
  security_group_id = aws_security_group.k8s_master.id

  referenced_security_group_id = aws_security_group.k8s_worker.id
  ip_protocol = "udp"
  from_port = 8472
  to_port = 8472

}

resource "aws_security_group" "k8s_worker" {
  name   = "k8s_worker_nodes"  
  vpc_id = aws_vpc.k8s.id
  revoke_rules_on_delete = true
  tags = {
    Name = "k8s-worker-sg"
  }
}

#outbound rule for worker nodes
resource "aws_vpc_security_group_egress_rule" "k8s_worker_outbound" {
  security_group_id = aws_security_group.k8s_worker.id
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# Inbound traffic from other workers and self
resource "aws_vpc_security_group_ingress_rule" "k8s_worker_worker" {
  security_group_id = aws_security_group.k8s_worker.id

  referenced_security_group_id = aws_security_group.k8s_worker.id
  ip_protocol = "-1"

}

# Inbound traffic from masters 
resource "aws_vpc_security_group_ingress_rule" "k8s_worker_master" {
  security_group_id = aws_security_group.k8s_worker.id

  referenced_security_group_id = aws_security_group.k8s_master.id
  ip_protocol = "-1"

}