FROM archlinux

RUN pacman -Syu --noconfirm && pacman -S --noconfirm openldap && pacman -Scc --noconfirm \
	&& slapadd -l /dev/null -f /etc/openldap/slapd.conf \
	&& cp /var/lib/openldap/openldap-data/DB_CONFIG.example /var/lib/openldap/openldap-data/DB_CONFIG \
	&& rm -rf /etc/openldap/slapd.d/*

COPY image/slapd.conf /etc/openldap/slapd.conf

COPY image/cmd.sh image/init.sh image/restore.sh /
EXPOSE 389
VOLUME [ "/var/lib/openldap/openldap-data/" ]
VOLUME [ "/etc/openldap/" ]

CMD [ "/bin/sh", "/cmd.sh" ]
