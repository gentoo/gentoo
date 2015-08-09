# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils multilib versionator user

DESCRIPTION="DBMail is an open-source project that enables storage of mail messages in a relational database"
HOMEPAGE="http://www.dbmail.org/"
SRC_URI="http://www.dbmail.org/download/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap sieve +sqlite ssl static"

DEPEND="dev-db/libzdb
	sieve? ( >=mail-filter/libsieve-2.2.1 )
	ldap? ( >=net-nds/openldap-2.3.33 )
	app-text/asciidoc
	app-text/xmlto
	app-crypt/mhash
	sys-libs/zlib
	dev-libs/gmime:2.6
	>=dev-libs/glib-2.16
	dev-libs/libevent
	ssl? ( dev-libs/openssl )"
#asciidoc and xmlto needed?
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup dbmail
	enewuser dbmail -1 -1 /var/lib/dbmail dbmail
}

src_configure() {
	local myconf=""
	use ldap && myconf=${myconf}" --with-auth-ldap"

	econf \
		--sysconfdir=/etc/dbmail \
		$(use_enable static) \
		$(use_with sieve) \
		${myconf}
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS BUGS ChangeLog README* INSTALL NEWS THANKS UPGRADING

	docompress -x /usr/share/doc/${PF}/sql
	dodoc -r sql
	dodoc -r test-scripts
	dodoc -r contrib
	## TODO: install other contrib stuff

	sed -i -e "s:nobody:dbmail:" dbmail.conf
	sed -i -e "s:nogroup:dbmail:" dbmail.conf
	sed -i -e "s:/var/run:/var/run/dbmail:" dbmail.conf
	#sed -i -e "s:#library_directory:library_directory:" dbmail.conf

	insinto /etc/dbmail
	newins dbmail.conf dbmail.conf.dist

	# change config path to our default and use the conf.d and init.d files from the contrib dir
	sed -i -e "s:/etc/dbmail.conf:/etc/dbmail/dbmail.conf:" contrib/startup-scripts/gentoo/init.d-dbmail
	#sed -i -e "s:exit 0:return 1:" contrib/startup-scripts/gentoo/init.d-dbmail
	#sed -i -e "s:/var/run:/var/run/dbmail:" contrib/startup-scripts/gentoo/init.d-dbmail
	#newconfd contrib/startup-scripts/gentoo/conf.d-dbmail dbmail
	#newinitd contrib/startup-scripts/gentoo/init.d-dbmail dbmail
	# use custom init scripts until updated in upstream contrib
	newinitd "${FILESDIR}/dbmail-imapd.initd" dbmail-imapd
	newinitd "${FILESDIR}/dbmail-lmtpd.initd" dbmail-lmtpd
	newinitd "${FILESDIR}/dbmail-pop3d.initd" dbmail-pop3d
	newinitd "${FILESDIR}/dbmail-timsieved.initd" dbmail-timsieved

	dobin contrib/mailbox2dbmail/mailbox2dbmail
	doman contrib/mailbox2dbmail/mailbox2dbmail.1
	#doman man/*.{1,5,8}

	# ldap schema
	if use ldap; then
	   insinto /etc/openldap/schema
	   doins "${S}/dbmail.schema"
	fi

	keepdir /var/lib/dbmail
	fperms 750 /var/lib/dbmail
	fowners dbmail:dbmail /var/lib/dbmail
	# create this through init-scripts instead of at installt ime (bug #455002)
	#keepdir /var/run/dbmail
	#fowners dbmail:dbmail /var/run/dbmail
}

pkg_postinst() {
	elog "Please read the INSTALL file in /usr/share/doc/${PF}/"
	elog "for remaining instructions on setting up dbmail users and "
	elog "for finishing configuration to connect to your MTA and "
	elog "to connect to your db."
	echo
	elog "DBMail requires either SQLite, PostgreSQL or MySQL."
	elog "Database schemes can be found in /usr/share/doc/${PF}/"
	elog "You will also want to follow the installation instructions"
	elog "on setting up the maintenance program to delete old messages."
	elog "Don't forget to edit /etc/dbmail/dbmail.conf as well."
	echo
	elog "For regular maintenance, add this to crontab:"
	elog "0 3 * * * /usr/bin/dbmail-util -cpdy >/dev/null 2>&1"
	echo
	elog "Please make sure to run etc-update."
	elog "If you get an error message about plugins not found"
	elog "please add the library_directory configuration switch to"
	elog "dbmail.conf and set it to the correct path"
	elog "(usually /usr/lib/dbmail or /usr/lib64/dbmail on amd64)"
	elog "A sample can be found in dbmail.conf.dist after etc-update."
	echo
	elog "We are now using the init script from upstream."
	elog "Please edit /etc/conf.d/dbmail to set which services to start"
	elog "and delete /etc/init.d/dbmail-* when you are done. (don't"
	elog "forget to rc-update del dbmail-* first)"
	echo
	elog "Changed pid directory to /var/run/dbmail (see"
	elog "http://www.dbmail.org/mantis/view.php?id=949 for details)"
	echo
	ewarn "The database config has changed to support libzdb db URI"
	ewarn "Please check the documentation (or Bug #479664)"
	echo
	ewarn "The database schema has changed since 3.0.x make sure"
	ewarn "to run the migration script"
	echo
	ewarn "Please be aware, that the single init-script for all services"
	ewarn "has been replaced with seperate init scripts for the individual services."
	ewarn "Make sure to add dbmail-(imapd|lmtpd|pop3d|timsieved) using rc-update"
	ewarn "and remove dbmail if you want to take advantage of this change."
	echo
}
