#!/usr/bin/env bash

####MOETOX####

#### Set the img_source directory
img=/usr/local/bin/warrant_canary_icons

#### Check for internet connection a time or two if no connection is made
tries=3
while true; do
    notify-send -t 3000 -i $img/check_connection.png "Checking internet connection"
    sleep 3
  connected=$(fping -4 google.com 2>/dev/null | grep -o alive)
  if [[ $connected == "alive" ]]; then
    notify-send -t 3000 -i $img/connected.png "Connection established!"
    sleep 3
    notify-send -t 3000 -i $img/check_canary.png "Checking for Canary Warrant"
    sleep 3
    break
  else
    notify-send -t 3000 -i $img/not_connected.png "You are not online!"
    sleep 3
    notify-send -t 3000 -i $img/check_connection.png "Trying again ($tries)..."
    sleep 3
  fi
  if [[ $tries == 0 ]]; then
    notify-send -t 3000 -i $img/not_connected.png "Connection cannot be established! Exiting..."
    exit 99
  fi
  tries=$(expr $tries - 1)
done

#### Now actually check for the ParrotSEC warrant canary
#### Well... at least a particular phrase
phrase="WE ARE STILL SAFE"
website="https://parrotsec.org/docs/warrant-canary.html"
keywords=$(curl -L -s $website | grep -o "$phrase")
if [[ ! $keywords ]]; then
    notify-send -t 0 -i $img/search.png "Searched for phrase '$phrase' from '$website'"
    notify-send -t 0 -i $img/has_warrants.png "PARROTSEC HAS SECRET WARRANTS!!!"
  else
    notify-send -t 6000 -i $img/still_safe.png "We are still safe!"
fi
exit 0
