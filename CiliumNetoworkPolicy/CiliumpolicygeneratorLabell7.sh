#!/bin/bash
v="vl7"
x=0
NUMBER=$1
rm ciliumbasepolicyvl7.yaml
kubectl delete cnp iperfpolicyv300
kubectl delete cnp iperfpolicy$v

cat <<EOF > ciliumbasepolicyvl7.yaml
kind: CiliumNetworkPolicy
apiVersion: "cilium.io/v2"
metadata:
  name: "iperfpolicy$v"
  namespace: default
spec:
  endpointSelector:
    matchLabels:
      app: nginx
      role: server
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: apache
        role: client
    toPorts:
    - ports:
      - port: "80"
        protocol: TCP
      rules:
        http:
        - method: GET
          path: "/get.html"
        - method: POST
          path: "/post.html"
        - method: GET
          path: "/"
EOF

while [ $x -lt $NUMBER ]; do
    my_list=("GET" "PUT" "POST")
    random_index=$(( $RANDOM % ${#my_list[@]} ))
    length=5
    y="${my_list[$random_index]}"
    random_string=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 5)
    echo "        - method: $y" >> ciliumbasepolicyvl7.yaml
    echo "          path: \"/$random_string.html\"" >> ciliumbasepolicyvl7.yaml
    ((x++))
done

echo "Uploading Policy !!!!!!!!!!!!!!"
kubectl create -f ciliumbasepolicyvl7.yaml

sleep 3
exit