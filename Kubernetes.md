# Kubernetes

Katakoda: It provides a free, in-browser Kubernetes environment.

Pod: A Kubernetes Pod is a group of one or more Containers, tied together for the purposes of administration and networking. A Pod is the basic execution unit of a Kubernetes application. Each Pod represents a part of a workload that is running on your cluster.

Deployment: A Kubernetes Deployment checks on the health of your Pod and restarts the Pod’s Container if it terminates. Deployments are the recommended way to manage the creation and scaling of Pods.

kubectl commands:

kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

kubectl get deployments

kubectl get pods

kubectl get events - view cluster events

Expose the Pod to the public internet using the kubectl expose command:
kubectl expose deployment hello-node --type=LoadBalancer --port=8080



minikube addons list
minikube addons enable metrics-server
kubectl get pod,svc -n kube-system
minikube addons disable metrics-server
kubectl delete service hello-node
kubectl delete deployment hello-node
minikube stop
minikube delete


Kubernetes cluster consists of 2 types of resources

1. The Matser coordinates the cluster: The master coordinates all activities in your cluster, such as scheduling applications, maintaining applications' desired state, scaling applications, and rolling out new updates.
2. Nodes are the workers that runs applications: A node is a VM or a physical computer that serves as a worker machine in a Kubernetes cluster. Each node has a Kubelet, which is an agent for managing the node and communicating with the Kubernetes master. The node should also have tools for handling container operations, such as Docker or rkt. A Kubernetes cluster that handles production traffic should have a minimum of three nodes.

Every Kubernetes Node runs at least:

Kubelet, a process responsible for communication between the Kubernetes Master and the Node; it manages the Pods and the containers running on a machine.
A container runtime (like Docker, rkt) responsible for pulling the container image from a registry, unpacking the container, and running the application.
Containers should only be scheduled together in a single Pod if they are tightly coupled and need to share resources such as disk.




Minikube:
Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a Virtual Machine (VM) on your laptop for users looking to try out Kubernetes or develop with it day-to-day.

minikube version - To check installation

minikube start - To start the cluster

Kubectl: 
Kubernetes command line interface. To interact with Kubernetes Cluster.

kubectl version

kubectl cluster-info

kubectl get nodes

A Kubernetes service deployment has, at least, two parts. A replication controller and a service.

The replication controller defines how many instances should be running, the Docker Image to use, and a name to identify the service. Additional options can be utilized for configuration and discovery.
kubectl get rc

A Kubernetes service is a named load balancer that proxies traffic to one or more containers. The proxy works even if the containers are on different nodes.

Module 2: Deploy an App

kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1

kubectl get deployments

kubectl proxy
curl http://localhost:8001/version
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

Pods: A Pod is a Kubernetes abstraction that represents a group of one or more application containers (such as Docker or rkt), and some shared resources for those containers. Those resources include:

Shared storage, as Volumes
Networking, as a unique cluster IP address
Information about how to run each container, such as the container image version or specific ports to use

Module 3: Explore your app
kubectl describe pods

curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/

kubectl logs $POD_NAME

kubectl exec $POD_NAME env
kubectl exec -ti $POD_NAME bash


Module 4: Expose Your App
Kubernetes Service:
A Kubernetes Service is an abstraction layer which defines a logical set of Pods and enables external traffic exposure, load balancing and service discovery for those Pods. The set of Pods targeted by a Service is usually determined by a LabelSelector. 
Although each Pod has a unique IP address, those IPs are not exposed outside the cluster without a Service. Services allow your applications to receive traffic. Services can be exposed in different ways by specifying a type in the ServiceSpec:

ClusterIP (default) - Exposes the Service on an internal IP in the cluster. This type makes the Service only reachable from within the cluster.
NodePort - Exposes the Service on the same port of each selected Node in the cluster using NAT. Makes a Service accessible from outside the cluster using <NodeIP>:<NodePort>. Superset of ClusterIP.
LoadBalancer - Creates an external load balancer in the current cloud (if supported) and assigns a fixed, external IP to the Service. Superset of NodePort.
ExternalName - Exposes the Service using an arbitrary name (specified by externalName in the spec) by returning a CNAME record with the name. No proxy is used. This type requires v1.7 or higher of kube-dns.

Step 1 Create a new service:
kubectl get pods
kubectl get services
kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080
kubectl describe services/Kubernetes-bootcamp
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT
curl $(minikube ip):$NODE_PORT

Step 2: Using labels
kubectl describe deployment
kubectl get pods -l run=kubernetes-bootcamp
kubectl get services -l run=kubernetes-bootcamp
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME
kubectl label pod $POD_NAME app=v1
kubectl describe pods $POD_NAME
kubectl get pods -l app=v1

Step 3: Deleting a Service 
kubectl delete service -l run=kubernetes-bootcamp



Module 5: Scaling an Application

Scaling is accomplished by changing the number of replicas in a Deployment
To create from the start a Deployment with multiple instances using the --replicas parameter

kubectl scale deployments/kubernetes-bootcamp --replicas=4
kubectl get deployments
kubectl get pods -o wide
kubectl describe deployments/kubernetes-bootcamp

