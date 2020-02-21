# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils fixheadtails qmail

HOMEPAGE="http://www.inter7.com/index.php?page=vpopmail"
DESCRIPTION="Collection of programs to manage virtual email on Qmail servers"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="clearpasswd ipalias maildrop mysql postgres spamassassin"
REQUIRED_USE="mysql? ( !postgres )"

DEPEND="
	acct-group/vpopmail
	acct-user/vpopmail
	virtual/qmail
	maildrop? ( mail-filter/maildrop )
	mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:=[server] )
	spamassassin? ( mail-filter/spamassassin )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.4.9-access.violation.patch
	"${FILESDIR}"/${PN}-lazy.patch
	"${FILESDIR}"/${PN}-vpgsql.patch
	"${FILESDIR}"/${PN}-double-free.patch
	"${FILESDIR}"/${PN}-5.4.33-vdelivermail-add-static.patch
	"${FILESDIR}"/${PN}-5.4.33-fix-those-vfork-instances-that-do-more-than-exec.patch
	"${FILESDIR}"/${PN}-5.4.33-remove-unneeded-forward-declaration.patch
	"${FILESDIR}"/${PN}-5.4.33-clean-up-calling-maildrop.patch
	"${FILESDIR}"/${PN}-5.4.33-fix-S-tag-in-case-spamassassin-changed-the-file-size.patch
	"${FILESDIR}"/${PN}-5.4.33-strncat.patch
	"${FILESDIR}"/${PN}-5.4.33-unistd.patch
)
DOCS=(
	ChangeLog
	doc/.
)
HTML_DOCS=(
	doc_html/.
	man_html/.
)

VPOP_HOME="/var/vpopmail"

pkg_setup() {
	upgradewarning
}

src_prepare() {
	default

	echo 'install-recursive: install-exec-am' \
		>>"${S}"/Makefile.am

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
	local authopts
	if use mysql; then
		incdir=$(mysql_config --variable=pkgincludedir || die)
		libdir=$(mysql_config --variable=pkglibdir || die)
		authopts+=" --enable-auth-module=mysql"
		authopts+=" --enable-incdir=${incdir}"
		authopts+=" --enable-libdir=${libdir}"
		authopts+=" --enable-sql-logging"
		authopts+=" --enable-valias"
		authopts+=" --disable-mysql-replication"
		authopts+=" --enable-mysql-limits"
	elif use postgres; then
		libdir=$(pg_config --libdir || die)
		incdir=$(pg_config --pkgincludedir || die)
		authopts+=" --enable-auth-module=pgsql"
		authopts+=" --enable-incdir=${incdir}"
		authopts+=" --enable-libdir=${libdir}"
		authopts+=" --enable-sql-logging"
		authopts+=" --enable-valias"
	else
		authopts+=" --enable-auth-module=cdb"
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
	emake DESTDIR="${D}" install
	keepdir "${VPOP_HOME}"/domains

	# install helper script for maildir conversion
	into "${VPOP_HOME}"
	dobin "${FILESDIR}"/vpopmail-Maildir-dotmaildir-fix.sh
	into /usr

	mv doc/doc_html/ doc/man_html/ . || die
	einstalldocs
	rm -r "${D}/${VPOP_HOME}"/doc || die
	dosym \
		$(realpath --relative-to "${D}/${VPOP_HOME}"/ "${D}"/usr/share/doc/${PF}/ || die) \
		"${VPOP_HOME}"/doc

	# create /etc/vpopmail.conf
	if use mysql; then
		insinto /etc
		newins "${D}${VPOP_HOME}"/etc/vpopmail.mysql vpopmail.conf
		dosym \
			$(realpath --relative-to "${D}/${VPOP_HOME}"/etc/ "${D}"/etc/vpopmail.conf || die) \
			"${VPOP_HOME}"/etc/vpopmail.mysql

		sed -e '12d' -i "${D}"/etc/vpopmail.conf || die
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
	sed -i 's/Disable = False;/Disable = True;/g' "${D}${VPOP_HOME}"/etc/vusagec.conf || die

	einfo "Installing env.d entry"
	dodir /etc/env.d
	doenvd "${FILESDIR}"/99vpopmail

	einfo "Locking down vpopmail permissions"
	fowners -R root:0 "${VPOP_HOME}"/{bin,etc,include}
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
		chmod 640 /etc/vpopmail.conf || die
		chown root:vpopmail /etc/vpopmail.conf || die
	fi

	upgradewarning
}

pkg_postrm() {
	elog "The vpopmail DATA will NOT be removed automatically."
	elog "You can delete them manually by removing the ${VPOP_HOME} directory."
}

upgradewarning() {
	if has_version "<=net-mail/vpopmail-5.2.1-r8"; then
		ewarn
		ewarn "Massive important warning if you are upgrading to 5.2.1-r8 or older"
		ewarn "The internal structure of the mail storage has changed for"
		ewarn "consistancy with the rest of Gentoo! Please review and utilize the "
		ewarn "script at ${VPOP_HOME}/bin/vpopmail-Maildir-dotmaildir-fix.sh"
		ewarn "to upgrade your system! (It can do conversions both ways)."
		ewarn "You should be able to run it right away without any changes."
		ewarn
	fi

	elog
	elog "Use of vpopmail's tcp.smtp[.cdb] is also deprecated now, consider"
	elog "using net-mail/relay-ctrl instead."
	elog

	if use mysql; then
		if has_version "<=net-mail/vpopmail-5.4.17"; then
			elog
			elog "If you are upgrading from 5.4.17 or older, you have to fix your"
			elog "MySQL tables, please see the UPGRADE file in the documentation!"
			elog
		fi
	fi

	ewarn
	ewarn "Newer versions of vpopmail contain a quota daemon called vusaged."
	ewarn "This ebuild DOES NOT INSTALL vusaged and has therefore disabled"
	ewarn "its usage in ${VPOP_HOME}/etc/vusagec.conf. DO NOT ENABLE!"
	ewarn "Otherwise mail delivery WILL BREAK"
	ewarn
}
