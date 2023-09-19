# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Zorro bus utility for Amigas running 2.1 and later kernels"
HOMEPAGE="http://users.telenet.be/geertu/Download/#zorro"
SRC_URI="https://github.com/glaubitz/zorroutils/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~m68k ~ppc"

PATCHES=(
	#"${FILESDIR}"/${PN}-0.04-20021014.diff
	#"${FILESDIR}"/${PN}-gentoo.diff
	"${FILESDIR}"/${PN}-0.05-fix-build-system.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dosbin lszorro
	einstalldocs
	doman *.8

	insinto /usr/share/misc
	doins zorro.ids
}
