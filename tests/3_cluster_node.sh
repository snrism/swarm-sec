#!/bin/sh

logit "\n"
info "3  - Cluster Node-specific Assessment"

token=e7f5da36dea5dcfb7fe1b23eb4222774
#node="host1"

#3.1
check_3_1="3.1 - Assessing security of all nodes in the cluster"
if [ -z "$token" ]
then
 info "   * Specify token with  -t "
 usage
else
  if [ -z "$node" ];then
    info "$check_3_1"

    for i in `docker run --rm swarm list token://$token`
      do
      echo "----------------------------------------------------"
      info "Running docker-bench in $i"
      echo "----------------------------------------------------"
      docker -H tcp://$i run -it --rm --net host --pid host --cap-add audit_control \
           -v /var/lib:/var/lib \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v /usr/lib/systemd:/usr/lib/systemd \
           -v /etc:/etc -v /etc/docker:/etc/docker --label docker-bench-security \
            diogomonica/docker-bench-security | egrep -i 'warn'

    done
  else
    echo "----------------------------------------------------"
    info "Running docker-bench in $i"
    echo "----------------------------------------------------"
    docker -H tcp://0.0.0.0:2375 run -e constraint:node==$node -it --rm --net host --pid host --cap-add audit_control \
         -v /var/lib:/var/lib \
         -v /var/run/docker.sock:/var/run/docker.sock \
         -v /usr/lib/systemd:/usr/lib/systemd \
         -v /etc:/etc -v /etc/docker:/etc/docker --label docker-bench-security \
         diogomonica/docker-bench-security | egrep -i 'warn'
fi
fi
