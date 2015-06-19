# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/powersoftplus-libftdi/powersoftplus-libftdi-0.1.8-r1.ebuild,v 1.2 2012/02/26 12:34:47 pacho Exp $

EAPI=4
inherit multilib toolchain-funcs

MY_PN="${PN/-libftdi/}"
MY_P="${MY_PN}-${PV}"

TABFILE="libd2xx_table.so"
TABFILEDIR="libftdi/lib_table"

DESCRIPTION="Library which includes a table of VIDs and PIDs of Ever UPS devices"
HOMEPAGE="http://www.ever.com.pl"
SRC_URI="http://www.ever.com.pl/pl/pliki/${MY_P}-x86.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	cd "${TABFILEDIR}"

	# Wipe out precompiled binary
	emake clean
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	ftditabfile="${TABFILEDIR}/${TABFILE}"
	dolib.so ${ftditabfile}
}
