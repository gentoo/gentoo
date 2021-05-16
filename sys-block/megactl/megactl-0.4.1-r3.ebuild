# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="LSI MegaRAID control utility"
HOMEPAGE="https://sourceforge.net/projects/megactl/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}"/${P}.patch
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-gcc-fixes.patch
	"${FILESDIR}"/${P}-tracefix.patch )

src_compile() {
	use x86 && MY_MAKEOPTS="ARCH=-m32"
	use amd64 && MY_MAKEOPTS="ARCH=-m64"
	emake -C src CC=$(tc-getCC) ${MY_MAKEOPTS}
}

src_install() {
	cd src || die
	dosbin megactl megasasctl megarpt megasasrpt
	# it's not quite fixed yet
	[ -x megatrace ] && dosbin megatrace
	dodoc ../README
}
