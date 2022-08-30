# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Solvent accesible Surface calculator"
HOMEPAGE="http://www.ks.uiuc.edu/"
SRC_URI="http://www.ks.uiuc.edu/Research/vmd/extsrcs/surf.tar.Z -> ${P}.tar.Z"

LICENSE="SURF"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="!www-client/surf"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-Wreturn-type.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin surf
	einstalldocs
}
