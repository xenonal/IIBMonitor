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
# SCRIPT NAME:  packages.sh
# VERSION:      V1.00
#                July 2017 - James McVicar - Created
#
# Method:       manually as required.
# Usage:        packages.sh from within OS_Setup.sh
#               command takes an external comma seperated list of packages to install
#
# Description:  Used to to install software needed by the OS or docker image
#
#
#Future  enhancement would be to work out if the OS is debian or RHEL based for yum installs
#also the ability to update the list of repos incase packages are not standard.
#------------------------------------------------------------------------------------------
echo "Installing requested packaages"

#updating the packages list

echo "Updating repository lists"
apt-get update -y

#Use the external arguments to create a directories in the same path

printf '%s' "$1"  | xargs -d, -I '{}' echo apt-get install -y '{}'
printf '%s' "$1"  | xargs -d, -I '{}' apt-get install -y '{}'

#deterimes the exit code success carry on failure exit
#0 = sucess
#1 = failure
RETVAL=$?
[ $RETVAL -eq 0 ] && echo packages installed Successfully
[ $RETVAL -ne 0 ] && echo Error installing packages && exit 1

echo "Packages were installed successfully"
