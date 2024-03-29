#!/bin/bash 
DATE=$(date +"%b_%-d_%H%M%S")

kubectl apply -f abpod.yaml
sleep 3
kubectl apply -f nginxserver.yaml 
sleep 3 
kubectl cp get.html httpd-pod:/usr/local/apache2/htdocs/
kubectl cp post.html httpd-pod:/usr/local/apache2/htdocs/

PODNAME=$(kubectl get pods -o wide | grep apache-benchmark-pod | awk '{print $1}')
echo "Podname --> $PODNAME"

NGINX=$(kubectl get pods -o wide | grep httpd-pod| awk '{print $1}')
echo "iperfServer --> $NGINX "

HOSTIP=$(kubectl get pod $NGINX -o=jsonpath='{.status.podIP}')
echo "HostIP --> $HOSTIP"
echo "$DATE"

for i in {1..5}
do 
    echo "#####################################  Simple request test $i   ###############################" >> $DATE"Result".yaml
    kubectl exec -it $PODNAME -- ab -n 1 -c 1 -i http://$HOSTIP:80/ | grep -E 'Transfer rate|Time per request|Requests per second' >> $DATE"Result".yaml
    kubectl exec -it $PODNAME -- ab -n 1 -c 1 -i http://$HOSTIP:80/get.html | grep -E 'Transfer rate|Time per request|Requests per second' >> $DATE"Result".yaml
    kubectl exec -it $PODNAME -- ab -n 1 -c 1 -i http://$HOSTIP:80/post.html | grep -E 'Transfer rate|Time per request|Requests per second' >> $DATE"Result".yaml
    echo "#########################################################################################" >> $DATE"Result".yaml
    echo "#########################################################################################" >> $DATE"Result".yaml
    echo "#########################################################################################" >> $DATE"Result".yaml
done 

# for i in {1..5}
# do 
#     echo "#####################################  Concurrency test  $i ###############################" >> $DATE"Result".yaml
#     kubectl exec -it $PODNAME -- ab -n 1000 -c 10 http://$HOSTIP:80/ >> $DATE"Result".yaml
#     echo "#########################################################################################" >> $DATE"Result".yaml
#     echo "#########################################################################################" >> $DATE"Result".yaml
#     echo "#########################################################################################" >> $DATE"Result".yaml
# done
# for i in {1..5}
# do
# echo "#####################################  Increasing load test $i  ###############################" >> $DATE"Result".yaml
# for concurrency in 1 5 10 25 50 100; do
#     echo "Concurrency $concurrency" >> $DATE"Result".yaml
#     kubectl exec -it $PODNAME -- ab -n 1000 -c $concurrency  http://$HOSTIP:80/ | grep -E 'Transfer rate|Time per request|Requests per second' >> $DATE"Result".yaml
# done     
# echo "#########################################################################################" >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml
# done

# for i in {1..5}
# do 
# echo "#####################################  Keep Alive Test  $i ###############################" >> $DATE"Result".yaml
# kubectl exec -it $PODNAME -- ab -n 1000 -c 10 -k http://$HOSTIP:80/ >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml
# done 

# echo "#####################################  Content-specific test:   ###############################" >> $DATE"Result".yaml
# kubectl exec -it $PODNAME -- ab -n 1000 -c 10 -c 10 http://$HOSTIP:80/ >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml
# echo "#########################################################################################" >> $DATE"Result".yaml



#CleanUP 
echo "Clean UP in progress ......"

kubectl delete pods apache-benchmark-pod httpd-pod
sleep 2  
echo "Test completes "
exit 