#!/usr/bin/env bash

####MOETOX####

#### Set some variables
version="Warrant Canary v1.0"
icons="/usr/local/bin/warrant_canary_icons"
phrase="Signed Warrant"
website="https://parrotsec.org/docs/warrant-canary.html"

#### Display version info
notify-send -t 3000 -i $icons/still_safe.png "$version"
sleep 3

#### Check for internet connection a time or two if no connection is made
tries=3
while true; do
    notify-send -t 3000 -i $icons/check_connection.png "Checking internet connection"
    sleep 3
  connected=$(fping -4 google.com 2>/dev/null | grep -o alive)
  if [[ $connected == "alive" ]]; then
    notify-send -t 3000 -i $icons/connected.png "Connection established!"
    sleep 3
    notify-send -t 3000 -i $icons/check_canary.png "Checking for Canary Warrant"
    sleep 3
    break
  else
    notify-send -t 3000 -i $icons/not_connected.png "You are not online!"
    sleep 3
    notify-send -t 3000 -i $icons/check_connection.png "Trying again ($tries)..."
    sleep 3
  fi
  if [[ $tries == 0 ]]; then
    notify-send -t 3000 -i $icons/not_connected.png "Connection cannot be established! Exiting..."
    exit 99
  fi
  tries=$(expr $tries - 1)
done

#### Now actually check for the ParrotSEC warrant canary
#### Well... at least a particular phrase
keywords=$(curl -L -s $website | grep "$phrase")
if [[ $? != 0 ]]; then
    notify-send -t 0 -i $icons/has_warrants.png "PARROTSEC MAY HAVE BEEN SERVED!!!"
  else
    notify-send -t 10000 -i $icons/still_safe.png "$keywords"
fi
exit 0
