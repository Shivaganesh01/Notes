Kubernetes

It is used to automate the management, deployment and scaling of the containers.

Advantages:
Package up the application and something else manage it for us (container orchestration)
Scaling of containers
Eliminate single point of failure
Rollout new updates
Robust networking and persistent storage options

Features:
Service discovery
Load balancing
Storage orchestration
Automate rollouts/rollback
self healingsecret and configuration management
horizontal scaling

Master: has API Server, store(etcd), controller manager, scheduler
Nodes: kubelet communicate, kube-proxy for ip address, runtime(docker, rkt)

Commands

kubectl

kubectl version
kubectl cluster-info
kubectl get all
kubectl run [conatiner-name] --image=[image]
kubectl port-forward [pod] [ports]
kubectl expose
kubectl create [resource]
kubectl apply [resource]

Pods:
smallest unit in kubernets object model
environment for containers
orgainze application parts into pods
pods ip, volumes, meory are shared across containers
scale horizontally by adding pod replicas
pod live and die but never come back to life

Pods containers share same network namespace(ip address/port)
same loopback network interface(localhost)
container processes within pod should bind to different ports
pods do not span nodes

Running a pod
1. kubectl run command
2. kubectl create/apply command with yaml files

Expose a pod port
kubectl port-forward [name-of-pod] 8080:80    8080 external, 80 internal

delete
kubectl delete pod nameofpod
or delete the deployment

kubectl delete deployment [name-of-deployment]

kubectl create -d deployment.yaml --dry-run --vaidate=true  trial create and validate the yaml

kubectl create -f .yaml --saveconfig
kubectl describe
kubectl apply
kubectl exec
kubectl edit
kubectl delete

health check:
Probe is a diagnostic performed periodically by kubelet on a container
Liveness-healthy and running as expected, Readiness-if a pod should receive requests
Failed pod conatiners are recreated always(restartPolicy defaults to always)

These can be done by
ExecAction
TCPSocketAction
HTTPGetAction

Results: success, failure, unknown



Replica sets: declarative way to manage pods. They act as pod controller
They have self healing mechainsm, ensure requested no. of pods available, provide fault tolrance, scaling, relies on pod template

Deployment: declarative way to manage pods using replica sets
pods are managed by replicasets.
scales replica sets which scales pods
provides zero downtime updates
rollback facility
provides unique labels for replicasets, pods

kubectl create
kubectl apply
kubectl get deployment --show-labels
kubectl get deployment -l app-nginx

kubectl delete deployment [deployment-name]
update yaml or kubectl scale deployment [name] --replicas=5

kubectl scale -f .yaml --replicas=5

spec:
    replicas: 3
    selector:
        ...

Deployment options:

Zero downtime deployment without endusers noticing it.

Rolling updates
Blue-green deployment
Canary deployment
Rollbacks



Services:

Pods are mortal so we cant relay on the pod ip address. when horizontally scaled each pod will get new ip address and pods get ip address only after it is scheduled(no ahead of time we can know ip address of pod)

Services abstarct pod ip address from consumer
Load balance
relies on labels to associate a service with pod
node's kube-proxy creates a virtual ip address for a service
Layer 4 (tcp/udp over IP)
services are not ephemeral
create a endpoint between pod and service

Service Types:
4 TYPES
ClusterIP: expose service on cluster-internal IP(default). Only pods within cluster can talk to service, allows pods to talk each other
NodePort: Expose the service on each node's IP at a static port(default 30000-32767), each node proxies allocated port
LoadBalancer: provision a external IP to act as  load balancer for the service, exposes service externally. NodePort and clusterip services created internally  , each node proxies the allocated port, combines with cloud providers load balancer more powerful
ExternalName: maps a service to a dns name. Proxy for an external service(external service details are hidden from cluster)

To check a pod can call other pod
kubectl exec [pod-name] --curl -s http://pod-ip


Storage options in kubernetes:
Volumes: emptyDir(ephemeral storage), hostPath, nfs, configMap/secrets, cloud, persistentvolumeclaims
PersistentVolumes: Cluster wide storage unit provisioned by administrator for lifecycle independent of pods
PersistentVolumesClaim: Request for a stoarge unit(pv)
StorageClasses: It is a type of storage template that can be used to dynamically provision storage

How data is stored and shared - Using volumes
Volumes can be used to hold data and state for pods and containers
A Pod can have multiple volumes attached to it.
Containers relay on mountpath to access the volume



ConfigMaps and Secrets
ConfigMaps provides a way to store config information and pass it to containers
Provide using a file, command line, configMap manifest

kubectl create configmap [name] --from-file=[path-to-file]
                                --from-env-file
                                --from-literal
kubectl create -f .yaml         manifest file

Secret: A secret is an object that containes small amount of sensitive data such as key, passowrd, certificates or token.
Stored in tmpfs not on disk of node.