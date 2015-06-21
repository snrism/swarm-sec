# Swarm-sec: A native cluster security assessment tool

---

The goal of swarm-sec is to assess and  highlight the security issues in a native swarm cluster setup and faciliate a developer or administrator to deploy a secure cluster environment. swarm-sec is an extension to [docker-bench-security](https://github.com/docker/docker-bench-security). 

Currently swarm-sec can:
* Assesses possible issues in swarm daemon configuration
* Details node-specific security issues in the cluster
* Remote connection issues between the node and swarm manager

The list of test scenarios considered in the current version is
documented here [TESTCASES](tests/TESTS.md)

---

# Requirements

* Install swarm by following the instructions [here](https://github.com/docker/swarm)
* Setup a few node cluster and start the manager and cluster as described [here](https://github.com/docker/swarm/blob/master/docs/install-w-machine.md). For dev environment, install swarm manually as described [here](https://github.com/docker/swarm/blob/master/docs/install-manual.md)
* Ensure that all nodes run docker version 1.6.0 or above (run `docker
  version`)

# Swarm-sec Installation

Step-by-step installation and setup information are enumerated below:

Get the source:
```sh
git clone https://github.com/snrism/swarm-sec.git
```


Build swarm-sec:
```sh
cd <swarm-sec>
docker build -t swarm-sec .
docker run -it --net host --pid host --cap-add audit_control \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/systemd:/usr/lib/systemd \
    -v /etc:/etc --label swarm-sec \
    swarm-sec
```

Alternatively, swarm-sec can be started by just running
```sh
cd <swarm-sec>
sh swarm-sec.sh (Not recommended. Lets containerize swarm-sec :))
```

---

# Quick Start

Get help using:
```sh
docker run -it --net host --pid host --cap-add audit_control \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/systemd:/usr/lib/systemd \
    -v /etc:/etc --label swarm-sec \
    swarm-sec -h
```

Run swarm-sec for entire cluster using:
```sh
docker run -it --net host --pid host --cap-add audit_control \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/systemd:/usr/lib/systemd \
    -v /etc:/etc --label swarm-sec \
    swarm-sec
```

Run swarm-sec on a single cluster node using:
```sh
docker run -it --net host --pid host --cap-add audit_control \
    -v /var/lib:/var/lib \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/lib/systemd:/usr/lib/systemd \
    -v /etc:/etc --label swarm-sec \
    swarm-sec -n <hostname> -t <token-id>
```

---
