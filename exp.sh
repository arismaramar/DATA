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
# Trojan TCP
data=( `cat /usr/local/etc/xray/netz/trojantcp.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
	exp=$(grep -w "^### $user" "/usr/local/etc/xray/netz/trojantcp.json" | cut -d ' ' -f 3)
	d1=$(date -d "$exp" +%s)
	d2=$(date -d "$now" +%s)
	exp2=$(( (d1 - d2) / 86400 ))
	if [[ "$exp2" = "0" ]]; then
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/trojantcp.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/trojantcpnon.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/trojanws.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/trojanwsnon.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/trojankuota.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/trojangrpc.json
	fi
done
echo TROJAN EXPIRED TERHAPUS
# Vless WS
data=( `cat /usr/local/etc/xray/netz/vlessws.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
	exp=$(grep -w "^### $user" "/usr/local/etc/xray/netz/vlessws.json" | cut -d ' ' -f 3)
	d1=$(date -d "$exp" +%s)
	d2=$(date -d "$now" +%s)
	exp2=$(( (d1 - d2) / 86400 ))
	if [[ "$exp2" = "0" ]]; then
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vlessws.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vlesswsnon.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vlesskuota.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vlessgrpc.json
	fi
done
echo VLESS EXPIRED TERHAPUS
# Vmess WS
data=( `cat /usr/local/etc/xray/netz/vmessws.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
	exp=$(grep -w "^### $user" "/usr/local/etc/xray/netz/vmessws.json" | cut -d ' ' -f 3)
	d1=$(date -d "$exp" +%s)
	d2=$(date -d "$now" +%s)
	exp2=$(( (d1 - d2) / 86400 ))
	if [[ "$exp2" = "0" ]]; then
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vmessws.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vmesswsnon.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vmesskuota.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/vmessgrpc.json
		rm -f /etc/adi/vmess/$user-membervmessws.json
	fi
done
echo VMESS EXPIRED TERHAPUS
# ShadowSocks WS
data=( `cat /usr/local/etc/xray/netz/ssws.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
	exp=$(grep -w "^### $user" "/usr/local/etc/xray/netz/ssws.json" | cut -d ' ' -f 3)
	d1=$(date -d "$exp" +%s)
	d2=$(date -d "$now" +%s)
	exp2=$(( (d1 - d2) / 86400 ))
	if [[ "$exp2" = "0" ]]; then
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/ssws.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/sswsnon.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/sskuota.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/sswsgrpc.json
	fi
done
echo SHADOWSOCKS EXPIRED TERHAPUS
# Shadowsocks 2022 WS
data=( `cat /usr/local/etc/xray/netz/ssblakews.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
	exp=$(grep -w "^### $user" "/usr/local/etc/xray/netz/ssblakews.json" | cut -d ' ' -f 3)
	d1=$(date -d "$exp" +%s)
	d2=$(date -d "$now" +%s)
	exp2=$(( (d1 - d2) / 86400 ))
	if [[ "$exp2" = "0" ]]; then
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/ssblakews.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/ssblakewsnon.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/ssblakekuota.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/ssblakegrpc.json
	fi
done
echo SHADOWSOCKS 2022 EXPIRED TERHAPUS
# SOCKS5 WS
data=( `cat /usr/local/etc/xray/netz/socksws.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
	exp=$(grep -w "^### $user" "/usr/local/etc/xray/netz/socksws.json" | cut -d ' ' -f 3)
	d1=$(date -d "$exp" +%s)
	d2=$(date -d "$now" +%s)
	exp2=$(( (d1 - d2) / 86400 ))
	if [[ "$exp2" = "0" ]]; then
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/socksws.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/sockswsnon.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/sockskuota.json
		sed -i "/^### $user $exp/,/^},{/d" /usr/local/etc/xray/netz/socksgrpc.json
	fi
done
echo SOCKS5 EXPIRED TERHAPUS
systemctl restart xray
