#!/bin/bash
v="v300"
x=0
NUMBER=$1
rm ciliumbasepolicyv222.yaml
kubectl delete cnp iperfpolicy$v
echo "kind: CiliumNetworkPolicy" >> ciliumbasepolicyv222.yaml
echo "apiVersion: \"cilium.io/v2\"" >> ciliumbasepolicyv222.yaml
echo "metadata:" >> ciliumbasepolicyv222.yaml
echo "  name: \"iperfpolicy$v\"" >> ciliumbasepolicyv222.yaml
echo "  namespace: default" >> ciliumbasepolicyv222.yaml
echo "spec:">> ciliumbasepolicyv222.yaml
echo "  endpointSelector:" >> ciliumbasepolicyv222.yaml
echo "    matchLabels:" >> ciliumbasepolicyv222.yaml
echo "      app: iperf" >> ciliumbasepolicyv222.yaml
echo "      role: client" >> ciliumbasepolicyv222.yaml
echo "      role: server" >> ciliumbasepolicyv222.yaml
echo "  ingress:" >> ciliumbasepolicyv222.yaml
echo "  - fromEndpoints:" >> ciliumbasepolicyv222.yaml
echo "    - matchLabels:" >> ciliumbasepolicyv222.yaml
echo "        app: iperf" >> ciliumbasepolicyv222.yaml
echo "        role: client" >> ciliumbasepolicyv222.yaml

while [ $x -le $NUMBER ]; do

        echo "    - matchLabels:" >> ciliumbasepolicyv222.yaml
        echo "        key$x: value$x" >> ciliumbasepolicyv222.yaml
        ((x++))
        echo "        key$x: value$x" >> ciliumbasepolicyv222.yaml
        ((x++))
done

######### Uploading Policy 

echo "Uploading Policy !!!!!!!!!!!!!!"

kubectl create -f ciliumbasepolicyv222.yaml

wait
sleep 3 

exit


