#!/bin/bash
#
# A rouggh hack to install teh kubernetes GuestBook test application...
#

echo "Apply the Redis Master Deployment..."

read $x;
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml

read $x;

echo "Query the list of Pods to verify that the Redis Master Pod is running..."

read $x;
  kubectl get pods

  kubectl logs -f POD-NAME

read $x;

echo "Apply the Redis Master Service from the following redis-master-service.yaml file..."

read $x;
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml

read $x;
echo "Query the list of Services to verify that the Redis Master Service is running..."

read $x;
  kubectl get service

read $x;
 
echo "Apply the Redis Slave Deployment from the redis-slave-deployment.yaml file..."

read $x;
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml

read $x;
echo "Query the list of Pods to verify that the Redis Slave Pods are running..."

read $x;
  kubectl get pods

read $x;

echo "Apply the Redis Slave Service from the following redis-slave-service.yaml file..."

read $x;
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml

read $x;
echo "Query the list of Services to verify that the Redis slave service is running..."

read $x;
  kubectl get services

read $x;
echo "Apply the frontend Deployment from the frontend-deployment.yaml file..."

read $x;
  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml

read $x;
echo "Query the list of Pods to verify that the three frontend replicas are running..."

read $x;
  kubectl get pods -l app=guestbook -l tier=frontend

read $x;
echo "Apply the frontend Service from the frontend-service.yaml file..."

read $x;
  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml
read $x;

echo "Query the list of Services to verify that the frontend Service is running..."

read $x;
  kubectl get services
read $x;


echo "Run the following command to get the IP address for the frontend Service..."

read $x;
  kubectl get service frontend
read $x;

echo "Run the following command to scale up the number of frontend Pods..."

read $x;
  kubectl scale deployment frontend --replicas=5

read $x;
echo "Query the list of Pods to verify the number of frontend Pods running..."

read $x;
  kubectl get pods
read $x;

echo "Run the following command to scale down the number of frontend Pods..."

read $x;
  kubectl scale deployment frontend --replicas=2

read $x;
echo "Query the list of Pods to verify the number of frontend Pods running..."

read $x;
  kubectl get pods
read $x;


echo "Deleting the Deployments and Services also deletes any running Pods. Use labels to delete multiple resources with one command..."
read $x;

echo "Run the following commands to delete all Pods, Deployments, and Services..."
read $x;
      kubectl delete deployment -l app=redis
read $x;
      kubectl delete service -l app=redis
      kubectl delete deployment -l app=guestbook
      kubectl delete service -l app=guestbook
read $x;
		kubectl get pods
read $x;
