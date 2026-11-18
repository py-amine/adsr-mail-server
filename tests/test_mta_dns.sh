#!/bin/bash
set -euo pipefail

DOMAIN="adsr.fssm.ma"
SERVER_IP="192.168.56.10"

echo "=== [1] DNS Forward, Reverse & TXT Records ==="
echo -n "MX Record  : "; dig @127.0.0.1 "${DOMAIN}" MX +short
echo -n "A Record   : "; dig @127.0.0.1 "mail.${DOMAIN}" A +short
echo -n "PTR Record : "; dig @127.0.0.1 -x "${SERVER_IP}" +short
echo -n "SPF Record : "; dig @127.0.0.1 "${DOMAIN}" TXT +short
echo -n "DMARC Rec  : "; dig @127.0.0.1 "_dmarc.${DOMAIN}" TXT +short

echo -e "\n=== [2] Active Services & Listening Ports ==="
systemctl is-active named postfix
ss -tln | grep -E ':25|:53|:587'

echo -e "\n=== [3] End-to-End Local SMTP Delivery Test ==="
id -u etudiant1 &>/dev/null || useradd -m -s /bin/bash etudiant1
swaks --to "etudiant1@${DOMAIN}" --from "admin_mail@${DOMAIN}" --server 127.0.0.1 --hide-all --silent 1
echo "Delivered messages in /home/etudiant1/Maildir/new/:"
ls -1 /home/etudiant1/Maildir/new/ | wc -l
