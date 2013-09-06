#!/bin/bash
## Author: Simon Peter, Swisscom IT Services AG
## Created: 15.08.2013
## Last modfied: 28.08.2013
## Version: 0.3
## Script to sequentially connect to an arbitrary number of ssh servers, in conjunction with auto_connect.sh
##### IMPORTANT: REQUIRES auto_connect.sh
## Check whether expect is installed (used in auto_connect.sh)
if [[ "`which expect`" != "/usr/bin/expect" ]]
then
  echo "Paket expect missing. Please install missing paket."
  exit 1
fi

## Let me drop some knowledge on you ;-)
usage() {
  cat<<EOF
  usage: $0 [-h] [-m] [[-e] -c command] server [server...]

  OPTIONS:
    -h  Show this message
    -m  Master Mode (automatically sets you as root)
    -e  Exit from SSH Server after command execution
    -c  Execute command on SSH Server
EOF
}

COMMAND=
EXITAFTER=0
MASTER=0

## Get the options
while getopts "hmec:" OPTION
do
  case "$OPTION" in
    h)
      usage
      exit 1
      ;;
    m) MASTER=1 ;;
    e) EXITAFTER=1 ;;
    c) COMMAND="$OPTARG" ;;
  esac
done

## Ask for Password (which will be used for all ssh connections)
echo -n "Passwort: "
read -s pass
i=0
for sshserver in "$@"
do
    ## Make sure no hyphen is in front (indication of option)
    first=$(echo "$sshserver" | cut -c1-1)
    if [[ "$first" != "-" && "$COMMAND" != "$sshserver" ]]
    then
      ((i++))
      echo "./auto_connect.sh $sshserver $pass exit=$EXITAFTER master=$MASTER $COMMAND"
    fi
done
if [[ $i < 1 ]]
then
  echo -e "\nPlease enter an sshserver at the end of the command\n"
  usage
  exit 1
fi
