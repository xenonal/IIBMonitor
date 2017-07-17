#!/bin/ksh
#-------------------------------------------------------------------------------------------
# Copyright 2014 National Australia Bank, Ltd
#
# All rights reserved.
# Warning: No part of this work covered by copyright may be reproduced,
# distributed or copied in any form or by any means (graphic, electronic
# or mechanical, including photocopying, recording, taping, or information
# retrieval systems) without the written permission of National Australia
# Bank, Ltd.
# Unauthorised reproduction, distribution or copying of this work may
# result in severe civil and criminal penalties, and will be prosecuted
# to the maximum extent possible under the law.
#
#-------------------------------------------------------------------------------------------
#
# SCRIPT NAME:  menu_brokerSetup.sh
# VERSION:      V2.00
#                Sept 2014 - James McVicar - Created
# LAST CHANGED:  Dec  2014 - James McVicar - IIB-10, Web Admin setup.            
#
# LOCATION:     /opt/mbroker/scripts/Setup
#
# Method:       manually as required.
# Usage:        menu_brokersetup.sh
#
# Description:  Interactive menu display for set-up of a Integration Bus environment 
#
#------------------------------------------------------------------------------------------
. ./menu_brokersetup.var
. ./menu_brokerEnv.var

echo "=================================================================" >> brksetuplog.txt
echo "=                       " >> brksetuplog.txt
date >> brksetuplog.txt
echo "=                                                                " >> brksetuplog.txt

if [ "X$1" != "X" ]
then
        GOARG=$1
fi
function func_ShowMenu {
  clear
  
  echo "   ------- ESB Broker Environment Set-up -----"
  echo
  echo "   Environment    = $ENVIRONMENT"
  echo "   Broker         = $BROKER"
  echo "   Queue Manager  = $MB_BQM"
  echo "   Hostname       = $MB_HOST"
  echo "   User           = $MB_USER running from $MB_REALPC"
  echo
  echo "     INTEGRATION NODE MENUS"
  echo "   	   ================================================================================"
  echo " AD . Full automated broker deployment"
  echo " IN . Integration Node Menu"
  echo " CS . Configurable Services Menu" 
  echo " SSL. Execution group SSL Menu"
  echo " DB . Database Menu"
  echo " WA . Web Admin Menu"
  echo " FS . Message Flow stats Menu"
  echo
  echo "      ---------------------------------------------------------------------------------"
  echo "      MB UTILITIES TO START,STOP OR RELOAD THE BROKER"
  echo "      ---------------------------------------------------------------------------------"
  echo "  ST. Stop the broker"
  echo "  SB. Start the broker"
  echo "  RB. Reload the broker"
  echo
  echo "      MB EXECUTION GROUP DELETE OPTION"
  echo "    -----------------------------------------------------------------------------------"
  echo "  DI. Delete items from a execution group"
  echo
  echo " --------------------------------------------------------------------------------------"
  echo "  q.  Quit"
}

function func_Option {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      SETUP BROKER ENVIRONMENT       *******************************
#------------------------------------------------------------------------------------------
        
		'AD')
				func_createBroker
				func_linkODBC
				func_linkDeployToolFile
				func_createRSAKey
				func_setDatabasesecurityCredentials
				func_setSFTPSecurityCredential
			        func_startBroker	
                                func_createAggregationConfiguarableService
				func_createFTPServerConfigurableService
				func_stopBroker
                                func_startBroker
				echo; echo "   ------- Press Return -------"
                read keyreturn ;;
				
		'ST')
			   func_stopBroker
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
				
		'SB')
			   func_startBroker
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;;
		
		'RB')
			    func_reloadBroker
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;;	
                
		'CS')
                            func_confugurableServicesMenu;;
		'SSL')
                            func_sslMenu;;
		'DB')
                            func_databaseMenu;;
                'IN')
                            func_inodeMenu;;
                'WA')
                            func_webAdminMenu;;

                'FS')
                            func_flowStatsMenu;;
			
                 'q')
                exit;;
        *)
                echo "   ---- Incorrect Parameter Specified"; echo
                read keyreturn ;;
  esac

}  


function func_confugurableServicesMenu

{

  echo "   -------Integration Bus Configurable Services Menu-----"
  echo
  echo "   Environment      = $ENVIRONMENT"
  echo "   Integration Node = $BROKER"
  echo "   Queue Manager    = $MB_BQM"
  echo "   Hostname         = $MB_HOST"
  echo "   User             = $MB_USER running from $MB_REALPC"
  echo "       ------------------------------------------------------------------------------------"
  echo "       CONFIGURABLE SERVICE OPTIONS"
  echo "       ------------------------------------------------------------------------------------"
  echo "       --------------------------------------------------------------------------------"   
  echo "       SFTP AND FTP CONFIGURABLE SERVICES"
  echo "       --------------------------------------------------------------------------------"
  echo "   1.Create RSA key used for SFTP"
  echo "   2.Setup SFTP Security Credentials on the broker"
  echo "   3.Create FTPServer Configurable Service on the broker"
  echo "   4.Display FTPServer Configurable service settings"
  echo
  echo "       --------------------------------------------------------------------------------"
  echo "       AGGREGATION CONFIGURABLE SERVICES"
  echo "       --------------------------------------------------------------------------------"
  echo "   5.Create Aggregation Configurable Service on the broker"
  echo "   6.Display Aggregation Configurable Service settings"
  echo "       --------------------------------------------------------------------------------"
  echo "   BK.Back to main menu"
  echo
  echo "       --------------------------------------------------------------------------------"

read optionCS

if [[ "$optionCS" = "BK" ]];then 
clear
          func_ShowMenu
else
                clear

echo $optionCS
                func_OptionCS $optionCS
                func_confugurableServicesMenu
fi
}


function func_OptionCS {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      MENU SYSTEM CONFIGURABLE SERVICES      *******************************
#------------------------------------------------------------------------------------------
				
		'1')

                                func_createRSAKey
                                echo; echo "   ------- Press Return -------"
                                read keyreturn ;;
                '2')
                                func_setSFTPSecurityCredential
                                echo; echo "   ------- Press Return -------"
                                read keyreturn ;;
                '3')            
				func_startBroker
                                func_createFTPServerConfigurableService
                                echo; echo "   ------- Press Return -------"
                                read keyreturn ;;
                '4')
                                func_mqsireprortpropertiesFTPServer
                                echo; echo "   ------- Press Return -------"
                                read keyreturn ;;
                '5')   
                                func_startBroker
				func_createAggregationConfiguarableService
                                echo; echo "   ------- Press Return -------"
                                read keyreturn ;;
                '6')
                                func_mqsireprortpropertiesAggregation
                                echo; echo "   ------- Press Return -------"
                                read keyreturn ;;

                   *)
                                echo "   ---- Incorrect Parameter Specified"; echo
                                read keyreturn ;;
esac

}

function func_sslMenu

{

  echo "   -------Integration Bus SSL Setup Menu-----"
  echo
  echo "   Environment      = $ENVIRONMENT"
  echo "   Integration Node = $BROKER"
  echo "   Queue Manager    = $MB_BQM"
  echo "   Hostname         = $MB_HOST"
  echo "   User             = $MB_USER running from $MB_REALPC"
  echo "       ------------------------------------------------------------------------------------"
  echo "       SSL OPTIONS"
  echo "       ------------------------------------------------------------------------------------"
  echo "       --------------------------------------------------------------------------------"   
  echo "       EXECUTION GROUP SSL SETUP"
  echo "       --------------------------------------------------------------------------------"
  echo "   1.Set Keystore property on a execution group"
  echo "   2.Set password property for a keystore"
  echo "   3.Set TrustStore property on a execution group"
  echo "   4.Set password property for a truststore"
  echo "   5.Set password for KeyStore on the broker"
  echo "   6.Set password for TrustStore on the broker"
  echo "   7.Explicitly set SSL port number"
  echo
  echo "       --------------------------------------------------------------------------------"
  echo "       SSL EXECUTION GROUP PROPERTIES DISPLAY"
  echo "       --------------------------------------------------------------------------------"
  echo "   8.Display execution group ssl properties"
  echo
  echo "       --------------------------------------------------------------------------------"
  echo "   BK.Back to main menu"
  echo
  echo "       --------------------------------------------------------------------------------"

read optionSSL

if [[ "$optionSSL" = "BK" ]];then 
clear
          func_ShowMenu
else
                clear

echo $optionCS
                func_OptionSSL $optionSSL
                func_sslMenu
fi
}


