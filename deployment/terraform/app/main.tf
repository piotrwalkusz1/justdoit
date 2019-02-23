resource "helm_repository" "helm-chart-repository" {
    name = "helm-chart-repository"
    url  = "https://piotrwalkusz1.github.io/helm-chart-repository"
}

resource "helm_release" "justdoit" {
  name      = "justdoit"
  repository = "${helm_repository.helm-chart-repository.metadata.0.name}"
  chart     = "justdoit"
}