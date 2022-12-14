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
#GET CLIENT NAME
# vmess TCP
#echo -n > /tmp/other.txt
#data=( `cat /usr/local/etc/xray/netz/vmesstcp.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ vmess TCP Login ]=-----";
#echo "-------------------------------";
#for akun in "${data[@]}"
#if [[ -z "$akun" ]]; then
#akun="tidakada"
#echo -n > /tmp/ipvmesstcp.txt
#data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
#for ip in "${data2[@]}"
#jum=$(cat /var/log/adi/access.log | grep vmessTCP | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
#if [[ "$jum" = "$ip" ]]; then
#echo "$jum" >> /tmp/ipvmesstcp.txt
#else
#echo "$ip" >> /tmp/other.txt
#jum2=$(cat /tmp/ipvmesstcp.txt)
#sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
#done
#jum=$(cat /tmp/ipvmesstcp.txt)
#if [[ -z "$jum" ]]; then
#echo > /dev/null
#else
#jum2=$(cat /tmp/ipvmesstcp.txt | nl)
#echo "-------------------------------";
#echo "-----=[ vmess TCP Login ]=-----";
#echo "-------------------------------";
#echo "user : $akun";
#echo "$jum2";
#echo "-------------------------------"
#rm -rf /tmp/ipvmesstcp.txt
#done
#oth=$(cat /tmp/other.txt | sort | uniq | nl)
#echo "other";
#echo "$oth";
#echo "-------------------------------"
# VLESS WS
echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/netz/vlessws.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ VLESS WS Login ]=-----";
#echo "-------------------------------";
for akun in "${data[@]}"; do
	if [[ -z "$akun" ]]; then
		akun="tidakada"
		echo -n > /tmp/ipvlessws.txt
		data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
		for ip in "${data2[@]}"; do
			jum=$(cat /var/log/adi/access.log | grep VLESSWS | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
			if [[ "$jum" = "$ip" ]]; then
				echo "$jum" >> /tmp/ipvlessws.txt
			else
				echo "$ip" >> /tmp/other.txt
				jum2=$(cat /tmp/ipvlessws.txt)
				sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
			fi
		done
	fi
	jum=$(cat /tmp/ipvlessws.txt)
	if [[ -z "$jum" ]]; then
		echo > /dev/null
	else
		jum2=$(cat /tmp/ipvlessws.txt | nl)
		echo "-------------------------------";
		echo "-----=[ VLESS WS Login ]=-----";
		echo "-------------------------------";
		echo "user : $akun";
		echo "$jum2";
		echo "-------------------------------"
		rm -rf /tmp/ipvlessws.txt
	fi
done
# VLESS WS NON
echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/netz/vlessws.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ VLESS WS NON Login ]=-----";
#echo "-------------------------------";
for akun in "${data[@]}"; do
	if [[ -z "$akun" ]]; then
		akun="tidakada"
		echo -n > /tmp/ipvlesswsnon.txt
		data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
		for ip in "${data2[@]}"; do
			jum=$(cat /var/log/adi/access.log | grep VLESSWSNON | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
			if [[ "$jum" = "$ip" ]]; then
				echo "$jum" >> /tmp/ipvlesswsnon.txt
			else
				echo "$ip" >> /tmp/other.txt
				jum2=$(cat /tmp/ipvlesswsnon.txt)
				sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
			fi
		done
	fi
	jum=$(cat /tmp/ipvlesswsnon.txt)
	if [[ -z "$jum" ]]; then
		echo > /dev/null
	else
		jum2=$(cat /tmp/ipvlesswsnon.txt | nl)
		echo "-------------------------------";
		echo "-----=[ VLESS WS NON Login ]=-----";
		echo "-------------------------------";
		echo "user : $akun";
		echo "$jum2";
		echo "-------------------------------"
		rm -rf /tmp/ipvlesswsnon.txt
	fi
done
# VLESS GRPC
echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/netz/vlessws.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ VLESS GRPC Login ]=-----";
#echo "-------------------------------";
for akun in "${data[@]}"; do
	if [[ -z "$akun" ]]; then
		akun="tidakada"
		echo -n > /tmp/ipvlessgrpc.txt
		data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
		for ip in "${data2[@]}"; do
			jum=$(cat /var/log/adi/access.log | grep VLESSGRPC | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
			if [[ "$jum" = "$ip" ]]; then
				echo "$jum" >> /tmp/ipvlessgrpc.txt
			else
				echo "$ip" >> /tmp/other.txt
				jum2=$(cat /tmp/ipvlessgrpc.txt)
				sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
			fi
		done
	fi
	jum=$(cat /tmp/ipvlessgrpc.txt)
	if [[ -z "$jum" ]]; then
		echo > /dev/null
	else
		jum2=$(cat /tmp/ipvlessgrpc.txt | nl)
		echo "-------------------------------";
		echo "-----=[ VLESS GRPC Login ]=-----";
		echo "-------------------------------";
		echo "user : $akun";
		echo "$jum2";
		echo "-------------------------------"
		rm -rf /tmp/ipvlessgrpc.txt
	fi
done
rm -rf /tmp/other.txt
