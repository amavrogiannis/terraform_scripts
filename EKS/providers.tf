provider "aws" {
  region  = "us-east-1" #Select the region that you want to deploy the resources. 
  profile = "ACG"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint // This is the data, pulling the endpoint name of the cluster.
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data) //To authenticate and access the cluster controller, you need authentication and this brings the certificate generated from EKS in base64decode.
  token                  = data.aws_eks_cluster_auth.cluster.token //This pulls the token. 
  version                = "~> 2.11.0"
}