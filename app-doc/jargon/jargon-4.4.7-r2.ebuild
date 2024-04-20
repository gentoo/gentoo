# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A compendium of hacker slang illuminating many aspects of hackish tradition"
HOMEPAGE="http://www.catb.org/jargon/"
SRC_URI="http://www.catb.org/jargon/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"

src_prepare() {
	default
	find . -name .xvpics | xargs rm -rf
	assert
	cd html || die
	sed -i -e 's#\.\./\.\.#..#' */* \
		|| die "sed failed"
}

src_install() {
	docinto html
	dodoc -r html/.
}