function func_OptionSSL {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      MENU SYSTEM SSL     *******************************
#------------------------------------------------------------------------------------------
				
		'1')
				func_setKeystoreProperty
                echo ; echo "   ------- Press Return -------"
                read keyreturn ;;
		'2')
				func_setKeystorePasswordProperty
                echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
		'3')	
				func_setTrustStoreProperty
                echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
		'4')
			   func_setTruststorePasswordProperty
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
		'5')
			   func_setPasswordForKeyStore
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
				
		'6')
			   func_setPasswordForTrustStore
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
				
		'7')
			   func_ConfigureSSLListenerExplicitPort
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
                '8')
			    func_dspHttpsLinksForTest
			    echo ; echo "   ------- Press Return -------"
                read keyreturn ;;

                   *)
                                echo "   ---- Incorrect Parameter Specified"; echo
                                read keyreturn ;;
esac

}

function func_databaseMenu
{

  echo "   -------Integration Bus Database Setup Menu-----"
  echo
  echo "   Environment      = $ENVIRONMENT"
  echo "   Integration Node = $BROKER"
  echo "   Queue Manager    = $MB_BQM"
  echo "   Hostname         = $MB_HOST"
  echo "   User             = $MB_USER running from $MB_REALPC"
  echo "       ------------------------------------------------------------------------------------"
  echo "        DATABASE OPTIONS"
  echo "       ------------------------------------------------------------------------------------"
  echo "       --------------------------------------------------------------------------------"   
  echo "       ODBC DATABASE SETUP"
  echo "       --------------------------------------------------------------------------------"
  echo "   1.Set-up Database security credentials on broker"
  echo "   2.Set Execution Groups max Connection age"
  echo
  echo "       --------------------------------------------------------------------------------"
  echo "       ODBC DATABASE PROPERTIES DISPLAY"
  echo "       --------------------------------------------------------------------------------"
  echo "   3.Check Brokers connections to Databases"
  echo "       --------------------------------------------------------------------------------"
  echo
  echo "   BK.Back to main menu"
  echo
  echo "       --------------------------------------------------------------------------------"

read optionDB

if [[ "$optionDB" = "BK" ]];then 
clear
          func_ShowMenu
else
                clear

                func_OptionDatabase $optionDB
                func_databaseMenu
fi
}


function func_OptionDatabase {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      MENU SYSTEM DATABASE SETUP      *******************************
#------------------------------------------------------------------------------------------
				
		'1')
				func_setDatabasesecurityCredentials
                echo ; echo "   ------- Press Return -------"
                read keyreturn ;;
		'2')
				func_setDBMaxConAge
                echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
		'3')	
				 func_mqsicvp
    		echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 

                  *)
                 echo "   ---- Incorrect Parameter Specified"; echo
                 read keyreturn ;;
esac

}

function func_inodeMenu

{

  echo "   -------Integration Bus INTEGRATION NODE Setup Menu-----"
  echo
  echo "   Environment      = $ENVIRONMENT"
  echo "   Integration Node = $BROKER"
  echo "   Queue Manager    = $MB_BQM"
  echo "   Hostname         = $MB_HOST"
  echo "   User             = $MB_USER running from $MB_REALPC"
  echo "       ------------------------------------------------------------------------------------"
  echo "        INTEGRATION NODE OPTIONS"
  echo "       ------------------------------------------------------------------------------------"
  echo "       --------------------------------------------------------------------------------"   
  echo "       INTEGRATION NODE SETUP"
  echo "       --------------------------------------------------------------------------------"
  echo "   1. Create Integration Node"
  echo "   2. Link to environment ODBC.ini"
  echo "   3. Link to deployment tool environment file"
  echo
  echo "       --------------------------------------------------------------------------------"
  echo
  echo "   BK.Back to main menu"
  echo
  echo "       --------------------------------------------------------------------------------"

read optionInode

if [[ "$optionInode" = "BK" ]];then 
clear
          func_ShowMenu
else
                clear

                func_OptionInode $optionIN
                func_inodeMenu
fi
}


function func_OptionInode {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      MENU SYSTEM INTEGRATION NODE SETUP      *******************************
#------------------------------------------------------------------------------------------
				
		'1')
				func_createBroker
                                func_startBroker

                echo ; echo "   ------- Press Return -------"
                read keyreturn ;;
		'2')
				func_linkODBC
                echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 
		'3')	
				 func_linkDeployToolFile
    		echo ; echo "   ------- Press Return -------"
                read keyreturn ;; 

                   *)
                                echo "   ---- Incorrect Parameter Specified"; echo
                                read keyreturn ;;
esac

}

function func_webAdminMenu
{

  echo "   -------Integration Bus INTEGRATION WEB ADMIN Setup Menu-----"
  echo
  echo "   Environment      = $ENVIRONMENT"
  echo "   Integration Node = $BROKER"
  echo "   Queue Manager    = $MB_BQM"
  echo "   Hostname         = $MB_HOST"
  echo "   User             = $MB_USER running from $MB_REALPC"
  echo "       ------------------------------------------------------------------------------------"
  echo "        INTEGRATION NODE WEB ADMIN OPTIONS"
  echo "       ------------------------------------------------------------------------------------"
  echo "       --------------------------------------------------------------------------------"   
  echo "       INTEGRATION NODE WEB ADMIN SETUP"
  echo "       --------------------------------------------------------------------------------"
  echo "   1. Setup Web Admin"
  echo "   2. Set MQ auths for Web Admin  Admins"
  echo "   3. Set MQ auths for Web Admin  Users (Read Only)"
  echo
  echo "       --------------------------------------------------------------------------------"   
  echo "       INTEGRATION NODE WEB ADMIN USER SETUP"
  echo "       --------------------------------------------------------------------------------"
  echo "   4. Create Web Admin user"
  echo "   5. Create Web Read Only user"
  echo "       --------------------------------------------------------------------------------"   
  echo "       INTEGRATION NODE WEB ADMIN SETUP"
  echo "       --------------------------------------------------------------------------------"
  echo "   6. View Web Admin properties"
  echo
  echo "   BK.Back to main menu"
  echo
  echo "       --------------------------------------------------------------------------------"

read optionWeb

if [[ "$optionWeb" = "BK" ]];then 
clear
          func_ShowMenu
else
                clear

                func_OptionWebAdmin $optionWeb
                func_webAdminMenu
fi
}


function func_OptionWebAdmin {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      MENU SYSTEM INTEGRATION WEB ADMIN SETUP      *******************************
#------------------------------------------------------------------------------------------
				
		'1') 
				func_webAdminSetup
                		echo ; echo "   ------- Press Return -------"
                		read keyreturn ;;

		'2')
				func_setIIBUserAuths_Admin
                		echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
						
		'3')
				func_setIIBUserAuths_Read_Only
                		echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
		'4')	
				func_webadmin_admin_setup
				echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
						
		'5')	
				func_webadmin_user_setup
				echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
		'6')	
				func_webAdminSetupReportProperties
				echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
          *)
                echo "   ---- Incorrect Parameter Specified"; echo
                read keyreturn ;;
esac

}


