#!/bin/bash
clear
#delete file
rm -f /usr/local/bin/trial
rm -f /usr/local/bin/usernew
rm -f /usr/local/bin/menu


# download script
cd /usr/local/bin
wget -O trial "https://raw.githubusercontent.com/jinggovpn/DATA/main/SSHOVPN/trial.sh" && chmod +x trial
wget -O usernew "https://raw.githubusercontent.com/jinggovpn/DATA/main/SSHOVPN/usernew.sh" && chmod +x usernew
wget -O menu "https://raw.githubusercontent.com/jinggovpn/DATA/main/SSHOVPN/menu.sh" && chmod +x menu

cd
clear
