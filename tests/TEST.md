# Swarm Security Test Cases

---
##	Swarm Daemon Configuration
  1.	Check if swarm daemon is started inside the container and not in the host
  2.	Keep Swarm up-to-date (Check for swarm latest version)
  3.	Check swarm’s log-level and discourage use of debug
  4.	Check if docker default port is used. Docker should be started on a network interface and with its default port.
  5.	Check if TLS is enabled: Ensure that –tlsverify, --tlscert, --tlscacert, --tlskey are present.
  6.	Check if heartbeat is a low-value and recommend using 20s
  7.	Warn about missing API endpoints
  8.	Warn about which APIs behave differently b/w swarm and docker
  9.	Warn that mesos driver is experimental

---

##	Master Node Configuration
  1.	Verify if docker-machine is installed for default installation of swarm and WARN if its manual installation.
  2.	Verify TLS file permission configuration.

---

## Cluster Node & Runtime Setup
  1.	Check if docker –H is started
  2.	Verify client and server are running the same docker version
  3.	Check if each node has unique labels
  4.	Verify TLS file permission configuration for each node
  5.	Run docker-bench and parse each node:
    1. To reduce cluttering of output, we can only show tests that didn’t pass with suggested output.
    2. Improve output to not just fail/pass, but also add suggestions or preferred options

---

