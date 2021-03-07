# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

MY_PN="${PN/-libftdi/}"
MY_P="${MY_PN}-${PV}"

TABFILE="libd2xx_table.so"
TABFILEDIR="libftdi/lib_table"

DESCRIPTION="Library which includes a table of VIDs and PIDs of Ever UPS devices"
HOMEPAGE="http://www.ever.com.pl"
SRC_URI="http://www.ever.com.pl/pl/pliki/${MY_P}-x86.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"

PATCHES=(
	"${FILESDIR}/${PN}-0.1.8-LDFLAGS.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	cd "${TABFILEDIR}" || die

	# Wipe out precompiled binary
	emake clean
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	ftditabfile="${TABFILEDIR}/${TABFILE}"
	dolib.so ${ftditabfile}
}
