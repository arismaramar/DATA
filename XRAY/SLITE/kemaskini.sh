#!/bin/bash
clear
#delete file
rm -f /usr/local/bin/menu

# download script
cd /usr/local/bin
wget -O menu "https://raw.githubusercontent.com/jinggovpn/DATA/main/XRAY/SLITE/menu.sh" && chmod +x menu

cd
clear
