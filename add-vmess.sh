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
# Read User Info
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
	read -rp "User: " -e user
	CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/netz/vmessws.json | wc -l)
	if [[ ${CLIENT_EXISTS} == '2' ]]; then
			echo ""
			echo "User ini telah ada, Tolong gunakan nama lain."
			exit 1
	fi
done
uuid=$(xray uuid)
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
# Buat Akun
# WS TLS
sed -i '/#membervmessws$/a\### '"$user $exp"'},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "alterId": 0' /usr/local/etc/xray/netz/vmessws.json
# WS NON TLS
sed -i '/#membervmesswsnon$/a\### '"$user $exp"'},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "alterId": 0' /usr/local/etc/xray/netz/vmesswsnon.json
# WS NON TLS ORBIT
sed -i '/#membervmesskuotahabis$/a\### '"$user $exp"'\
},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"'', "alterId": 0' /usr/local/etc/xray/netz/vmesskuota.json
# GRPC
sed -i '/#membervmessgrpc$/a\### '"$user $exp"'},{"email": ''"'"$user"'"'',"id": ''"'"$uuid"'"''' /usr/local/etc/xray/netz/vmessgrpc.json
# Encrypt Method
# WS TLS
cat>/etc/adi/vmess/$user-membervmessws.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${porttls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/netzvmess",
      "type": "none",
      "host": "",
      "tls": "tls"
	  }
EOF
# WS NON TLS
cat>/etc/adi/vmess/$user-membervmesswsnon.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${portnontls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/netzvmess",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
	  }
EOF
# WS NON TLS
cat>/etc/adi/vmess/$user-membervmesskuotahabis.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${portnontls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/kuota-habis/netzvmess",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
	  }
EOF
# GRPC
cat>/etc/adi/vmess/$user-membervmessgrpc.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "${porttls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "netzvmessgrpc",
      "type": "gun",
      "host": "",
      "tls": "tls"
	  }
EOF
# Converter Vmess
vmessws="vmess://$(base64 -w 0 /etc/adi/vmess/$user-membervmessws.json)"
vmesswsnon="vmess://$(base64 -w 0 /etc/adi/vmess/$user-membervmesswsnon.json)"
vmesskuota="vmess://$(base64 -w 0 /etc/adi/vmess/$user-membervmesskuotahabis.json)"
vmessgrpc="vmess://$(base64 -w 0 /etc/adi/vmess/$user-membervmessgrpc.json)"
# Cleanup
clear
# Post Telegram
if [[ -z $BOT_TOKEN ]]; then
	echo "Terimakasih Telah Menggunakan Layanan NetzXRay Bot"
elif [[ -z $CHAT_ID ]]; then
	echo -e " "
else
tg_send_message --chat_id "$CHAT_ID" --text "*VMESS BERHASIL DIBUAT !*
*ISP*   : $ISP
*IP*    : $IPADRESS
*Domain*        : $domain
*Client*        : $user
*UUID*  : $uuid
*Aktif Sampai* : $exp
VMESS
Vmess WS TLS    : \`$vmessws\`
Vmess WS NON    : \`$vmesswsnon\`
Vmess ORBIT     : \`$vmesskuota\`
Vmess GRPC TLS  : \`$vmessgrpc\`
AutoScript By Adi Subagja" --parse_mode "Markdown" >/dev/null
echo "Terimakasih Telah Menggunakan Layanan NetzXRay"
fi
# Informasi Akun
echo -e XRAY/VMESS
echo -e Remarks     : "$user"
echo -e UUID        : "$uuid"
echo -e Domain      : "$domain"
echo -e Port        : "$porttls & $portnontls"
echo -e Masa Aktif  : "$exp"
echo -e Path        : "/netzvmess"
echo -e Path Orbit  : "/kuota-habis/netzvmess"
echo -e ServiceName : "netzvmessgrpc"
echo -e
echo -e WS TLS      : "$vmessws"
echo -e ""
echo -e
echo -e WS NON      : "$vmesswsnon"
echo -e ""
echo -e
echo -e ORBIT       : "$vmesskuota"
echo -e ""
echo -e
echo -e GRPC        : "$vmessgrpc"
echo -e ""
echo -e
echo -e NO TORRENT
echo -e NO SEEDING
echo -e NO MULTILOGIN
echo -e
# Trigger Reload Services
echo -e "Halaman akan ditutup dalam 5-10 detik"
sleep 10
systemctl restart xray
clear
echo -e "Sucessfully Created"
welcome
