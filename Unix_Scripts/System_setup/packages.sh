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
#
# Description:  Used to to install software needed by the OS or docker image
#
#
#------------------------------------------------------------------------------------------
apt-get update -y
apt-get install -y bash bc curl rpm tar
