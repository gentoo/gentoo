# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 multilib systemd user

DESCRIPTION="A python-based mailing list server with an extensive web interface"
SRC_URI="mirror://sourceforge/${PN}/${P/_p/-}.tgz"
HOMEPAGE="http://www.list.org/"
S="${WORKDIR}/${P/_p/-}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="selinux"

DEPEND="
	virtual/mta
	virtual/cron
	virtual/httpd-cgi
	virtual/dnspython[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-mailman )
"

pkg_setup() {
	python-single-r1_pkg_setup
	INSTALLDIR=${MAILMAN_PREFIX:-"/usr/$(get_libdir)/mailman"}
	VAR_PREFIX=${MAILMAN_VAR_PREFIX:-"/var/lib/mailman"}
	CGIUID=${MAILMAN_CGIUID:-apache}
	CGIGID=${MAILMAN_CGIGID:-apache}
	MAILUSR=${MAILMAN_MAILUSR:-mailman}
	MAILUID=${MAILMAN_MAILUID:-280}
	MAILGRP=${MAILMAN_MAILGRP:-mailman}
	MAILGID=${MAILMAN_MAILGID:-280}

	# Bug #58526: switch to enew{group,user}.
	# need to add mailman here for compile process.
	# Duplicated at pkg_postinst() for binary install.
	enewgroup ${MAILGRP} ${MAILGID}
	enewuser  ${MAILUSR} ${MAILUID} /bin/bash ${INSTALLDIR} mailman,cron
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.1.14_rc1-directory-check.patch"
	epatch "${FILESDIR}/${PN}-2.1.9-icons.patch"
}

src_configure() {
	econf \
		--without-permcheck \
		--prefix="${INSTALLDIR}" \
		--with-mail-gid=${MAILGID} \
		--with-cgi-gid=${CGIGID} \
		--with-cgi-ext="${MAILMAN_CGIEXT}" \
		--with-var-prefix="${VAR_PREFIX}" \
		--with-username=${MAILUSR} \
		--with-groupname=${MAILGRP} \
		--with-python="${PYTHON}"
}

src_install () {
	emake "DESTDIR=${D}" doinstall

	insinto /etc/apache2/modules.d
	newins "${FILESDIR}/50_mailman.conf-r2" 50_mailman.conf
	sed \
		-e "s:/usr/local/mailman/cgi-bin:${INSTALLDIR}/cgi-bin:g" \
		-e "s:/usr/local/mailman/icons:${INSTALLDIR}/icons:g" \
		-e "s:/usr/local/mailman/archives:${VAR_PREFIX}/archives:g" \
		-i "${D}/etc/apache2/modules.d/50_mailman.conf" || die

	newdoc "${FILESDIR}/README.gentoo-r3" README.gentoo

	dodoc ACK* BUGS FAQ NEWS README* TODO UPGRADING INSTALL contrib/mailman.mc \
		contrib/README.check_perms_grsecurity contrib/virtusertable

	exeinto ${INSTALLDIR}/bin
	doexe build/contrib/*.py contrib/majordomo2mailman.pl contrib/auto \
		contrib/mm-handler*

	dodir /etc/mailman
	mv "${D}/${INSTALLDIR}/Mailman/mm_cfg.py" "${D}/etc/mailman"
	dosym /etc/mailman/mm_cfg.py ${INSTALLDIR}/Mailman/mm_cfg.py

	# Save the old config for updates from pre-2.1.9-r2
	# To be removed some distant day
	for i in /var/mailman /home/mailman /usr/local/mailman ${INSTALLDIR}; do
		if [ -f ${i}/Mailman/mm_cfg.py ] && ! [ -L ${i}/Mailman/mm_cfg.py ]; then
			cp ${i}/Mailman/mm_cfg.py "${D}/etc/mailman/mm_cfg.py" || die
		fi
	done

	newinitd "${FILESDIR}/mailman.rc" mailman
	cp "${FILESDIR}/mailman.service" "${T}/mailman.service" || die
	sed -i "s/^User=.*/User=${MAILUSR}/" "${T}/mailman.service" || die
	systemd_dounit "${T}/mailman.service"

	keepdir ${VAR_PREFIX}/logs
	keepdir ${VAR_PREFIX}/locks
	keepdir ${VAR_PREFIX}/spam
	keepdir ${VAR_PREFIX}/archives/public
	keepdir ${VAR_PREFIX}/archives/private
	keepdir ${VAR_PREFIX}/lists
	keepdir ${VAR_PREFIX}/qfiles

	chown -R ${MAILUSR}:${MAILGRP} "${D}/${VAR_PREFIX}" "${D}/${INSTALLDIR}" "${D}"/etc/mailman/* || die
	chown ${CGIUID}:${MAILGRP} "${D}/${VAR_PREFIX}/archives/private" || die
	chmod 2775 "${D}/${INSTALLDIR}" "${D}/${INSTALLDIR}"/templates/* \
		"${D}/${INSTALLDIR}"/messages/* "${D}/${VAR_PREFIX}" "${D}/${VAR_PREFIX}"/{logs,lists,spam,locks,archives/public} || die
	chmod 2770 "${D}/${VAR_PREFIX}/archives/private" || die
	chmod 2770 "${D}/${VAR_PREFIX}/qfiles" || die
	chmod 2755 "${D}/${INSTALLDIR}"/cgi-bin/* "${D}/${INSTALLDIR}/mail/mailman" || die

	python_optimize ${INSTALLDIR}/bin/ ${INSTALLDIR}/Mailman \
		${INSTALLDIR}/Mailman/*/
}

