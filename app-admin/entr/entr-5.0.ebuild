# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Run arbitrary commands when files change"
HOMEPAGE="https://eradman.com/entrproject/"
SRC_URI="https://eradman.com/entrproject/code/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"

src_configure() {
	sh configure || die
	sed -i -e 's#\(^PREFIX \).*#\1\?= /usr#' Makefile.bsd || die
}

src_compile() {
	export CC=$(tc-getCC)
	default
}

src_test() {
	export CC=$(tc-getCC)
	default
}
