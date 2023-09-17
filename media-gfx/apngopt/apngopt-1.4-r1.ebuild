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

RDEPEND="sys-libs/zlib
	>=app-arch/zopfli-1.0.1-r2:=
	media-libs/libpng:0="
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${PF}-makefile.patch )

src_prepare() {
	default
	rm -rf libpng zlib zopfli || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
