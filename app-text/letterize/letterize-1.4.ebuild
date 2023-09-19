# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Generate English-plausible alphabetic mnemonics for a phone number"
HOMEPAGE="http://www.catb.org/~esr/letterize/"
SRC_URI="http://www.catb.org/~esr/letterize/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	tc-export CC
	default
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README
}
