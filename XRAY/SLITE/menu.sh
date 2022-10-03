#!/bin/bash
clear
red='\e[1;31m'
gr='\e[0;32m'
blue='\e[0;34m'
bb='\e[0;94m'
cy='\033[0;36m'
NC='\e[0m'

clear
IPVPS=$(curl -s icanhazip.com)
DOMAIN=$(cat /etc/xray/domain)
cekxray="$(openssl x509 -dates -noout < /usr/local/etc/xray/xray.crt)"                                      
expxray=$(echo "${cekxray}" | grep 'notAfter=' | cut -f2 -d=)

status="$(systemctl show xray --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
xray_ok=""$gr"NO ERROR"$NC""             
else                                                                                    
xray_ok=""$red"ERROR"$NC""    
fi     

status="$(systemctl show xray@none --no-page)"                                 
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
none_ok=""$gr"NO ERROR"$NC""             
else                                                                                    
none_xok=""$red"ERROR"$NC""    
fi     



status="$(systemctl show nginx.service --no-page)"                                      
status_text=$(echo "${status}" | grep 'ActiveState=' | cut -f2 -d=)                     
if [ "${status_text}" == "active" ]                                                     
then                                                                                    
nginx_ok=""$gr"NO ERROR"$NC""                  
else                                                                                    
nginx_xok=""$red"ERROR"$NC""       
fi

usrvl="$gr$(grep -o -i "###" /usr/local/etc/xray/vless.txt | wc -l)$NC"
usrvm="$gr$(grep -o -i "###" /usr/local/etc/xray/vmess.txt | wc -l)$NC"
usrtr="$gr$(grep -o -i "###" /usr/local/etc/xray/xtr.txt | wc -l)$NC"

echo -e  "        "" ${bb}  ╦╦╔╗╔╔═╗╔═╗╔═╗╦  ╦╔═╗╔╗╔  ╔═╗╔═╗╦═╗╦╔═╗╔╦╗ "${NC}
echo -e  "        "" ${bb}  ║║║║║║ ╦║ ╦║ ║╚╗╔╝╠═╝║║║  ╚═╗║  ╠╦╝║╠═╝ ║  "${NC}
echo -e  "        "" ${bb} ╚╝╩╝╚╝╚═╝╚═╝╚═╝ ╚╝ ╩  ╝╚╝  ╚═╝╚═╝╩╚═╩╩   ╩   "${NC}
echo -e  " "
echo -e  "  ${cy}IP VPS NUMBER                    : $IPVPS${NC}"
echo -e  "  ${cy}DOMAIN                           : $DOMAIN${NC}"
echo -e  "  ${cy}OS VERSION                       : `hostnamectl | grep "Operating System" | cut -d ' ' -f5-`"${NC}
echo -e  "  ${cy}KERNEL VERSION                   : `uname -r`${NC}"
echo -e  "  ${cy}EXP DATE CERT XRAY               : $expxray${NC}"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  "       ${cy}PROTOCOL          VMESS      VLESS      TROJAN${NC}    "
echo -e  "       "${cy}TOTAL USER${NC}"              [$usrvm]        [$usrvl]        [$usrtr]        "
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  " ${bb}═══════════════════════════${NC}" "${cy}XRAY MENU${NC}" "${bb}═══════════════════════════${NC} "       
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} " 
echo -e  " "${cy}NGINX${NC}" $nginx_ok $nginx_xok"${cy}XRAY TLS${NC}" $xray_ok $xray_xok "${cy}XRAY NONE TLS${NC}" $none_ok $none_xok"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "        
echo -e  " ${bb}[  1 ]${NC} CREATE NEW USER            ${bb}[  5 ]${NC}"" CHECK USER LOGIN"
echo -e  " ${bb}[  2 ]${NC} CREATE TRIAL USER          ${bb}[  6 ]${NC}"" DELETE USER EXPIRED"
echo -e  " ${bb}[  3 ]${NC} EXTEND ACCOUNT ACTIVE      ${bb}[  7 ]${NC}"" RENEW XRAY CERTIFICATION"
echo -e  " ${bb}[  4 ]${NC} DELETE ACTIVE USER"
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " ${bb}═════════════════════════${NC}" "${cy}SYSTEM MENU${NC}" "${bb}═══════════════════════════${NC} "       
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC} "
echo -e  " ${bb}[  8 ]${NC} ADD/CHANGE DOMAIN VPS      ${bb}[ 13 ]${NC} SPEEDTEST VPS"
echo -e  " ${bb}[  9 ]${NC} CHANGE DNS SERVER          ${bb}[ 14 ]${NC} INSTALL BBR"
echo -e  " ${bb}[ 10 ]${NC} RESTART ALL SERVICE        ${bb}[ 15 ]${NC} CHECK STREAM GEO LOCATION"
echo -e  " ${bb}[ 11 ]${NC} CHECK RAM USAGE            ${bb}[ 16 ]${NC} DISPLAY SYSTEM INFORMATION"
echo -e  " ${bb}[ 12 ]${NC} REBOOT VPS"              
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}" 
echo -e  " ${bb}[  0 ]${NC}" "${cy}EXIT MENU${NC}  "
echo -e  " ${bb}═════════════════════════════════════════════════════════════════${NC}"
echo -e  "  "
echo -e  " SCRIPT VERSION 1.0"
echo -e  "  "
echo -e "\e[1;31m"
read -p  "     Please select an option :  " menu
echo -e "\e[0m"
 case $menu in
  1)
  clear ; mxraynew
  ;;
  2)
  clear ; mxraytrial
  ;;
  3)
  clear ; mxrayextend
  ;;
  4)
  clear ; mxraydel
  ;; 
  5)
  clear ; mxraycek
  ;;
  6)
  clear ; delexp
  ;;
  7)
  clear ; recert-xray
  ;;    
  8)
  clear ; add-host
  ;;
  9)
  clear ; mdns
  ;;
  10)
  clear ; restart-service
  ;;
  11)
  clear ; ram
  ;;
  12)
  clear ; reboot
  ;;
  13)
  clear ; speedtest
  ;;
  14)
  clear ; bbr
  ;;
  15)
  clear ; nf
  ;;
  16)
  clear ; info
  ;;
  0)
  sleep 0.5
  clear
  exit
  ;;
  *)
  echo -e "ERROR!! Please Enter an Correct Number"
  sleep 1
  clear
  menu
  ;;
  esac
