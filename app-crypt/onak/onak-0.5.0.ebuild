# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="onak is an OpenPGP keyserver"
HOMEPAGE="http://www.earth.li/projectpurple/progs/onak.html"
SRC_URI="http://www.earth.li/projectpurple/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="berkdb postgres"

DEPEND="berkdb? ( >=sys-libs/db-4 )
	postgres? ( dev-db/postgresql[server] )"

DOCS=(
	apache2 README LICENSE onak.sql
)

# it tries to use all backends?
RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local backend="fs"
	use berkdb && backend="db4"
	use postgres && backend="pg"
	if use berkdb && use postgres; then
		ewarn "berkdb and postgres requested, postgres was preferred"
	fi
	econf --localstatedir=/var --enable-backend="${backend}"
}

src_install() {
	default
	insinto /etc
	doins onak.ini
	keepdir /var/lib/onak
	dodir /usr/lib/cgi-bin/pks
	insinto /usr/lib/cgi-bin/pks
	doins add gpgwww lookup
}
