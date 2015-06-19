# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/jargon/jargon-4.4.7.ebuild,v 1.9 2012/06/26 05:27:59 dirtyepic Exp $

DESCRIPTION="A compendium of hacker slang illuminating many aspects of hackish tradition, folklore, and humor"
HOMEPAGE="http://www.catb.org/~esr/jargon"
SRC_URI="http://www.catb.org/~esr/jargon/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	find "${S}" -name .xvpics | xargs rm -rf
	cd "${S}/html"
	sed -i -e 's#\.\./\.\.#..#' */* \
		|| die "sed failed"
}

src_install() {
	dohtml -r html/* || die "dohtml failed"
}
