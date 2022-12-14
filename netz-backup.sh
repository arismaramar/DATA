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
# Initialize Backup
# Tanggal
Tanggal=$(date +"%Y-%m-%d")
# Nama
echo -e "Buatlah Nama Anda Sendiri"
read -rp "Masukan Nama : " -e NamaMu
if [[ -z $NamaMu ]]; then
	exit 0
fi
echo -e "Buatlah Password Rahasia Sendiri"
read -rp "Masukan Password : " -e PassKamu
if [[ -z $PassKamu ]]; then
	exit 0
fi
echo -e "Processing... "
# Logical Checker
# Logical Test File
NETZ_UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
HEADER="--header X-Forwarded-For:$XIP"
# Write code
result=$(curl $HEADER --user-agent "${NETZ_UA}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "http://cloud.adinetworks.eu.org/$Tanggal/$NamaMu-$Tanggal.zip")
if [ "$result" = "200" ]; then
	echo -e "${red}Data Telah Ada Gunakan Nama Lain${NC}"
	exit 0
elif [ "$result" = "000" ]; then
	echo -e "${red}Maintenance Sabar Ya..${NC}"
	exit 0
elif [ "$result" = "404" ]; then
echo -e "${green}SIP Data Kamu Akan Dibackup${NC}"
mkdir -p /root/backup
# Link Backup
cp /etc/passwd /root/backup
cp /etc/group /root/backup
cp /etc/shadow /root/backup
cp /etc/gshadow /root/backup
cp -r /usr/local/etc/xray/netz /root/backup
cd /root
zip -rP $PassKamu $NamaMu-$Tanggal.zip backup > /dev/null 2>&1
# Initialize Github
git config --global user.email "adisubagja.id@gmail.com" &> /dev/null
git config --global user.name "Assisten-Netz" &> /dev/null
git clone https://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@github.com/adisubagja/netz-cloud adi-assistance &> /dev/null
mkdir /root/adi-assistance/$Tanggal &> /dev/null
mv /root/$NamaMu-$Tanggal.zip /root/adi-assistance/$Tanggal/$NamaMu-$Tanggal.zip &> /dev/null
cd adi-assistance &> /dev/null
git pull &> /dev/null
git add . &> /dev/null
git commit -m "$NamaMu-$Tanggal Sukses Dibackup" &> /dev/null
git push -f https://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@github.com/adisubagja/netz-cloud.git &> /dev/null
# CLEARING
rm -rf /root/backup
rm -rf /root/adi-assistance
rm -rf /root/$NamaMu-$Tanggal.zip
echo -e "Data Telah Tersimpan Di Netz-Backup
================================
User    : $NamaMu
Pass    : $PassKamu
Tgl     : $Tanggal
================================
Silahkan catat atau simpan data tersebut baik-baik
Untuk Restore Tinggal Masukan Nama Tanggal dan Password saja
Warning !!! Admin Script Tidak Memberikan Fitur Untuk Lupa Sandi :D Terimakasih"
fi
