# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Zorro bus utility for Amigas running 2.1 and later kernels"
HOMEPAGE="http://users.telenet.be/geertu/Download/#zorro"
SRC_URI="http://users.telenet.be/geertu/Download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~m68k ~ppc"

PATCHES=(
	"${FILESDIR}"/${PN}-0.04-20021014.diff
	"${FILESDIR}"/${PN}-gentoo.diff
	"${FILESDIR}"/${PN}-0.04-fix-build-system.patch
)

src_configure() {
	tc-export CC
	append-cflags -Wall
}

src_install() {
	dosbin lszorro
	einstalldocs
	doman *.8

	insinto /usr/share/misc
	doins zorro.ids
}
