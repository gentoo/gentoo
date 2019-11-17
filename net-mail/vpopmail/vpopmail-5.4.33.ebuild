# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools eutils fixheadtails qmail user

HOMEPAGE="http://www.inter7.com/index.php?page=vpopmail"
DESCRIPTION="Collection of programs to manage virtual email on Qmail servers"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="clearpasswd ipalias maildrop mysql spamassassin"

DEPEND="
	acct-group/vpopmail
	acct-user/vpopmail
	virtual/qmail
	maildrop? ( mail-filter/maildrop )
	mysql? ( virtual/mysql )
	spamassassin? ( mail-filter/spamassassin )"
RDEPEND="${DEPEND}"

# This makes sure the variable is set, and that it isn't null.
VPOP_DEFAULT_HOME="/var/vpopmail"

vpopmail_set_homedir() {
	VPOP_HOME=$(egethome vpopmail)
	if [[ -z "${VPOP_HOME}" ]]; then
		eerror "vpopmail's home directory is null in passwd data!"
		eerror "You probably want to check that out."
		eerror "Continuing with default."
		VPOP_HOME="${VPOP_DEFAULT_HOME}"
	else
		einfo "Setting VPOP_HOME to: $VPOP_HOME"
	fi
}

pkg_setup() {
	enewuser vpopmail 89 -1 ${VPOP_DEFAULT_HOME} vpopmail
	upgradewarning
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.4.9-access.violation.patch
	epatch "${FILESDIR}"/${PN}-lazy.patch
	epatch "${FILESDIR}"/${PN}-double-free.patch

	# fix maildir paths
	sed -i -e 's|Maildir|.maildir|g' \
		vchkpw.c vconvert.c vdelivermail.c \
		vpopbull.c vpopmail.c vqmaillocal.c \
		vuserinfo.c maildirquota.c || die

	# remove vpopmail advertisement
	sed -i -e '/printf.*vpopmail/s:vpopmail (:(:' \
		vdelivermail.c vpopbull.c vqmaillocal.c || die

	# automake/autoconf
	mv -f "${S}"/configure.{in,ac} || die
	sed -i -e 's,AM_CONFIG_HEADER,AC_CONFIG_HEADERS,g' \
	        configure.ac || die

	# _FORTIFY_SOURCE
	sed -i \
		-e 's/\(snprintf(\s*\(LI->[a-zA-Z_]\+\),\s*\)[a-zA-Z_]\+,/\1 sizeof(\2),/' \
		vlistlib.c || die

	eautoreconf
	ht_fix_file cdb/Makefile
}

src_configure() {
	vpopmail_set_homedir

	local authopts
	if use mysql; then
		incdir=$(mysql_config --variable=pkgincludedir)
		libdir=$(mysql_config --variable=pkglibdir)
		authopts+=" --enable-auth-module=mysql"
		authopts+=" --enable-incdir=${incdir}"
		authopts+=" --enable-libdir=${libdir}"
		authopts+=" --enable-sql-logging"
		authopts+=" --enable-valias"
		authopts+=" --disable-mysql-replication"
		authopts+=" --enable-mysql-limits"
	else
		authopts="--enable-auth-module=cdb"
	fi

	econf ${authopts} \
		--sysconfdir=${VPOP_HOME}/etc \
		--enable-non-root-build \
		--enable-qmaildir=${QMAIL_HOME} \
		--enable-qmail-newu=${QMAIL_HOME}/bin/qmail-newu \
		--enable-qmail-inject=${QMAIL_HOME}/bin/qmail-inject \
		--enable-qmail-newmrh=${QMAIL_HOME}/bin/qmail-newmrh \
		--enable-vpopuser=vpopmail \
		--enable-vpopgroup=vpopmail \
		--enable-many-domains \
		--enable-file-locking \
		--enable-file-sync \
		--enable-md5-passwords \
		--enable-logging \
		--enable-auth-logging \
		--enable-log-name=vpopmail \
		--enable-qmail-ext \
		--disable-tcpserver-file \
		--disable-roaming-users \
		$(use_enable ipalias ip-alias-domains) \
		$(use_enable clearpasswd clear-passwd) \
		$(use_enable maildrop) \
		$(use_enable maildrop maildrop-prog /usr/bin/maildrop) \
		$(use_enable spamassassin)
}

