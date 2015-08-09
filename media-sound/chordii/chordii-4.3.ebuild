# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools

DESCRIPTION="A guitar music typesetter"
HOMEPAGE="http://chordii.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/${P}-user_guide.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=""
DEPEND=">=sys-devel/autoconf-2.67"

src_prepare() {
	sed -i -e "/dist_man_MAN/d" man/Makefile.am
	eautomake
}

src_install() {
	default

	use doc && dodoc "${DISTDIR}"/${P}-user_guide.pdf

	if use examples ; then
		docinto examples
		dodoc examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
