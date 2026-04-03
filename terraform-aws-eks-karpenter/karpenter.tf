# 3. Karpenter Infrastructure
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws/modules/karpenter"
  version = "~> 20.0"

  cluster_name = module.eks.cluster_name

  # Enable Pod Identity for Karpenter
  enable_pod_identity             = true
  create_pod_identity_association = true

  # Attach policies for Karpenter to manage EC2
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

# 4. Install Karpenter via Helm
resource "helm_release" "karpenter" {
  namespace           = "karpenter"
  create_namespace    = true
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter"
  version             = "1.10.0" # Versão v1.10.0

  values = [
    jsonencode({
      settings = {
        clusterName       = module.eks.cluster_name
        clusterEndpoint   = module.eks.cluster_endpoint
        interruptionQueue = module.karpenter.queue_name
      }
    })
  ]
}

# 5. Karpenter Manifests (NodePool & EC2NodeClass)
# Usando Bottlerocket conforme solicitado
resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: Bottlerocket
      role: ${module.karpenter.node_iam_role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${var.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            kubernetes.io/cluster/${var.cluster_name}: "owned"
  YAML

  depends_on = [helm_release.karpenter]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1
    kind: NodePool
    metadata:
      name: default
    spec:
      template:
        spec:
          nodeClassRef:
            group: karpenter.k8s.aws
            kind: EC2NodeClass
            name: default
          requirements:
            - key: "karpenter.sh/capacity-type"
              operator: In
              values: ["on-demand", "spot"]
            - key: "kubernetes.io/arch"
              operator: In
              values: ["amd64", "arm64"]
      disruption:
        consolidationPolicy: WhenEmptyOrUnderutilized
        expireAfter: 720h
  YAML

  depends_on = [kubectl_manifest.karpenter_node_class]
}
