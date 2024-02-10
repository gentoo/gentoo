# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Netcat clone extended with twofish encryption"
HOMEPAGE="https://cryptcat.sourceforge.io"
SRC_URI="mirror://sourceforge/${PN}/${PN}-unix-${PV}.tar"
S="${WORKDIR}"/unix

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-misc.patch
)

src_prepare() {
	default
	tc-export CC CXX
}

src_install() {
	dobin cryptcat
	dodoc Changelog README README.cryptcat netcat.blurb
}
