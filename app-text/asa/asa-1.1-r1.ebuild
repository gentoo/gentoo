# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ASA Carriage control conversion for ouput by Fortran programs"
HOMEPAGE="https://www.ibiblio.org/pub/Linux/devel/lang/fortran/"
SRC_URI="https://www.ibiblio.org/pub/Linux/devel/lang/fortran/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/asa-1.1-implicit-int.patch"
	)

	default

	sed \
		-e "s;-o;${LDFLAGS} -o;g" \
		-e "/^CFLAGS/d" \
		-i Makefile || die

	tc-export CC
}

src_install() {
	dobin asa
	doman asa.1
	dodoc README asa.dat
}
