# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD="1"

inherit autotools-utils

DESCRIPTION="Brute force attack against Wifi Protected Setup"
HOMEPAGE="http://code.google.com/p/reaver-wps/"
SRC_URI="http://reaver-wps.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	net-libs/libpcap
	dev-db/sqlite:3
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src"

PATCHES=(
	"${FILESDIR}"/${P}_cflags.patch
	"${FILESDIR}"/${P}_memset.patch
	"${FILESDIR}"/${P}_parallel-make.patch
	"${FILESDIR}"/${P}_var_db.patch
	"${FILESDIR}"/${P}_wps_registrar.patch
)

src_compile() {
	emake V=1
}

src_install() {
	dobin wash reaver

	insinto "/var/db/reaver"
	doins reaver.db

	doman ../docs/reaver.1.gz
	dodoc ../docs/README ../docs/README.REAVER ../docs/README.WASH
}
