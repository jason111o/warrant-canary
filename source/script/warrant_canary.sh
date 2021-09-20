#!/usr/bin/env bash

####MOETOX####

#### Set some variables
version="Warrant Canary v1.1"
icons="/usr/local/bin/warrant_canary_icons"
phrase="Signed Warrant"
website="https://parrotsec.org/docs/warrant-canary.html"

#### Display version info
notify-send -t 3000 -i $icons/still_safe.png "$version"
echo "$version"
sleep 3

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
    notify-send -t 3000 -i $icons/check_canary.png "Checking for Canary Warrant"
    echo "Checking for Canary Warrant"
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
keywords=$(curl -L -s $website | grep "$phrase")
if [[ $? != 0 ]]; then
    notify-send -t 0 -i $icons/has_warrants.png "PARROTSEC MAY HAVE BEEN SERVED!!!"
    echo "PARROTSEC MAY HAVE BEEN SERVED!!!"
  else
    notify-send -t 10000 -i $icons/still_safe.png "$keywords"
    echo "$keywords"
fi
exit 0
