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
# Telegram Stuff
BOT_TOKEN="5705818275:AAF6Uz494dgJ3OyEaxRAfq5AApxyVby3GnM"
CHAT_ID="-1001544942716"
IPADRESS=$( curl -4 -s ipv4.appspot.com)
REGION=$( curl -s https://ipapi.co/${IPADRESS}/country_name/)
ISP=$( curl -s https://ipapi.co/${IPADRESS}/org/)
telegram_curl() {
	local ACTION=${1}
	shift
	local HTTP_REQUEST=${1}
	shift
	if [ "$HTTP_REQUEST" != "POST_FILE" ]; then
			curl -s -X $HTTP_REQUEST "https://api.telegram.org/bot$BOT_TOKEN/$ACTION" "$@" | jq .
	else
			curl -s "https://api.telegram.org/bot$BOT_TOKEN/$ACTION" "$@" | jq .
	fi
}
telegram_main() {
	local ACTION=${1}
	local HTTP_REQUEST=${2}
	local CURL_ARGUMENTS=()
	while [ "${#}" -gt 0 ]; do
		case "${1}" in
			--animation | --audio | --document | --photo | --video )
					local CURL_ARGUMENTS+=(-F $(echo "${1}" | sed 's/--//')=@"${2}")
					shift
					;;
			--* )
					if [ "$HTTP_REQUEST" != "POST_FILE" ]; then
							local CURL_ARGUMENTS+=(-d $(echo "${1}" | sed 's/--//')="${2}")
					else
							local CURL_ARGUMENTS+=(-F $(echo "${1}" | sed 's/--//')="${2}")
					fi
					shift
					;;
		esac
		shift
	done
	telegram_curl "$ACTION" "$HTTP_REQUEST" "${CURL_ARGUMENTS[@]}"
}
tg_send_message() {
	telegram_main sendMessage POST "$@"
}
## End of Telegram Stuff
# ENV
domain=$(cat /etc/adi/domain)
porttls="443"
portnontls="80"
fix=%26
# Remove SSH Expired
hariini=`date +%d-%m-%Y`
echo "Thank you for removing the EXPIRED USERS"
echo "--------------------------------------"
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
do
	tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
	username=`echo $tuserval | cut -f1 -d:`
	userexp=`echo $tuserval | cut -f2 -d:`
	userexpireinseconds=$(( $userexp * 86400 ))
	tglexp=`date -d @$userexpireinseconds`
	tgl=`echo $tglexp |awk -F" " '{print $3}'`
	while [ ${#tgl} -lt 2 ]
	do
		tgl="0"$tgl
	done
	while [ ${#username} -lt 15 ]
	do
		username=$username" "
	done
	bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
	echo "echo "Expired- User : $username Expire at : $tgl $bulantahun"" >> /usr/local/bin/alluser
	todaystime=`date +%s`
	if [ $userexpireinseconds -ge $todaystime ] ;
	then
			:
	else
		echo "echo "Expired- Username : $username are expired at: $tgl $bulantahun and removed : $hariini "" >> /usr/local/bin/deleteduser
	   echo "Username $username that are expired at $tgl $bulantahun removed from the VPS $hariini"
		userdel $username
	fi
done
echo " "
echo "--------------------------------------"
echo "Script are successfully run"
