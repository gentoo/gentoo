# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Motorola Coldfire Emulator"
HOMEPAGE="http://www.slicer.ca/coldfire/"
SRC_URI="http://www.slicer.ca/coldfire/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0=
"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-headers.patch
	"${FILESDIR}"/${P}-ld.patch
	"${FILESDIR}"/${P}-no-common.patch
	"${FILESDIR}"/${P}-implicit-function-declarations.patch
)

src_prepare() {
	default
	eautoreconf

	tc-export LD
}

src_install() {
	dobin coldfire
	dodoc CONTRIBUTORS HACKING README
}
