# module "eks_blueprints_kubernetes_addons" {
#   source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.0.2"

#   eks_cluster_id = module.eks_blueprints.eks_cluster_id

#   # EKS Addons
#   enable_amazon_eks_vpc_cni            = true
#   enable_amazon_eks_coredns            = true
#   enable_amazon_eks_kube_proxy         = true
#   enable_amazon_eks_aws_ebs_csi_driver = true

#   #K8s Add-ons
#   enable_argocd                       = false
#   enable_aws_for_fluentbit            = false
#   enable_aws_load_balancer_controller = true
#   enable_cluster_autoscaler           = true
#   enable_metrics_server               = true
#   enable_prometheus                   = false
# }