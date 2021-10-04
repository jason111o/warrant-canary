#!/usr/bin/env bash


##### Add a little style
RED='\033[01;31m'
YELLOW='\033[01;33m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
NOCOLOR='\033[0m'


#### Check for super powers
if [ $EUID != 0 ]; then
  echo -e "\n${RED}Installer must be run with Super Powers ;)\n${NOCOLOR}"
  exit 1
fi
#### Ensure that we are in the warrant-canary directory
if [[ $(echo $PWD | awk -F '/' '{print $NF}') != "warrant-canary" ]]; then
  echo -e "\n${RED}Installer must be run from the warrant-canary directory\n${NOCOLOR}"
  exit 1
fi


#### Check for dependencies (some are moot, purely for cli asthetics)
check_for_dependencies() {
  depends=("curl" "fping" "echo" "apt" "printf")
  depends_not_installed=()
  printf "${WHITE}Checking dependencies"
  for x in "${depends[@]}"; do
    printf "."
    xpath=$(command -v "$x")
    if [[ "$xpath" ]]; then
      sleep .5
    elif [[ ! "$xpath" ]]; then
      sleep 0.25
      depends_not_installed+=("$x")
    fi
  done
  echo ""
  sleep 1
}
#### If dependencies are needed then prompt the user to install them
dependencies_needed() {
  len=${#depends_not_installed}
  while [ "$len" -gt 0 ]; do
    echo ""
    echo -e "${WHITE}Install missing dependencies? Y/n/e/v${NOCOLOR}"
    read -r ans
    if [[ "$ans" == "v" ]]; then
      print_version
    elif [[ "$ans" == "n" ]]; then
      echo -e "${CYAN}This script needs..."
      for x in "${depends_not_installed[@]}"; do
        echo -e "${WHITE}----> ${RED}$x"
        sleep 0.5
      done
      echo -e "${CYAN}in order to work.${NOCOLOR}\n"
    elif [[ $ans == "e" ]]; then
      echo -e "${WHITE}Exiting...${NOCOLOR}\n"
      sleep 1
      exit 1
    elif [[ "$len" == 0 ]]; then
      break
    else
      for x in "${depends_not_installed[@]}"; do
        apt install -f -y "$x"
        if [[ $? != 0 ]]; then
          echo -e "${YELLOW}\"$x\" was not found in your distribution package sources."
          echo -e "Check your distros documentation.${NOCOLOR}\n"
        fi
        check_for_dependencies
        len=${#depends_not_installed}
        if [[ $len == 0 ]]; then
          echo -e "${WHITE}Dependencies have been satisfied. Press enter to continue...${NC}"
        fi
      done
    fi
  done
}
#### Run previously declared funtions
check_for_dependencies
dependencies_needed


#### Check if warrant_canary is already installed
if [ -x /usr/local/bin/warrant_canary ]; then
  echo -e "\n${YELLOW}Warrant Canary is already installed."
  printf "${CYAN}Press ENTER to reinstall or CTRL+C to exit"
  read
fi


#### Check if the icon source directory exists and if it does remove it for reinstall
if [ -d /usr/local/bin/warrant_canary_icons ]; then
  rm -r /usr/local/bin/warrant_canary_icons
fi


#### Install everything to /usr/local/bin and set permissions for all users
echo -e "\n${WHITE}Installing Warrant Canary...${NOCOLOR}"
sleep 3
#---------------------------------------------
if [[ ! -f source/script/warrant_canary.sh ]]; then
  echo -e "\n${CYAN}\"source/script/warrant_canary.sh\" ${RED}NOT FOUND\n${NOCOLOR}Exiting...\n"
  sleep 2
  exit 1
else
  cp source/script/warrant_canary.sh /usr/local/bin/warrant_canary 2>/dev/null
  if [[ $? != 0 ]]; then
    echo -e "\n${RED}ERROR encountered while copying script to ${YELLOW}/usr/local/bin${NOCOLOR}\nExiting...\n"
    sleep 2
    exit 1
  else
    chmod +x /usr/local/bin/warrant_canary
  fi
fi
#-----------------------------------------------
if [[ ! -d source/warrant_canary_icons ]]; then
  echo -e "\n${CYAN}\"source/warrant_canary_icons\" ${RED}NOT FOUND\nExiting...\n"
  sleep 2
  exit 1
else
  cp -r source/warrant_canary_icons /usr/local/bin/ 2>/dev/null
  if [[ $? != 0 ]]; then
    echo -e "${RED}ERROR encoutered while copying icons to ${YELLOW}/usr/local/bin${NOCOLOR}\nExiting...\n"
    sleep 2
    exit 1
  fi
fi


#### Everything is done
echo -e "\n${CYAN}Warrant Canary has been installed and can be run from the command line as 'warrant_canary'\n${NOCOLOR}"


exit 0
