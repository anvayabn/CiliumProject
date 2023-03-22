#!/bin/bash

############# SCRIPT TO MEASURE THROUGHPUT FROM NETPERF PODS ################
DATE=$(date +"%b_%-d_%H%M%S")
TIME="10"
echo "length of iperf test:$TIME"
#SCRIPT="TCP_STREAM"
#echo "Using Script $SCRIPT"
#CONNECTIONS="1"
#echo "Number of Parallel Connection: $CONNECTION"
#MTU_SIZE="1"
#echo "MTUSIZE is $MTU_SIZE"
echo "Creating Iperf3 pods for stats"
kubectl apply -f iperf3.yaml
sleep 5 
echo "Iperf3 pods are created"
echo "kubectl get all | grep iperf3 "

PODNAME=$(kubectl get pods -o wide | grep iperf-client | awk '{print $1}')
echo "Podname --> $PODNAME"

IPERF_SERVER=$(kubectl get pods -o wide | grep iperf-server| awk '{print $1}')
echo "iperfServer --> $IPERF_SERVER "

HOSTIP=$(kubectl get pod $IPERF_SERVER -o=jsonpath='{.status.podIP}')
echo "HostIP --> $HOSTIP"
echo "$DATE"

################## TCP TEST #################################
# for j in { 1000 2000 5000 10000 20000 30000 40000 }
# do  
#     echo "$j"
#     /home/an001/CiliumProject/CiliumNetoworkPolicy/CiliumpolicygeneratorLabel.sh $j
#     wait 
#     for i in {1..5}
#     do 
#     kubectl exec -it $PODNAME -- iperf3 -c $HOSTIP -A 0,1 -V -t $TIME -f g -T CiliumpodtestTCP 
#     sleep 2
# done  
# done 
# for i in {1..5}
# do 
# kubectl exec -it $PODNAME -- iperf3 -c $HOSTIP -A 0,1 -V -t $TIME -f g -T CiliumpodtestTCP 
# sleep 2
# done 


# ################# UDP TEST ###################
for i in {1..3}
do 
kubectl exec -it $PODNAME -- iperf3 -c $HOSTIP -A 0,1 -t $TIME -V -u -b 1G -f g  -T CiliumpodtestUDP 
done 

echo "###############################################################################"
echo "###############################################################################"
echo "Completed the Iperf Test"
echo "###############################################################################"
echo "###############################################################################"
kubectl delete deployment.apps/iperf-client deployment.apps/iperf-server service/iperf-service
sleep 5 
echo "Deleting the iperf3 container"
exit

