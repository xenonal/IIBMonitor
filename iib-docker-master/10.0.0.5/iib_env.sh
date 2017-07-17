#!/bin/bash


if [ -z "$MQSI_VERSION" ]; then
  echo "Sourcing profile"
  source /opt/ibm/iib-10.0.0.4/server/bin/mqsiprofile
  export ODBCINI=/opt/ibm/iib-10.0.0.4/server/ODBC/unixodbc/odbc.ini
fi
