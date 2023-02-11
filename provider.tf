provider "aws" {
 region = var.region
}

provider "kubernetes" {
host = aws_eks_cluster.var.name.endpoint
cluster_ca_certificate = base64decode(aws_eks_cluster.var.name.certificate_authority.0.data)
exec {
api_version = "client.authentication.k8s.io/user"
args = ["eks", "get-token", "--cluster-name", local.cluster_name]
command = "aws"
 }
}