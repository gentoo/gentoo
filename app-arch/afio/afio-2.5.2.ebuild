# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="CPIO-Archiver & backup program with fault tolerant compression"
HOMEPAGE="https://github.com/kholtman/afio"
SRC_URI="https://github.com/kholtman/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.2-fix-build-system.patch
)

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
