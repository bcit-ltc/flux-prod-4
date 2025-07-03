#!/usr/bin/env bash


NAMESPACE="longhorn-system"


# Remove finalizers from all Longhorn volumes
#
for finalizers in $(kubectl get volumes.longhorn.io -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n'); do
  kubectl -n ${NAMESPACE} patch volumes.longhorn.io $finalizers --type json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
done


# Remove finalizers from all Longhorn snapshots
#
for finalizers in $(kubectl get snapshot.longhorn.io -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n'); do
  kubectl -n ${NAMESPACE} patch snapshot.longhorn.io $finalizers --type json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
done


# Remove finalizers from all Longhorn replicas
#
for finalizers in $(kubectl get replicas.longhorn.io -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n'); do
  kubectl -n ${NAMESPACE} patch replicas.longhorn.io $finalizers --type json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
done


# Remove finalizers from all Longhorn engines
#
for finalizers in $(kubectl get engines.longhorn.io -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n'); do
  kubectl -n ${NAMESPACE} patch engines.longhorn.io $finalizers --type json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
done


# Remove finalizers from all Longhorn nodes
#
for finalizers in $(kubectl get nodes.longhorn.io -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n'); do
  kubectl -n ${NAMESPACE} patch nodes.longhorn.io $finalizers --type json -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
done


# Delete CRD finalizers, instances and definitions
#
for crd in $(kubectl get crd -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep longhorn.io); do
  kubectl -n ${NAMESPACE} get $crd -o yaml | sed "s/\- longhorn.io//g" | kubectl apply -f -
  kubectl -n ${NAMESPACE} delete $crd --all
  kubectl delete crd/$crd
done



