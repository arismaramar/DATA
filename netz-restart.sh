#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
blue='\e[0;34m'
yellow='\e[1;33m'
cyan='\e[1;96m'
NC='\e[0m'
# Getting Online Date
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
dateayena=`date +"%Y-%m-%d" -d "$dateFromServer"`
# MYIP IP & GET EXPIRED
MYIP=$(curl -4 -sS ipv4.icanhazip.com)
IZIN=$(curl -4 -sS https://raw.githubusercontent.com/arismaramar/kuprit/main/list.txt | awk '{print $1}' | grep -w $MYIP)
EXP=$(curl -4 -sS https://raw.githubusercontent.com/arismaramar/kuprit/main/list.txt | grep -w $MYIP | awk '{print $2}')
USERVPS=$(curl -4 -sS https://raw.githubusercontent.com/arismaramar/kuprit/main/list.txt | grep -w $MYIP | awk '{print $3}')
# Cek Database
echo "Checking..."
if [[ $MYIP = $IZIN ]]; then
	echo -e "${green}IP Diterima...${NC}"
else
	echo -e "${red}IP Belum Terdaftar!${NC}";
	echo "Hubungi @arismaramar Untuk Daftar Premium"
	exit 0
fi
# Cek Tanggal
d1=(`date -d "$EXP" +%s`)
d2=(`date -d "$dateayena" +%s`)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
	echo "${red}Masa Aktif Habis ! Silahkan Perpanjang${NC}";
	exit 0
else
	echo -e "${green}Masa Aktif Berjalan${NC}";
fi
clear
echo -e ""
echo -e "======================================"
echo -e ""
echo -e ""
echo -e "    [1] Restart All Services"
echo -e "    [2] Restart Xray"
echo -e "    [3] Restart Nginx"
echo -e "    [4] Restart Dropbear"
echo -e "    [5] Restart Stunnel4"
echo -e "    [x] Exit"
echo -e ""
read -p "    Select From Options [1-5 or x] :  " Restart
echo -e ""
echo -e "======================================"
sleep 1
clear
case $Restart in
clear
systemctl restart xray
systemctl restart nginx
systemctl restart dropbear
systemctl restart stunnel4
systemctl restart rc-local
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "          Service/s Restarted         "
echo -e ""
echo -e "======================================"
exit
clear
systemctl restart xray
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "          Service/s Restarted         "
echo -e ""
echo -e "======================================"
exit
clear
systemctl restart nginx
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "          Service/s Restarted         "
echo -e ""
echo -e "======================================"
exit
clear
systemctl restart dropbear
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "          Service/s Restarted         "
echo -e ""
echo -e "======================================"
exit
clear
systemctl restart stunnel4
echo -e ""
echo -e "======================================"
echo -e ""
echo -e "          Service/s Restarted         "
echo -e ""
echo -e "======================================"
exit
exit
echo  "Pilih nomor perintah"
esac
