# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/chordii/chordii-4.5.1.ebuild,v 1.1 2013/08/10 05:40:52 radhermit Exp $

EAPI=5

DESCRIPTION="A guitar music typesetter"
HOMEPAGE="http://chordii.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/user_guide-4.5.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

src_install() {
	default

	use doc && dodoc "${DISTDIR}"/user_guide-4.5.pdf

	if use examples ; then
		docinto examples
		dodoc examples/*
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
