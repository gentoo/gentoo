# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="JPEG to AVI/MJPEG animation command-line conversion tool"
HOMEPAGE="https://sourceforge.net/projects/jpegtoavi/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc CHANGELOG README
}
