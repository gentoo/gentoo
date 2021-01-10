# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Open-source PSF1 (Playstation music) file player"
HOMEPAGE="http://projects.raphnet.net/#sexypsf"
SRC_URI="http://projects.raphnet.net/sexypsf/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.8-Makefile.patch
	"${FILESDIR}"/${PN}-0.4.8-fno-common.patch
)

src_configure() {
	tc-export CC
}

src_compile() {
	emake -C Linux
}

src_install() {
	dobin Linux/sexypsf
	dodoc -r Docs/.
}
