#!/bin/bash

sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/resolv.conf

systemctl restart NetworkManager.service