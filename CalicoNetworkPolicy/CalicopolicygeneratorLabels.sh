#!/bin/bash
v="v300"
x=0
rm calicobasepolicyv222.yaml
echo "kind: NetworkPolicy" >> calicobasepolicyv222.yaml
echo "apiVersion: networking.k8s.io/v1" >> calicobasepolicyv222.yaml
echo "metadata:" >> calicobasepolicyv222.yaml
echo "  name: calicobasepolicy$v" >> calicobasepolicyv222.yaml
echo "  namespace: default" >> calicobasepolicyv222.yaml
echo "spec:">> calicobasepolicyv222.yaml
echo "  podSelector:" >> calicobasepolicyv222.yaml
echo "    matchLabels:" >> calicobasepolicyv222.yaml
echo "      app: iperf" >> calicobasepolicyv222.yaml
echo "      role: server" >> calicobasepolicyv222.yaml
echo "  ingress:" >> calicobasepolicyv222.yaml
echo "    - from:" >> calicobasepolicyv222.yaml
echo "      - podSelector:" >> calicobasepolicyv222.yaml
echo "          matchLabels:" >> calicobasepolicyv222.yaml
echo "            app: iperf" >> calicobasepolicyv222.yaml
echo "            role: client" >> calicobasepolicyv222.yaml

while [ $x -le 17000 ]; do
	echo "      - podSelector:" >> calicobasepolicyv222.yaml
	echo "          matchLabels:" >> calicobasepolicyv222.yaml
	echo "            key$x: value$x" >> calicobasepolicyv222.yaml
        ((x++))
	echo "            key$x: value$x" >> calicobasepolicyv222.yaml
	((x++))
done
