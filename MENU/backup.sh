#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
clear
IP=$(curl -sS ipv4.icanhazip.com);
date=$(date +"%Y-%m-%d")

MYIP=$(curl -sS ipv4.icanhazip.com)
IZIN=$(curl https://raw.githubusercontent.com/jinggovpn/DATA/main/IP/accsess | grep $MYIP | awk '{print $4}')
if [ $MYIP = $IZIN ]; then
    echo -e ""
else
  echo -e ""
  clear
    echo -e "${green}ACCESS DENIED...PM TELEGRAM OWNER${NC}"
    sleep 2
    exit
fi
NOIP=$(curl -sS https://raw.githubusercontent.com/jinggovpn/DATA/main/IP/accsess | grep $MYIP | awk '{print $4}')
NM=$(curl -sS https://raw.githubusercontent.com/jinggovpn/DATA/main/IP/accsess | grep $MYIP | awk '{print $2}')

echo -e "[ ${green}INFO${NC} ] Please Insert Password To Secure Backup Data ."
echo ""
read -rp "Enter password : " -e InputPass
clear
sleep 1
if [[ -z $InputPass ]]; then
exit 0
fi
echo -e "[ ${green}INFO${NC} ] Processing . . . "
mkdir -p /root/backup
sleep 1
cp -r /etc/passwd /root/backup/sshovpn &> /dev/null
cp -r /usr/local/etc/xray /root/backup/xray
cd /root
zip -rP $InputPass $NOIP.zip backup > /dev/null 2>&1
LLatest=`date`
Get_Data () {
git clone https://github.com/jinggovpn/BACKUP-DB.git /root/user-backup/ &> /dev/null
}

Mkdir_Data () {
mkdir -p /root/user-backup/$NM
}

Input_Data_Append () {
if [ ! -f "/root/user-backup/$NOIP/$NOIP-last-backup" ]; then
touch /root/user-backup/$NM/$NOIP-last-backup
fi
echo -e "User         : $NM
last-backup : $LLatest
" >> /root/user-backup/$NM/$NOIP-last-backup
mv /root/$NOIP.zip /root/user-backup/$NM/
}

Save_And_Exit () {
    cd /root/user-backup
    git config --global user.email "jinggovpn@gmail.com" &> /dev/null
    git config --global user.name "jinggovpn" &> /dev/null
    rm -rf .git &> /dev/null
    git init &> /dev/null
    git add . &> /dev/null
    git commit -m m &> /dev/null
    git branch -M main &> /dev/null
    git remote add origin https://github.com/jinggovpn/BACKUP-DB
    git push -f https://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@github.com/jinggovpn/BACKUP-DB.git &> /dev/null
}

if [ ! -d "/root/user-backup/" ]; then
sleep 1
echo -e "[ ${green}INFO${NC} ] Getting database . . . "
Get_Data
Mkdir_Data
sleep 1
echo -e "[ ${green}INFO${NC} ] Getting info server . . . "
Input_Data_Append
sleep 1
echo -e "[ ${green}INFO${NC} ] Processing updating server . . . "
Save_And_Exit
fi
link="https://raw.githubusercontent.com/jinggovpn/BACKUP-DB/main/$NM/$NOIP.zip"
sleep 1
clear
echo -e "[ ${green}INFO${NC} ] VPS Data Backup Done! "
sleep 1
echo ""
echo -e "[ ${green}INFO${NC} ] Generate Link VPS Data Backup . . . "
echo
sleep 1
clear
echo -e "\033[1;37mVPS Data Backup By JINGGO007\033[0m
\033[1;37mTelegram : https://t.me/jinggo007 / @jinggo007\033[0m"
echo ""
echo "Please Copy Link Below & Save In Notepad"
echo ""
echo -e "Your VPS IP ( \033[1;37m$IP\033[0m )"
echo ""
echo -e "Your VPS Data Backup Password : \033[1;37m$InputPass\033[0m"
echo ""
echo -e "\033[1;37m$link\033[0m"
echo ""
echo "If you want to restore data, please enter the link above"
rm -rf /root/backup &> /dev/null
rm -rf /root/user-backup &> /dev/null
rm -f /root/$NOIP.zip &> /dev/null
echo ""