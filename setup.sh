
## DO NOT RUN ##

## Install
  # Mason Perdue
  # masonp
  # server
  # masonperdue.com
  # Root on SSD, /home on HDD

## Head boot
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove --purge -y
  sudo apt autoclean
  sudo apt install -y openssh-server
  sudo shutdown now

## Headless Boot
  ssh -A masonp@192.168.50.10
  
