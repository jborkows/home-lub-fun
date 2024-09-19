kubectl apply -f metallb-config.yaml
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.yaml
kubectl create secret generic dns-api-token --from-literal=DNS_API_TOKEN=<api-token> -n traefik
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
kubectl create namespace traefik
helm install traefik traefik/traefik --namespace=traefik  -f traefic-values.yaml

