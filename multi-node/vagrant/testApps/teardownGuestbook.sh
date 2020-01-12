#!/bin/bash
#
# A rough hack to remove the kubernetes GuestBook test application...
#

echo -e "Deleting the Deployments and Services also deletes any running Pods. Use labels to delete multiple resources with one command..."

echo -e "\nRun the following commands to delete all Pods, Deployments, and Services...
      kubectl delete deployment -l app=redis
      kubectl delete service -l app=redis
      kubectl delete deployment -l app=guestbook
      kubectl delete service -l app=guestbook\n"

      kubectl delete deployment -l app=redis
      kubectl delete service -l app=redis
      kubectl delete deployment -l app=guestbook
      kubectl delete service -l app=guestbook

echo -e "kubectl get pods\n"
		kubectl get pods

		sleep 15

echo -e "kubectl get pods\n"
		kubectl get pods
		sleep 15

echo -e "kubectl get pods\n"
		kubectl get pods
