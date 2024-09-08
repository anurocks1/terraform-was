resource "aws_kms_key" "msk_kms_key" {
  description             = "KMS key for encrypting MSK secrets"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "msk_key_alias" {
  name          = "alias/msk_key"
  target_key_id = aws_kms_key.msk_kms_key.id
}

resource "aws_secretsmanager_secret" "kafka_password" {
  name        = "AmazonMSK_SEI_Secret"
  description = "Password for Kafka authentication"
  kms_key_id  = aws_kms_key.msk_kms_key.arn  
}

resource "aws_msk_cluster" "kafka" {
  cluster_name           = "sei-msk-cluster"
  kafka_version          = "3.6.0"  
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"  
    client_subnets  = ["subnet-0a83906c","subnet-ae0ae8e5","subnet-92acf0c8"]  
    security_groups = [aws_security_group.msk_security_group.id]
    storage_info {
      ebs_storage_info {
        volume_size = 1  
    }
  }
  }

client_authentication {
    sasl {
      iam = false
      scram = true
    }
  }
  encryption_info {
  encryption_in_transit {
    client_broker = "TLS"
    in_cluster    = true
  }
}
}

resource "aws_security_group" "msk_security_group" {
  name   = "msk-security-group"
  vpc_id = "vpc-0ab91873"  
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


