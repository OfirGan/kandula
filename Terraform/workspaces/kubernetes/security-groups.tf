
resource "aws_security_group" "k8s_ssh_sg" {
  name_prefix = "k8s_ssh_sg"
  description = "K8s SSH Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = var.cidr_blocks
  }

  tags = {
    "Name" = "k8s_ssh_sg"
  }
}

resource "aws_security_group" "k8s_node_exporter_sg" {
  name        = "k8s_node_exporter_sg"
  description = "K8s Node Exporter Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 9100
    to_port   = 9100
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  tags = {
    "Name" = "k8s_node_exporter_sg"
  }
}

resource "aws_security_group" "k8s_prometheus_sg" {
  name        = "k8s_prometheus_sg"
  description = "K8s Prometheus Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  tags = {
    "Name" = "k8s_prometheus_sg"
  }
}

resource "aws_security_group" "k8s_consul_sg" {
  name        = "k8s_consul_sg"
  description = "K8s Consul Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    iterator = port
    for_each = [8600, 8301, 8302]
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }

  dynamic "ingress" {
    iterator = port
    for_each = [8600, 8301, 8302]
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "udp"
      cidr_blocks = var.cidr_blocks
    }
  }

  tags = {
    "Name" = "k8s_consul_sg"
  }
}
