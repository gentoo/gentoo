# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd readme.gentoo-r1

DESCRIPTION="Fast and scalable sql based email services"
HOMEPAGE="https://www.dbmail.org/"
SRC_URI="https://github.com/dbmail/dbmail/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc jemalloc ldap sieve ssl static systemd"

DEPEND="dev-db/libzdb
	sieve? ( >=mail-filter/libsieve-2.2.1 )
	ldap? ( >=net-nds/openldap-2.3.33:= )
	jemalloc? ( dev-libs/jemalloc:= )
	app-text/asciidoc
	app-text/xmlto
	app-crypt/mhash
	sys-libs/zlib
	dev-libs/gmime:2.6
	>=dev-libs/glib-2.16
	dev-libs/libevent:=
	virtual/libcrypt:=
	ssl? (
		dev-libs/openssl:=
	)"
RDEPEND="${DEPEND}
	acct-group/dbmail
	acct-user/dbmail"
DOCS=( AUTHORS README.md INSTALL THANKS UPGRADING )

README_GENTOO_SUFFIX=""

src_prepare() {
	sed -i -e "s:nobody:dbmail: ; s:nogroup:dbmail: ; s:/var/run:/run/dbmail:" dbmail.conf || die
	# change config path to our default and use the conf.d and init.d files from the contrib dir
	sed -i -e "s:/etc/dbmail.conf:/etc/dbmail/dbmail.conf:" contrib/startup-scripts/gentoo/init.d-dbmail || die

	default
}

src_configure() {
	econf \
		--enable-manpages \
		--sysconfdir=/etc/dbmail \
		$(use_enable doc manpages) \
		$(use_enable static) \
		$(use_enable systemd) \
		$(use_with jemalloc) \
		$(use_with sieve) \
		$(use_with ldap auth-ldap)
}

src_install() {
	emake DESTDIR="${D}" SYSTEMD_UNIT_DIR="$(systemd_get_systemunitdir)" install
	einstalldocs

	docompress -x /usr/share/doc/${PF}/sql
	dodoc -r sql
	dodoc -r test-scripts
	dodoc -r contrib
	## TODO: install other contrib stuff

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
		doins "${S}/dbmail.schema"
	fi

	keepdir /var/lib/dbmail
	fperms 750 /var/lib/dbmail
	fowners dbmail:dbmail /var/lib/dbmail

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