Step 2: Load Balancing
export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')
echo NODE_PORT=$NODE_PORT
curl $(minikube ip):$NODE_PORT - call this multiple time and see different pods are called each time

Step 3: Scale Down
kubectl scale deployments/kubernetes-bootcamp --replicas=2
kubectl get deployments
kubectl get pods -o wide

Module 6: Performing a Rolling Update
Rolling updates allow Deployments' update to take place with zero downtime by incrementally updating Pods instances with new ones. The new Pods will be scheduled on Nodes with available resources.
If a Deployment is exposed publicly, the Service will load-balance the traffic only to available Pods during the update.
In Kubernetes, updates are versioned and any Deployment update can be reverted to a previous (stable) version.

Rolling updates allow the following actions:

Promote an application from one environment to another (via container image updates)
Rollback to previous versions
Continuous Integration and Continuous Delivery of applications with zero downtime

kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=jocatalin/kubernetes-bootcamp:v2
kubectl set image deployments/kubernetes-bootcamp kubernetes-bootcamp=gcr.io/google-samples/kubernetes-bootcamp:v10
Confirming update
kubectl rollout status deployments/kubernetes-bootcamp

Rollback:
kubectl rollout undo deployments/kubernetes-bootcamp


Katakoda Courses:

1. Launch Single Node Kubernetes Cluster

Install minikube
    minikube version
Start the Cluster
minikube start --wait=false
kubectl cluster-info
kubectl get nodes
kubectl expose deployment first-deployment --port=80 --type=NodePort\
export PORT=$(kubectl get svc first-deployment -o go-template='{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}')
echo "Accessing host01:$PORT"
curl host01:$PORT
minikube addons enable dashboard
kubectl apply -f /opt/kubernetes-dashboard.yaml
kubectl get pods -n kubernetes-dashboard -w

2. Launch a multi-node cluster using Kubeadm - Getting started with kubeadm
   Step 1 - Initialise Master
kubeadm init --token=102952.1a7dd4cc8d1f4cc5 --kubernetes-version $(kubeadm version -o short)
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

Step 2 - Deploy Container Networking Interface (CNI)
cat /opt/weave-kube
kubectl apply -f /opt/weave-kube
kubectl get pod -n kube-system

Step 3 - Join Cluster
kubeadm token list

Second window
kubeadm join --discovery-token-unsafe-skip-ca-verification --token=102952.1a7dd4cc8d1f4cc5 172.17.0.34:6443

Step 4 - View Nodes
kubectl get nodes

Step 5 - Deploy Pod
kubectl create deployment http --image=katacoda/docker-http-server:latest
kubectl get pods

Second window docker ps | grep docker-http-server

Step 6 - Deploy Dashboard
kubectl apply -f dashboard.yaml
kubectl get pods -n kube-system

A ServiceAccount is required to login. A ClusterRoleBinding is used to assign the new ServiceAccount (admin-user) the role of cluster-admin on the cluster.
cat <<EOF | kubectl create -f - 
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF

Get the token:
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

For production, instead of externalIPs, it's recommended to use kubectl proxy to access the dashboard.


Deploy Containers Using Kubectl;

1. Launch the cluster
minikube start --wait=false
kubectl get nodes

2. kubectl run
kubectl run http --image=katacoda/docker-http-server:latest --replicas=1
kubectl get deployments
kubectl describe deployment http

3. kubectl expose
kubectl expose deployment http --external-ip="172.17.0.115" --port=8000 --target-port=80
curl http://172.17.0.115:8000

Run and expose in a single command
kubectl run httpexposed --image=katacoda/docker-http-server:latest --replicas=1 --port=80 --hostport=8001

this exposes the Pod via Docker Port Mapping. As a result, you will now see the service listed using
kubectl get svc
. The Pause container is responsible for defining the network for the Pod. Other containers in the pod share the same network namespace. This improves network performance and allow multiple containers to communicate over the same network interface..

4. Scale the application 
kubectl scale --replicas=3 deployment http
kubectl get pods
kubectl describe svc http



Deploy Containers Using YAML

1. Create Deployment
kubectl create -f deployment.yaml

deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp1
  template:
    metadata:
      labels:
        app: webapp1
    spec:
      containers:
      - name: webapp1
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80

kubectl get deployment
kubectl describe deployment webapp1

2. Create Service
Kubernetes has powerful networking capabilities that control how applications communicate. These networking configurations can also be controlled via YAML.
kubectl create -f service.yaml
service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp1-svc
  labels:
    app: webapp1
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30080
  selector:
    app: webapp1

kubectl get svc
kubectl describe svc webapp1-svc

3. Scale Deployment
Update the deployment.yaml file to increase the number of instances running.
replicas: 4
kubectl apply -f deployment.yaml

kubectl get deployment
kubectl get pods


Networking Introduction

Cluster IP is the default approach when creating a Kubernetes Service. The service is allocated an internal IP that other components can use to access the pods.

By having a single IP address it enables the service to be load balanced across multiple Pods.
Target ports allows us to separate the port the service is available on from the port the application is listening on. TargetPort is the Port which the application is configured to listen on. Port is how the application will be accessed from the outside.

