# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/amlc/amlc-0.5.1.ebuild,v 1.8 2015/01/26 18:55:40 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Another Modeline Calculator, generates quality X11 display configs easily"
HOMEPAGE="http://sourceforge.net/projects/amlc.berlios/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.cpp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S=${WORKDIR}

src_prepare() {
	cp "${DISTDIR}"/${P}.cpp "${S}"
}

src_compile() {
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} ${P}.cpp -o ${PN} || die
}

src_install() {
	dobin ${PN}
}
