#!/bin/bash
## Author: Simon Peter, Swisscom IT Services AG
## Created: 15.08.2013
## Last modfied: 20.08.2013
## Version: 0.2
## Script to sequentially connect to an arbitrary number of ssh servers, in conjunction with auto_connect.sh
##### IMPORTANT: REQUIRES auto_connect.sh
if [[ "`which expect`" != "/usr/bin/expect" ]]
then
  echo "Paket expect missing. Please install missing paket."
  exit 1
fi

usage() {
  cat<<EOF
  usage: $0 [-h] [-m] [-c command [-e]] server [server...]

  OPTIONS:
    -h  Show this message
    -m  Master Mode (automatically sets you as root)
    -c  Execute command on SSH Server
    -e  Exit from SSH Server after command execution
EOF
}

COMMAND=
EXITAFTER=0
MASTER=0

while getopts "hmc:e" OPTION
do
  case $OPTION in
    h)
      usage
      exit 1
      ;;
    m)
      MASTER=1
      ;;
    c)
      COMMAND=$OPTARG
      ;;
    e)
      EXITAFTER=1
      ;;
  esac
done

echo -n "Passwort: "
read -s pass
i=0
for sshserver in $@
do
    first=$(echo "$sshserver" | cut -c1-1)
    if [[ "$first" != "-" && "$COMMAND" != "$sshserver" ]]
    then
      ((i++))
      ./auto_connect.sh $sshserver $pass comm=$COMMAND exit=$EXITAFTER master=$MASTER
    fi
done
if [[ $i < 1 ]]
then
  echo -e "\nPlease enter an sshserver at the end of the command\n"
  usage
  exit 1
fi
