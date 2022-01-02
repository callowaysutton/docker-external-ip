# callowaysutton/ptero-external-ip
# For Pterodactyl

<https://github.com/callowaysutton/ptero-external-ip>

## Description

Run:

```
$ docker run --detach \
 --net=host --cap-add=NET_ADMIN --cap-add=NET_RAW \
 --volume /var/run/docker.sock:/var/run/docker.sock \
 --volume /run/xtables.lock:/run/xtables.lock \
 callowaysutton/ptero-external-ip
```

After that, if any other Docker container has an environment variable `SERVER_IP` set, with an IP address to use for
containers external IP, iptables will be configured to route container's traffic from that external IP.
The external IP must be assigned on the host.

A chain named `SERVER_IP` is created in the `nat` table into which all the rules are added.

Please make sure `/run/xtables.lock` exists on the host before starting the container.
This file ensures iptables locking is consistent between the host and the container, 
preventing race conditions that can cause containers to fail to start.
If this file does not exist, Docker will incorrectly create it as a directory, which may cause issues both on the host and with the container.
