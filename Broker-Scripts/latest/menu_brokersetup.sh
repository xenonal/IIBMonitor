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
# VERSION:       V2.00
#                Sept 2014 - James McVicar - Created
# LAST CHANGED:  Dec  2014 - James McVicar - IIB-10, Web Admin setup.            
#				 Mar  2015 - James McVicar - Deployment File Mode or stand alone mode
# LOCATION:     /opt/mbroker/scripts/Setup
#
# Method:       manually as required.
# Usage:        menu_brokersetup.sh
#
# Description:  Interactive menu display for set-up of a Integration Bus environment 
#
#------------------------------------------------------------------------------------------

. ./menu_brokerEnv.var


echo "=================================================================" >> brksetuplog.txt
echo "=                       " >> brksetuplog.txt
date >> brksetuplog.txt
echo "=                                                                " >> brksetuplog.txt

if [ "X$1" != "X" ]
	then
        GOARG=$1
fi


function func_Header
{
 clear
  echo "   Environment    	= $ENVIRONMENT"
  echo "   Broker         	= $BROKER"
  echo "   Queue Manager  	= $MB_BQM"
  echo "   Hostname       	= $MB_HOST"
  echo "   User           	= $MB_USER running from $MB_REALPC"
  echo "   Deployment File  = ${DEPLOYMENT_FILE_LOADED} - File name = ${filename}"
  echo "   UCD    	= ${UCD_DEPLOY}"
  if [[ "$BROKERSECURITY" = "TRUE" ]]
		then
		echo "   Integration Node security = ENABLED"
  else
		echo "   Integration Node security = NOT-ENABLLED"
    fi
  echo
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
        DIRECTORY_ODBC=/opt/mbroker/ODBC/odbc.ini
		
		PATH_ODBCINST=/opt/mbroker/ODBC/odbcinst.ini.$ENVIRONMENT
        DIRECTORY_ODBCINST=/opt/mbroker/ODBC/odbcinst.ini
        echo "   ------- Link to ODBC environment file  -------" ;echo
		echo ln -s $DIRECTORY_ODBCINST $PATH_ODBCINST
		#New file part of the Datadirect drivers introduced IIB9 
		echo ln -s $DIRECTORY_ODBC $PATH_ODBCINST >> brksetuplog.txt
		ln -s $DIRECTORY_ODBC $PATH_ODBCINST		
 }
 
 function func_linkDeployToolFile
 {
	    PATH_DEPLOY_TOOL_ENV_FILE=/opt/mbroker/MB_DEPLOY/app_files/${MB_HOST}_env_config.properties
        DIRECTORY=/opt/mbroker/MB_DEPLOY/app_files/env_config.properties
        echo "   ------- Link to ODBC environment file  -------" ;echo
		echo ln -s $DIRECTORY $PATH_DEPLOY_TOOL_ENV_FILE
		ln -s $DIRECTORY $PATH_DEPLOY_TOOL_ENV_FILE
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
					#--Protocol changed to TLS as SSLV3 has a security issue
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n sslProtocol -v TLS >> brksetuplog.txt
					echo mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n sslProtocol -v TLS
					mqsichangeproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -n sslProtocol -v TLS
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

function func_autoDeploySSL
{
					echo "Beginning SSL Auto Deployment"
					func_setKeystoreProperty
					func_setKeystorePasswordProperty
					func_setTrustStoreProperty
					func_setTruststorePasswordProperty
					func_setPasswordForKeyStore
					func_setPasswordForTrustStore
					func_ConfigureSSLListenerExplicitPort
					func_stopBroker
					func_startBroker
					echo "Finished SSL Auto Deployment"
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
		fi	
}

function func_AllreportableProperties
{
					echo "   ------- Display All reportable properties for a broker -------" ;echo
					echo mqsireportproperties $BROKER -c AllTypes -o AllReportableEntityNames -r
					mqsireportproperties $BROKER -c AllTypes -o AllReportableEntityNames -r  >> brksetuplog.txt
					mqsireportproperties $BROKER -c AllTypes -o AllReportableEntityNames -r 

}
function func_dspHttpsLinksForTest
{
    if [[ -n "$SSL_COUNT" ]]
		then
                echo "   -------Verify SSL Set-up -------" ;echo
				SSL_PORT_COUNTER=1
				until [ $SSL_PORT_COUNTER -gt $SSL_COUNT ]
	   			 do
					eval "SSL_SSLPORT_var=\$SSL_SSLPORT${SSL_PORT_COUNTER}"
                    eval "SSL_EXECUTIONGROUP_var=\$SSL_EXECUTIONGROUP${SSL_PORT_COUNTER}"
                    echo mqsireportproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -r >> brksetuplog.txt
                    echo mqsireportproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -r
                    mqsireportproperties $BROKER -e $SSL_EXECUTIONGROUP_var -o HTTPSConnector -r
					SSL_PORT_COUNTER=`expr $SSL_PORT_COUNTER + 1`
				 done 
		fi	
}

function func_setDBMaxConAge
{
        if [[ -n "$MAXCONAGE_COUNT" ]]
                then
                echo "   ------- Set the Connection Age for Database connections -------" ;echo
                                MAXCONAGE_COUNTER=1
                                until [ $MAXCONAGE_COUNTER -gt $MAXCONAGE_COUNT ]
                                do
                                        eval "MAXCONAGE_EG_var=\$MAXCONAGE_EG${MAXCONAGE_COUNTER}"
										eval "MAXCONAGE_TIME_var=\$MAXCONAGE_TIME${MAXCONAGE_COUNTER}"
										echo mqsichangeproperties $BROKER -e $MAXCONAGE_EG_var -o ComIbmDatabaseConnectionManager -n maxConnectionAge -v $MAXCONAGE_TIME_var
										echo mqsichangeproperties $BROKER -e $MAXCONAGE_EG_var -o ComIbmDatabaseConnectionManager -n maxConnectionAge -v$MAXCONAGE_TIME_var >> brksetuplog.txt
                                        mqsichangeproperties $BROKER -e $MAXCONAGE_EG_var -o ComIbmDatabaseConnectionManager -n maxConnectionAge -v $MAXCONAGE_TIME_var
                                        $MAXCONAGE_COUNTER=`expr $MAXCONAGE_COUNTER + 1`
                                done
                fi
}

 function func_deleteExecutiongroupItems
 {
                if [[ -n "$DELETE_COUNT" ]]
                then
                 echo "   ------- Deleting Resource from Execution Group  -------" ;echo
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
					 echo "   ------- Setup Web admin mbroker admin account" ; echo
					 echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_PASS
					 echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_PASS>> brksetuplog.txt
					 mqsiwebuseradmin $BROKER -c -u $WEBADMIN -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_PASS
					 
					 echo "   ------- Setup Web admin HTTPS connection  -------" ;echo
					 echo mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n port,keystoreFile,keystorePass -v $WEBADMIN_PORT,$WEBADMIN_KEYSTOREFILE,$WEBADMIN_KEYSTOREPASS>> brksetuplog.txt
					 echo mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n port,keystoreFile,keystorePass -v $WEBADMIN_PORT,$WEBADMIN_KEYSTOREFILE,$WEBADMIN_KEYSTOREPASS
				     mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n port,keystoreFile,keystorePass -v $WEBADMIN_PORT,$WEBADMIN_KEYSTOREFILE,$WEBADMIN_KEYSTOREPASS
					 
					 echo "   ------- Enable the web admin server  -------" ;echo
					 echo mqsichangeproperties $BROKER -b webadmin -o server -n enableSSL -v true >> brksetuplog.txt
					 echo mqsichangeproperties $BROKER -b webadmin -o server -n enableSSL -v true 
					 mqsichangeproperties $BROKER -b webadmin -o server -n enableSSL -v true 
					 
					 #-CHANGE THE SECURITY PROTOCOL FROM SSL TO TLS AS SSL HAS A SECURITY ISSUE IN V3
					 echo "   ------- Change encryption method to TLS  -------" ;echo
					 echo mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n sslProtocol -v TLS >>brksetuplog.txt
					 echo mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n sslProtocol -v TLS
					 mqsichangeproperties $BROKER -b webadmin -o HTTPSConnector -n sslProtocol -v TLS

					 func_stopBroker
					 echo "   ------- Enable IIB Broker Security  -------" ;echo
					 echo mqsichangebroker $BROKER -s active >> brksetuplog.txt
					 echo mqsichangebroker $BROKER -s active
					 mqsichangebroker $BROKER -s active
					 BROKERSECURITY=TRUE
					 echo "BROKERSECURITY=TRUE" >>menu_brokerEnv.var
					 #--Environment variable script must be re-ran to pick up the new security variable
									 
 }
  
  function func_setIIBUserAuths_Admin
  {
					echo "   ------- Set MQ Queue Auths for Broker Admins -------" ;echo
					echo setmqaut -m $MB_BQM -t qmgr -g $BRK_MQ_ADMIN_GRP +connect +inq >> brksetuplog.txt
					echo setmqaut -m $MB_BQM -t qmgr -g $BRK_MQ_ADMIN_GRP +connect +inq
					setmqaut -m $MB_BQM -t qmgr -g $BRK_MQ_ADMIN_GRP +connect +inq
					
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_ADMIN_GRP +put >> brksetuplog.txt
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_ADMIN_GRP +put
					setmqaut -m $MB_BQM -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_ADMIN_GRP +put
					
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_ADMIN_GRP +put +get >> brksetuplog.txt
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_ADMIN_GRP +put +get
				    setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.REPLY -t queue -g $BRK_MQ_ADMIN_GRP +put +get
					
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set >> brksetuplog.txt
					echo  setmqaut -m $MB_BQM -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					setmqaut -m $MB_BQM -n SYSTEM.BROKER.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set  >> brksetuplog.txt
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					setmqaut -m $MB_BQM -n SYSTEM.BROKER.AUTH.* -t queue -g $BRK_MQ_ADMIN_GRP +inq +put +set
					
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +set >> brksetuplog.txt
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +set
					setmqaut -m $MB_BQM -n SYSTEM.BROKER.DC.AUTH -t queue -g $BRK_MQ_ADMIN_GRP +inq +set
					 
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_ADMIN_GRP +put +get >> brksetuplog.txt
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_ADMIN_GRP +put +get
					setmqaut -m $MB_BQM -n SYSTEM.BROKER.WEBADMIN.SUBSCRIPTION -t queue -g $BRK_MQ_ADMIN_GRP +put +get
					
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_ADMIN_GRP +sub +pub >> brksetuplog.txt
					echo setmqaut -m $MB_BQM -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_ADMIN_GRP +sub +pub
				    setmqaut -m $MB_BQM -n SYSTEM.BROKER.MB.TOPIC -t topic -g $BRK_MQ_ADMIN_GRP +sub +pub				
  }
  
    function func_setIIBUserAuths_Read_Only
  {
					echo "   ------- Set MQ Queue Auths for Broker Admins -------" ;echo
					echo setmqaut -m $BROKER -t qmgr -g $BRK_MQ_READ_GRP +connect +inq >> brksetuplog.txt
					echo setmqaut -m $BROKER -t qmgr -g $BRK_MQ_READ_GRP +connect +inq
					setmqaut -m $BROKER -t qmgr -g $BRK_MQ_READ_GRP +connect +inq
					
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_READ_GRP +put >> brksetuplog.txt
					echo setmqaut -m $BROKER -n SYSTEM.BROKER.DEPLOY.QUEUE -t queue -g $BRK_MQ_READ_GRP +put
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
                                        eval "WEBADMIN_USER_PASS_var=\$WEBADMIN_USER_PASS${WEBADMINUSER_COUNTER}"
										 if [[ "$BROKERSECURITY" = "TRUE" ]]
											then
												echo mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -c -u $WEBADMIN_USER_var -r $WEBADMIN_USER_ROLE -a $WEBADMIN_USER_PASS_var >> brksetuplog.txt
                                                echo mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -c -u $WEBADMIN_USER_var -r $WEBADMIN_USER_ROLE -a $WEBADMIN_USER_PASS_var
												mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -c -u $WEBADMIN_USER_var -r $WEBADMIN_USER_ROLE -a $WEBADMIN_USER_PASS_var
                                                WEBADMINADMIN_COUNTER=`expr $WEBADMINUSER_COUNT + 1`
										 else
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_USER_var -r $WEBADMIN_USER_ROLE -a $WEBADMIN_USER_PASS_var >> brksetuplog.txt
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_USER_var -r $WEBADMIN_USER_ROLE -a $WEBADMIN_USER_PASS_var
												mqsiwebuseradmin $BROKER -c -u $WEBADMIN_USER_var -r $WEBADMIN_USER_ROLE -a $WEBADMIN_USER_PASS_var
                                                WEBADMINUSER_COUNTER=`expr $WEBADMINUSER_COUNT + 1`
										fi
                                        done
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
											eval "WEBADMIN_ADMIN_USER_var=\$WEBADMIN_ADMIN_USER${WEBADMINADMIN_COUNTER}"
											eval "WEBADMIN_ADMIN_USER_PASS_var=\$WEBADMIN_ADMIN_USER_PASS${WEBADMINADMIN_COUNTER}"	
							            if [[ "$BROKERSECURITY" = "TRUE" ]]
											then
												echo mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -c -u $WEBADMIN_AUSER_var -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_USER_PASS_var >> brksetuplog.txt
                                                echo mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -c -u $WEBADMIN_AUSER_var -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_USER_PASS_var
												mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -c -u $WEBADMIN_ADMIN_USER_var -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_USER_PASS_var
                                                WEBADMINADMIN_COUNTER=`expr $WEBADMINADMIN_COUNT + 1`
											
                                        else
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_ADMIN_USER_var -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_USER_PASS_var >> brksetuplog.txt
                                                echo mqsiwebuseradmin $BROKER -c -u $WEBADMIN_ADMIN_USER_var -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_USER_PASS_var
												mqsiwebuseradmin $BROKER -c -u $WEBADMIN_ADMIN_USER_var -r $WEBADMIN_ADMIN_ROLE -a $WEBADMIN_ADMIN_USER_PASS_var
                                                WEBADMINADMIN_COUNTER=`expr $WEBADMINADMIN_COUNT + 1`
										fi
                                        done
				fi
  }


function func_ListWebAdminUsers
{
										echo "   ------- Listing Web Admin Users  -------" ;echo
										if [[ "$BROKERSECURITY" = "TRUE" ]]
											then
												echo mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -l
												mqsiwebuseradmin $BROKER -i tcp://${WEBADMIN}:${WEBADMIN_ADMIN_PASS}@localhost:${WEBADMIN_PORT} -m -u $WEBADMIN_USER_var -a $WEBADMIN_USER_PASS_var
										else
											echo mqsiwebuseradmin $BROKER -l
											mqsiwebuseradmin $BROKER -l
                                    fi
}
  function func_webadminAutoDeploy
  {
										echo "-------- Beginning Web Admin Setup ------------"
										func_webAdminSetup
										func_setIIBUserAuths_Admin
										#func_setIIBUserAuths_Read_Only	
										func_webadmin_user_setup
										func_webadmin_admin_setup
										echo "-------- End Web Admin Setup ----------" 
  }
  
  function func_enableFlowStatsWholeBroker
  {
  					                    echo "   ------- Enable flow statistics for the whole broker these can be viewed in the web admin console   -------" ;echo
										echo mqsichangeflowstats $BROKER -s -g -j -c active -o json,xml  >> brksetuplog.txt
										echo mqsichangeflowstats $BROKER -s -g -j -c active -o json,xml 
									    mqsichangeflowstats $BROKER -s -g -j -c active -o json,xml 
  }
  

  function func_activateFlowEvents
  {
 echo "   ------- Activate Flow Events  -------" ;echo
				
				if [[ -n "$ACTIVATE_FLOW_EVENTS_COUNT" ]]
                then
                 echo "   ------- Activating Flow Events  -------" ;echo
                                        ACTIVATE_FLOW_EVENTS_COUNTER=1
                                        until [  $ACTIVATE_FLOW_EVENTS_COUNTER -gt $ACTIVATE_FLOW_EVENTS_COUNT ]
                                        do
                                        eval "ACTIVE_FLOW_EVENTS_EXECUTION_GROUP_var=\$ACTIVE_FLOW_EVENTS_EXECUTION_GROUP${ACTIVATE_FLOW_EVENTS_COUNTER}"
										eval "ACTIVE_FLOW_EVENTS_FLOW_var=\$ACTIVE_FLOW_EVENTS_FLOW${ACTIVATE_FLOW_EVENTS_COUNTER}"
                                        
                                                echo mqsichangeflowmonitoring $BROKER -e $ACTIVE_FLOW_EVENTS_EXECUTION_GROUP_var -f $ACTIVE_FLOW_EVENTS_FLOW_var -c active >> brksetuplog.txt
                                                echo mqsichangeflowmonitoring $BROKER -e $ACTIVE_FLOW_EVENTS_EXECUTION_GROUP_var -f $ACTIVE_FLOW_EVENTS_FLOW_var -c active
												mqsichangeflowmonitoring $BROKER -e $ACTIVE_FLOW_EVENTS_EXECUTION_GROUP_var -f $ACTIVE_FLOW_EVENTS_FLOW_var -c active
                                                ACTIVATE_FLOW_EVENTS_COUNTER=`expr $ACTIVATE_FLOW_EVENTS_COUNT + 1`
                                        done
                fi
  }
  
  function func_deactivateFlowEvents
  {
 echo "   ------- Deactivating Flow Events  -------" ;echo
				
				if [[ -n "$DEACTIVATE_FLOW_EVENTS_COUNT" ]]
                then
                 echo "   ------- Deactivating Flow Events  -------" ;echo
                                        DEACTIVATE_FLOW_EVENTS_COUNTER=1
                                        until [  $DEACTIVATE_FLOW_EVENTS_COUNTER -gt $DEACTIVATE_FLOW_EVENTS_COUNT ]
                                        do
                                        eval "DEACTIVATE_FLOW_EVENTS_EXECUTION_GROUP_var=\$DEACTIVATE_FLOW_EVENTS_EXECUTION_GROUP${DEACTIVATE_FLOW_EVENTS_COUNTER}"
										eval "DEACTIVATE_FLOW_EVENTS_FLOW_var=\$DEACTIVATE_FLOW_EVENTS_FLOW${DEACTIVATE_FLOW_EVENTS_COUNTER}"
                                        
                                                echo mqsichangeflowmonitoring $BROKER -e $DEACTIVATE_FLOW_EVENTS_EXECUTION_GROUP_var -f $DEACTIVATE_FLOW_EVENTS_FLOW_var -c inactive >> brksetuplog.txt
                                                echo mqsichangeflowmonitoring $BROKER -e $DEACTIVATE_FLOW_EVENTS_EXECUTION_GROUP_var -f $DEACTIVATE_FLOW_EVENTS_FLOW_var -c inactive
												mqsichangeflowmonitoring $BROKER -e $DEACTIVATE_FLOW_EVENTS_EXECUTION_GROUP_var -f $DEACTIVATE_FLOW_EVENTS_FLOW_var -c inactive
                                                DEACTIVATE_FLOW_EVENTS_COUNTER=`expr $DEACTIVATE_FLOW_EVENTS_COUNT + 1`
                                        done
                fi
  }
  	

function func_UCDDeploy
{
								
                                UCD_EVENT_COUNTER=1			
								
								print $UCD_EVENT_COUNTER
								print $UCD_EVENT_COUNT
								print $UCD_EVENT1
								
								
								
								print $UCD_EVENT_COUNTER
								print $UCD_EVENT_COUNT
								print $UCD_EVENT1
								
								
                                   until [  $UCD_EVENT_COUNTER -gt $UCD_EVENT_COUNT  ]
									    do
									 
										  eval "UCD_EVENT_var=\$UCD_EVENT${UCD_EVENT_COUNTER}"
										  print $UCD_EVENT_var
										
										   case "$UCD_EVENT_var" in
						# # # # #------------------------------------------------------------------------------------------
						# # # # # *************************      UCD DECISION Logic      *******************************
						# # # # #------------------------------------------------------------------------------------------
					
										# #First stage of the broker creation 
										# #ODBC link
										# #create RSA Key this should be emailed to Stephen leitch to be placed in the known hosts
										# #create the sftp security credential on the broker
										# #start the boker
										# #create the aggregation configurable service
										# #Create FTPSever configurable service 
										# #Set up the web admin 
										# #stop broker 
										# #start broker
										
										    'AutoDeployment_part1')
										 	  func_createBroker
											  func_linkODBC
										      func_createRSAKey
											  func_setDatabasesecurityCredentials
											  func_setSFTPSecurityCredential
											  func_startBroker	
											  func_createAggregationConfiguarableService
											  func_createFTPServerConfigurableService
											  func_webadminAutoDeploy
											  func_stopBroker
											  echo "UCD_EVENT1=AutoDeployment_part2" >>UCD_DEPLOY.var
											  exit
										    echo "   ------- UCD Deploy Logic - Auto Deploy Part one complete -------" ;echo
										    ;;				


											# #Part two of the auto deploy to be ran after a part 1 and after code deploy
											# # Deploy SSL
											# #Activaye flow events 
											# #Activate flow stats 
											# #Recycle the broke
											
										    'AutoDeployment_part2')
										   	 func_autoDeploySSL
											 func_activateFlowEvents
											 func_enableFlowStatsWholeBroker
											 func_stopBroker
											 rm UCD_DEPLOY.var
											 UCD_EVENT_COUNTER=`expr $UCD_EVENT_COUNT + 1`
											 echo "   ------- UCD Deploy Logic - Auto Deploy Part two complete -------" ;echo
										    ;;
																				 
										    *)
										    echo "   ---- Incorrect Parameter Specified"; echo
											  exit
										    ;;
										   esac
										 
                                       done   
										  exit
}
#------------------------------------------------------------------------------------------
# *************************      Start of Menu              *******************************
#------------------------------------------------------------------------------------------
if [ "X$GOARG" = "X" ]
	then	
						. ./UCD_DEPLOY.var
						func_Header
						func_UCDDeploy
						exit
fi
