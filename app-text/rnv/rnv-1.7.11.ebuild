# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rnv/rnv-1.7.11.ebuild,v 1.4 2012/11/27 11:08:45 pinkbyte Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="A lightweight Relax NG Compact Syntax validator"
HOMEPAGE="http://www.davidashen.net/rnv.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}
		app-arch/unzip"

src_prepare() {
	sed -i -e "/^AR/s/ar/$(tc-getAR)/" Makefile.in || die 'sed on Makefile.in failed'
}

src_install() {
	dobin rnv rvp arx
	dodoc readme.txt
}
