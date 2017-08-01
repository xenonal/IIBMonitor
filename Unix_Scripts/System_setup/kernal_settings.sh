#!/bin/bash
#-------------------------------------------------------------------------------------------
# Copyright 2017 Tri
#
# All rights reserved.
# Warning: No part of this work covered by copyright may be reproduced,
# distributed or copied in any form or by any means (graphic, electronic
# or mechanical, including photocopying, recording, taping, or information
# retrieval systems) without the written permission of Tri.
# Unauthorised reproduction, distribution or copying of this work may
# result in severe civil and criminal penalties, and will be prosecuted
# to the maximum extent possible under the law.
#
#-------------------------------------------------------------------------------------------
#
# SCRIPT NAME:  OS_Setup.sh
# VERSION:      V1.00
#                July 2017 - James McVicar - Created
#
# Method:       manually as required.
# Usage:        Kernal_settings.sh from within OS_Setup.sh
#
# Description:  Used to update the sysctl.conf and limits.conf to allow applications
#                to run
#
#------------------------------------------------------------------------------------------
echo "net.ipv4.tcp_fin_timeout = 30" >> ./sysctl.conf
#echo "net.ipv4.tcp_keepalive_time = 300" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_keepalive_intvl = 15" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_keepalive_probes = 5" >> /etc/sysctl.conf
#echo "kernel.sem = 500 256000 250 1024" >> /etc/sysctl.conf
#echo "kernel.shmmni = 4096" >> /etc/sysctl.conf
#echo "kernel.shmall = 2097152" >> /etc/sysctl.conf
#echo "kernel.shmmax = 268435456" >> /etc/sysctl.conf
#echo "fs.file-max = 524288" >> /etc/sysctl.conf
#echo "kernel.shmall = 2097152" >> /etc/sysctl.conf
#echo "net.core.netdev_max_backlog = 3000" >> /etc/sysctl.conf
#echo "net.core.somaxconn = 3000" >> /etc/sysctl.conf
#echo "iibuser hard nofile 8192" >> /etc/security/limits.conf
#echo "iibuser soft nofile 8192" >> /etc/security/limits.conf