function func_flowStatsMenu
{

  echo "   -------Integration Bus Flow stats Menu-----"
  echo
  echo "   Environment      = $ENVIRONMENT"
  echo "   Integration Node = $BROKER"
  echo "   Queue Manager    = $MB_BQM"
  echo "   Hostname         = $MB_HOST"
  echo "   User             = $MB_USER running from $MB_REALPC"
  echo "       ------------------------------------------------------------------------------------"
  echo "        INTEGRATION NODE FLOW STATS OPTIONS"
  echo "       ------------------------------------------------------------------------------------"
  echo "       --------------------------------------------------------------------------------"   
  echo "       INTEGRATION NODE FLOW STATS SETUP"
  echo "       --------------------------------------------------------------------------------"
  echo "   1. Setup flow stats for the whole integration Node"
  echo "   2. Setup flow stats for a whole execution group"
  echo "   3. Setup flow stats for a single flow"
  echo
  echo "       --------------------------------------------------------------------------------"   
  echo "       INTEGRATION NODE STOP FLOW STATS"
  echo "       --------------------------------------------------------------------------------"
  echo "   4. Stop Flow Stats for full broker"
  echo "   5. Stop flow stats for a whole execution group"
  echo "   6. Stop flow stats for a single flow"
  echo "       --------------------------------------------------------------------------------"
  echo
  echo "   BK.Back to main menu"
  echo
  echo "       --------------------------------------------------------------------------------"

read optionFlowStats

if [[ "$optionFlowStats" = "BK" ]];then 
clear
          func_ShowMenu
else
                clear

                func_OptionFlowStats $optionFlowStats
                func_flowStatsMenu
fi
}


function func_OptionFlowStats {

  case "$1" in
#------------------------------------------------------------------------------------------
# *************************      MENU SYSTEM INTEGRATION FLOW STAT SETUP      *******************************
#------------------------------------------------------------------------------------------
				
		'1') 
				func_enableFlowStatsWholeBroker
                		echo ; echo "   ------- Press Return -------"
                		read keyreturn ;;

		'2')
				func_enableFlowStatsWholeExecutionGroup
                		echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
		'3')	
				func_enableFlowStatsSingleflow
				echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
		'4')	
				func_stopFlowStatsWholeBroker
				echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
		'5')	
				func_stopFlowStatExecutionGrp
				echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 

		'6')	
				func_stopFlowStatsMsgFlow
				echo ; echo "   ------- Press Return -------"
                		read keyreturn ;; 
                  *)
                                echo "   ---- Incorrect Parameter Specified"; echo
                                read keyreturn ;;
esac

}