pkg_postinst() {
	enewgroup ${MAILGRP} ${MAILGID}
	enewuser  ${MAILUSR} ${MAILUID} -1 ${INSTALLDIR} mailman,cron
	echo
	elog "Please read /usr/share/doc/${PF}/README.gentoo.bz2 for additional"
	elog "Setup information, mailman will NOT run unless you follow"
	elog "those instructions!"
	echo

	elog "An example Mailman configuration file for Apache has been installed into:"
	elog "  ${APACHE2_MODULES_CONFDIR}/50_mailman.conf"
	echo
	elog "To enable, you will need to add \"-D MAILMAN\" to"
	elog "/etc/conf.d/apache2."
	echo

	ewarn "Default-Configuration has changed deeply in 2.1.9-r2. You can configure"
	ewarn "mailman with the following variables:"
	ewarn "MAILMAN_PREFIX (default: /usr/$(get_libdir)/mailman)"
	ewarn "MAILMAN_VAR_PREFIX (default: /var/lib/mailman)"
	ewarn "MAILMAN_CGIUID (default: apache)"
	ewarn "MAILMAN_CGIGID (default: apache)"
	ewarn "MAILMAN_CGIEXT (default: empty)"
	ewarn "MAILMAN_MAILUSR (default: mailman)"
	ewarn "MAILMAN_MAILUID (default: 280)"
	ewarn "MAILMAN_MAILGRP (default: mailman)"
	ewarn "MAILMAN_MAILGID (default: 280)"
	ewarn
	ewarn "Config file is now symlinked in /etc/mailman, so etc-update works."
	ewarn
	ewarn "If you're upgrading from below 2.1.9-r2 or changed MAILMAN_PREFIX, you"
	ewarn "NEED to make a few manual updates to your system:"
	ewarn
	ewarn "1.  Update your mailman users's home directory: usermod -d ${INSTALLDIR} mailman"
	ewarn "2.  Re-import the crontab: su - mailman -c 'crontab cron/crontab.in'"
	ewarn "3.  Copy your old mm_cfg.py file to /etc/mailman/mm_cfg.py"
	ewarn
	ewarn "Additionally if you've modified MAILMAN_VAR_PREFIX (or upgraded from"
	ewarn "a pre 2.1.9-r2 installation), you should move your old lists/ and"
	ewarn "archives/ directory to the new location, ensuring that the"
	ewarn "permissions is correct.  See bug #208789 for a discussion."
}
