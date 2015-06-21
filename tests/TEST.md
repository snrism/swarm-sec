# Swarm Security Test Cases

---
##	Swarm Daemon Configuration
  1.	Check if swarm daemon is started inside the container and not in the host
  2.	Keep Swarm up-to-date (Check for swarm latest version)
  3.	Check swarm’s log-level and discourage use of debug
  4.	Verify if docker default port is used and with port correct default port proxy.
  5.	Verify if TLS is enabled:
    i.	Ensure that –tlsverify, --tlscert, --tlscacert, --tlskey are present.
  6.	Verify if heartbeat is a low-value and recommend using 20s
  7.	Verify for cluster-driver. If mesos driver is used, warn it to be experimental
  8.	Verify if master replication is enabled and warn if not.
  9.	Verify if AppArmor or SecurityOpt is enabled for Swarm container
  10. Verify if cross-origin resource sharing is enabled for remote API
      calls.

---

## Cluster Node & Runtime Setup
  1.	Verify client and server are running the same docker version
  2.	Check if each node has unique labels
  3.  Verify the cluster node configuration
  4.  Verify docker daemon configuration
  5.  Determine the container runtime configuration status (images &
      containers)

---