function func_createBroker
{
	        echo "   ------- Create Broker -------" ; echo
                echo mqsicreatebroker $BROKER -q $MB_BQM >> brksetuplog.txt
                echo mqsicreatebroker $BROKER -q $MB_BQM
                mqsicreatebroker $BROKER -q $MB_BQM
 }
 
 function func_linkODBC
 {
        PATH_ODBC=/opt/mbroker/ODBC/odbc.ini.$ENVIRONMENT
        DIRECTORY=/opt/mbroker/ODBC/odbc.ini
        echo "   ------- Link to ODBC environment file  -------" ;echo
        echo -n "ln -s $PATH_ODBC" > ODBCTemp.txt
        echo -n " " >> ODBCTemp.txt
        echo "$DIRECTORY" >> ODBCTemp.txt
        sed "s/
//g" ODBCTemp.txt
        COMMAND=`sed "s/
//g" ODBCTemp.txt`
        echo $COMMAND
        echo  $COMMAND >> brksetuplog.txt
		$COMMAND
 }
 
 function func_linkDeployToolFile
 {
	    PATH_DEPLOY_TOOL_ENV_FILE=/opt/mbroker/MB_DEPLOY/app_files/${MB_HOST}_env_config.properties
        DIRECTORY=/opt/mbroker/MB_DEPLOY/app_files/env_config.properties
        echo "   ------- Link to ODBC environment file  -------" ;echo
        echo -n "ln -s $PATH_DEPLOY_TOOL_ENV_FILE" > MBDEPLOYTemp.txt
        echo -n " " >> MBDEPLOYTemp.txt
        echo "$DIRECTORY" >> MBDEPLOYTemp.txt
        sed "s/
//g" MBDEPLOYTemp.txt
        COMMAND=`sed "s/
//g" MBDEPLOYTemp.txt`
        echo $COMMAND
        echo  $COMMAND >> brksetuplog.txt
		$COMMAND
 }
 function func_createRSAKey
 {
 
		if [[ -n "$RSA_PASSPHRASE" ]]
		then
                   

                             echo "   ------- Create RSA key for SFTP  -------" ;echo
 
                             file="/opt/mbroker/.ssh/id_rsa"
                             if [ -f "$file" ]
                                  then
	                             echo "$file found."
	                             rm -f /opt/mbroker/.ssh/id*
                                  else
                               	echo "$file not found."
                               fi
                               echo ssh-keygen  -t rsa -N $RSA_PASSPHRASE -f /opt/mbroker/.ssh/id_rsa
				ssh-keygen  -t rsa -N $RSA_PASSPHRASE -f /opt/mbroker/.ssh/id_rsa  >> brksetuplog.txt
				echo "   ------- Copying Public key       -------" 
				echo "This must be given to the mainframe team Stephen Lietch to be put in the known hosts."
				echo "File located /opt/mbroker/rsa/ id_rsa.pub" ;echo
				echo mkdir /opt/mbroker/rsa >> brksetuplog.txt
				echo "   ------ Creating directory to store public RSA key-------" ;echo
				echo mkdir /opt/mbroker/rs0
				mkdir /opt/mbroker/rsa/
				echo cp /opt/mbroker/.ssh/id_rsa.pub /opt/mbroker/rsa/ >> brksetuplog.txt
				echo cp /opt/mbroker/.ssh/id_rsa.pub /opt/mbroker/rsa/
				cp /opt/mbroker/.ssh/id_rsa.pub /opt/mbroker/rsa/
		else
				echo "RSA_PASSPHRASE has not been set. This function can not be performed"
		fi
 }
 function func_setDatabasesecurityCredentials
 {
		if [[ -n "$ODBC_COUNT" ]]
		then
                 echo "   ------- Setting Database Security Credential  -------" ;echo
					ODBC_COUNTER=1
					until [  $ODBC_COUNTER -gt $ODBC_COUNT ]
					do
					eval "ODBC_DATASOURCE_var=\$ODBC_DATASOURCE${ODBC_COUNTER}"
					eval "ODBC_USERNAME_var=\$ODBC_USERNAME${ODBC_COUNTER}"
					eval "ODBD_PASSWORD_var=\$ODBC_PASSWORD${ODBC_COUNTER}"
						echo mqsisetdbparms $BROKER -n $ODBC_DATASOURCE_var -u $ODBC_USERNAME_var -p $ODBD_PASSWORD_var >> brksetuplog.txt
						echo mqsisetdbparms $BROKER -n $ODBC_DATASOURCE_var -u $ODBC_USERNAME_var -p $ODBD_PASSWORD_var
						mqsisetdbparms $BROKER -n $ODBC_DATASOURCE_var -u $ODBC_USERNAME_var -p $ODBD_PASSWORD_var
						 ODBC_COUNTER=`expr $ODBC_COUNTER + 1`
					done
		else
				echo "No ODBC count has been set, This function cannot be performed"
		fi
 }
 function func_setSFTPSecurityCredential
 {
		if [[ -n "$SFTP_COUNT" ]]
		then
 
                 echo "   ------- Setting SFTP Security Credential  -------" ;echo
					SFTP_COUNTER=1
					until [  $SFTP_COUNTER -gt $SFTP_COUNT ]
					do
					eval "SFTP_SECURITY_ID_NAME_var=\$SFTP_SECURITY_ID_NAME${SFTP_COUNTER}"
					eval "SFTP_USERNAME_var=\$SFTP_USERNAME${SFTP_COUNTER}"
					eval "SFTP_PASSPHRASE_var=\$SFTP_PASSPHRASE${SFTP_COUNTER}"
						echo mqsisetdbparms $BROKER -n sftp::$SFTP_SECURITY_ID_NAME_var -u $SFTP_USERNAME_var -i /opt/mbroker/.ssh/id_rsa -r $SFTP_PASSPHRASE_var >> brksetuplog.txt
						echo mqsisetdbparms $BROKER -n sftp::$SFTP_SECURITY_ID_NAME_var -u $SFTP_USERNAME_var -i /opt/mbroker/.ssh/id_rsa -r $SFTP_PASSPHRASE_var 
						mqsisetdbparms $BROKER -n sftp::$SFTP_SECURITY_ID_NAME_var -u $SFTP_USERNAME_var -i /opt/mbroker/.ssh/id_rsa -r $SFTP_PASSPHRASE_var 
						 SFTP_COUNTER=`expr $SFTP_COUNTER + 1`
					done
		else
				echo "No SFTP count has been set, This function cannot be performed"
		fi
 }
 function func_createAggregationConfiguarableService
 {
 	if [[ -n "$AGG_CONFIG_SERVICE_COUNT" ]]
		then
                 echo "   ------- Create Aggregation Configurable Service   -------" ;echo
					AGG_CONFIG_SERVICE_COUNTER=1
					until [  $AGG_CONFIG_SERVICE_COUNTER -gt $AGG_CONFIG_SERVICE_COUNT ]
					do
					eval "AGG_CONFIG_SERVICE_OBJECT_var=\$AGG_CONFIG_SERVICE_OBJECT${AGG_CONFIG_SERVICE_COUNTER}"
					eval "AGG_CONFIG_SERVICE_PROPERTY_NAME_var=\$AGG_CONFIG_SERVICE_PROPERTY_NAME${AGG_CONFIG_SERVICE_COUNTER}"
					eval "AGG_CONFIG_SERVICE_PROPERTY_VALUE_var=\$AGG_CONFIG_SERVICE_PROPERTY_VALUE${AGG_CONFIG_SERVICE_COUNTER}"
						echo mqsicreateconfigurableservice $BROKER -c Aggregation -o $AGG_CONFIG_SERVICE_OBJECT_var -n $AGG_CONFIG_SERVICE_PROPERTY_NAME_var -v $AGG_CONFIG_SERVICE_PROPERTY_VALUE_var >> brksetuplog.txt
						echo mqsicreateconfigurableservice $BROKER -c Aggregation -o $AGG_CONFIG_SERVICE_OBJECT_var -n $AGG_CONFIG_SERVICE_PROPERTY_NAME_var -v $AGG_CONFIG_SERVICE_PROPERTY_VALUE_var
						mqsicreateconfigurableservice $BROKER -c Aggregation -o $AGG_CONFIG_SERVICE_OBJECT_var -n $AGG_CONFIG_SERVICE_PROPERTY_NAME_var -v $AGG_CONFIG_SERVICE_PROPERTY_VALUE_var
					AGG_CONFIG_SERVICE_COUNTER=`expr $AGG_CONFIG_SERVICE_COUNTER + 1`
					done
		else
				echo "No Aggregation Configurable service count has been set, This function cannot be performed"
		fi
		
 }
 function func_createFTPServerConfigurableService
 {
 
		if [[ -n "$FTP_CONFIG_SERVICE_COUNT" ]]
		then
                echo "   ------- Create FtpServer Configurable Service   -------" ;echo
				echo "Please ensure you create your SFTP Security Credential  " ;echo
				
					FTP_CONFIG_SERVICE_COUNTER=1
					until [  $FTP_CONFIG_SERVICE_COUNTER -gt $FTP_CONFIG_SERVICE_COUNT ]
					do
					eval "FTP_CONFIG_SERVICE_OBJECT_var=\$FTP_CONFIG_SERVICE_OBJECT${FTP_CONFIG_SERVICE_COUNTER}"
					eval "FTP_CONFIG_SERVICE_SERVER_NAME_var=\$FTP_CONFIG_SERVICE_SERVER_NAME${FTP_CONFIG_SERVICE_COUNTER}"
					eval "FTP_CONFIG_SERVICE_SCAN_DELAY_var=\$FTP_CONFIG_SERVICE_SCAN_DEPLAY${FTP_CONFIG_SERVICE_COUNTER}"
					eval "FTP_CONFIG_SERVICE_TRANSFER_MODE_var=\$FTP_CONFIG_SERVICE_TRANSFER_MODE${FTP_CONFIG_SERVICE_COUNTER}"
					eval "FTP_CONFIG_SERVICE_SECURITY_IDENITY_var=\$FTP_CONFIG_SERVICE_SECURITY_IDENTITY${FTP_CONFIG_SERVICE_COUNTER}"
					eval "FTP_CONFIG_SERVICE_REMOTE_DIRECTORY_var=\$FTP_CONFIG_SERVICE_REMOTE_DIRECTORY${FTP_CONFIG_SERVICE_COUNTER}"
					eval "FTP_CONFIG_SERVICE_REMOTE_ACCOUNTTINFO_var=\$FTP_CONFIG_SERVICE_ACCOUNTTINFO${FTP_CONFIG_SERVICE_COUNTER}"
					eval "FTP_CONFIG_SERVICE_PROTOCOL_var=\$FTP_CONFIG_SERVICE_PROTOCOL${FTP_CONFIG_SERVICE_COUNTER}"
					echo "Delete old one if it exists..."
                                        echo mqsideleteconfigurableservice $BROKER -c FtpServer -o $FTP_CONFIG_SERVICE_OBJECT_var
					mqsideleteconfigurableservice $BROKER -c FtpServer -o $FTP_CONFIG_SERVICE_OBJECT_var
					echo "Now attempting to create..."
                                        echo  mqsicreateconfigurableservice $BROKER  -c FtpServer -o $FTP_CONFIG_SERVICE_OBJECT_var -n serverName,scanDelay,transferMode,securityIdentity,remoteDirectory,accountInfo,protocol -v $FTP_CONFIG_SERVICE_SERVER_NAME_var,$FTP_CONFIG_SERVICE_SCAN_DELAY_var,$FTP_CONFIG_SERVICE_TRANSFER_MODE_var,$FTP_CONFIG_SERVICE_SECURITY_IDENITY_var,$FTP_CONFIG_SERVICE_REMOTE_DIRECTORY_var,$FTP_CONFIG_SERVICE_REMOTE_ACCOUNTTINFO_var,$FTP_CONFIG_SERVICE_PROTOCOL_var
					mqsicreateconfigurableservice $BROKER  -c FtpServer -o $FTP_CONFIG_SERVICE_OBJECT_var -n serverName,scanDelay,transferMode,securityIdentity,remoteDirectory,accountInfo,protocol -v $FTP_CONFIG_SERVICE_SERVER_NAME_var,$FTP_CONFIG_SERVICE_SCAN_DELAY_var,$FTP_CONFIG_SERVICE_TRANSFER_MODE_var,$FTP_CONFIG_SERVICE_SECURITY_IDENITY_var,$FTP_CONFIG_SERVICE_REMOTE_DIRECTORY_var,$FTP_CONFIG_SERVICE_REMOTE_ACCOUNTTINFO_var,$FTP_CONFIG_SERVICE_PROTOCOL_var
						
						FTP_CONFIG_SERVICE_COUNTER=`expr $FTP_CONFIG_SERVICE_COUNTER + 1`
					done
		else
				echo "No FTP Configurable service count has been set, This function cannot be performed"
		fi
 }
 function func_setKeystoreProperty
 {
 
		if [[ -n "$SSL_COUNT" ]]
		then
                echo "   ------- Set the keystore property -------" ;echo
               
			    SSL_KEYSTORE_COUNTER=1
				until  [  $SSL_KEYSTORE_COUNTER -gt $SSL_COUNT ]
				do
				eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_KEYSTORE_COUNTER}"
				eval "SSL_KEYSTORELOCATION_var=\$SSL_KEYSTORELOCATION${SSL_KEYSTORE_COUNTER}"
				
                echo "EXECUTION GROUP=" $SSL_EXECUTIONGROUP_var
                echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystoreFile -v $SSL_KEYSTORELOCATION_var >> brksetuplog.txt
                echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystoreFile -v $SSL_KEYSTORELOCATION_var 
                mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystoreFile -v $SSL_KEYSTORELOCATION_var 
                echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystoreType -v JKS >> brksetuplog.txt
                echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystoreType -v JKS
                mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystoreType -v JKS
				SSL_KEYSTORE_COUNTER=`expr $SSL_KEYSTORE_COUNTER + 1`
				done
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi
 }
 
 function func_setKeystorePasswordProperty
 {
		if [[ -n "$SSL_COUNT" ]]
		then
				echo "   ------- Set the keystore password -------" ;echo
               
			   SSL_KEYSTORE_PASSWORD_PROP_COUNTER=1
			   until [ $SSL_KEYSTORE_PASSWORD_PROP_COUNTER -gt $SSL_COUNT ]
			   do
			   eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_KEYSTORE_PASSWORD_PROP_COUNTER}"
               
			   echo "EXECUTION GROUP=" $SSL_EXECUTIONGROUP_var
               echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystorePass -v $SSL_EXECUTIONGROUP_var::keystorepass >> brksetuplog.txt
               echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystorePass -v $SSL_EXECUTIONGROUP_var::keystorepass
               mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n keystorePass -v $SSL_EXECUTIONGROUP_var::keystorepass
			   SSL_KEYSTORE_PASSWORD_PROP_COUNTER=`expr $SSL_KEYSTORE_PASSWORD_PROP_COUNTER + 1`
			   done
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi
 }
 function func_setTrustStoreProperty
 {
		if [[ -n "$SSL_COUNT" ]]
		then
				echo "   ------- Set the truststore property -------" ;echo
                SSL_TRUSTSTORE_COUNTER=1
			    until [ $SSL_TRUSTSTORE_COUNTER -gt $SSL_COUNT ]
			    do
					eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_TRUSTSTORE_COUNTER}"
					eval "SSL_TRUSTSTORELOCATION_var=\$SSL_TRUSTSTORELOCATION${SSL_TRUSTSTORE_COUNTER}"
				
					echo "EXECUTION GROUP=" $SSL_EXECUTIONGROUP_var
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststoreFile -v $SSL_TRUSTSTORELOCATION_var >> brksetuplog.txt
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststoreFile -v $SSL_TRUSTSTORELOCATION_var
					mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststoreFile -v $SSL_TRUSTSTORELOCATION_var 
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststoreType -v JKS >> brksetuplog.txt
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststoreType -v JKS
					mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststoreType -v JKS
					SSL_TRUSTSTORE_COUNTER=`expr $SSL_TRUSTSTORE_COUNTER + 1`
				done
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi
 }
 
 function func_setTruststorePasswordProperty
{
		if [[ -n "$SSL_COUNT" ]]
		then
			SSL_TRUSTSTORE_PASSWORD_PROP_COUNTER=1
			   until [ $SSL_TRUSTSTORE_PASSWORD_PROP_COUNTER -gt $SSL_COUNT ]
			   do
					eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_TRUSTSTORE_PASSWORD_PROP_COUNTER}"
			   
					echo "   ------- Set the truststore password -------" ;echo
					echo "EXECUTION GROUP=" $SSL_EXECUTIONGROUP_var
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststorePass -v $SSL_EXECUTIONGROUP_var::truststorepass >> brksetuplog.txt
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststorePass -v $SSL_EXECUTIONGROUP_var::truststorepass
					mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o ComIbmJVMManager -n truststorePass -v $SSL_EXECUTIONGROUP_var::truststorepass
					SSL_TRUSTSTORE_PASSWORD_PROP_COUNTER=`expr $SSL_TRUSTSTORE_PASSWORD_PROP_COUNTER + 1`
				done 
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi

 }
 function func_setPasswordForKeyStore
 {
               		if [[ -n "$SSL_COUNT" ]]
		then
			   SSL_KEYSTORE_PASSWORD_COUNTER=1
			   until [ $SSL_KEYSTORE_PASSWORD_COUNTER -gt $SSL_COUNT ]
			   do
                   echo "   ------- Set the password for the keystore -------" ;echo
				   eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_KEYSTORE_PASSWORD_COUNTER}"
				   eval "SSL_KEYSTOREPWD_var=\$SSL_KEYSTOREPWD${SSL_KEYSTORE_PASSWORD_COUNTER}"
				   eval "SSL_KEYSTOREUSR_var=\$SSL_KEYSTOREUSR${SSL_KEYSTORE_PASSWORD_COUNTER}"
				   echo "EXECUTION GROUP=" $SSL_EXECUTIONGROUP_var >> brksetuplog.txt
				   echo mqsisetdbparms $BROKER -n $SSL_EXECUTIONGROUP_var::keystorepass -u $SSL_KEYSTOREUSR_var -p $SSL_KEYSTOREPWD_var >> brksetuplog.txt
				   echo mqsisetdbparms $BROKER -n $SSL_EXECUTIONGROUP_var::keystorepass -u $SSL_KEYSTOREUSR_var -p $SSL_KEYSTOREPWD_var
				   mqsisetdbparms $BROKER -n $SSL_EXECUTIONGROUP_var::keystorepass -u $SSL_KEYSTOREUSR_var -p $SSL_KEYSTOREPWD_var
				   SSL_KEYSTORE_PASSWORD_COUNTER=`expr $SSL_KEYSTORE_PASSWORD_COUNTER + 1`
				done
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi 
 }				
				
 function func_setPasswordForTrustStore			
{
		if [[ -n "$SSL_COUNT" ]]
		then
			   SSL_TRUSTSTORE_PASSWORD_COUNTER=1
			   until [ $SSL_TRUSTSTORE_PASSWORD_COUNTER -gt $SSL_COUNT ]
			   do
                   echo "   ------- Set the password for the keystore -------" ;echo
				   eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_TRUSTSTORE_PASSWORD_COUNTER}"
				   eval "SSL_TRUSTSTOREPWD_var=\$SSL_TRUSTSTOREPWD${SSL_TRUSTSTORE_PASSWORD_COUNTER}"
				   eval "SSL_TRUSTSTOREUSR_var=\$SSL_TRUSTSTOREUSR${SSL_TRUSTSTORE_PASSWORD_COUNTER}"
				   echo "EXECUTION GROUP=" $SSL_EXECUTIONGROUP_var >> brksetuplog.txt
				   echo mqsisetdbparms $BROKER -n $SSL_EXECUTIONGROUP_var::truststorepass -u $SSL_TRUSTSTOREUSR_var -p $SSL_TRUSTSTOREPWD_var >> brksetuplog.txt
                   echo mqsisetdbparms $BROKER -n $SSL_EXECUTIONGROUP_var::truststorepass -u $SSL_TRUSTSTOREUSR_var -p $SSL_TRUSTSTOREPWD_var
                   mqsisetdbparms $BROKER -n $SSL_EXECUTIONGROUP_var::truststorepass -u $SSL_TRUSTSTOREUSR_var -p $SSL_TRUSTSTOREPWD_var
				   SSL_TRUSTSTORE_PASSWORD_COUNTER=`expr $SSL_TRUSTSTORE_PASSWORD_COUNTER + 1`
				done
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi	 
 }
 function func_ConfigureSSLListenerExplicitPort
{
	if [[ -n "$SSL_COUNT" ]]
		then
                echo "   ------- Configure SSL to listen on a certain port -------" ;echo
				SSL_PORT_COUNTER=1
				until [ $SSL_PORT_COUNTER -gt $SSL_COUNT ]
				do
					echo "   ------- Set the password for the keystore -------" ;echo
					eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_PORT_COUNTER}"
					eval "SSL_SSLPORT_var=\$SSL_SSLPORT${SSL_PORT_COUNTER}"
					eval "SSL_SSLMUTUALAUTH_var=\$SSL_SSLMUTUALAUTH${SSL_PORT_COUNTER}"
					echo "EXECUTION GROUP=" $EXECUTIONGROUP >> brksetuplog.txt
					echo "EXECUTION GROUP=" $EXECUTIONGROUP
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n explicitlySetPortNumber -v $SSL_SSLPORT_var >> brksetuplog.txt
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n explicitlySetPortNumber -v $SSL_SSLPORT_var
					mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n explicitlySetPortNumber -v $SSL_SSLPORT_var
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n sslProtocol -v SSL >> brksetuplog.txt
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n sslProtocol -v SSL
					mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n sslProtocol -v SSL
					if [[ "$SSL_SSLMUTUALAUTH_var" = "TRUE" ]];
						then
							echo "   ------- Configure SSL to use Mutual Authentication -------" ;echo
					  		echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n clientAuth -v true >> brksetuplog.txt
							echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n clientAuth -v true
							mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n clientAuth -v true
					fi	
				
					SSL_PORT_COUNTER=`expr $SSL_PORT_COUNTER + 1`
				done 
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi			
}
function func_stopBroker
{
				echo "   ------- Stop the broker -------" >> brksetuplog.txt ;echo
                echo "BROKER="$BROKER
				echo mqsistop $BROKER
                mqsistop $BROKER               
}
function func_startBroker
{
                echo "   ------- Start the broker -------" >> brksetuplog.txt ;echo
                echo "BROKER="$BROKER
				echo mqsistart $BROKER
                mqsistart $BROKER
}

