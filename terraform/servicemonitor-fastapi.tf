resource "kubernetes_manifest" "fastapi_servicemonitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "fastapi"
      namespace = kubernetes_namespace_v1.monitoring.metadata[0].name
      labels = {
        release = "kube-prometheus-stack"
      }
    }
    spec = {
      selector = {
        matchLabels = {
          app = "fastapi"
        }
      }
      namespaceSelector = {
        matchNames = ["observability"]
      }
      endpoints = [
        {
          port     = "http"
          path     = "/metrics"
          interval = "15s"
        }
      ]
    }
  }
}
