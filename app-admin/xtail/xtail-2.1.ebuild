# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit toolchain-funcs

DESCRIPTION="Tail multiple logfiles at once, even if rotated"
HOMEPAGE="http://www.unicom.com/sw/xtail/"
SRC_URI="http://www.unicom.com/sw/xtail/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	dobin xtail || die
	doman xtail.1 || die
	dodoc README
}
