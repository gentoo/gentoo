# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 systemd

DESCRIPTION="Fast and scalable sql based email services"
HOMEPAGE="https://www.dbmail.org/"
SRC_URI="https://github.com/dbmail/dbmail/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ldap sieve ssl"

RDEPEND="
	acct-group/dbmail
	acct-user/dbmail
	app-text/asciidoc
	app-crypt/mhash
	app-text/xmlto
	dev-db/libzdb
	>=dev-libs/glib-2.16
	dev-libs/gmime:2.6
	dev-libs/libevent:=
	sys-libs/zlib
	virtual/libcrypt:=
	ldap? ( >=net-nds/openldap-2.3.33:= )
	sieve? ( >=mail-filter/libsieve-2.2.1 )
	ssl? (
		dev-libs/openssl:=
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

DOC_CONTENTS="Please read the INSTALL file in /usr/share/doc/${PF}/
for remaining instructions on setting up dbmail users and
for finishing configuration to connect to your MTA and
to connect to your db.
DBMail requires either SQLite, PostgreSQL or MySQL.
Database schemes can be found in /usr/share/doc/${PF}/
You will also want to follow the installation instructions
on setting up the maintenance program to delete old messages.
Don't forget to edit /etc/dbmail/dbmail.conf as well.
For regular maintenance, add this to crontab:
0 3 * * * /usr/bin/dbmail-util -cpdy >/dev/null 2>&1
Please make sure to run etc-update.
If you get an error message about plugins not found
please add the library_directory configuration switch to
dbmail.conf and set it to the correct path
(usually /usr/lib/dbmail or /usr/lib64/dbmail on amd64)
A sample can be found in dbmail.conf.dist after etc-update.
We are now using the init script from upstream.
Please edit /etc/conf.d/dbmail to set which services to start
and delete /etc/init.d/dbmail-* when you are done. (don't
forget to rc-update del dbmail-* first)
Changed pid directory to /run/dbmail (see
http://www.dbmail.org/mantis/view.php?id=949 for details)
The database config has changed to support libzdb db URI
Please check the documentation (or Bug #479664)
The database schema has changed since 3.0.x make sure
to run the migration script
Please be aware, that the single init-script for all services
has been replaced with seperate init scripts for the individual services.
Make sure to add dbmail-(imapd|lmtpd|pop3d|timsieved) using rc-update
and remove dbmail if you want to take advantage of this change."

src_prepare() {
	default

	# change config path to our default and use the conf.d and init.d files from the contrib dir
	sed -i -e "s:/etc/dbmail.conf:/etc/dbmail/dbmail.conf:" contrib/startup-scripts/gentoo/init.d-dbmail || die

	sed -i \
		-e "s:nobody:dbmail:" \
		-e "s:nogroup:dbmail:" \
		-e "s:/var/run:/run/dbmail:" \
		dbmail.conf || die
}

src_configure() {
	econf \
		--enable-manpages \
		--enable-systemd \
		--sysconfdir=/etc/dbmail \
		--disable-static \
		$(use_with sieve) \
		$(use_with ldap auth-ldap)
}

src_install() {
	emake DESTDIR="${D}" SYSTEMD_UNIT_DIR="$(systemd_get_systemunitdir)" install
	einstalldocs
	dodoc UPGRADING

	docompress -x /usr/share/doc/${PF}/sql
	dodoc -r sql
	dodoc -r test-scripts
	dodoc -r contrib

	insinto /etc/dbmail
	newins dbmail.conf dbmail.conf.dist

	# use custom init scripts until updated in upstream contrib
	newinitd "${FILESDIR}/dbmail-imapd.initd" dbmail-imapd
	newinitd "${FILESDIR}/dbmail-lmtpd.initd" dbmail-lmtpd
	newinitd "${FILESDIR}/dbmail-pop3d.initd" dbmail-pop3d
	newinitd "${FILESDIR}/dbmail-timsieved.initd" dbmail-timsieved

	dobin contrib/mailbox2dbmail/mailbox2dbmail
	doman contrib/mailbox2dbmail/mailbox2dbmail.1

	# ldap schema
	if use ldap; then
		insinto /etc/openldap/schema
		doins dbmail.schema
	fi

	keepdir /var/lib/dbmail
	fperms 750 /var/lib/dbmail
	fowners dbmail:dbmail /var/lib/dbmail

	readme.gentoo_create_doc

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	readme.gentoo_print_elog
}
