# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="A guitar music typesetter"
HOMEPAGE="http://chordii.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/user_guide-${PV}.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

src_install() {
	default

	use doc && dodoc "${DISTDIR}"/user_guide-${PV}.pdf

	if use examples ; then
		docinto examples
		dodoc examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
