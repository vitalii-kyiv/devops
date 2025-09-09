resource "helm_release" "aws_ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = var.ebs_csi_chart_version
  namespace  = "kube-system"

  values = [
    yamlencode({
      controller = {
        tolerations = [
          { key = "node-role.kubernetes.io/control-plane", operator = "Exists", effect = "NoSchedule" }
        ]
      }
    })
  ]

  depends_on = [aws_eks_node_group.this]
}

