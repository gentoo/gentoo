# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Read and display data from Fronius IG and IG Plus inverters"
HOMEPAGE="https://fslurp.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_compile() {
	emake CC="$(tc-getCXX)"
}

src_install() {
	dobin ${PN}
	dodoc History README TODO
}
