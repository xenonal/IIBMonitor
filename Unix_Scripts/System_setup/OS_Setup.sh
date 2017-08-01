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
# Usage:        OS_Setup.sh <command>
#
# Description:  Used to set up Kernal settings, directories and install 0S tools
#
#------------------------------------------------------------------------------------------
if [ "X$1" != "X" ]
then
        GOARG=$1
fi

function func_adddate() {
    while IFS= read -r line; do
        echo "$(date) $line"
    done
}


function func_Option {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      Setup Unix Environment       *******************************
#------------------------------------------------------------------------------------------

		'SystemSetup')
    echo "`/bin/bash ./opt/setup/kernal/kernal_settings.sh`" # exact path for the script file
		echo; echo "   ------- Completed System Setup -------"
     ;;

		'CreateDirectories')

		echo ; echo "   ------- Competed Directory Setup -------"
    ;;


		'SystemUtilsSetup')
    echo "`/bin/bash ./opt/setup/packages/packages.sh`" # exact path for the script file

	  echo ; echo "   ------- Competed installing packages -------"
    ;;

    'SystemUserSetup')
    echo ; echo "   ------- Competed System Setup -------"
    ;;



    *)
    echo "   ---- Incorrect Parameter Specified"; echo
    ;;
  esac

}

#------------------------------------------------------------------------------------------
# *************************      Start of Script Orchestration              *******************************
#------------------------------------------------------------------------------------------
if [ "X$GOARG" = "X" ]
then
        while :
        do
                ##func_ShowMenu

                read option
                clear
                func_Option $option
        done

else
        func_Option $GOARG
fi
