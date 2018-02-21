# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Run arbitrary commands when files change"
HOMEPAGE="http://entrproject.org"
SRC_URI="http://entrproject.org/code/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd"
IUSE="test"

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
