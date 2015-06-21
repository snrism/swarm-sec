#!/bin/sh

logit "\n"
info "1 - Swarm Daemon Configuration"
token=$1
node=$2

# 1.1
check_1_1="1.1 - Swarm up to date"
swarm_version=$(docker run --rm swarm -version | awk '{print $3}')
do_version_check 0.3.0 $swarm_version
if [ $? -eq 11 ]; then
  warn "1.1 - Update Swarm to the latest version"
else
  pass "$check_1_1"
fi

# 1.2
check_1_2="1.2 - Swarm is running inside a container"
# Get running containers
containers=$(docker ps -q)
for c in $containers; do
  image=$(docker inspect --format '{{ .Config.Image }}' "$c")
  if [ "$image" == "swarm" ]; then
    incontainer=image
  fi
done
if [ incontainer == "swarm" ]; then
  warn "1.2 - Swarm running in host - Please containerize your swarm daemon"
else
  pass "$check_1_2"
fi

# 1.3
check_1_3="1.3 - Log level not set to debug"
# Get running containers
containers=$(docker ps -q)
for c in $containers; do
  image=$(docker inspect --format '{{ .Config.Image }}' "$c")
  if [ "$image" == "swarm" ]; then
    commands=$(docker inspect --format '{{ .Config.Cmd }}' "$c")
  fi
done
logcheck=0
contains "$commands" "log-level=debug" && logcheck=1
if [ $logcheck -eq 1 ]; then
  warn "1.3 - Log level set to debug. Do not use this in production"
else
  pass "$check_1_3"
fi

#1.4
check_1_4="1.4 - Swarm uses default ports"
# Check docker daemon status
hostport=0
containerport=0
setup=$(ps aux | grep docker | grep -v grep)
contains "$setup" "-host-port 3000" && hostport=1
contains "$setup" "-container-port 2375" && containerport=1
if [ $hostport -eq 1 ] && [ $containerport -eq 1 ]; then
  pass "$check_1_4"
else
  warn "1.4 - Default port usage encouraged"
fi

#1.5
check_1_5="1.5 - TLS enabled correctly"
# Check if all options for TLS is correctly specified and started with swarm manager
cert=0
cacert=0
key=0
tlsverify=0
setup=$(ps aux | grep "swarm manage" | grep -v grep)
contains "$setup" "--tlsverify" && tlsverify=1
contains "$setup" "--tlscacert" && cacert=1
contains "$setup" "--tlscert" && cert=1
contains "$setup" "--tlskey" && key=1
if [ $tlsverify -eq 1 ] && [ $cacert -eq 1 ] && [ $cert -eq 1 ] && [ $key -eq 1 ]; then
  pass "$check_1_5"
else
  warn "1.5 - TLS not enabled between master and cluster nodes"
  warn "    * Cluster nodes can be hacked!!"
fi

#1.6
check_1_6="1.6 - Swarm Master replication enabled"
# Check if swarm master is enabled with replication for high availability
replication=0
setup=$(ps aux | grep "swarm manage" | grep -v grep)
contains "$setup" "--replication" && replication=1
if [ $replication -eq 1 ]; then
  pass "$check_1_6"
else
  warn "1.6 - High Availabilty is recommended"
  warn "    * Enable --replication"
fi

#1.7
check_1_7="1.7 - Swarm is used as the cluster driver"
# Warn if mesos is used as a cluster driver
driver=0
setup=$(ps aux | grep "swarm manage" | grep -v grep)
contains "$setup" "--cluster-driver mesos-experimental" && driver=1
if [ $driver -eq 1 ]; then
  warn "1.7 - Mesos Cluster driver is an experimental feature. Not recommended"
else
  pass "$check_1_7"
fi

#1.8
check_1_8="1.8 - Heartbeat value is acceptable"
# Warn if heartbeat value is lower than defaul
heartbeat=0
setup=$(ps aux | grep "swarm manage" | grep -v grep)
contains "$setup" "--heartbeat" && heartbeat=1
if [ $heartbeat -eq 1 ]; then
  hb=$(echo $setup | sed 's/.*heartbeat \([^ ]*\)*.*/\1/')
  hbval=$(echo "${hb%?}")
  if [ $hbval -le 20 ]; then
    warn "1.8 - Set heartbeat greater than 20s"
  else
    pass "$check_1_8"
  fi
else
  pass "$check_1_8"
fi

#1.9
check_1_9="1.9 - Security Profile enabled"
# Warn if neither AppArmor or SELinux option is used
armorval=0
seval=0
# Get running containers
containers=$(docker ps -q)
for c in $containers; do
  image=$(docker inspect --format '{{ .Config.Image }}' "$c")
  if [ "$image" == "swarm" ]; then
    armor=$(docker inspect --format '{{ .AppArmorProfile }}' "$c")
    sel=$(docker inspect --format 'SecurityOpt={{ .HostConfig.SecurityOpt }}' "$c")
  fi
done
if [ -z "$armor" ]; then
  armorval=1
fi
if [ "$sel" = "SecurityOpt=" -o "$sel" = "SecurityOpt=[]" -o "$sel" = "SecurityOpt=<no value>" ]; then
  seval=1
fi
if [ $seval -ge 0 ] || [ $armorval -ge 0 ]; then
  warn "1.9 - Enable security options for swarm container"
  if [ $armorval -ge 0 ]; then
    warn "    * AppArmorProfile not set"
  fi
  if [ $seval -ge 0 ]; then
    warn "    * SELinux Security Option not enabled"
  fi
else
  pass "$check_1_9"
fi

#1.10
check_1_10="1.10 - Swarm manager enabled CORS for remote API"
# Check if swarm manager has enabled cors for remote API
cors=0
setup=$(ps aux | grep "swarm manage" | grep -v grep)
contains "$setup" "--api-enable-cors" && cors=1
contains "$setup" "-cors" && cors=2
if [ $cors -gt 0 ]; then
  pass "$check_1_10"
else
  warn "1.10 - Enable cross-origin resource sharing"
fi
