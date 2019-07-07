# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utility which reduces large palettes in PNG images"
HOMEPAGE="https://entropymine.com/jason/pngrewrite/"
SRC_URI="https://entropymine.com/jason/${PN}/${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~x86-linux ~ppc-macos"
IUSE=""

BDEPEND="app-arch/unzip"
DEPEND="media-libs/libpng:0="
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc readme.txt
}