function func_reloadBroker
{
                echo "   ------- Reload the the broker -------" >> brksetuplog.txt ;echo
                echo "BROKER="$BROKER
				echo mqsireload $BROKER
                mqsireload $BROKER
}
function func_mqsicvp
{
	if [[ -n "$ODBC_COUNT" ]]
		then
				echo "   ------- Check Database Connections  -------" ;echo
				ODBC_COUNTER=1
					until [  $ODBC_COUNTER -gt $ODBC_COUNT ]
					do
						eval "ODBC_DATASOURCE_var=\$ODBC_DATASOURCE${ODBC_COUNTER}"
						echo mqsicvp $BROKER -n $ODBC_DATASOURCE_var  >> brksetuplog.txt
						echo mqsicvp $BROKER -n $ODBC_DATASOURCE_var 
						 mqsicvp $BROKER -n $ODBC_DATASOURCE_var 
						 ODBC_COUNTER=`expr $ODBC_COUNTER + 1`
						 echo ; echo "  ------- Press Return -------"
					     read keyreturn ;
					done
				echo "   ------- Finished Displaying Database connections -------" ;echo
		else
				echo "   ------- Check Database Connections  -------" ;echo
				echo ; echo "Please enter the name of the ODBC entry you would like to check the connection for" >> brksetuplog.txt
                echo ; echo "Please enter the name of the ODBC entry you would like to check the connection for"
                echo "(just press return to cancel):"
                read ODBC_DATASOURCE_var
				echo mqsicvp $BROKER -n $ODBC_DATASOURCE_var  >> brksetuplog.txt
				echo mqsicvp $BROKER -n $ODBC_DATASOURCE_var 
				mqsicvp $BROKER -n $ODBC_DATASOURCE_var 
				echo
				echo "   ------- Finished Displaying Database connections -------" ;echo
		fi		
				
}
function func_mqsireprortpropertiesAggregation
{
		if [[ -n "$AGG_CONFIG_SERVICE_COUNT" ]]
			then
                 echo "   ------- Display Aggregation Configurable Services   -------" ;echo
					AGG_CONFIG_SERVICE_COUNTER=1
					until [  $AGG_CONFIG_SERVICE_COUNTER -gt $AGG_CONFIG_SERVICE_COUNT ]
					do
					eval "AGG_CONFIG_SERVICE_OBJECT_var=\$AGG_CONFIG_SERVICE_OBJECT${AGG_CONFIG_SERVICE_COUNTER}"
						echo mqsireportproperties $BROKER -c Aggregation -o $AGG_CONFIG_SERVICE_OBJECT_var -r >> brksetuplog.txt
						echo mqsireportproperties $BROKER -c Aggregation -o $AGG_CONFIG_SERVICE_OBJECT_var -r
						mqsireportproperties $BROKER -c Aggregation -o $AGG_CONFIG_SERVICE_OBJECT_var -r 
						AGG_CONFIG_SERVICE_COUNTER=`expr $AGG_CONFIG_SERVICE_COUNTER + 1`
						 ODBC_COUNTER=`expr $ODBC_COUNTER + 1`
							 echo ; echo "  ------- Press Return -------"
					     read keyreturn ;
					done		
				echo "   ------- Finished Displaying Aggregation Configurable services-------" ;echo
		else    
				echo "   ------- Display Aggregation Configurable Services   -------" ;echo
				echo ; echo "Please enter the name of the AggregationConfigurable service you would like to check" >> brksetuplog.txt
                echo ; echo "Please enter the name of the AggregationConfigurable service you would like to check"
                echo "(just press return to cancel):"
                read AGG_CONFIG_SERVICE_OBJECT_var
				mqsireportproperties $BROKER -c Aggregation -o $AGG_CONFIG_SERVICE_OBJECT_var -r 
				echo
				echo "   ------- Finished Displaying Aggregation Configurable services-------" ;echo
		fi		
}
function func_mqsireprortpropertiesFTPServer
{
		if [[ -n "$FTP_CONFIG_SERVICE_COUNT" ]]
			then

                 echo "   ------- Display FtpServer Configurable Services   -------" ;echo
					FTP_CONFIG_SERVICE_COUNTER=1
					until [  $FTP_CONFIG_SERVICE_COUNTER -gt $FTP_CONFIG_SERVICE_COUNT ]
					do
					eval "FTP_CONFIG_SERVICE_OBJECT_var=\$FTP_CONFIG_SERVICE_OBJECT${FTP_CONFIG_SERVICE_COUNTER}"
						echo mqsireportproperties $BROKER  -c FtpServer -o $FTP_CONFIG_SERVICE_OBJECT_var -r >> brksetuplog.txt
						echo mqsireportproperties $BROKER  -c FtpServer -o $FTP_CONFIG_SERVICE_OBJECT_var -r
						mqsireportproperties $BROKER -c FtpServer -o $FTP_CONFIG_SERVICE_OBJECT_var -r						
						FTP_CONFIG_SERVICE_COUNTER=`expr $FTP_CONFIG_SERVICE_COUNTER + 1`
						 echo ; echo "  ------- Press Return -------"
					     read keyreturn ;
					done
					echo
					echo "   ------- Finished Displaying FTPServer Configurable services-------" ;echo
		else
				echo "   ------- Display FtpServer Configurable Services   -------" ;echo
				echo ; echo "Please enter the name of the AggregationConfigurable service you would like to check" >> brksetuplog.txt
                echo ; echo "Please enter the name of the AggregationConfigurable service you would like to check"
                echo "(just press return to cancel):"
				echo
                read AGG_CONFIG_SERVICE_OBJECT_var
				mqsireportproperties $BROKER -c FtpServer -o $AGG_CONFIG_SERVICE_OBJECT_var -r 
				echo
				echo "   ------- Finished Displaying FTPServer Configurable services-------" ;echo
		fi	
}
function func_dspHttpsLinksForTest
{
			if [[ -n "$SSL_COUNT" ]]
		then
                echo "   ------- Display HTTPS Links to verify SSL Set-up -------" ;echo
				echo "  ------- Paste the link into a web browser and a warning about the certificate should be displayed -------" ;echo
				URL_PREFIX="https://"
				SSL_PORT_COUNTER=1
				until [ $SSL_PORT_COUNTER -gt $SSL_COUNT ]
				do
					eval "SSL_SSLPORT_var=\$SSL_SSLPORT${SSL_PORT_COUNTER}"
                                        eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_PORT_COUNTER}"
					echo -n "$URL_PREFIX$MB_HOST" > MBSSLtemp.txt
					echo ":$SSL_SSLPORT_var" >> MBSSLtemp.txt
					sed "s///g" MBSSLtemp.txt
					COMMAND=`sed "s///g" MBSSLtemp.txt`
					echo $COMMAND
					echo $COMMAND >> brksetuplog.txt
                                        echo mqsireportproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -r >> brksetuplog.txt
                                        echo mqsireportproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -r
                                        mqsireportproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -r
					rm MBSSLtemp.txt
					SSL_PORT_COUNTER=`expr $SSL_PORT_COUNTER + 1`
				done 
		else
				echo "No SSL count has been set, This function cannot be performed"
		fi	

}