src_install() {
	vpopmail_set_homedir

	# bug #277764
	emake -j1 DESTDIR="${D}" install
	keepdir "${VPOP_HOME}"/domains

	# install helper script for maildir conversion
	into "${VPOP_HOME}"
	dobin "${FILESDIR}"/vpopmail-Maildir-dotmaildir-fix.sh
	into /usr

	dodoc doc/AUTHORS ChangeLog doc/FAQ doc/INSTALL doc/README*
	dohtml doc/doc_html/* doc/man_html/*
	rm -rf "${D}/${VPOP_HOME}"/doc
	dosym \
		$(realpath --relative-to "${D}/${VPOP_HOME}"/ "${D}"/usr/share/doc/${PF}/) \
		"${VPOP_HOME}"/doc

	# create /etc/vpopmail.conf
	if use mysql; then
		dodir /etc
		mv "${D}${VPOP_HOME}"/etc/vpopmail.mysql "${D}"/etc/vpopmail.conf
		dosym \
			$(realpath --relative-to "${D}/${VPOP_HOME}"/etc/ "${D}"/etc/vpopmail.conf) \
			"${VPOP_HOME}"/etc/vpopmail.mysql

		sed -e '12d' -i "${D}"/etc/vpopmail.conf
		echo '# Read-only DB' >> "${D}"/etc/vpopmail.conf
		echo 'localhost|0|vpopmail|secret|vpopmail' >> "${D}"/etc/vpopmail.conf
		echo '# Write DB' >> "${D}"/etc/vpopmail.conf
		echo 'localhost|0|vpopmail|secret|vpopmail' >> "${D}"/etc/vpopmail.conf

		# lock down perms
		fperms 640 /etc/vpopmail.conf
		fowners root:vpopmail /etc/vpopmail.conf
	fi

	insinto "${VPOP_HOME}"/etc
	doins vusagec.conf
	dosym "${VPOP_HOME}"/etc/vusagec.conf /etc/vusagec.conf
	sed -i 's/Disable = False;/Disable = True;/g' "${D}${VPOP_HOME}"/etc/vusagec.conf

	einfo "Installing env.d entry"
	dodir /etc/env.d
	doenvd "${FILESDIR}"/99vpopmail

	einfo "Locking down vpopmail permissions"
	fowners root:0 -R "${VPOP_HOME}"/{bin,etc,include}
	fowners root:vpopmail "${VPOP_HOME}"/bin/vchkpw
	fperms 4711 "${VPOP_HOME}"/bin/vchkpw
}

pkg_postinst() {
	if use mysql ; then
		elog
		elog "You have 'mysql' turned on in your USE"
		elog "Vpopmail needs a VALID MySQL USER. Let's call it 'vpopmail'"
		elog "You MUST add it and then specify its passwd in the /etc/vpopmail.conf file"
		elog
		elog "First log into mysql as your mysql root user and pass. Then:"
		elog "> create database vpopmail;"
		elog "> use mysql;"
		elog "> grant select, insert, update, delete, create, drop on vpopmail.* to"
		elog "  vpopmail@localhost identified by 'your password';"
		elog "> flush privileges;"
		elog
		elog "If you have problems with vpopmail not accepting mail properly,"
		elog "please ensure that /etc/vpopmail.conf is chmod 640 and"
		elog "owned by root:vpopmail"
		elog
	fi

	# do this for good measure
	if [[ -e /etc/vpopmail.conf ]]; then
		chmod 640 /etc/vpopmail.conf
		chown root:vpopmail /etc/vpopmail.conf
	fi

	upgradewarning
}

pkg_postrm() {
	vpopmail_set_homedir

	elog "The vpopmail DATA will NOT be removed automatically."
	elog "You can delete them manually by removing the ${VPOP_HOME} directory."
}

upgradewarning() {
	ewarn
	ewarn "Massive important warning if you are upgrading to 5.2.1-r8 or older"
	ewarn "The internal structure of the mail storage has changed for"
	ewarn "consistancy with the rest of Gentoo! Please review and utilize the "
	ewarn "script at ${VPOP_HOME}/bin/vpopmail-Maildir-dotmaildir-fix.sh"
	ewarn "to upgrade your system! (It can do conversions both ways)."
	ewarn "You should be able to run it right away without any changes."
	ewarn

	elog
	elog "Use of vpopmail's tcp.smtp[.cdb] is also deprecated now, consider"
	elog "using net-mail/relay-ctrl instead."
	elog

	if use mysql; then
		elog
		elog "If you are upgrading from 5.4.17 or older, you have to fix your"
		elog "MySQL tables:"
		elog
		elog 'ALTER TABLE `dir_control` CHANGE `domain` `domain` CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `ip_alias_map` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `lastauth` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `valias` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `vlog` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `vpopmail` CHANGE domain domain CHAR(96) NOT NULL;'
		elog 'ALTER TABLE `limits` CHANGE domain domain CHAR(96) NOT NULL,'
		elog '    ADD `disable_spamassassin` TINYINT(1) DEFAULT '0' NOT NULL AFTER `disable_smtp`,'
		elog '    ADD `delete_spam` TINYINT(1) DEFAULT '0' NOT NULL AFTER `disable_spamassassin`;'
		elog
	fi

	ewarn
	ewarn "Newer versions of vpopmail contain a quota daemon called vusaged."
	ewarn "This ebuild DOES NOT INSTALL vusaged and has therefore disabled"
	ewarn "its usage in ${VPOP_HOME}/etc/vusagec.conf. DO NOT ENABLE!"
	ewarn "Otherwise mail delivery WILL BREAK"
	ewarn
}
