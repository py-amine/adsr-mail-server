$TTL    604800
@       IN      SOA     ns1.adsr.fssm.ma. admin.adsr.fssm.ma. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.adsr.fssm.ma.
@       IN      MX  10  mail.adsr.fssm.ma.

ns1     IN      A       192.168.56.10
mail    IN      A       192.168.56.10
