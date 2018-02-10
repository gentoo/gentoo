# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A compendium of hacker slang illuminating many aspects of hackish tradition"
HOMEPAGE="http://www.catb.org/~esr/jargon"
SRC_URI="http://www.catb.org/~esr/jargon/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE=""

src_prepare() {
	find "${S}" -name .xvpics | xargs rm -rf || die
	cd "${S}/html" || die
	sed -i -e 's#\.\./\.\.#..#' */* \
		|| die "sed failed"
	default
}

src_install() {
	dodoc -r html/*
}
