#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
	echo "Harap Menggunakan User ROOT"
	exit 1
fi
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
	rm -f setup.sh
	rm -f simbah.sh
	exit 0
fi
# Cek Tanggal
d1=(`date -d "$EXP" +%s`)
d2=(`date -d "$dateayena" +%s`)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" -le "0" ]]; then
	echo "${red}Masa Aktif Habis ! Silahkan Perpanjang${NC}";
	rm -f setup.sh
	rm -f simbah.sh
	exit 0
else
	echo -e "${green}Masa Aktif Berjalan${NC}";
fi
clear
# Remove Necessary Files
rm -rf /etc/adi
rm -rf /etc/adi/vmess
# Create Necessary Files
mkdir /etc/adi;
mkdir /etc/adi/vmess;
# Input Domain
touch /root/domain;
echo "PASTIKAN DOMAIN SUDAH DI POINTING DARI ISP KE CLOUDFLARE"
read -p "Hostname / Domain: " host
echo "$host" >> /etc/adi/domain
echo "$host" >> /root/domain
# LINK ENVIROMENT
source="https://raw.githubusercontent.com/arismaramar/kuprit/main/data"
#scgeo="https://raw.githubusercontent.com/malikshi/v2ray-rules-dat/release"
scgeo="https://raw.githubusercontent.com/arismaramar/kuprit/main/data"
domain=$(cat /root/domain)
# Timpa Text
echo -e "
Installing...
Jangan Panik !
Proses ini memakan waktu
"
# Installer Package
apt install -y wget curl jq shc neofetch vnstat >/dev/null 2>&1
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof >/dev/null 2>&1
# Set Timezone
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime >/dev/null 2>&1
# Accept Env
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
exit 0
END
# Ubah izin akses
chmod +x /etc/rc.local
# enable rc local
systemctl enable rc-local >/dev/null 2>&1
systemctl start rc-local.service >/dev/null 2>&1
# Install Nginx
apt -y install curl tar socat wget >/dev/null 2>&1
apt -y install nginx >/dev/null 2>&1
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-available/default
wget -q -O /etc/nginx/nginx.conf "${source}/nginx.conf"
wget -q -O /etc/nginx/conf.d/netz.conf "${source}/netz.conf"
wget -q -O /etc/nginx/conf.d/default.conf "${source}/default.conf"
systemctl start nginx >/dev/null 2>&1
# Install Cleanup
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y > /dev/null 2>&1
apt install socat cron bash-completion ntpdate -y >/dev/null 2>&1
ntpdate pool.ntp.org >/dev/null 2>&1
apt -y install chrony >/dev/null 2>&1
timedatectl set-ntp true >/dev/null 2>&1
systemctl enable chronyd >/dev/null 2>&1
systemctl restart chronyd >/dev/null 2>&1
systemctl enable chrony >/dev/null 2>&1
systemctl restart chrony >/dev/null 2>&1
timedatectl set-timezone Asia/Jakarta >/dev/null 2>&1
chronyc sourcestats -v >/dev/null 2>&1
chronyc tracking -v >/dev/null 2>&1
date
# Timpa Text
echo -e "
Installing...
XRAY CORE
"
# Install Xray Core
bash -c "$(curl -s -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install --version 1.6.2
# Install Certificate
curl https://get.acme.sh | sh
ufw disable >/dev/null 2>&1
systemctl stop nginx >/dev/null 2>&1
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m netz@$domain
~/.acme.sh/acme.sh --issue -d $domain --standalone --server letsencrypt
~/.acme.sh/acme.sh --installcert -d $domain --key-file /etc/adi/adi.key --fullchain-file /etc/adi/adi.crt
# Timpa Text
echo -e "
Installing...
SSH Dropbear
SSH Stunnel
SSH WS / WS SSL
DNS-Resolver
Speedtest
Tekan Enter Dikeyboard ya !
"
# Install SSH SSL PLUS
apt install dropbear -y >/dev/null 2>&1
apt install stunnel4 -y >/dev/null 2>&1
apt install python2 -y >/dev/null 2>&1
# Install Speedtest
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash
apt-get install speedtest -y >/dev/null 2>&1
# Settings Dropbear
# sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
# sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
# sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
# sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
cat > /etc/default/dropbear <<-END
# disabled because OpenSSH is installed
# change to NO_START=0 to enable Dropbear
NO_START=0
# the TCP port that Dropbear listens on
DROPBEAR_PORT=143
# any additional arguments for Dropbear
DROPBEAR_EXTRA_ARGS="-p 109"
# specify an optional banner file containing a message to be
# sent to clients before they connect, such as "/etc/issue.net"
DROPBEAR_BANNER="/etc/issue.net"
# RSA hostkey file (default: /etc/dropbear/dropbear_rsa_host_key)
#DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
# DSS hostkey file (default: /etc/dropbear/dropbear_dss_host_key)
#DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
# ECDSA hostkey file (default: /etc/dropbear/dropbear_ecdsa_host_key)
#DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
# Receive window size - this is a tradeoff between memory and
# network performance
DROPBEAR_RECEIVE_WINDOW=65536
END
# Settings Stunnel4
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/adi/adi.crt
key = /etc/adi/adi.key
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[dropbear]
accept = 445
connect = 127.0.0.1:109
[dropbear]
accept = 777
connect = 127.0.0.1:22
[openvpn]
accept = 442
connect = 127.0.0.1:1194
END
cat <<EOF >/etc/issue.net
<font color="blue"><b>================================</b></font><br>
<font color="red"><b> TERIMA KASIH TELAH MENGGUNAKAN LAYANAN ANGGUN-VPN.MY.ID</b></font><br>
<font color="blue"><b>================================</b> </font><br>
BACA PERATURAN DI BAWAH INI : <br>
<br>
<strong>[server hosted on website]<strong><br>
<font color="red" size="50"><b>DILARANG ILLEGAL CONTEN/DDOS/MULTI LOGIN</b></font><br>
<font color="blue" size="50"><b>MELANGGAR AUTO BANED</b></font><br>
<font color="blue" size="50"><b>https://t.me/arismaramar</b></font><br>
<font color="blue" size="50"><b>https://wa.me/+6285365581599</b></font><br>
## gabung group utk udate config
<font color="blue" size="50"><b>https://chat.whatsapp.com/BhVLmdLKxfkGsf6zO5vjrD</b></font><br>
<br>
<font color="blue"><b>================================</b>
</font><br> MELANGGAR  <br> AUTON DI BANED <br>
<font color="blue"><b>================================</b></font><br>
<font color="green"><b> ANGGUN-VPN.MY.ID  </b></font><br>
<font color="blue"><b> ================================</b></font><br>
<font color="red"><b> Auto Reboot Server : 05.00 </b></font><br>
<br>
<font color="red"><b> *
* </b></font><br>
<font color="blue"><b>-{------ANGGUN-VPN.MY.ID------}-</font><br>
<font color="white"><b> *
* </b></font><br >
EOF
# Settings SSHD CONFIG
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sshlogined=$(cat /etc/shells | grep -w /bin/false)
sshlogintrue="$?"
if [[ $sshlogintrue = "1" ]]; then
	echo "/bin/false" >> /etc/shells
	echo "/usr/sbin/nologin" >> /etc/shells
	echo -e "Konfigurasi OpenSSH"
