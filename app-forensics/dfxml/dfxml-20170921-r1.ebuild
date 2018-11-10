# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Digital Forensics XML"
HOMEPAGE="https://github.com/simsong/dfxml"
SRC_URI="https://api.github.com/repos/simsong/${PN}/tarball/7d11eaa7da8d31f588ce8aecb4b4f5e7e8169ba6 -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/expat
"
RDEPEND="
	${DEPEND}
"

S=${WORKDIR}/${P}/src

src_unpack() {
	unpack ${A}
	mv simsong-dfxml-* ${P} || die
}

src_prepare() {
	default

	eautoreconf
}
