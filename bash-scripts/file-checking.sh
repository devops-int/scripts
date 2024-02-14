#!/usr/bin/env bash

# The script takes csv or json file based on the entered parameter.
# It iterates through the hosts listed in the file and checks if there is connection to them.


FILE=""
TYPE=""
COUNT_OK=0
COUNT_NOTOK=0
COUNT_OK_JSON=0
COUNT_NOTOK_JSON=0

function check_csv(){
  while IFS=, read -r HOST PORT 
  do 
    IP=$(ping -c 1 $HOST| awk -F '[()]' '/PING/ { print $2}')
    nc -z -w 3 $HOST $PORT
    if [ $? -eq 0 ]; then
      COUNT_OK=$((COUNT_OK + 1))
      echo "$HOST ($IP) - OK"
    else
      COUNT_NOTOK=$((COUNT_NOTOK + 1))
      echo "$HOST ($IP) - NOT OK"    
    fi           
  done < $FILE
  echo "TOTAL: $COUNT_OK OK, $COUNT_NOTOK NOT OK"
}

function check_json(){
  count=`jq '. | length' $FILE`
  for ((i=0; i<$count; i++)); do
      HOST=`jq -r '.['$i'].host' $FILE`
      PORT=`jq -r '.['$i'].port' $FILE`
      nc -z -w 3 $HOST $PORT
      if [ $? -eq 0 ]; then
        COUNT_OK_JSON=$((COUNT_OK_JSON + 1))
        echo "$HOST ($IP) - OK"
      else
        COUNT_NOTOK_JSON=$((COUNT_NOTOK_JSON + 1))
        echo "$HOST ($IP) - NOT OK"    
      fi  
  done
  echo "TOTAL: $COUNT_OK_JSON OK, $COUNT_NOTOK_JSON NOT OK"
}

while getopts "f:t:" OPTION; do
  case $OPTION in
    f)
      FILE="$OPTARG"
      ;;
    t)
      TYPE="$OPTARG"
      ;;
    *)
      echo "Unknown option";
      exit 1;;
  esac
done 

if [[ $TYPE == "csv" ]] || [[ $TYPE == "CSV" ]]; then
  echo "Starting the CSV formating"
  check_csv 
  exit 0
elif [[ $TYPE == "json" ]] || [[ $TYPE == "JSON" ]]; then
  echo "Starting the JSON formating"
  check_json
  exit 0
else
  echo "Incorrect format of the file"
fi