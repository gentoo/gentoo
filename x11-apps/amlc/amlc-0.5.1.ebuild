# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Another Modeline Calculator, generates quality X11 display configs easily"
HOMEPAGE="https://sourceforge.net/projects/amlc.berlios/"
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
