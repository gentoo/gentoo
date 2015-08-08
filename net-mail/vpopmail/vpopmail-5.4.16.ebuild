# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils fixheadtails autotools user

# TODO: all ldap, sybase support
#MY_PV=${PV/_/-}
#MY_P=${PN}-${MY_PV}
HOMEPAGE="http://www.inter7.com/index.php?page=vpopmail"
DESCRIPTION="A collection of programs to manage virtual email domains and accounts on your Qmail mail servers"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~ia64 ppc s390 sh sparc x86"
IUSE="mysql ipalias clearpasswd"
# vpopmail will NOT build if non-root.
RESTRICT="userpriv"

DEPEND_COMMON="virtual/qmail
	mysql? ( virtual/mysql )"
DEPEND="sys-apps/sed
	sys-apps/ucspi-tcp
	${DEPEND_COMMON}"
RDEPEND="${DEPEND_COMMON}
	virtual/cron"

# S="${WORKDIR}/${MY_P}"

# Define vpopmail home dir in /etc/password if different
VPOP_DEFAULT_HOME="/var/vpopmail"
VPOP_HOME="$VPOP_DEFAULT_HOME"

# This makes sure the variable is set, and that it isn't null.
vpopmail_set_homedir() {
	VPOP_HOME=$(egethome vpopmail)
	if [ -z "$VPOP_HOME" ]; then
		echo -ne "\a"
		eerror "vpopmail's home directory is null in passwd data!"
		eerror "You probably want to check that out."
		eerror "Continuing with default."
		VPOP_HOME="${VPOP_DEFAULT_HOME}"
	else
		einfo "Setting VPOP_HOME to: $VPOP_HOME"
	fi
}

pkg_setup() {
	enewgroup vpopmail 89
	enewuser vpopmail 89 -1 ${VPOP_DEFAULT_HOME} vpopmail
	upgradewarning
}

src_unpack() {
	# cd ${WORKDIR}
	# unpack ${MY_P}.tar.gz
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PN}-5.4.9-access.violation.patch || die "failed to patch."
	epatch ${FILESDIR}/${PN}-lazy.patch || die "failed to patch."

	sed -i \
		's|Maildir|.maildir|g' \
		vchkpw.c vconvert.c vdelivermail.c \
		vpopbull.c vpopmail.c vqmaillocal.c \
		vuserinfo.c maildirquota.c \
		|| die "failed to change Maildir to .maildir"
	sed -i \
		'/printf.*vpopmail/s:vpopmail (:(:' \
		vdelivermail.c vpopbull.c vqmaillocal.c \
		|| die "failed to remove vpopmail advertisement"

	eautoreconf
	ht_fix_file ${S}/cdb/Makefile || die "failed to fix file"
}

src_compile() {
	vpopmail_set_homedir

	use ipalias \
		&& myopts="${myopts} --enable-ip-alias-domains=y" \
		|| myopts="${myopts} --enable-ip-alias-domains=n"

	use mysql \
		&& myopts="${myopts} --enable-auth-module=mysql \
			--enable-libs=/usr/include/mysql \
			--enable-libdir=/usr/lib/mysql \
			--enable-sql-logging=y \
			--enable-auth-logging=y \
			--enable-valias=y \
			--enable-mysql-replication=n \
			--enable-mysql-limits"

	# Bug 20127
	use clearpasswd \
		&& myopts="${myopts} --enable-clear-passwd=y" \
		|| myopts="${myopts} --enable-clear-passwd=n"

	econf \
		${myopts} \
		--sbindir=/usr/sbin \
		--bindir=/usr/bin \
		--sysconfdir=${VPOP_HOME}/etc \
		--enable-qmaildir=/var/qmail \
		--enable-qmail-newu=/var/qmail/bin/qmail-newu \
		--enable-qmail-inject=/var/qmail/bin/qmail-inject \
		--enable-qmail-newmrh=/var/qmail/bin/qmail-newmrh \
		--enable-vpopuser=vpopmail \
		--enable-many-domains=y \
		--enable-vpopgroup=vpopmail \
		--enable-file-locking=y \
		--enable-file-sync=y \
		--enable-md5-passwords=y \
		--enable-logging=y \
		--enable-log-name=vpopmail \
		--enable-qmail-ext \
		--disable-tcp-rules-prog --disable-tcpserver-file --disable-roaming-users \
		|| die

	# TCPRULES for relaying is now considered obsolete, use relay-ctrl instead
	#--enable-tcprules-prog=/usr/bin/tcprules --enable-tcpserver-file=/etc/tcp.smtp \
	#--enable-roaming-users=y --enable-relay-clear-minutes=60 \
	#--disable-rebuild-tcpserver-file \

	emake || die "Make failed."
}

