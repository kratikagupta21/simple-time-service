
resource "kubernetes_deployment" "time_service" {

  metadata {
    name = var.deployment_name
    namespace = var.deployment_namespace
    labels = {
      app = var.deployment_label
    }
  }

  spec {
    replicas = var.deployment_replicas

    selector {
      match_labels = {
        app = var.deployment_label
      }
    }

    template {
      metadata {
        labels = {
          app = var.deployment_label
        }
      }

      spec {
        container {
          name  = var.deployment_container_name
          image = var.deployment_image_name

          port {
            container_port = var.deployment_container_port
          }

          resources {
            limits = {
              cpu    = var.deployment_cpu_limit
              memory = var.deployment_memory_limit
            }
            requests = {
              cpu    = var.deployment_cpu_request
              memory = var.deployment_memory_request
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "time_service" {

  metadata {
    name = var.service_name
    namespace = var.deployment_namespace
  }

  spec {
    selector = {
      app = var.deployment_label
    }

    type = var.service_type

    port {
      port        = var.service_port
      target_port = var.service_target_port
    }
  }
}