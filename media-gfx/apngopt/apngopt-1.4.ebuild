# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="optimize APNG images"
HOMEPAGE="https://sourceforge.net/projects/apng/"
SRC_URI="mirror://sourceforge/apng/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib
	>=app-arch/zopfli-1.0.1-r2:=
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default
	rm -rf libpng zlib zopfli || die
}

src_compile() {
	emake CC="$(tc-getCC)" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
