#!/bin/bash
#
# A rough hack to install teh kubernetes GuestBook test application...
#

echo -e  "Apply the Redis Master Deployment..."

echo -e "	kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml\n"
	kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml


echo -e  "\n\nQuery the list of Pods to verify that the Redis Master Pod is running..."

echo -e "	kubectl get pods\n"
	kubectl get pods

	#kubectl logs -f POD-NAME


echo -e  "\n\nApply the Redis Master Service from the following redis-master-service.yaml file..."

echo -e "  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml\n"
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml


echo -e  "\n\nQuery the list of Services to verify that the Redis Master Service is running..."

echo -e "  kubectl get service\n"
  kubectl get service


echo -e  "\n\nApply the Redis Slave Deployment from the redis-slave-deployment.yaml file..."

echo -e "  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml\n"
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml


echo -e  "\n\nQuery the list of Pods to verify that the Redis Slave Pods are running..."

echo -e "  kubectl get pods\n"
  kubectl get pods


echo -e  "\n\nApply the Redis Slave Service from the following redis-slave-service.yaml file..."

echo -e "  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml\n"
  kubectl apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml


echo -e  "\n\nQuery the list of Services to verify that the Redis slave service is running..."

echo -e "  kubectl get services\n"
  kubectl get services


echo -e  "\n\nApply the frontend Deployment from the frontend-deployment.yaml file..."

echo -e "  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml\n"
  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml


echo -e  "\n\nQuery the list of Pods to verify that the three frontend replicas are running..."

echo -e "  kubectl get pods -l app=guestbook -l tier=frontend\n"
  kubectl get pods -l app=guestbook -l tier=frontend


echo -e  "\n\nApply the frontend Service from the frontend-service.yaml file..."

echo -e "  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml\n"
  kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml


echo -e  "\n\nQuery the list of Services to verify that the frontend Service is running..."

echo -e "  kubectl get services\n"
  kubectl get services


echo -e  "\n\nRun the following command to get the IP address for the frontend Service..."

echo -e "  kubectl get service frontend\n"
  kubectl get service frontend


echo -e  "\n\nRun the following command to scale up the number of frontend Pods ==> 5 replicas..."

echo -e "  kubectl scale deployment frontend --replicas=5\n"
  kubectl scale deployment frontend --replicas=5


echo -e  "\n\nQuery the list of Pods to verify the number of frontend Pods running..."

echo -e "  kubectl get pods\n"
  kubectl get pods

  sleep 15

echo -e "  kubectl get pods\n"
  kubectl get pods

  sleep 15

echo -e "  kubectl get pods\n"
  kubectl get pods


echo -e  "\n\nRun the following command to scale down the number of frontend Pods ==> 2 replicas..."

echo -e "  kubectl scale deployment frontend --replicas=2\n"
  kubectl scale deployment frontend --replicas=2

  sleep 15

echo -e "  kubectl get pods\n"
  kubectl get pods

  sleep 15

echo -e "  kubectl get pods\n"
  kubectl get pods

