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
# Extending SSH
read -p "Username:  " User
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
	read -p "Day Extend:  " Days
	Today=`date +%s`
	Days_Detailed=$(( $Days * 86400 ))
	Expire_On=$(($Today + $Days_Detailed))
	Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
	Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%d %b %Y')
	passwd -u $User
	usermod -e  $Expiration $User
	egrep "^$User" /etc/passwd >/dev/null
	echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
	clear
	echo -e ""
	echo -e "========================================"
	echo -e ""
	echo -e "    Username        :  $User"
	echo -e "    Days Added      :  $Days Hari"
	echo -e "    Expires on      :  $Expiration_Display"
	echo -e ""
	echo -e "========================================"
else
	clear
	echo -e ""
	echo -e "======================================"
	echo -e ""
	echo -e "        Username Doesnt Exist        "
	echo -e ""
	echo -e "======================================"
fi
