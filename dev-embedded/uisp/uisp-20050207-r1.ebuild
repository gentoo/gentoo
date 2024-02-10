# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tool for programming AVR microcontroller through the parallel port"
HOMEPAGE="https://savannah.nongnu.org/projects/uisp"
SRC_URI="https://savannah.nongnu.org/download/uisp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-mega-48-88-168.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	dodoc -r doc/.
}
