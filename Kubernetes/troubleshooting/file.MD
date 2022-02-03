To check the logs:
```
kubectl logs -f <pod_name>
kubectl logs -f <pod_name> -c <container_name> 
```

To check the container in the pod:
```
kubectl exec ${POD_NAME} -c ${CONTAINER_NAME} -- ${CMD} ${ARG1} ${ARG2} ... ${ARGN}
kubectl exec -it <pod-name> bash
```

If your container has previously crashed, you can access the previous container's crash log with:
```
kubectl logs --previous ${POD_NAME} ${CONTAINER_NAME}
```

Using kubectl logs --follow [Pod name], we can view logs from the pod in real time:
```
kubectl logs --follow podname
```

Restarting pods using kubectl:
```
kubectl restart {podname}
```

What to do with pods in CrashLoopBackoff status:
```
kubectl logs <pod> -c dependencies
```
How to tail all Kubernetes cluster events in real time:
```
kubectl get events -w --all-namespaces
```

Testing pull request