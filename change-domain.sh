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
# PKG
apt update && upgrade
apt install git -y
# Remove Necesarry Files
rm -f /etc/adi/adi.crt
rm -f /etc/adi/adi.key
rm -f /etc/adi/domain
rm -f /root/domain
# Command
echo "Masukan Domain Baru Kamu"
read -p "Hostname / Domain: " host
echo "$host" >> /etc/adi/domain
echo "$host" >> /root/domain
# ENV
domain=$(cat /root/domain)
# Clone Acme
ufw disable
git clone https://github.com/acmesh-official/acme.sh.git /etc/acme
cd /etc/acme
systemctl stop nginx
systemctl stop xray
chmod +x acme.sh
./acme.sh --set-default-ca --server letsencrypt
./acme.sh --register-account -m netz@$domain
./acme.sh --issue -d $domain --standalone --server letsencrypt --force
./acme.sh --installcert -d $domain --key-file /etc/adi/adi.key --fullchain-file /etc/adi/adi.crt
# Restart Service
rm -f /root/domain
systemctl restart nginx
systemctl restart xray
echo "Domain Telah Diperbarui & Sertifikasi Selesai"
