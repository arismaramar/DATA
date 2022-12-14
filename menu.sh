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
cekreboot=$(cat /etc/crontab | grep reboot)
cekprofilereboot="$?"
cekclearlog=$(cat /etc/crontab | grep clear-log)
cekprofilelog="$?"
cekexpired=$(cat /etc/crontab | grep exp)
cekprofileexpired="$?"
timezone=$(timedatectl | grep "Time zone" |  awk '{print $3}')
time=$(timedatectl | grep "Local time" | awk '{print $5" "$6}')
clear
# Menu
echo -e "${purple}==================>>  MENU <<==================${NC}"
if [[ $cekprofilereboot = "0" ]]; then
	echo -e "Auto Reboot : ${green}ON${NC}"
else
	echo -e "Auto Reboot : ${red}OFF${NC}"
fi
if [[ $cekprofilelog = "0" ]]; then
	echo -e "Auto ClearLog : ${green}ON${NC}"
else
	echo -e "Auto ClearLog : ${red}OFF${NC}"
fi
if [[ $cekprofileexpired = "0" ]]; then
	echo -e "Auto Delete Expired : ${green}ON${NC}"
else
	echo -e "Auto Delete Expired : ${red}OFF${NC}"
fi
echo -e "Jam : ${green}$time $timezone${NC}"
echo -e "${yellow}==================>>  SSH <<==================${NC}"
echo -e "0  => Trial Akun SSH"
echo -e "1  => Buat Akun SSH"
echo -e "2  => Hapus Akun SSH"
echo -e "3  => Perpanjang Akun SSH"
echo -e "4  => Cek Akun SSH"
echo -e "5  => Ganti Banner SSH"
echo -e "${cyan}==================>>  ADD <<==================${NC}"
echo -e "6  => Buat Akun VMESS"
echo -e "7  => Buat Akun VLESS"
echo -e "8  => Buat Akun TROJAN"
echo -e "9  => Buat Akun SHADOWSOCKS"
echo -e "10 => Buat Akun SHADOWSOCKS 2022"
echo -e "11 => Buat Akun SOCKS"
echo -e "${blue}==================>>  DEL <<==================${NC}"
echo -e "12 => Hapus Akun VMESS"
echo -e "13 => Hapus Akun VLESS"
echo -e "14 => Hapus Akun TROJAN"
echo -e "15 => Hapus Akun SHADOWSOCKS"
echo -e "16 => Hapus Akun SHADOWSOCKS 2022"
echo -e "17 => Hapus Akun SOCKS"
echo -e "${red}==================>>  RENEW <<==================${NC}"
echo -e "18 => Perpanjang Akun VMESS"
echo -e "19 => Perpanjang Akun VLESS"
echo -e "20 => Perpanjang Akun TROJAN"
echo -e "21 => Perpanjang Akun SHADOWSOCKS"
echo -e "22 => Perpanjang Akun SHADOWSOCKS 2022"
echo -e "23 => Perpanjang Akun SOCKS"
echo -e "${yellow}==================>>  ALAT <<==================${NC}"
echo -e "24 => Cek Traffic"
echo -e "25 => Backup Akun Ke Netz-Cloud"
echo -e "26 => Restore Akun Dari Netz-Cloud"
echo -e "27 => Ganti Domain & Perbarui Sertifikat"
echo -e "28 => Bersihkan Cache & Log"
echo -e "29 => Tweak BBR TeddySun"
echo -e "30 => Restart Service"
echo -e "31 => Install Kernel XanMod"
echo -e "32 => Speedtest Server"
read -p "   => Silahkan pilih opsi tersedia : " listmenu
case $listmenu in
	0) trial-ssh ;;
	1) add-ssh ;;
	2) del-ssh ;;
	3) renew-ssh ;;
	4) cek-ssh ;;
	5) nano /etc/issue.net ;;
	6) add-vmess ;;
	7) add-vless ;;
	8) add-trojan ;;
	9) add-ss ;;
	10) add-ssblake ;;
	11) add-socks ;;
	12) del-vmess ;;
	13) del-vless ;;
	14) del-trojan ;;
	15) del-ss ;;
	16) del-ssblake ;;
	17) del-socks ;;
	18) renew-vmess ;;
	19) renew-vless ;;
	20) renew-trojan ;;
	21) renew-ss ;;
	22) renew-ssblake ;;
	23) renew-socks ;;
	24) cek-traffic ;;
	25) netz-backup ;;
	26) netz-restore ;;
	27) change-domain ;;
	28) clear-log ;;
	29) netz-bbr ;;
	30) netz-restart ;;
	31) netz-xanmod ;;
	32) speedtest ;;
	*) welcome; echo "Pilih nomor list" ;;
esac
