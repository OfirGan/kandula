
resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_security_group" "node_exporter_k8s_sg" {
  name        = "node_exporter_k8s_sg"
  description = " Node Exporter Security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 9100
    to_port   = 9100
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_security_group" "kube_state_metrics_k8s_sg" {
  name        = "kube_state_metrics_k8s_sg"
  description = "Kube State Metrics Security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_security_group" "consul_k8s_sg" {
  name        = "consul_k8s_sg"
  description = "Consul K8S Security group"
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
}