else
	echo -e "OpenSSH Sudah Di Konfigurasi"
fi
# Timpa Text
echo -e "
Setup OpenVPN...
Server Mode......
"
# Environment OpenVPN
INTERFACE=$(ip -o -4 route show to default | awk '{print $5}')
# Remove OpenVPN Necessary
rm -rf /etc/openvpn/server/easy-rsa
rm -rf /etc/openvpn
rm -rf /usr/lib/openvpn
rm -rf /usr/share/nginx/html/*
# Create Dir Shared
mkdir /usr/share/nginx/html/openvpn;
# Create Dummy Boolean
debconf-set-selections <<EOF
iptables-persistent iptables-persistent/autosave_v4 boolean true
iptables-persistent iptables-persistent/autosave_v6 boolean true
EOF
# Install OpenVPN
apt install openvpn easy-rsa -y >/dev/null 2>&1
apt install openssl iptables iptables-persistent -y >/dev/null 2>&1
# Create Settings
mkdir -p /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/
# Getting Files
wget -q -O vpn.zip "${source}/vpn.zip"
unzip -qq vpn.zip
rm -f vpn.zip
chown -R root:root /etc/openvpn/server/easy-rsa/
# Create Lib
mkdir -p /usr/lib/openvpn/
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so
# Enable OpenVPN Server ALL
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn
systemctl enable --now openvpn-server@server-tcp-1194 >/dev/null 2>&1
systemctl enable --now openvpn-server@server-udp-2200 >/dev/null 2>&1
/etc/init.d/openvpn restart >/dev/null 2>&1
# /etc/init.d/openvpn status
# Aktivasi Ipv4 Forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
# Buat Konfigurasi
# TCP
cat > /etc/openvpn/client-tcp-1194.ovpn <<-END
client
dev tun
proto tcp
remote $MYIP 1194
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
# UDP
cat > /etc/openvpn/client-udp-2200.ovpn <<-END
client
dev tun
proto udp
remote $MYIP 2200
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END
# SSL
cat > /etc/openvpn/client-tcp-ssl.ovpn <<-END
client
dev tun
proto tcp
remote $MYIP 442
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
END
verb 3
# Setup Continue
/etc/init.d/openvpn restart >/dev/null 2>&1
# Masukan Sertifikat VPN
# TCP
echo '<ca>' >> /etc/openvpn/client-tcp-1194.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-1194.ovpn
# UDP
echo '<ca>' >> /etc/openvpn/client-udp-2200.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-udp-2200.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-2200.ovpn
# SSL
echo '<ca>' >> /etc/openvpn/client-tcp-ssl.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-ssl.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-ssl.ovpn
# Copy To Dir Nginx
rm -rf /usr/share/nginx/html/openvpn/TCP.ovpn
rm -rf /usr/share/nginx/html/openvpn/UDP.ovpn
rm -rf /usr/share/nginx/html/openvpn/SSL.ovpn
cp /etc/openvpn/client-tcp-1194.ovpn /usr/share/nginx/html/openvpn/TCP.ovpn
cp /etc/openvpn/client-udp-2200.ovpn /usr/share/nginx/html/openvpn/UDP.ovpn
cp /etc/openvpn/client-tcp-ssl.ovpn /usr/share/nginx/html/openvpn/SSL.ovpn
# Add Rules Forwarding
iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o $INTERFACE -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o $INTERFACE -j MASQUERADE
iptables-save > /etc/iptables.up.rules
chmod +x /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
# Restart service openvpn
systemctl enable openvpn >/dev/null 2>&1
systemctl start openvpn >/dev/null 2>&1
/etc/init.d/openvpn restart >/dev/null 2>&1
# Timpa Text
echo -e "
Generate Key...
Using API......
# Certificate PEM
country=ID
state=Indonesia
locality=Indonesia
organization=www.anggun-vpn.my.id
organizationalunit=www.anggun-vpn.my.id
commonname=www.anggun-vpn.my.id
email=arismar.amar@gmail.com
"
# Generate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
rm -rf key.pem
rm -rf cert.pem
# Timpa Text
echo -e "
Installing...
Netz-Xray......
"
# Create Config
rm -rf /usr/local/etc/xray/netz
rm -rf /var/log/adi
mkdir /usr/local/etc/xray/netz
mkdir /var/log/adi
###################### DOKEDEMO DOOR #######################
#cat > /usr/local/etc/xray/netz/dokedemo-door.json <<-END
#{  
#  "inbounds": [
#    {
#      "listen": "127.0.0.1",
#      "port": 10085,
#      "protocol": "dokodemo-door",
#      "settings": {
#        "address": "127.0.0.1"
#      },
#      "tag": "api"
#    }
#}
#END
###################### API #######################
cat > /usr/local/etc/xray/netz/api-traffic.json <<-END
{
  "stats": {},
  "api": {
    "tag": "api",
    "services": [
      "StatsService"
    ]
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserUplink": true,
        "statsUserDownlink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink": true,
      "statsOutboundDownlink": true
    }
  }
}
END
###################### DNS #######################
# DNS
cat > /usr/local/etc/xray/netz/dns.json <<-END
{
  "dns": {
    "servers": [
      "localhost"
    ],
    "queryStrategy": "UseIPv4"
  }
}
END
###################### LOG #######################
cat > /usr/local/etc/xray/netz/log.json <<-END
{
  "log": {
    "error": "/var/log/adi/error.log",
    "access": "/var/log/adi/access.log",
    "loglevel": "info"
  }
}
END
###################### OUT #######################
cat > /usr/local/etc/xray/netz/out.json <<-END
{
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "ip": [
          "1.1.1.1",
          "1.0.0.1"
        ],
        "outboundTag": "IPv4-out"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      }
    ]
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv4"
      },
      "tag": "IPv4-out"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIPv6"
      },
      "tag": "IPv6-out"
    },
    {
      "protocol": "blackhole",
      "tag": "blackhole-out"
    }
  ]
}
END
###################### TROJAN #######################
cat > /usr/local/etc/xray/netz/trojantcp.json <<-END
{
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "tag": "TROJANTCP",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "aditrojantcp"
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 82,
            "xver": 1
          },
          {
            "alpn": "h2",
            "dest": 31302,
            "xver": 0
          },
          {
            "dest": 4433,
            "xver": 1
          },
          {
            "path": "/netzsocks",
            "dest": 31294,
            "xver": 1
          },
          {
            "path": "/netzblake",
            "dest": 31295,
            "xver": 1
          },
          {
            "path": "/netzss",
            "dest": 31296,
            "xver": 1
          },
          {
            "path": "/netztrojan",
            "dest": 31298,
            "xver": 1
          },
          {
            "path": "/netzvless",
            "dest": 31297,
            "xver": 1
          },
          {
            "path": "/netzvmess",
            "dest": 31299,
            "xver": 1
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlsSettings": {
          "minVersion": "1.2",
          "certificates": [
            {
              "certificateFile": "/etc/adi/adi.crt",
              "keyFile": "/etc/adi/adi.key",
              "ocspStapling": 3600,
              "usage": "encipherment"
            }
          ]
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/trojantcpnon.json <<-END
{
  "inbounds": [
    {
      "port": 80,
      "protocol": "trojan",
      "tag": "TROJANTCPNON",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "aditrojantcp"
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "dest": 82,
            "xver": 1
          },
          {
            "alpn": "h2",
            "dest": 31302,
            "xver": 0
          },
          {
            "dest": 8880,
            "xver": 1
          },
          {
            "path": "/netzsocks",
            "dest": 32294,
            "xver": 1
          },
          {
            "path": "/netzblake",
            "dest": 32295,
            "xver": 1
          },
          {
            "path": "/netzss",
            "dest": 32296,
            "xver": 1
          },
          {
            "path": "/netztrojan",
            "dest": 32298,
            "xver": 0
          },
          {
            "path": "/netzvless",
            "dest": 32297,
            "xver": 0
          },
          {
            "path": "/netzvmess",
            "dest": 32299,
            "xver": 0
          },
          {
            "path": "/kuota-habis/netztrojan",
            "dest": 6001,
            "xver": 0
          },
          {
            "path": "/kuota-habis/netzvmess",
            "dest": 6002,
            "xver": 0
          },
          {
            "path": "/kuota-habis/netzvless",
            "dest": 6003,
            "xver": 0
          },
          {
            "path": "/kuota/habis/netzss",
            "dest": 6004,
            "xver": 0
          },
          {
            "path": "/kuota-habis/netzblake",
            "dest": 6005,
            "xver": 0
          },
          {
            "path": "/kuota-habis/netzsocks",
            "dest": 6006,
            "xver": 0
          }
        ]
      },
      "streamSettings": {
        "network": "tcp"
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/trojanws.json <<-END
{
  "inbounds": [
    {
      "port": 31298,
      "protocol": "trojan",
      "tag": "TROJANWS",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "aditrojanws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/netztrojan"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/trojanwsnon.json <<-END
{
  "inbounds": [
    {
      "port": 32298,
      "protocol": "trojan",
      "tag": "TROJANWSNON",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "aditrojanws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netztrojan"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/trojangrpc.json <<-END
{
  "inbounds": [
    {
      "port": 3001,
      "protocol": "trojan",
      "tag": "TROJANGRPC",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "aditrojangrpc"
          }
        ],
        "fallbacks": [
          {
            "dest": "31300"
          }
        ]
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "netztrojangrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ]
}
END
###################### VMESS #######################
cat > /usr/local/etc/xray/netz/vmessws.json <<-END
{
  "inbounds": [
    {
      "port": 31299,
      "protocol": "vmess",
      "tag": "VMESSWS",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "alterId": 0,
            "email": "adivmessws"
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/netzvmess"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/vmesswsnon.json <<-END
{
  "inbounds": [
    {
      "port": 32299,
      "protocol": "vmess",
      "tag": "VMESSWSNON",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "alterId": 0,
            "email": "adivmessws"
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netzvmess"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/vmessgrpc.json <<-END
{
  "inbounds": [
    {
      "port": 3003,
      "protocol": "vmess",
      "tag": "VMESSGRPC",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "adivmessgrpc"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "netzvmessgrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ]
}
END
###################### VLESS #######################
cat > /usr/local/etc/xray/netz/vlessws.json <<-END
{
  "inbounds": [
    {
      "port": 31297,
      "protocol": "vless",
      "tag": "VLESSWS",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "alterId": 0,
            "email": "adivlessws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/netzvless"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/vlesswsnon.json <<-END
{
  "inbounds": [
    {
      "port": 32297,
      "protocol": "vless",
      "tag": "VLESSWSNON",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "alterId": 0,
            "email": "adivlessws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netzvless"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/vlessgrpc.json <<-END
{
  "inbounds": [
    {
      "port": 3002,
      "protocol": "vless",
      "tag": "VLESSGRPC",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "adivlessgrpc"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "netzvlessgrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ]
}
END
###################### SHADOWSOCKS #######################
cat > /usr/local/etc/xray/netz/ssws.json <<-END
{
  "inbounds": [
    {
      "port": 31296,
      "protocol": "shadowsocks",
      "tag": "SSWS",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "method": "chacha20-ietf-poly1305",
            "email": "adishadowsocksws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/netzss"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/sswsnon.json <<-END
{
  "inbounds": [
    {
      "port": 32296,
      "protocol": "shadowsocks",
      "tag": "SSWSNON",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "method": "chacha20-ietf-poly1305",
            "email": "adishadowsocksws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netzss"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/ssgrpc.json <<-END
{
  "inbounds": [
    {
      "port": 3004,
      "protocol": "shadowsocks",
      "tag": "SSGRPC",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "method": "chacha20-ietf-poly1305",
            "email": "adishadowsocksgrpc"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "netzssgrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ]
}
END
###################### SHADOWSOCKS BLAKE #######################
cat > /usr/local/etc/xray/netz/ssblakews.json <<-END
{
  "inbounds": [
    {
      "port": 31295,
      "protocol": "shadowsocks",
      "tag": "SSBLAKEWS",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "CXX4y7hOW6XlLygCsx0U1w==",
        "clients": [
          {
            "password": "3LL+vjF92dtjYriXd9KC7A==",
            "email": "adiblakews"
          }
        ],
        "network": "tcp,udp"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/netzblake"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/ssblakewsnon.json <<-END
{
  "inbounds": [
    {
      "port": 32295,
      "protocol": "shadowsocks",
      "tag": "SSBLAKEWSNON",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "CXX4y7hOW6XlLygCsx0U1w==",
        "clients": [
          {
            "password": "3LL+vjF92dtjYriXd9KC7A==",
            "email": "adiblakewsnon"
          }
        ],
        "network": "tcp,udp"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netzblake"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/ssblakegrpc.json <<-END
{
  "inbounds": [
    {
      "port": 3005,
      "protocol": "shadowsocks",
      "tag": "SSBLAKEGRPC",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "CXX4y7hOW6XlLygCsx0U1w==",
        "clients": [
          {
            "password": "3LL+vjF92dtjYriXd9KC7A==",
            "email": "adiblakegrpc"
          }
        ],
        "network": "tcp,udp"
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "netzblakegrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ]
}
END
###################### SOCKS5 #######################
cat > /usr/local/etc/xray/netz/socksws.json <<-END
{
  "inbounds": [
    {
      "port": 31294,
      "protocol": "socks",
      "tag": "SOCKSWS",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "adminadisubagja",
            "pass": "netterzmyid"
          }
        ],
        "udp": true,
        "ip": "127.0.0.1"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": true,
          "path": "/netzsocks"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/sockswsnon.json <<-END
{
  "inbounds": [
    {
      "port": 32294,
      "protocol": "socks",
      "tag": "SOCKSWSNON",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "adminadisubagja",
            "pass": "netterzmyid"
          }
        ],
        "udp": true,
        "ip": "127.0.0.1"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/netzsocks"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/socksgrpc.json <<-END
{
  "inbounds": [
    {
      "port": 3006,
      "protocol": "socks",
      "tag": "SOCKSGRPC",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "adminadisubagja",
            "pass": "netterzmyid"
          }
        ],
        "udp": true,
        "ip": "127.0.0.1"
      },
      "streamSettings": {
        "network": "grpc",
        "grpcSettings": {
          "serviceName": "netzsocksgrpc"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ]
}
END
###################### ORBIT #######################
cat > /usr/local/etc/xray/netz/trojankuota.json <<-END
{
  "inbounds": [
    {
      "port": 6001,
      "protocol": "trojan",
      "tag": "TROJANKUOTA",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "email": "aditrojanws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/kuota-habis/netztrojan"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/vmesskuota.json <<-END
{
  "inbounds": [
    {
      "port": 6002,
      "protocol": "vmess",
      "tag": "VMESSKUOTA",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "alterId": 0,
            "email": "adivmessws"
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/kuota-habis/netzvmess"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/vlesskuota.json <<-END
{
  "inbounds": [
    {
      "port": 6003,
      "protocol": "vless",
      "tag": "VLESSKUOTA",
      "settings": {
        "clients": [
          {
            "id": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "alterId": 0,
            "email": "adivlessws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/kuota-habis/netzvless"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/sskuota.json <<-END
{
  "inbounds": [
    {
      "port": 6004,
      "protocol": "shadowsocks",
      "tag": "SSKUOTA",
      "settings": {
        "clients": [
          {
            "password": "bcf3cde7-83eb-5371-a37b-d5ae036c71e5",
            "method": "chacha20-ietf-poly1305",
            "email": "adishadowsocksws"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/kuota-habis/netzss"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/ssblakekuota.json <<-END
{
  "inbounds": [
    {
      "port": 6005,
      "protocol": "shadowsocks",
      "tag": "SSBLAKEKUOTA",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "CXX4y7hOW6XlLygCsx0U1w==",
        "clients": [
          {
            "password": "3LL+vjF92dtjYriXd9KC7A==",
            "email": "adiblakewsnon"
          }
        ],
        "network": "tcp,udp"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/kuota-habis/netzblake"
        }
      }
    }
  ]
}
END
cat > /usr/local/etc/xray/netz/sockskuota.json <<-END
{
  "inbounds": [
    {
      "port": 6006,
      "protocol": "socks",
      "tag": "SOCKSKUOTA",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "adminadisubagja",
            "pass": "netterzmyid"
          }
        ],
        "udp": true,
        "ip": "127.0.0.1"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/kuota-habis/netzsocks"
        }
      }
    }
  ]
}
END
###################### FOR ROUTE #######################
cat > /usr/local/etc/xray/netz/socksoutline.json <<-END
{
  "inbounds": [
    {
      "port": 7878,
      "protocol": "socks",
      "tag": "SOCKSOUTLINE",
      "settings": {
        "auth": "password",
        "accounts": [
          {
            "user": "adminadisubagja",
            "pass": "netterzmyid"
          }
        ],
        "udp": true,
        "ip": "127.0.0.1"
      }
    }
  ]
}
END
###################### END #######################
# Delete Original Services
systemctl stop xray
rm -rf /etc/systemd/stystem/multi-user.target.wants/xray.service
rm -rf /etc/systemd/system/xray.service.d
rm -rf /etc/systemd/system/xray@.service.d
rm -rf /etc/systemd/system/xray.service
rm -rf /etc/systemd/system/xray@.service
rm -rf /etc/systemd/system/nginx.service
rm -rf /lib/systemd/system/nginx.service
touch /etc/systemd/system/xray.service
execStart='/usr/local/bin/xray run -confdir /usr/local/etc/xray/netz'
cat <<EOF >/etc/systemd/system/xray.service
[Unit]
Description=Xray Service
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target
Wants=network-online.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_BIND_SERVICE CAP_NET_RAW
NoNewPrivileges=yes
ExecStart=${execStart}
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
# SSH WS Systemd
cat <<EOF >/etc/systemd/system/ws-https.service
[Unit]
Description=Websocket SSL Resolver
Documentation=https://netterz.my.id
After=network.target nss-lookup.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python2 -O /usr/local/bin/ws-https
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
cat <<EOF >/etc/systemd/system/ws-http.service
[Unit]
Description=Websocket SSL Resolver
Documentation=https://netterz.my.id
After=network.target nss-lookup.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python2 -O /usr/local/bin/ws-http
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
cat <<EOF >/etc/systemd/system/nginx.service
# Stop dance for nginx
# =======================
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target
[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
Restart=on-failure
TimeoutStopSec=5
KillMode=mixed
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
# Service Enabler
systemctl daemon-reload
systemctl enable xray.service >/dev/null 2>&1
systemctl enable ws-https.service >/dev/null 2>&1
systemctl enable ws-http.service >/dev/null 2>&1
systemctl enable stunnel4 >/dev/null 2>&1
systemctl enable dropbear >/dev/null 2>&1
systemctl restart xray >/dev/null 2>&1
systemctl restart ws-https.service >/dev/null 2>&1
systemctl restart ws-http.service >/dev/null 2>&1
systemctl restart stunnel4 >/dev/null 2>&1
systemctl restart dropbear >/dev/null 2>&1
systemctl restart ssh >/dev/null 2>&1
# GET HTML
#cd /var/www/html
cd /usr/share/nginx/html
wget -q -O adipack.zip "${source}/adipack.zip"
unzip -o -qq adipack.zip
rm -f adipack.zip
# Get SSH WS Files
cd /usr/local/bin
wget -q -O ws-https "${source}/ws-https.py"
wget -q -O ws-http "${source}/ws-http.py"
chmod 755 ws-https
chmod 755 ws-http
# Geodata Settings
cd /usr/local/share/xray
rm -rf geosite.dat
rm -rf geoip.dat
wget -q -O geosite.dat "${scgeo}/geosite.dat"
wget -q -O geoip.dat "${scgeo}/geoip.dat"
# Get Files
cd /usr/bin
# SSH FILES
wget -q -O add-ssh "${source}/add-ssh.sh"
wget -q -O del-ssh "${source}/del-ssh.sh"
wget -q -O renew-ssh "${source}/renew-ssh.sh"
wget -q -O exp-ssh "${source}/exp-ssh.sh"
wget -q -O cek-ssh "${source}/cek-ssh.sh"
wget -q -O trial-ssh "${source}/trial-ssh.sh"
# Add
wget -q -O add-ss "${source}/add-ss.sh"
wget -q -O add-ssblake "${source}/add-ssblake.sh"
wget -q -O add-socks "${source}/add-socks.sh"
wget -q -O add-trojan "${source}/add-trojan.sh"
wget -q -O add-vless "${source}/add-vless.sh"
wget -q -O add-vmess "${source}/add-vmess.sh"
# Delete
wget -q -O del-ss "${source}/del-ss.sh"
wget -q -O del-ssblake "${source}/del-ssblake.sh"
wget -q -O del-socks "${source}/del-socks.sh"
wget -q -O del-trojan "${source}/del-trojan.sh"
wget -q -O del-vless "${source}/del-vless.sh"
wget -q -O del-vmess "${source}/del-vmess.sh"
# Renew
wget -q -O renew-ss "${source}/renew-ss.sh"
wget -q -O renew-ssblake "${source}/renew-ssblake.sh"
wget -q -O renew-socks "${source}/renew-socks.sh"
wget -q -O renew-trojan "${source}/renew-trojan.sh"
wget -q -O renew-vless "${source}/renew-vless.sh"
wget -q -O renew-vmess "${source}/renew-vmess.sh"
# Cek
wget -q -O cek-ss "${source}/cek-ss.sh"
wget -q -O cek-ssblake "${source}/cek-ssblake.sh"
wget -q -O cek-socks "${source}/cek-socks.sh"
wget -q -O cek-trojan "${source}/cek-trojan.sh"
wget -q -O cek-vless "${source}/cek-vless.sh"
wget -q -O cek-vmess "${source}/cek-vmess.sh"
# Tools
wget -q -O menu "${source}/menu.sh"
wget -q -O welcome "${source}/welcome.sh"
wget -q -O exp "${source}/exp.sh"
wget -q -O clear-log "${source}/clear-log.sh"
wget -q -O cek-traffic "${source}/cek-traffic.sh"
wget -q -O change-domain "${source}/change-domain.sh"
wget -q -O netz-backup "${source}/netz-backup.sh"
wget -q -O netz-restore "${source}/netz-restore.sh"
wget -q -O badvpn-udpgw "${source}/badvpn-udpgw64.sh"
wget -q -O netz-restart "${source}/netz-restart.sh"
wget -q -O netz-xanmod "${source}/netz-xanmod.sh"
wget -q -O netz-bbr "${source}/netz-bbr.sh"
# Permission
# SSH
chmod +x add-ssh
chmod +x del-ssh
chmod +x renew-ssh
chmod +x cek-ssh
chmod +x exp-ssh
chmod +x trial-ssh
# Add
chmod +x add-ss
chmod +x add-ssblake
chmod +x add-socks
chmod +x add-trojan
chmod +x add-vless
chmod +x add-vmess
# Delete
chmod +x del-ss
chmod +x del-ssblake
chmod +x del-socks
chmod +x del-trojan
chmod +x del-vless
chmod +x del-vmess
# Renew
chmod +x renew-ss
chmod +x renew-ssblake
chmod +x renew-socks
chmod +x renew-trojan
chmod +x renew-vless
chmod +x renew-vmess
# Cek
chmod +x cek-ss
chmod +x cek-ssblake
chmod +x cek-socks
chmod +x cek-trojan
chmod +x cek-vless
chmod +x cek-vmess
# Tools
chmod +x menu
chmod +x welcome
chmod +x exp
chmod +x clear-log
chmod +x cek-traffic
chmod +x change-domain
chmod +x cek-traffic
chmod +x netz-backup
chmod +x netz-restore
chmod +x badvpn-udpgw
chmod +x netz-restart
chmod +x netz-xanmod
chmod +x netz-bbr
####### ENCRYPTION #####
# rm -rf *.x.c
# CLEANUP
# Timpa Text
echo -e "
Finalizing...
Set Rules & Permission......
"
mv /root/domain /etc/adi/domain
# Crontab Setup
cat <<EOF >/etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the crontab
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
0 5 * * * root clear-log && reboot
0 0 * * * root exp-ssh && exp
# */25 * * * * root cut-log
EOF
sleep 2 && rm -rf setup.sh && rm -rf adi.sh && rm -rf netzpremium.sh && rm -rf /tmp/setup.sh
history -c
cekprofile=$(cat /etc/profile | grep -w HISTFILE)
cekprofiletrue="$?"
if [[ $cekprofiletrue = "1" ]]; then
	echo "unset HISTFILE" >> /etc/profile
	# echo "clear" >> .profile
	echo "welcome" >> /etc/profile
	# echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
	# echo "0 0 * * * root exp" >> /etc/crontab
	echo -e "Rebooting Now"
else
	echo -e "Rebooting Now"
	reboot
fi
