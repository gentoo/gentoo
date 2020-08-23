# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A guitar music typesetter"
HOMEPAGE="http://chordii.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	doc? ( mirror://sourceforge/${PN}/user_guide-${PV}.pdf )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

PATCHES=( "${FILESDIR}"/${PN}-4.5.3-fno-common.patch )

src_install() {
	default

	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples

	use doc && dodoc "${DISTDIR}"/user_guide-${PV}.pdf
}
