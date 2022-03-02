resource "kubernetes_secret_v1" "test" {
  metadata {
    name = "basic-auth"
  }

  data = {
    username = "secret_value_user"
    password = "secret_value_pass"
  }

  type = "kubernetes.io/basic-auth"
}