function func_setDBMaxConAge
{
                        if [[ -n "$MAXCONAGE_COUNT" ]]
                then
                echo "   ------- Set the Max Connecection Age -------" ;echo
                             
                          
                                MAXCONAGE_COUNTER=1
                                until [ $MAXCONAGE_COUNTER -gt $MAXCONAGE_COUNT ]
                                do
                                        eval "MAXCONAGE_EG_var=\$MAXCONAGE_EG${MAXCONAGE_COUNTER}"
										eval "MAXCONAGE_TIME_var=\$MAXCONAGE_TIME${MAXCONAGE_COUNTER}"
										echo mqsichangeproperties $BROKER -e $MAXCONAGE_EG_var -o ComIbmDatabaseConnectionManager -n maxConnectionAge -v MAXCONAGE_TIME_var
										echo mqsichangeproperties $BROKER -e $MAXCONAGE_EG_var -o ComIbmDatabaseConnectionManager -n maxConnectionAge -v MAXCONAGE_TIME_var >> brksetuplog.txt
                                        mqsichangeproperties $BROKER -e $MAXCONAGE_EG_var -o ComIbmDatabaseConnectionManager -n maxConnectionAge -v MAXCONAGE_TIME_var
                                        MAXCONAGE_COUNTER=`expr $MAXCONAGE_COUNTER + 1`
                                done
                else
                                echo "There are no execution groups defined to set the Max Connection age"
                fi

}




 function func_deleteExecutiongroupItems
 {
                if [[ -n "$DELETE_COUNT" ]]
                then
                 echo "   ------- Deteleting Resource from Execution Group  -------" ;echo
                                        DELETE_COUNTER=1
                                        until [  $DELETE_COUNTER -gt $DELETE_COUNT ]
                                        do
                                        eval "EXECUTION_GROUP_var=\$EXECUTION_GROUP${DELETE_COUNTER}"
                                        eval "EXECUTION_GROUP_ITEMS_var=\$EXECUTION_GROUP_ITEMS${DELETE_COUNTER}"
                                        
                                                echo mqsideploy $BROKER -e $EXECUTION_GROUP_var -d $EXECUTION_GROUP_ITEMS_var >> brksetuplog.txt
                                                echo mqsideploy $BROKER -e $EXECUTION_GROUP_var -d $EXECUTION_GROUP_ITEMS_var
                                                mqsideploy $BROKER -e $EXECUTION_GROUP_var -d $EXECUTION_GROUP_ITEMS_var
                                                 DELETE_COUNTER=`expr $DELETE_COUNTER + 1`
                                        done
                else
                                echo "No deletes have been found, This function cannot be performed"
                fi
 }
 
 function func_webAdminSetup
 {
					 echo "   ------- Setup Web admin console  -------" ;echo
					 echo "   ------- Setup Web admin HTTPS connection  -------" ;echo
					 echo mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n port,keystoreFile,keystorePass -v $WEBADMIN_PORT,$WEBADMIN_KEYSTOREFILE,$WEBADMIN_KEYSTOREPASS>> brksetuplog.txt
					 echo mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n port,keystoreFile,keystorePass -v $WEBADMIN_PORT,$WEBADMIN_KEYSTOREFILE,$WEBADMIN_KEYSTOREPASS
					 mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n port,keystoreFile,keystorePass -v $WEBADMIN_PORT,$WEBADMIN_KEYSTOREFILE,$WEBADMIN_KEYSTOREPASS
					 
					 echo "   ------- Enable the web admin server  -------" ;echo
					 echo mqsichangeproperties $BROEKR -b webadmin -o server -enableSSL -v true >> brksetuplog.txt
					 echo mqsichangeproperties $BROEKR -b webadmin -o server -enableSSL -v true 
					 mqsichangeproperties $BROEKR -b webadmin -o server -enableSSL -v true 
					 func_stopBroker
					 echo "   ------- Enable IIB Security  -------" ;echo
					 echo mqsichangebroker $BROKER -s active >> brksetuplog.txt
					 echo mqsichangebroker $BROKER -s active
					 mqsichangebroker $BROKER -s active 
					 func_startBroker				 				 
 }
 
  function func_webAdminSetupReportProperties
  {
                    echo "   ------- Properties of Web admin console  -------" ;echo  
					echo "   ------- Properties of Web admin console HTTPS Connector -------" ;echo  
					echo mqsireportproperties $BROKER -b webadmin -o HTTPSConnector -a >> brksetuplog.txt
					echo mqsireportproperties $BROKER -b webadmin -o HTTPSConnector -a
					mqsireportproperties $BROKER -b webadmin -o HTTPSConnector -a
					
					echo "   ------- Properties of Web admin console server-----" ;echo
					echo mqsireportproperties $BROKER -b webadmin -o server -a >> brksetuplog.txt
					echo mqsireportproperties $BROKER -b webadmin -o server -a
					mqsireportproperties $BROKER -b webadmin -o server -a
  }
  
  function func_setIIBUserAuths_Admin
  {
					echo "   ------- Set MQ Queue Auths for Broker Admins -------" ;echo
					echo setmqaut -m $BROKER -t qmgr -g $BRK_MQ_ADMIN_GRP +connect +inq >> brksetuplog.txt
					echo setmqaut -m $BROKER -t qmgr -g $BRK_MQ_ADMIN_GRP +connect +inq
					setmqaut -m $BROKER -t qmgr -g $BRK_MQ_ADMIN_GRP +connect +inq
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_ADMIN_GRP +put >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_ADMIN_GRP +put
					setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_ADMIN_GRP +put
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_ADMIN_GRP +put +get >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_ADMIN_GRP +put +get
				    setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_ADMIN_GRP +put +get
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set >> brksetuplog.txt
					echo  setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set  >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +set >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +set
					setmqaut -m $BROKER -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +set
					 
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_ADMIN_GRP +put +get >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_ADMIN_GRP +put +get
					setmqaut -m $BROKER -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_ADMIN_GRP +put +get
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_ADMIN_GRP +sub +pub >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_ADMIN_GRP +sub +pub
				    setmqaut -m $BROKER -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_ADMIN_GRP +sub +pub				
  }
  
    function func_setIIBUserAuths_Read_Only
  {
					echo "   ------- Set MQ Queue Auths for Broker Admins -------" ;echo
					echo setmqaut -m $BROKER -t qmgr -g $BRK_MQ_READ_GRP +connect +inq >> brksetuplog.txt
					echo setmqaut -m $BROKER -t qmgr -g $BRK_MQ_READ_GRP +connect +inq
					setmqaut -m $BROKER -t qmgr -g $BRK_MQ_READ_GRP +connect +inq
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_READ_GRP +put >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_AREAD_GRP +put
					setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_READ_GRP +put
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_READ_GRP +put +get >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_READ_GRP +put +get
				    setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_READ_GRP +put +get
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_READ_GRP +inq >> brksetuplog.txt
					echo  setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_READ_GRP +inq
					setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_READ_GRP +inq
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_READ_GRP +inq >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_READ_GRP +inq
					setmqaut -m $BROKER -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_READ_GRP +inq
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_READ_GRP +inq +set >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_READ_GRP +inq +set
					setmqaut -m $BROKER -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_READ_GRP +inq +set
					 
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_READ_GRP +put +get >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_READ_GRP +put +get
					setmqaut -m $BROKER -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_READ_GRP +put +get
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_READ_GRP +sub +pub >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_READ_GRP +sub +pub
				    setmqaut -m $BROKER -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_READ_GRP +sub +pub				
  }
  
  function func_webadmin_user_setup
  {
 

 echo "   ------- Setup web admin users Read Only -------" ;echo
				
				if [[ -n "$WEBADMINUSER_COUNT" ]]
                then
                 echo "   ------- Creating web admin users  -------" ;echo
                                        WEBADMINUSER_COUNTER=1
                                        until [  $WEBADMINUSER_COUNTER -gt $WEBADMINUSER_COUNT ]
                                        do
                                        eval "WEBADMIN_USER_var=\$WEBADMIN_USER${WEBADMINUSER_COUNTER}"
                                        eval "WEBADMMIN_USER_PASS_var=\$WEBADMIN_USER_PASS${WEBADMINUSER_COUNTER}"
										eval "WEBADMMIN_USER_ROLE_var=\$WEBADMIN_USER_ROLE${WEBADMINUSER_COUNTER}"
                                        
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_AUSER_var -r $WEBADMMIN_USER_ROLE_var -a $WEBADMMIN_AUSER_PASS_var >> brksetuplog.txt
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_AUSER_var -r $WEBADMMIN_USER_ROLE_var -a $WEBADMMIN_AUSER_PASS_var
												mqsiwebuseradmin $BROKER -c -u $WEBADMIN_AUSER_var -r $WEBADMMIN_USER_ROLE_var -a $WEBADMMIN_AUSER_PASS_var
                                                WEBADMINADMIN_COUNTER=`expr $WEBADMINADMIN_COUNT + 1`
                                        done
                else
										echo "   ------- Manually create new user  -------" ;echo
										echo ; echo "Please enter the name of the user" >> brksetuplog.txt
										echo ; echo "Please enter the name of the user"
										echo "(just press return to cancel):"
										read WEBADMIN_USER_var
									        echo ; echo "Please enter the password for the user" >> brksetuplog.txt
										echo ; echo "Please enter the password for the user" 
										echo "(just press return to cancel):"
										read WEBADMMIN_USER_PASS_var
										echo ; echo "Please enter the role of the user" >> brksetuplog.txt
										echo ; echo "Please enter the role of the user" 
										echo "(just press return to cancel):"
										read WEBADMMIN_USER_ROLE_var
										mqsiwebuseradmin $BROKER -c -u $WEBADMIN_AUSER_var -r $WEBADMMIN_USER_ROLE_var -a $WEBADMMIN_AUSER_PASS_var 
										echo
										echo "   ------- Finished Creating  user-------" ;echo
                fi
  }
  
    function func_webadmin_admin_setup
  {
 

 echo "   ------- Setup web admin,  admin users -------" ;echo
				
				if [[ -n "$WEBADMINADMIN_COUNT" ]]
                then
                 echo "   ------- Creating web admin users  -------" ;echo
                                        WEBADMINADMIN_COUNTER=1
                                        until [  $WEBADMINADMIN_COUNTER -gt $WEBADMINADMIN_COUNT ]
                                        do
                                        eval "WEBADMIN_USER_var=\$WEBADMIN_USER${WEBADMINADMIN_COUNTER}"
                                        eval "WEBADMMIN_USER_PASS_var=\$WEBADMIN_USER_PASS${WEBADMINADMIN_COUNTER}"
										eval "WEBADMMIN_USER_ROLE_var=\$WEBADMIN_USER_ROLE${WEBADMINADMIN_COUNTER}"
                                        
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_USER_var -r $WEBADMMIN_ADMIN_ROLE_var -a $WEBADMMIN_USER_PASS_var >> brksetuplog.txt
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_USER_var -r $WEBADMMIN_ADMIN_ROLE_var -a $WEBADMMIN_USER_PASS_var
												mqsiwebuseradmin $BROKER -c -u $WEBADMIN_USER_var -r $WEBADMMIN_ADMIN_ROLE_var -a $WEBADMMIN_USER_PASS_var
                                                WEBADMINADMIN_COUNTER=`expr $WEBADMINADMIN_COUNT + 1`
                                        done
                else
										echo "   ------- Manually create new user  -------" ;echo
										echo ; echo "Please enter the name of the user" >> brksetuplog.txt
										echo ; echo "Please enter the name of the user"
										echo "(just press return to cancel):"
										read WEBADMIN_USER_var
									        echo ; echo "Please enter the password for the user" >> brksetuplog.txt
										echo ; echo "Please enter the password for the user" 
										echo "(just press return to cancel):"
										read WEBADMMIN_USER_PASS_var
										echo ; echo "Please enter the role of the user" >> brksetuplog.txt
										echo ; echo "Please enter the role of the user" 
										echo "(just press return to cancel):"
										read WEBADMMIN_USER_ROLE_var
										mqsiwebuseradmin $BROKER -c -u $WEBADMIN_USER_var -r $WEBADMMIN_ADMIN_ROLE_var -a $WEBADMMIN_USER_PASS_var 
										echo
										echo "   ------- Finished Creating  user-------" ;echo
                fi
  }
  
  function func_enableFlowStatsWholeBroker
  {
  					                                        echo "   ------- Enable flow statistics for the whole broker these can be viewed in the web admin console   -------" ;echo
										echo mqsichangeflowstats $BROKER -s -g -j -c active -o json,xml  >> brksetuplog.txt
										echo mqsichangeflowstats $BROKER -s -g -j -c active -o json,xml 
									        mqsichangeflowstats $BROKER -s -g -j -c active -o json,xml 
  }
  
  function func_enableFlowStatsWholeExecutionGroup
  {
										 echo "   ------- Enable flow statistics for the whole execution group these can be viewed in the web admin console   -------" ;echo
										 echo ; echo "Please enter the name of the execution group" >> brksetuplog.txt
										 echo ; echo "Please enter the name of the execution group"
										 echo "(just press return to cancel):"
										 read FLOWSTATS_EXCUTION_GRP_var
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -j -c active -o json,xml  >> brksetuplog.txt
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -j -c active -o json,xml 
									         mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -j -c active -o json,xml
  }
  
  function func_enableFlowStatsSingleflow
  {
									     echo "   ------- Enable flow statistics for the whole execution group these can be viewed in the web admin console   -------" ;echo
										 echo ; echo "Please enter the name of the execution group" >> brksetuplog.txt
										 echo ; echo "Please enter the name of the execution group"
										 echo "(just press return to cancel):"
										 read FLOWSTATS_EXCUTION_GRP_var
										 echo ; echo "Please enter the name of the Message Flow" >> brksetuplog.txt
										 echo ; echo "Please enter the name of the Message Flow"
										 echo "(just press return to cancel):"
										 read FLOWSTATS_MESSAGE_FLOW_var
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -f $FLOWSTATS_MESSAGE_FLOW_var -n advanced -c active -o json,xml  >> brksetuplog.txt
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -f  $FLOWSTATS_MESSAGE_FLOW_var -n advanced -c active -o json,xml 
									     mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -f $FLOWSTATS_MESSAGE_FLOW_var -n advanced -c active -o json,xml
  }

