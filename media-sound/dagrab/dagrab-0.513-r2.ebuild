# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN}-S${PV}"

DESCRIPTION="fixed point cd ripper"
HOMEPAGE="http://vertigo.fme.vutbr.cz/~stibor/dagrab.html"
SRC_URI="http://ashtray.jz.gts.cz/~smsti/archiv/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-freedb.patch
	"${FILESDIR}"/${P}-C99-inline.patch
	"${FILESDIR}"/${P}-fd_set.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dobin dagrab

	dodoc BUGS CHANGES FAQ grab TODO
	doman dagrab.1
}
