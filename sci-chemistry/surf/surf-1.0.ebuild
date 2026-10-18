# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Solvent accesible Surface calculator"
HOMEPAGE="http://www.ks.uiuc.edu/"
SRC_URI="http://www.ks.uiuc.edu/Research/vmd/extsrcs/surf.tar.Z -> ${P}.tar.Z"
S="${WORKDIR}"

LICENSE="SURF"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="!www-client/surf"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-Wreturn-type.patch
)

src_configure() {
	append-cflags -std=gnu89
	tc-export CC
}

src_install() {
	dobin surf
	einstalldocs
}
