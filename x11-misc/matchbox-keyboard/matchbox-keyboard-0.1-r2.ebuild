# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Matchbox-keyboard is an on screen 'virtual' or 'software' keyboard"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/$(ver_cut 1-2)/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE="debug cairo"

DEPEND="
	x11-libs/libfakekey
	cairo? ( x11-libs/cairo[X] )
	!cairo? ( x11-libs/libXft )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.1-r1-modernize_desktop.patch )

src_prepare() {
	default
	eautoreconf # bug 898250
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable cairo)
}
