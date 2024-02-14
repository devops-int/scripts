#!/usr/bin/env bash

# The script checks whether port is open or whether there is connectivity to server based on the selected option. 

SERVER=""
PORT=""
VAL_I=""

function check_port()
{  
  </dev/tcp/$1/$2 
  if [ "$?" -ne 0 ]; then
    echo "The port $2 is not open"
  else
    echo "The port $2 is open"
  fi
}

function check_connection()
{
  if ping -c 3 -W 3 $1 >/dev/null; then
    echo "There is connectivity to the host"
  else
    echo "There is not connectivity"
  fi  
}

while getopts "h:p:i" OPTION; do
  case $OPTION in
    h)
      SERVER="$OPTARG"
      ;;
    p)
      PORT="$OPTARG"
      ;;
    i)
      VAL_I="i"
      ;;
    *)
      echo "Unknown option";
      exit 1;;
  esac
done 

IP=$(ping -c 1 $SERVER| awk -F '[()]' '/PING/ { print $2}')     
echo $IP

if [[ $VAL_I == "i" ]]; then
  check_connection $SERVER
  exit 0
fi

check_port $SERVER $PORT 