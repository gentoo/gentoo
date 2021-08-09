# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Run arbitrary commands when files change"
HOMEPAGE="http://entrproject.org"
SRC_URI="http://entrproject.org/code/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

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
