# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Spouts silly mad-lib-style porn-like text"
HOMEPAGE="http://spatula.net/software/sex/"
SRC_URI="http://spatula.net/software/sex/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="!sci-astronomy/sextractor"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-Add-missing-string.h-for-strcmp.patch
)

src_prepare() {
	default

	rm -f Makefile || die
}

src_compile() {
	tc-export CC
	emake sex
}

src_install() {
	dobin sex
	doman sex.6
	dodoc README
}
