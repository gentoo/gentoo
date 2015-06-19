# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/onak/onak-0.4.0.ebuild,v 1.3 2014/12/28 14:44:04 titanofold Exp $

EAPI=2
inherit autotools eutils

DESCRIPTION="onak is an OpenPGP keyserver"
HOMEPAGE="http://www.earth.li/projectpurple/progs/onak.html"
SRC_URI="http://www.earth.li/projectpurple/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb postgres"

DEPEND="berkdb? ( >=sys-libs/db-4 )
	postgres? ( dev-db/postgresql[server] )"

src_prepare() {
	# Merged upstream
	#epatch "${FILESDIR}"/${P}-berkdb-5.0.patch
	eautoreconf
}

src_configure() {
	local backend="fs"
	use berkdb && backend="db4"
	use postgres && backend="pg"
	if use berkdb && use postgres; then
		ewarn "berkdb and postgres requested, postgres was preferred"
	fi
	econf --enable-backend="${backend}"
}

src_install() {
	keepdir /var/lib/onak
	dosbin onak maxpath sixdegrees onak-mail.pl
	dobin splitkeys stripkey
	doman *.[1-8]
	insinto /etc
	doins onak.conf
	dodir /var/lib/onak/doc
	insinto /var/lib/onak/doc
	doins apache2 README LICENSE onak.sql
	dodir /usr/lib/cgi-bin/pks
	insinto /usr/lib/cgi-bin/pks
	doins add gpgwww lookup

	sed -i \
		-e 's,^www_port 11371,www_port 0,g' \
		-e 's,^db_dir /var/lib/lib/onak,db_dir /var/lib/onak,g' \
		-e 's,^logfile /var/lib/log/onak.log,logfile /var/log/onak.log,g' \
		-e 's,^max_last 1,max_last 0,g' \
		"${D}/etc/onak.conf"
}
