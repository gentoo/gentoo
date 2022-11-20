# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Boosting Algorithm for Classification of Trees"
HOMEPAGE="http://chasen.org/~taku/software/bact/"
SRC_URI="http://chasen.org/~taku/software/bact/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-cpp14.patch
)

src_configure() {
	tc-export CXX
}

src_install() {
	dobin bact_learn bact_mkmodel bact_classify

	HTML_DOCS=( index.html bact.css )
	einstalldocs
}
