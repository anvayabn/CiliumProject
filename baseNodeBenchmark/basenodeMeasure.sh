#!/bin/bash 
IPERF=iperf3
TIME=20

sudo apt install iperf3 
 
for i in {1..5} 
do 
    $IPERF -c localhost -A 1,0 -t $TIME -f g 
done 

for i in {1..5}
do 
    $IPERF -c localhost -A 1,0 -u -t $TIME -f g 
done 

sudo apt remove $IPERF