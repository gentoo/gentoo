# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Afio creates cpio-format archives."
HOMEPAGE="http://members.chello.nl/k.holtman/afio.html https://github.com/kholtman/afio"
SRC_URI="http://members.chello.nl/k.holtman/${P}.tgz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ppc sparc x86"

PATCHES=( "${FILESDIR}"/${PN}-2.5.1-fix-build-system.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc ANNOUNCE-* HISTORY README SCRIPTS

	local i
	for i in {1..4}; do
		docinto "script${i}"
		dodoc -r "script${i}"/.
	done
}
