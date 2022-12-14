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
# TROJAN TCP
echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/netz/trojantcp.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ Trojan TCP Login ]=-----";
#echo "-------------------------------";
for akun in "${data[@]}"; do
	if [[ -z "$akun" ]]; then
		akun="tidakada"
		echo -n > /tmp/iptrojantcp.txt
		data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
		for ip in "${data2[@]}"; do
			jum=$(cat /var/log/adi/access.log | grep TROJANTCP | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
			if [[ "$jum" = "$ip" ]]; then
				echo "$jum" >> /tmp/iptrojantcp.txt
			else
				echo "$ip" >> /tmp/other.txt
				jum2=$(cat /tmp/iptrojantcp.txt)
				sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
			fi
		done
	fi
	jum=$(cat /tmp/iptrojantcp.txt)
	if [[ -z "$jum" ]]; then
		echo > /dev/null
	else
		jum2=$(cat /tmp/iptrojantcp.txt | nl)
		echo "-------------------------------";
		echo "-----=[ Trojan TCP Login ]=-----";
		echo "-------------------------------";
		echo "user : $akun";
		echo "$jum2";
		echo "-------------------------------"
		rm -rf /tmp/iptrojantcp.txt
	fi
done
#oth=$(cat /tmp/other.txt | sort | uniq | nl)
#echo "other";
#echo "$oth";
#echo "-------------------------------"
# TROJAN WS
echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/netz/trojantcp.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ Trojan WS Login ]=-----";
#echo "-------------------------------";
for akun in "${data[@]}"; do
	if [[ -z "$akun" ]]; then
		akun="tidakada"
		echo -n > /tmp/iptrojanws.txt
		data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
		for ip in "${data2[@]}"; do
			jum=$(cat /var/log/adi/access.log | grep TROJANWS | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
			if [[ "$jum" = "$ip" ]]; then
				echo "$jum" >> /tmp/iptrojanws.txt
			else
				echo "$ip" >> /tmp/other.txt
				jum2=$(cat /tmp/iptrojanws.txt)
				sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
			fi
		done
	fi
	jum=$(cat /tmp/iptrojanws.txt)
	if [[ -z "$jum" ]]; then
		echo > /dev/null
	else
		jum2=$(cat /tmp/iptrojanws.txt | nl)
		echo "-------------------------------";
		echo "-----=[ Trojan WS Login ]=-----";
		echo "-------------------------------";
		echo "user : $akun";
		echo "$jum2";
		echo "-------------------------------"
		rm -rf /tmp/iptrojanws.txt
	fi
done
# TROJAN WS NON
echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/netz/trojantcp.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ Trojan WS NON Login ]=-----";
#echo "-------------------------------";
for akun in "${data[@]}"; do
	if [[ -z "$akun" ]]; then
		akun="tidakada"
		echo -n > /tmp/iptrojanwsnon.txt
		data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
		for ip in "${data2[@]}"; do
			jum=$(cat /var/log/adi/access.log | grep TROJANWSNON | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
			if [[ "$jum" = "$ip" ]]; then
				echo "$jum" >> /tmp/iptrojanwsnon.txt
			else
				echo "$ip" >> /tmp/other.txt
				jum2=$(cat /tmp/iptrojanwsnon.txt)
				sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
			fi
		done
	fi
	jum=$(cat /tmp/iptrojanwsnon.txt)
	if [[ -z "$jum" ]]; then
		echo > /dev/null
	else
		jum2=$(cat /tmp/iptrojanwsnon.txt | nl)
		echo "-------------------------------";
		echo "-----=[ Trojan WS NON Login ]=-----";
		echo "-------------------------------";
		echo "user : $akun";
		echo "$jum2";
		echo "-------------------------------"
		rm -rf /tmp/iptrojanwsnon.txt
	fi
done
# TROJAN GRPC
echo -n > /tmp/other.txt
data=( `cat /usr/local/etc/xray/netz/trojantcp.json | grep '^###' | cut -d ' ' -f 2`);
#echo "-------------------------------";
#echo "-----=[ Trojan GRPC Login ]=-----";
#echo "-------------------------------";
for akun in "${data[@]}"; do
	if [[ -z "$akun" ]]; then
		akun="tidakada"
		echo -n > /tmp/iptrojangrpc.txt
		data2=( `cat /var/log/adi/access.log | tail -n 500 | awk '{print $3}' | cut -d: -f1 | grep -v 127.0.0.1 | grep -v tcp | sort | uniq`);
		for ip in "${data2[@]}"; do
		jum=$(cat /var/log/adi/access.log | grep TROJANGRPC | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | grep -v 127.0.0.1 | sort | uniq)
			if [[ "$jum" = "$ip" ]]; then
				echo "$jum" >> /tmp/iptrojangrpc.txt
			else
				echo "$ip" >> /tmp/other.txt
				jum2=$(cat /tmp/iptrojangrpc.txt)
				sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
			fi
		done
	jum=$(cat /tmp/iptrojangrpc.txt)
	if [[ -z "$jum" ]]; then
		echo > /dev/null
	else
		jum2=$(cat /tmp/iptrojangrpc.txt | nl)
		echo "-------------------------------";
		echo "-----=[ Trojan GRPC Login ]=-----";
		echo "-------------------------------";
		echo "user : $akun";
		echo "$jum2";
		echo "-------------------------------"
		rm -rf /tmp/iptrojangrpc.txt
	fi
done
rm -rf /tmp/other.txt
