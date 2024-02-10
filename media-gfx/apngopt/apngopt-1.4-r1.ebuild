# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Optimize APNG images"
HOMEPAGE="https://sourceforge.net/projects/apng/"
SRC_URI="mirror://sourceforge/apng/${P}-src.zip"
S="${WORKDIR}"

LICENSE="LGPL-2.1 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/zopfli:=
	media-libs/libpng:=
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${PF}-makefile.patch )

src_prepare() {
	default
	rm -rf libpng zlib zopfli || die
}

src_configure() {
	tc-export CXX
}

src_install() {
	dobin apngopt
	dodoc readme.txt
}
