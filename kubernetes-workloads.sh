# Source: https://gist.github.com/vfarcic/c49bd483d350187c9afdf7a6f646ef7b

##################################################
# Mastering Kubernetes: Dive into Workloads APIs #
##################################################

# Additional Info:
# - Kubernetes: https://kubernetes.io
# - N/A

#########
# Setup #
#########

git clone https://github.com/vfarcic/kubernetes-demo

cd kubernetes-demo

git pull

git checkout workloads

# Make sure that Docker is up-and-running. We'll use it to create a KinD cluster.

# Watch https://youtu.be/WiFLtcBvGMU if you are not familiar with Devbox. Alternatively, you can skip Devbox and install all the tools listed in `devbox.json` yourself.

devbox shell

kind create cluster --config kind.yaml

kubectl create namespace a-team

######################
# Pods in Kubernetes #
######################

cat pod/base.yaml

kubectl --namespace a-team apply --filename pod/base.yaml

kubectl --namespace a-team get pods

kubectl --namespace a-team delete pod silly-demo

kubectl --namespace a-team get pods

#############################
# ReplicaSets in Kubernetes #
#############################

cat replicaset/base.yaml

kubectl --namespace a-team apply --filename replicaset/base.yaml

kubectl tree --namespace a-team replicaset silly-demo

# Replace `[...]` with the name of one of the Pods (e.g., `silly-demo-7z7zt`)

kubectl --namespace a-team delete pod [...]

kubectl tree --namespace a-team replicaset silly-demo

diff replicaset/base.yaml replicaset/replicas.yaml

kubectl --namespace a-team apply \
    --filename replicaset/replicas.yaml

kubectl tree --namespace a-team replicaset silly-demo

diff replicaset/replicas.yaml replicaset/image.yaml

kubectl --namespace a-team apply --filename replicaset/image.yaml

kubectl tree --namespace a-team replicaset silly-demo

kubectl --namespace a-team get pods --output yaml | yq .

kubectl --namespace a-team delete pods \
    --selector app.kubernetes.io/name=silly-demo

kubectl tree --namespace a-team replicaset silly-demo

kubectl --namespace a-team get pods --output yaml | yq .

kubectl --namespace a-team delete \
    --filename replicaset/image.yaml

kubectl --namespace a-team get all

#############################
# Deployments in Kubernetes #
#############################

diff replicaset/image.yaml deployment/base.yaml

kubectl --namespace a-team apply --filename deployment/base.yaml

kubectl tree --namespace a-team deployment silly-demo

diff deployment/base.yaml deployment/image.yaml

kubectl --namespace a-team apply \
    --filename deployment/image.yaml \
    && viddy kubectl tree --namespace a-team \
    deployment silly-demo

# Stop watching by pressing `ctrl+c`.

####################################
# Deployment Volumes in Kubernetes #
####################################

cat deployment/volume.yaml

kubectl --namespace a-team apply \
    --filename deployment/volume.yaml

kubectl --namespace a-team get pods,persistentvolumes

kubectl --namespace a-team delete \
    --filename deployment/volume.yaml

##############################
# StatefulSets in Kubernetes #
##############################

cat statefulset/base.yaml

kubectl --namespace a-team apply --filename statefulset/base.yaml

viddy kubectl tree --namespace a-team statefulset silly-demo

# Stop watching by pressing `ctrl+c`.

kubectl --namespace a-team get pods,persistentvolumes

diff statefulset/base.yaml statefulset/replicas.yaml

kubectl --namespace a-team apply \
    --filename statefulset/replicas.yaml \
    && viddy kubectl tree --namespace a-team \
    statefulset silly-demo

# Stop watching by pressing `ctrl+c`.

kubectl --namespace a-team delete \
    --filename statefulset/replicas.yaml

############################
# DaemonSets in Kubernetes #
############################

diff deployment/base.yaml daemonset/base.yaml

kubectl --namespace a-team apply --filename daemonset/base.yaml

kubectl tree --namespace a-team daemonset silly-demo

kubectl get nodes

kubectl --namespace a-team delete --filename daemonset/base.yaml

######################
# Jobs in Kubernetes #
######################

cat job/base.yaml

kubectl --namespace a-team apply --filename job/base.yaml

kubectl tree --namespace a-team job silly-demo

kubectl --namespace a-team logs \
    --selector app.kubernetes.io/name=silly-demo

kubectl --namespace a-team delete --filename job/base.yaml

##########################
# CronJobs in Kubernetes #
##########################

cat cronjob/base.yaml

kubectl --namespace a-team apply --filename cronjob/base.yaml

kubectl --namespace a-team get cronjobs

viddy kubectl --namespace a-team get pods

# Stop watching by pressing `ctrl+c`.

kubectl --namespace a-team delete --filename cronjob/base.yaml

###########
# Destroy #
###########

kind delete cluster

git checkout main

exit
