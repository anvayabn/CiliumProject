#!/bin/bash 
DATE=$(date +"%b_%-d_%H%M%S")

kubectl apply -f abpod.yaml
kubectl apply -f nginxserver.yaml 
sleep 2 
kubectl cp get.html httpd-pod:/usr/local/apache2/htdocs/
kubectl cp post.html httpd-pod:/usr/local/apache2/htdocs/

PODNAME=$(kubectl get pods -o wide | grep apache-benchmark-pod | awk '{print $1}')
echo "Podname --> $PODNAME"

NGINX=$(kubectl get pods -o wide | grep httpd-pod| awk '{print $1}')
echo "iperfServer --> $NGINX "

HOSTIP=$(kubectl get pod $NGINX -o=jsonpath='{.status.podIP}')
echo "HostIP --> $HOSTIP"
echo "$DATE"

# #RANDOM URL GENERATOR 
# length=10
# # Generate a random string
# random_string=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $length | head -n 1)
# # Define the URL components
# protocol="http"
# domain="example.com"
# path="path"
# # Assemble the random URL
# random_url="${protocol}://$HOSTIP:80/${random_string}.html"
# # Print the random URL
# echo $random_url

echo "#####################################  Simple request test    ###############################" >> $DATE"Result".yaml
kubectl exec -it $PODNAME -- ab -n 1 -c 1 http://$HOSTIP:80/ >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml

echo "#####################################  Concurrency test   ###############################" >> $DATE"Result".yaml
kubectl exec -it $PODNAME -- ab -n 1000 -c 10 http://$HOSTIP:80/ >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml

echo "#####################################  Increasing load test   ###############################" >> $DATE"Result".yaml
for concurrency in 1 5 10 25 50 100; do
    echo "Concurrency $concurrency" >> $DATE"Result".yaml
    kubectl exec -it $PODNAME -- ab -n 1000 -c $concurrency  http://$HOSTIP:80/ >> $DATE"Result".yaml
done     
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml

echo "#####################################  Keep Alive Test  ###############################" >> $DATE"Result".yaml
kubectl exec -it $PODNAME -- ab -n 1000 -c 10 -k http://$HOSTIP:80/ >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml
echo "#########################################################################################" >> $DATE"Result".yaml

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