#!/bin/bash

############# SCRIPT TO MEASURE THROUGHPUT FROM NETPERF PODS ################
DATE=$(date +"%b_%-d_%H%M%S")
TIME="1"
echo "length of netperf test:$TIME"
SCRIPT="TCP_STREAM"
echo "Using Script $SCRIPT"
CONNECTIONS="1"
echo "Number of Parallel Connection: $CONNECTION"
MTU_SIZE="1"
echo "MTUSIZE is $MTU_SIZE"

PODNAME=$(kubectl get pods -o wide | grep netperf-client | awk '{print $1}')
echo "Podname --> $PODNAME"

NETPERF_SERVER=$(kubectl get pods -o wide | grep netperf-server| awk '{print $1}')
echo "NetperfServer --> $NETPERF_SERVER "

HOSTIP=$(kubectl get pod $NETPERF_SERVER -o=jsonpath='{.status.podIP}')
echo "HostIP --> $HOSTIP"

while [ $MTU_SIZE -lt 65 ]
do
  kubectl exec $PODNAME -- netperf -H $HOSTIP -t $SCRIPT -l $TIME -f g -c -C -P $CONNECTIONS "--" "-m" $MTU_SIZE"K" 
  MTU_SIZE=$((MTU_SIZE + 1))
done

echo "###############################################################################"
echo "###############################################################################"
echo "Completed the Netperf Test" 
echo "###############################################################################"
echo "###############################################################################"
exit
