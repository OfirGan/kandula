##################################################################################
# DATA SOURCE
##################################################################################

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = var.tfe_organization_name
    workspaces = {
      name = var.tfe_vpc_workspace_name
    }
  }
}

##################################################################################
# RDS
##################################################################################

resource "aws_db_subnet_group" "postgres_db_subnet_group" {
  name        = "${var.db_identifier_name}_subnet_group"
  description = "${var.db_identifier_name} Subnet Group"
  subnet_ids  = flatten(data.terraform_remote_state.vpc.outputs.public_subnets_ids)

  tags = {
    "Name" = "${var.db_identifier_name}-postgres-db-subnet-group"
  }
}

resource "aws_security_group" "postgres_db_sg" {
  name        = "${var.db_identifier_name}_postgres_db_sg"
  description = "${var.db_identifier_name} Postgres DB Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    iterator = port
    for_each = var.db_ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    "Name" = "${var.db_identifier_name}-postgres-db-sg"
  }
}

resource "aws_db_instance" "postgres_db_instance" {
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = var.db_engine_version
  identifier        = var.db_identifier_name
  instance_class    = var.db_instance_class
  username          = var.db_username
  password          = var.db_password

  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.postgres_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_db_subnet_group.name
  publicly_accessible    = true

  name = "kandula"

  tags = {
    "Name" = "${var.db_identifier_name}-postgres-db-instance"
  }
}

resource "aws_route53_record" "postgres_db_instance_dns" {
  zone_id = data.terraform_remote_state.vpc.outputs.route53_zone_zone_id
  name    = "rds.kandula"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_db_instance.postgres_db_instance.address}"]
}

