#!/bin/sh
# ------------------------------------------------------------------------------
# Swarm-sec assesses the security of a native docker cluster 
# ------------------------------------------------------------------------------

# Load dependencies
. ./output_lib.sh
. ./helper_lib.sh

# Setup the paths
this_path=$(abspath "$0")       ## Path of this file including filenamel
myname=$(basename "${this_path}")     ## file name of this script.

export PATH=/bin:/sbin:/usr/bin:/usr/local/bin:/usr/sbin/
logger="${myname}.log"

# Check for required program(s)
req_progs='awk docker grep netstat stat'
for p in $req_progs; do
  command -v "$p" >/dev/null 2>&1 || { printf "%s command not found.\n" "$p"; exit 1; }
done

# Ensure we can connect to docker daemon
docker ps -q >/dev/null 2>&1
if [ $? -ne 0 ]; then
  printf "Error connecting to docker daemon (does docker ps work?)\n"
  exit 1
fi

usage () {
  printf "
  usage: %s <token-id <hostname> [options]
   options:
     -h  		print this help message\n"
  exit 1
}

yell "# -----------------------------------------
# Swarm Cluster Security Assessment
#
# Provides automated tests for Swarm 0.3.0:
# -----------------------------------------"

logit "Initializing $(date)\n"

# Warn if not root
ID=$(id -u)
if [ "x$ID" != "x0" ]; then
    warn "Some tests might require root to run"
    #sleep 3
fi

# Get the flags
while getopts :h: args
do
  case $args in
  h) usage;;
  *) usage ;;
  esac
done

# Load all the tests from tests/ and run them
main () {
  # List all running containers
  containers=$(docker ps -q)
  # If there is a container with label swarm-sec, memorize it:
  benchcont="nil"
  for c in $containers; do
    labels=$(docker inspect --format '{{ .Config.Labels }}' "$c")
    contains "$labels" "swarm-sec" && benchcont="$c"
  done
  # List all running containers except swarm-sec
  containers=$(docker ps -q | grep -v "$benchcont")

  if [ -z $1 ]; then
    echo "Please specify a <token-id>"
    exit 1;
  fi
  for test in tests/*.sh
  do
     . ./"$test" $1 $2
  done
}

main "$@"