NodePort exposes the service on each Node’s IP via the defined static port. No matter which Node within the cluster is accessed, the service will be reachable based on the port number defined.

External IPs
Another approach to making a service available outside of the cluster is via External IP addresses.

When running in the cloud, such as EC2 or Azure, it's possible to configure and assign a Public IP address issued via the cloud provider. This will be issued via a Load Balancer such as ELB. This allows additional public IP addresses to be allocated to a Kubernetes cluster without interacting directly with the cloud provider.


Create Ingress Routing:
Kubernetes have advanced networking capabilities that allow Pods and Services to communicate inside the cluster's network. An Ingress enables inbound connections to the cluster, allowing external traffic to reach the correct Pod.

Ingress enables externally-reachable urls, load balance traffic, terminate SSL, offer name based virtual hosting for a Kubernetes cluster


deployment.yaml
```yaml

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webapp1
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp1
    spec:
      containers:
      - name: webapp1
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webapp2
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp2
    spec:
      containers:
      - name: webapp2
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: webapp3
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: webapp3
    spec:
      containers:
      - name: webapp3
        image: katacoda/docker-http-server:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: webapp1-svc
  labels:
    app: webapp1
spec:
  ports:
  - port: 80
  selector:
    app: webapp1
---
apiVersion: v1
kind: Service
metadata:
  name: webapp2-svc
  labels:
    app: webapp2
spec:
  ports:
  - port: 80
  selector:
    app: webapp2
---
apiVersion: v1
kind: Service
metadata:
  name: webapp3-svc
  labels:
    app: webapp3
spec:
  ports:
  - port: 80
  selector:
    app: webapp3
```




Liveness and Readiness Healthchecks

Readiness Probes checks if an application is ready to start processing traffic. This probe solves the problem of the container having started, but the process still warming up and configuring itself meaning it's not ready to receive traffic.

Liveness Probes ensure that the application is healthy and capable of processing requests.

```yml
kind: List
apiVersion: v1
items:
- kind: ReplicationController
  apiVersion: v1
  metadata:
    name: frontend
    labels:
      name: frontend
  spec:
    replicas: 1
    selector:
      name: frontend
    template:
      metadata:
        labels:
          name: frontend
      spec:
        containers:
        - name: frontend
          image: katacoda/docker-http-server:health
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 1
            timeoutSeconds: 1
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 1
            timeoutSeconds: 1
- kind: ReplicationController
  apiVersion: v1
  metadata:
    name: bad-frontend
    labels:
      name: bad-frontend
  spec:
    replicas: 1
    selector:
      name: bad-frontend
    template:
      metadata:
        labels:
          name: bad-frontend
      spec:
        containers:
        - name: bad-frontend
          image: katacoda/docker-http-server:unhealthy
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 1
            timeoutSeconds: 1
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 1
            timeoutSeconds: 1
- kind: Service
  apiVersion: v1
  metadata:
    labels:
      app: frontend
      kubernetes.io/cluster-service: "true"
    name: frontend
  spec:
    type: NodePort
    ports:
    - port: 80
      nodePort: 30080
    selector:
      app: frontend
```
kubectl get pods --selector="name=bad-frontend"

To crash the service
pod=$(kubectl get pods --selector="name=frontend" --output=jsonpath={.items..metadata.name})
kubectl exec $pod -- /usr/bin/curl -s localhost/unhealthy

kubectl get pods --selector="name=frontend"


Deploy Docker Compose with Kompose

Kompose is a tool to help users familiar with docker-compose move to Kubernetes. It takes a Docker Compose file and translates it into Kubernetes resources.

To deploy kombose https://github.com/kubernetes/kompose/releases
curl -L https://github.com/kubernetes/kompose/releases/download/v1.9.0/kompose-linux-amd64 -o /usr/bin/kompose && chmod +x /usr/bin/kompose

As with Docker Compose, Kompose allows the Images to be deployed using a single command of 
kompose up

Kompose also has the ability to take existing Compose files and generate the related Kubernetes Manifest files.

The command `kompose convert` will generate the files

kubectl apply -f frontend-service.yaml,redis-master-service.yaml,redis-slave-service.yaml,frontend-deployment.yaml,redis-master-deployment.yaml,redis-slave-deployment.yaml

Kompose also supports different Kubernetes distributions, for example OpenShift.

kompose --provider openshift convert

By default, Kompose generates YAML files. It's possible to generate JSON based files by specifying the -j parameter.

kompose convert -j

Play with Kubernetes Classroom:

1st Terminal
Initialize the cluster
  kubeadm init --apiserver-advertise-address $(hostname -i)

2nd Terminal
kubeadm join 192.168.0.38:6443 --token 1skm0u.9wcnzjwz1gp39agr \
    --discovery-token-ca-cert-hash sha256:b7ef344cf9fb509da7c28c81dc1cef8cd379e013a2b24a43f5cf1143c27006da

1st Terminal
kubectl apply -n kube-system -f \
    "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 |tr -d '\n')"