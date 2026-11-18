#!/bin/bash
set -euo pipefail

DOMAIN="adsr.fssm.ma"
HOSTNAME="mail.${DOMAIN}"
SERVER_IP="192.168.56.10"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[1/6] Configuring system hostname..."
hostnamectl set-hostname "${HOSTNAME}"
grep -q "${HOSTNAME}" /etc/hosts || echo "${SERVER_IP} ${HOSTNAME} mail" >> /etc/hosts

echo "[2/6] Installing Bind9, Postfix, and CLI mail utilities..."
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "postfix postfix/mailname string ${DOMAIN}"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get update -qq
apt-get install -y bind9 bind9utils postfix mailutils swaks

echo "[3/6] Deploying and validating Bind9 DNS zones..."
cp "${REPO_ROOT}/configs/bind9/named.conf.local" /etc/bind/named.conf.local
cp "${REPO_ROOT}/configs/bind9/db.adsr.fssm.ma" /etc/bind/db.adsr.fssm.ma
cp "${REPO_ROOT}/configs/bind9/db.192.168.56" /etc/bind/db.192.168.56

named-checkconf
named-checkzone "${DOMAIN}" /etc/bind/db.adsr.fssm.ma
named-checkzone "56.168.192.in-addr.arpa" /etc/bind/db.192.168.56

systemctl enable --now named
systemctl reload named

echo "[4/6] Configuring system mail aliases..."
id -u admin_mail &>/dev/null || useradd -m -s /bin/bash admin_mail
grep -q "^root:" /etc/aliases || echo "root: admin_mail" >> /etc/aliases
grep -q "^postmaster:" /etc/aliases || echo "postmaster: admin_mail" >> /etc/aliases
newaliases

echo "[5/6] Deploying and validating Postfix configuration..."
cp "${REPO_ROOT}/configs/postfix/main.cf" /etc/postfix/main.cf
cp "${REPO_ROOT}/configs/postfix/master.cf" /etc/postfix/master.cf
postfix check

systemctl enable --now postfix
systemctl restart postfix

echo "[6/6] DNS & MTA setup complete!"
