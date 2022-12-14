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
# Variable
domain=$(cat /etc/adi/domain)
ISP=$( curl -s https://ipapi.co/${MYIP}/org/)
master=$(hostname)
clientssh=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
clientvmess=$(grep -E -s "^### " "/usr/local/etc/xray/netz/vmessws.json" | cut -d ' ' -f 2 | wc -l)
clientvless=$(grep -E -s "^### " "/usr/local/etc/xray/netz/vlessws.json" | cut -d ' ' -f 2 | wc -l)
clienttrojan=$(grep -E -s "^### " "/usr/local/etc/xray/netz/trojantcp.json" | cut -d ' ' -f 2 | wc -l)
clientshadowsocks=$(grep -E -s "^### " "/usr/local/etc/xray/netz/ssws.json" | cut -d ' ' -f 2 | wc -l)
clientssblake=$(grep -E -s "^### " "/usr/local/etc/xray/netz/ssblakews.json" | cut -d ' ' -f 2 | wc -l)
clientsocks=$(grep -E -s "^### " "/usr/local/etc/xray/netz/socksws.json" | cut -d ' ' -f 2 | wc -l)
totalclient=$(($clientssh + $clientvmess + $clientvless + $clienttrojan + $clientshadowsocks + $clientssblake + $clientsocks))
# Data Usage
downloadharian=$(vnstat -d | grep estimated | awk '{print $5 $6}')
uploadharian=$(vnstat -d | grep estimated | awk '{print $2 $3}')
totalharian=$(vnstat -d | grep estimated | awk '{print $8 $9}')
totalbulanan=$(vnstat -m | grep estimated | awk '{print $8 $9}')
# Running
neofetch
echo -e "Selamat Datang ${red}${master}${NC}"
echo -e "${purple}=============================================${NC}"
echo -e "${red}Client SSH               : ${green}$clientssh"
echo -e "${red}Client VMESS             : ${green}$clientvmess"
echo -e "${red}Client VLESS             : ${green}$clientvless"
echo -e "${red}Client TROJAN            : ${green}$clienttrojan"
echo -e "${red}Client SHADOWSOCKS       : ${green}$clientshadowsocks"
echo -e "${red}Client SHADOWSOCKS 2022  : ${green}$clientssblake"
echo -e "${red}Client SOCKS             : ${green}$clientsocks"
echo -e "${cyan}=============================================${NC}"
echo -e "${yellow}TOTAL CLIENT          : ${green}$totalclient${NC}"
echo -e "${yellow}Download Hari Ini     : ${green}$downloadharian${NC}"
echo -e "${yellow}Upload Hari Ini       : ${green}$uploadharian${NC}"
echo -e "${yellow}Total Hari Ini        : ${green}$totalharian${NC}"
echo -e "${yellow}Total Bulanan         : ${green}$totalbulanan${NC}"
echo -e "${cyan}=============================================${NC}"
echo -e "${green}Name                   : $USERVPS${NC}"
echo -e "${green}ISP                    : $ISP${NC}"
echo -e "${green}IP                     : $MYIP${NC}"
echo -e "${green}Domain                 : $domain${NC}"
echo -e "${green}Masa Aktif             : $exp2 Hari${NC}"
echo -e "${blue}=============================================${NC}"
# Status DROPBEAR
status="$(systemctl show dropbear --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
	echo -e "${green}Dropbear               : Aktif${NC}"
else
	echo -e "${red}Dropbear                 : Tidak Aktif (Error)${NC}"
fi
# Status Stunnel
status="$(systemctl show stunnel4 --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
	echo -e "${green}Stunnel                : Aktif${NC}"
else
	echo -e "${red}Stunnel                  : Tidak Aktif (Error)${NC}"
fi
# Status SSH WS SSL
status="$(systemctl show ws-https --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
	echo -e "${green}SSH WS SSL             : Aktif${NC}"
else
	echo -e "${red}SSH WS SSL               : Tidak Aktif (Error)${NC}"
fi
# Status SSH WS
status="$(systemctl show ws-http --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
	echo -e "${green}SSH WS                 : Aktif${NC}"
else
	echo -e "${red}SSH WS                   : Tidak Aktif (Error)${NC}"
fi
# Status Xray
status="$(systemctl show xray --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
	echo -e "${green}Xray                   : Aktif${NC}"
else
	echo -e "${red}Xray                     : Tidak Aktif (Error)${NC}"
fi
# Nginx
status="$(systemctl show nginx --no-page)"
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)
if [ "${status_text}" == "active" ]
then
	echo -e "${green}Nginx                  : Aktif${NC}"
else
	echo -e "${red}Nginx                    : Tidak Aktif (Error)${NC}"
fi
echo -e "${yellow}=============================================${NC}"
echo -e "Ketik menu untuk melihat perintah"
