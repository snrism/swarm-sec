#!/bin/sh

logit "\n"
info "2  - Cluster Runtime"

token=e7f5da36dea5dcfb7fe1b23eb4222774
#node="host1"

#2.1
check_2_1="2.1 - Swarm Master and Cluster Nodes are running the same docker engine version"
master_docker_version=$(docker -H tcp://0.0.0.0:2375 version | grep 'Client version' | awk '{print $3}')
loopval=1
for i in `docker run --rm swarm list token://$token`
    do
     docker_version=$(docker -H tcp://$i version | grep 'Client version' | awk '{print $3}')
     do_version_check $master_docker_version $docker_version
     if [ $? -eq 11 ]; then
       warn "2.1.$loopval - Run same docker engine version on node $i"
       loopval=$((loopval + 1))
     else
       pass "2.1.$loopval - Node $i and swarm master are running same version"
       loopval=$((loopval + 1))
     fi
done

#2.2
check_2_2="2.2 - Nodes have distinct user-specified labels"
dupe_label=`docker -H tcp://0.0.0.0:2375 info | grep Labels |awk -F: '{print $2}'| sort -n | uniq -d`;
if [ -z "$dupe_label" ]
 then
   pass "$check_2_2"
else
   warn  "2.2 - User-specified node label is not unique. Check cluster node labels!!"
fi
