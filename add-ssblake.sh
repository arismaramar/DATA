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
# Method Shadowsocks
method1="aes-128-gcm"
method2="aes-256-gcm"
method3="chacha20-ietf-poly1305"
method10="2022-blake3-aes-128-gcm"
method11="2022-blake3-aes-256-gcm"
method12="2022-blake3-chacha20-poly1305"
# Read User Info
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
	read -rp "User: " -e user
	CLIENT_EXISTS=$(grep -w $user /usr/local/etc/xray/netz/ssblakews.json | wc -l)
	if [[ ${CLIENT_EXISTS} == '2' ]]; then
			echo ""
			echo "User ini telah ada, Tolong gunakan nama lain."
			exit 1
	fi
done
uuid=$(xray uuid)
genid=$(openssl rand -base64 16)
serverid="CXX4y7hOW6XlLygCsx0U1w=="
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
# Buat Akun
# WS TLS
sed -i '/#memberblakews$/a\### '"$user $exp"'\
},{"password": ''"'"$genid"'"'', "email": ''"'"$user"'"''' /usr/local/etc/xray/netz/ssblakews.json
# WS NON TLS
sed -i '/#memberblakewsnon$/a\### '"$user $exp"'\
},{"password": ''"'"$genid"'"'', "email": ''"'"$user"'"''' /usr/local/etc/xray/netz/ssblakewsnon.json
# WS NON TLS
sed -i '/#memberblakekuotahabis$/a\### '"$user $exp"'\
},{"password": ''"'"$genid"'"'', "email": ''"'"$user"'"''' /usr/local/etc/xray/netz/ssblakekuota.json
# GRPC
sed -i '/#memberblakegrpc$/a\### '"$user $exp"'\
},{"password": ''"'"$genid"'"'', "email": ''"'"$user"'"''' /usr/local/etc/xray/netz/ssblakegrpc.json
# Encrypt Technical
encrypt10=$(echo -n "${method10}:${serverid}:${genid}" | base64 -w0)
# Converted
ssblakews="ss://${encrypt10}@${domain}:${porttls}?path=%2Fnetzblake&security=tls&type=ws#${user}"
ssblakewsnon="ss://${encrypt10}@${domain}:${portnontls}?path=%2Fnetzblake&security=none&type=ws#${user}"
ssblakekuota="ss://${encrypt10}@${domain}:${portnontls}?path=%2Fkuota-habis%2Fnetzblake&security=none&type=ws#${user}"
ssblakegrpc="ss://${encrypt10}@${domain}:${porttls}?mode=gun&security=tls&type=grpc&serviceName=netzblakegrpc#${user}"
# Converted Telegram
ssblakewstelegram="ss://${encrypt3}@${domain}:${porttls}?path=/netzblake${fix}security=tls${fix}type=ws#${user}"
ssblakewsnontelegram="ss://${encrypt3}@${domain}:${portnontls}?path=/netzblake${fix}security=none${fix}type=ws#${user}"
ssblakekuotatelegram="ss://${encrypt3}@${domain}:${portnontls}?path=/kuota-habis/netzblake${fix}security=none${fix}type=ws#${user}"
ssblakegrpctelegram="ss://${encrypt3}@${domain}:${porttls}?mode=gun${fix}security=tls${fix}type=grpc${fix}serviceName=netzblakegrpc#${user}"
# Cleanup
clear
# Post Telegram
if [[ -z $BOT_TOKEN ]]; then
	echo "Terimakasih Telah Menggunakan Layanan NetzXRay Bot"
elif [[ -z $CHAT_ID ]]; then
	echo -e " "
else
tg_send_message --chat_id "$CHAT_ID" --text "*SHADOWSOCKS 2022 BERHASIL DIBUAT !*
*ISP*   : $ISP
*IP*    : $IPADRESS
*Domain*        : $domain
*Client*        : $user
*Password*      : $uuid
*Aktif Sampai* : $exp
SHADOWSOCKS2022
Shadowsocks WS          : \`$ssblakewstelegram\`
Shadowsocks WS NON      : \`$ssblakewsnontelegram\`
Shadowsocks ORBIT       : \`$ssblakekuotatelegram\`
Shadowsocks GRPC        : \`$ssblakegrpctelegram\`
AutoScript By Adi Subagja" --parse_mode "Markdown" >/dev/null
echo "Terimakasih Telah Menggunakan Layanan NetzXRay"
fi
# Informasi Akun
echo -e
XRAY/SHADOWSOCKS2022
echo -e Remarks     : "$user"
echo -e PASS        : "$uuid"
echo -e Domain      : "$domain"
echo -e Port        : "$porttls & $portnontls"
echo -e Masa Aktif  : "$exp"
echo -e Path        : "/netzblake"
echo -e Path Orbit      : "/kuota-habis/netzblake"
echo -e ServiceName : "netzblakegrpc"
echo -e Encrypt     : "$method10"
echo -e
echo -e WS TLS      : "$ssblakews"
echo -e ""
echo -e
echo -e WS NON      : "$ssblakewsnon"
echo -e ""
echo -e
echo -e ORBIT       : "$ssblakekuota"
echo -e ""
echo -e
echo -e GRPC        : "$ssblakegrpc"
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
