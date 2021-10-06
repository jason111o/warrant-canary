#!/usr/bin/env bash

####MOETOX####

#### Set some variables
version="Warrant Canary v1.4"
icons="/usr/local/share/warrant_canary_icons"
phrase="Signed"
website="https://parrotsec.org/docs/warrant-canary.html"
help_info="\nwarrant_canary [-h (help) | -v (version) | -a (about)]\n"

#### Display usage
case $1 in
  "-h")
    echo -e "$help_info"
    exit 0
    ;;
  "-v")
    echo -e "\n$version\n"
    exit 0
    ;;
  "-a")
    echo -e "\nWarrant Canary (warrant_canary from the cli);"
    echo -e "uses basic linux commands to check for a particular \"string\""
    echo -e "from https://parrotsec.org/docs/warrant-canary.html and then"
    echo -e "display it to you in hopes of just making it easier to get a"
    echo -e "hint if they have been served a secret warrant by an agency"
    echo -e "of sorts."
    echo -e "  This information is passive in nature, but is on display"
    echo -e "and available to all who wish to know just how far an agency"
    echo -e "is willing to go to monitor it's law abiding citizens in the"
    echo -e "name of whatever the catch phrase is of the day.\n"
    exit 0
    ;;
esac

#### Check for internet connection a time or two if no connection is made
connected="true"
tries=3
while (expr $tries > 0); do
    notify-send -t 3000 -i $icons/check_connection.png "Checking internet connection"
    echo "Checking internet connection..." &
  connected=$(fping -4 parrotsec.org 2>/dev/null | grep -o alive)
  if [[ $connected == "alive" ]]; then
    notify-send -t 3000 -i $icons/connected.png "Connection established!"
    echo "Connection established!"
    sleep 3
    notify-send -t 3000 -i $icons/check_canary.png "Checking for Warrant Canary"
    echo "Checking for Warrant Canary"
    sleep 3
    break
  else
    notify-send -t 3000 -i $icons/not_connected.png "You are not online!"
    echo "You are not online!"
    sleep 3
    notify-send -t 3000 -i $icons/check_connection.png "Trying again ($tries)..."
    echo "Trying again ($tries)"
  fi
  tries=$(expr $tries - 1)
  if [[ $tries == 0 ]]; then
    connected="false"
  fi
done
if [[ "$connected" == "false" ]]; then
    notify-send -t 3000 -i $icons/not_connected.png "Connection cannot be established! Exiting..."
    echo "Connection cannot be established! Exiting..."
    sleep 1
  exit 99
fi

#### Now actually check for the ParrotSEC warrant canary
#### Well... at least a particular phrase
keywords=$(curl -s $website | grep "$phrase")
if [[ $? != 0 ]]; then
    notify-send -t 0 -i $icons/has_warrants.png "PARROTSEC MAY HAVE BEEN SERVED!!!"
    echo "PARROTSEC MAY HAVE BEEN SERVED!!!"
  else
    notify-send -t 10000 -i $icons/still_safe.png "$keywords"
    echo "$keywords"
fi
exit 0
