#!/bin/bash

touch /run/xtables.lock

docker pull callowaysutton/ptero-external-ip

service="[Unit]
Description=Simple SNAT for Docker Containers
After=docker.service
Requires=docker.service
StartLimitBurst=16

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=/usr/bin/docker pull callowaysutton/ptero-external-ip
ExecStart=/usr/bin/docker run --net=host --cap-add=NET_ADMIN --cap-add=NET_RAW --volume /var/run/docker.sock:/var/run/docker.sock --volume /run/xtables.lock:/run/xtables.lock --restart=always --name %n callowaysutton/ptero-external-ip
ExecStop=/usr/bin/docker stop %n
ExecStopPost=/usr/bin/docker rm -f %n
ExecReload=/usr/bin/docker restart %n

[Install]
WantedBy=multi-user.target"

echo "$service" > /etc/systemd/system/external-ip.service

systemctl enable --now external-ip
