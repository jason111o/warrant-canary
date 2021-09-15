#!/usr/bin/env bash


#### Check for super powers
if [ $UID != 0 ]; then
  echo "Installer must be run with Super Powers ;)"
  exit 1
fi


#### Check if warrant_canary is already installed
if [ -x /usr/local/bin/warrant_canary ]; then
  echo "warrant_canary is already installed"
  echo "Press ENTER to reinstall or CTRL+C to exit"
  read
fi


#### Check if the icon source directory exists and if it does remove it for reinstall
if [ -d /usr/local/bin/warrant_canary_icons ]; then
  rm -r /usr/local/bin/warrant_canary_icons
fi


#### Install everything to /usr/local/bin and set permissions for all users
cp source/script/warrant_canary.sh /usr/local/bin/warrant_canary
chmod +x /usr/local/bin/warrant_canary
cp -r source/warrant_canary_icons /usr/local/bin/


#### Everything is done
echo -e "\nwarrant_canary has been installed and can be run from the command line as 'warrant_canary'\n"


exit 0
