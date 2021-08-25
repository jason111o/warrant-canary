#!/usr/bin/env bash

####MOETOX####

#### Check for internet connection a time or two if no connection is made
tries=10
while true; do
    notify-send -t 3000 -i /usr/share/icons/parrot-logo-black-600.png "Checking internet connection"
    sleep 3
  connected=$(fping -4 google.com 2>/dev/null | grep -o alive)
  if [[ $connected == "alive" ]]; then
    notify-send -t 3000 -i /usr/share/icons/parrot-logo-black-600.png "Connection established!"
    sleep 3
    notify-send -t 3000 -i /usr/share/icons/parrot-logo-black-600.png "Checking for Canary Warrant"
    sleep 3
    break
  else
    notify-send -t 3000 -i /usr/share/icons/parrot-logo-black-600.png "You are not online!"
    sleep 3
    notify-send -t 3000 -i /usr/share/icons/parrot-logo-black-600.png "Trying again ($tries)..."
    sleep 3
  fi
  if [[ $tries == 0 ]]; then
    notify-send -t 3000 -i /usr/share/icons/parrot-logo-black-600.png "Connection cannot be established! Exiting..."
    exit 1
  fi
  tries=$(expr $tries - 1)
done

#### Now actually check for the ParrotSEC warrant canary
phrase="WE ARE STILL SAFE"
website="https://parrotsec.org/docs/warrant-canary.html"
keywords=$(curl -L -s $website | grep -o "$phrase")
if [[ ! $keywords ]]; then
    notify-send -t 0 -i /usr/share/icons/parrot-logo-black-600.png "Searched for phrase '$phrase' from '$website'"
    notify-send -t 0 -i /usr/share/icons/parrot-logo-black-600.png "PARROTSEC HAS SECRET WARRANTS!!!"
  else
    notify-send -t 3000 -i /usr/share/icons/parrot-logo-black-600.png "We are still safe!"
fi

