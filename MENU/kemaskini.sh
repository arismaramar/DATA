#!/bin/bash
clear
#delete file
rm -f /usr/local/bin/menu
rm -f /usr/local/bin/backup

# download script
cd /usr/local/bin
wget -O menu "https://raw.githubusercontent.com/jinggovpn/DATA/main/MENU/menu.sh" && chmod +x menu
wget -O backup "https://raw.githubusercontent.com/jinggovpn/DATA/main/MENU/backup.sh" && chmod +x backup

cd
clear
