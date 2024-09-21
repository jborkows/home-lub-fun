# Microk8s cluster settings


## TODO
- [x] expose simple web app using load balancer
- [x] use dns from cloudflare for going through the load balancer
- [x] use ssl and traefik for the web app
- [-] expose dashboard -> failure with dashboard certificate
- [x] autodeploy after image in dockerhub is updated, partial success, I can add script and cronjob with adding annotation to deployment, failure to use argoCD or flux without github connection
- [ ] create pod using operator sdk which will change the image in deployment when someone hits it  
