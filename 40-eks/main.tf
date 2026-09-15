module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.project
  kubernetes_version = "1.33"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    metrics-server = {}
  }



  # Optional
  endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnet_id
  control_plane_subnet_ids = local.private_subnet_id

  create_node_security_group = false
  create_security_group      = false

  node_security_group_id = local.Node_sg_id
  security_group_id      = local.Control_plane_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    roboshop = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
    
      instance_types = [var.instance_type]

      min_size     = 2
      max_size     = 3
      desired_size = var.desired_nodes

      iam_role_additional_policies = {
        EBS = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicyV2"
        EFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        ECRReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }

      metadata_options = {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
      }

      capacity_type = "ON_DEMAND"
      disk_size     = 30
    }
  }


  tags = {
    Environment = var.environment
    Project     = "Roboshop"
  }
}