function func_stopFlowStatsWholeBroker
{
									        echo "   ------- Disable flow statistics for the whole broker-------" ;echo
										echo mqsichangeflowstats $BROKER -s -g -j-c inactive  >> brksetuplog.txt
										echo mqsichangeflowstats $BROKER -s -g -j-c inactive 
										mqsichangeflowstats $BROKER -s -g -j-c inactive 

}

function func_stopFlowStatsMsgFlow
{
 										 echo "   ------- Disable flow statistics for the whole execution group-------" ;echo
										 echo ; echo "Please enter the name of the execution group" >> brksetuplog.txt
										 echo ; echo "Please enter the name of the execution group"
										 echo "(just press return to cancel):"
										 read FLOWSTATS_EXCUTION_GRP_var
										 echo ; echo "Please enter the name of the Message Flow" >> brksetuplog.txt
										 echo ; echo "Please enter the name of the Message Flow"
										 echo "(just press return to cancel):"
										 read FLOWSTATS_MESSAGE_FLOW_var
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -f $FLOWSTATS_MESSAGE_FLOW_var -c inactive >> brksetuplog.txt
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -f  $FLOWSTATS_MESSAGE_FLOW_var -c inactive
									         mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -f $FLOWSTATS_MESSAGE_FLOW_var -c inactive

}


function func_stopFlowStatExecutionGrp
{
										 echo "   ------- Disbale flow statistics for the whole execution group-------" ;echo
										 echo ; echo "Please enter the name of the execution group" >> brksetuplog.txt
										 echo ; echo "Please enter the name of the execution group"
										 echo "(just press return to cancel):"
										 read FLOWSTATS_EXCUTION_GRP_var
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -j -c inactive >> brksetuplog.txt
										 echo mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -j -c inactive  
									         mqsichangeflowstats $BROKER -a -e  $FLOWSTATS_EXCUTION_GRP_var -j -c inactive

}

#------------------------------------------------------------------------------------------
# *************************      Start of Menu              *******************************
#------------------------------------------------------------------------------------------
if [ "X$GOARG" = "X" ]
then
        while :
        do
                func_ShowMenu

                read option
                clear
                func_Option $option
        done

else
        func_Option $GOARG
fi
