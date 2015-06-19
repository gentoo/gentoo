# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/perdition/perdition-1.18.ebuild,v 1.5 2014/12/28 16:36:28 titanofold Exp $

EAPI=4
inherit eutils pam user

DESCRIPTION="modular and fully featured POP3 and IMAP4 proxy"
HOMEPAGE="http://www.vergenet.net/linux/perdition/"
SRC_URI="http://www.vergenet.net/linux/${PN}/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb cdb ssl mysql odbc postgres gdbm ldap"

DEPEND="dev-scheme/guile
	>=dev-libs/vanessa-logger-0.0.8
	>=dev-libs/vanessa-adt-0.0.6
	>=net-libs/vanessa-socket-0.0.10
	dev-libs/libpcre
	virtual/pam
	berkdb? ( sys-libs/db )
	cdb? ( || ( >=dev-db/tinycdb-0.76 >=dev-db/cdb-0.75-r1 ) )
	ssl? ( dev-libs/openssl )
	odbc? ( dev-db/unixODBC )
	gdbm? ( sys-libs/gdbm )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql[server] )
	ldap? ( net-nds/openldap )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewuser perdition
	enewgroup perdition
}

src_configure() {
	econf --with-user=perdition \
		--enable-posix-regex \
		$(use_enable ssl) \
		$(use_enable mysql) \
		$(use_enable odbc) \
		$(use_enable postgres pg) \
		$(use_enable gdbm) \
		$(use_enable ldap) \
		$(use_enable cdb) \
		$(use_enable berkdb bdb)
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README AUTHORS TODO INSTALL ChangeLog CODING_LOCATIONS

	newinitd "${FILESDIR}"/perdition.initd perdition
	newconfd "${FILESDIR}"/perdition.confd perdition

	rm -f "${D}"/etc/pam.d/perdition
	pamd_mimic sys-auth perdition auth account password session
}
