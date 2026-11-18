$TTL    604800
@       IN      SOA     ns1.adsr.fssm.ma. admin.adsr.fssm.ma. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.adsr.fssm.ma.
@       IN      MX  10  mail.adsr.fssm.ma.

ns1     IN      A       192.168.56.10
mail    IN      A       192.168.56.10

@       IN      TXT     "v=spf1 mx ip4:192.168.56.10 -all"
_dmarc  IN      TXT     "v=DMARC1; p=reject; rua=mailto:admin_mail@adsr.fssm.ma"
