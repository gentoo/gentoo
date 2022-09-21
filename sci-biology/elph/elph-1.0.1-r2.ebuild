# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Estimated Locations of Pattern Hits - Motif finder program"
HOMEPAGE="http://cbcb.umd.edu/software/ELPH/"
SRC_URI="ftp://ftp.cbcb.umd.edu/pub/software/elph/ELPH-${PV}.tar.gz"
S="${WORKDIR}/${PN^^}/sources"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=( "${FILESDIR}"/${PN}-1.0.1-fix-build-system.patch )

src_configure() {
	tc-export CC CXX
}

src_install() {
	dobin elph

	cd "${WORKDIR}"/ELPH || die
	dodoc VERSION
	newdoc Readme.ELPH README
}
