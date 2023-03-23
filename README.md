# CiliumProject

Performance of analysis of Cilium (ebpf based CNI) and Calico (standard  networking - kube-proxy) with respect to number of Layer 3/4 Layer 7 policies. 

# Environment Setup

To Setup a Kubernetes Environment use the following github repo and follow the steps accordingly 

https://github.com/ShixiongQi/UNIVERSE/blob/kn-v0.22.0/


# Measuring the basline 

```
Run on a seperate terminal 
iperf3 -s
```
```
iperf -c localhost -V -A 0,1 -t 10 -T iperfbaselinetest
```


# Iperf3 Pod to Pod Test 

```
cd /scripts/iperfPod2Podtest
chmod 777 testiperfpods.sh
./testiperfpods.sh 
```
# Generating Cilium Network Policies

```
cd CiliumNetoworkPolicy 
chmod +x CiliumpolicygeneratorLabel.sh CiliumpolicygeneratorLabell7.sh
```
## To generate label based policy 
```
./CiliumpolicygeneratorLabel.sh <number of Policies>
```
## E.g. 
```
./CiliumpolicygeneratorLabel.sh 1000 
```
## To generate http rule/policies 
```
./CiliumpolicygeneratorLabell7.sh 10000

```

# Generate Calico Network Policy 

```
cd CalicoNetworkPolicy

chmod +x CalicopolicygeneratorLabels.sh

./CalicopolicygeneratorLabels.sh 10000

```

# Iperf Pod to Pod Testing 

 ```
 cd ./CiliumProject/scripts/
 
 ```
 
## For Cilium CNI 

```
cd ./CiliumProject/scripts/iperfPod2PodtestCilium/

./testiperfpods.sh 
```
## For Calico CNI 

```

cd ./CiliumProject/scripts/iperfPod2PodtestCalico/

./testiperfpods.sh

```


# For ab testing 
 
``` 
cd ./CiliumProject/apachebenchmark/

./abtest.sh 
```