src_install() {
	vpopmail_set_homedir

	make DESTDIR=${D} install || die
	dosed ${VPOP_HOME}/etc/inc_deps
	dosed ${VPOP_HOME}/etc/lib_deps

	into /var/vpopmail
	dobin ${FILESDIR}/vpopmail-Maildir-dotmaildir-fix.sh
	into /usr

	# Install documentation.
	dodoc AUTHORS ChangeLog FAQ INSTALL README*
	dodoc doc/doc_html/* doc/man_html/*
	rm -rf ${D}/${VPOP_HOME}/doc
	dosym /usr/share/doc/${PF}/ ${VPOP_HOME}/doc

	# Create /etc/vpopmail.conf
	if use mysql ; then
		einfo "Installing vpopmail mysql configuration file"
		dodir /etc
		#config file position
		mv ${D}/var/vpopmail/etc/vpopmail.mysql ${D}/etc/vpopmail.conf
		dosym /etc/vpopmail.conf /var/vpopmail/etc/vpopmail.mysql
		sed -e '12d' -i ${D}/etc/vpopmail.conf
		echo '# Read-only DB' >>${D}/etc/vpopmail.conf
		echo 'localhost|0|vpopmail|secret|vpopmail' >>${D}/etc/vpopmail.conf
		echo '# Write DB' >>${D}/etc/vpopmail.conf
		echo 'localhost|0|vpopmail|secret|vpopmail' >>${D}/etc/vpopmail.conf
		# lock down perms
		fperms 640 /etc/vpopmail.conf
		fowners root:vpopmail /etc/vpopmail.conf
	fi

	# Install a proper cronjob instead of the old nastiness
	#einfo "Installing cronjob"
	#dodir /etc/cron.hourly
	#insinto /etc/cron.hourly
	#doins ${FILESDIR}/vpopmail.clearopensmtp
	#fperms +x /etc/cron.hourly/vpopmail.clearopensmtp

	einfo "Installing env.d entry"
	dodir /etc/env.d
	doenvd ${FILESDIR}/99vpopmail

	# Configure b0rked. We'll do this manually
	#echo "-I${VPOP_HOME}/include" > ${D}/${VPOP_HOME}/etc/inc_deps
	#local libs_extra
	#use mysql && libs_extra="-L/usr/lib/mysql -lmysqlclient -lz" || libs_extra=""
	#echo "-L${VPOP_HOME}/lib -lvpopmail ${libs_extra}" > ${D}/${VPOP_HOME}/etc/lib_deps

	einfo "Locking down vpopmail permissions"
	# secure things more, i don't want the vpopmail user being able to write this stuff!
	chown -R root:0 ${D}${VPOP_HOME}/{bin,etc,include}
	chown root:vpopmail ${D}${VPOP_HOME}/bin/vchkpw
	chmod 4711 ${D}${VPOP_HOME}/bin/vchkpw
}

pkg_preinst() {
	vpopmail_set_homedir

	# Keep DATA
	keepdir ${VPOP_HOME}/domains

	# This is a workaround until portage handles binary packages+users better.
	pkg_setup

	upgradewarning
}

pkg_postinst() {
	einfo "Performing post-installation routines for ${P}."

	if use mysql ; then
		echo
		elog "You have 'mysql' turned on in your USE"
		elog "Vpopmail needs a VALID MySQL USER. Let's call it 'vpopmail'"
		elog "You MUST add it and then specify its passwd in the /etc/vpopmail.conf file"
		elog
		elog "First log into mysql as your mysql root user and pass. Then:"
		elog "> create database vpopmail;"
		elog "> use mysql;"
		elog "> grant select, insert, update, delete, create, drop on vpopmail.* to"
		elog "	 vpopmail@localhost identified by 'your password';"
		elog "> flush privileges;"
		elog
		elog "If you have problems with vpopmail not accepting mail properly,"
		elog "please ensure that /etc/vpopmail.conf is chmod 640 and"
		elog "owned by root:vpopmail"
	fi
	# do this for good measure
	if [ -e /etc/vpopmail.conf ] ; then
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
	ewarn "Massive important warning if you are upgrading to 5.2.1-r8 or older"
	ewarn "The internal structure of the mail storage has changed for"
	ewarn "consistancy with the rest of Gentoo! Please review and utilize the "
	ewarn "script at /var/vpopmail/bin/vpopmail-Maildir-dotmaildir-fix.sh"
	ewarn "to upgrade your system! (It can do conversions both ways)."
	ewarn "You should be able to run it right away without any changes."
	echo
	einfo "Use of vpopmail's tcp.smtp[.cdb] is also deprecated now, consider"
	einfo "using net-mail/relay-ctrl instead."
}
