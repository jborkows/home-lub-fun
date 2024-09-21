curl -s https://fluxcd.io/install.sh | sudo bash
#from account with KUBECONFIG
flux install --namespace=flux-system --components-extra image-reflector-controller,image-automation-controller

