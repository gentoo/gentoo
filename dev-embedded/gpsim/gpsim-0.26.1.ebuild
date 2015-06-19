# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gpsim/gpsim-0.26.1.ebuild,v 1.7 2012/08/05 08:37:23 ssuominen Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="A simulator for the Microchip PIC microcontrollers"
HOMEPAGE="http://gpsim.sourceforge.net"
SRC_URI="mirror://sourceforge/gpsim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc gtk static-libs"

RDEPEND=">=dev-embedded/gputils-0.12
	!dev-embedded/gpsim-lcd
	dev-libs/glib:2
	dev-libs/popt
	sys-libs/readline
	gtk? ( >=x11-libs/gtk+extra-2 )"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc"

DOCS="ANNOUNCE AUTHORS ChangeLog HISTORY PROCESSORS README README.MODULES TODO"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-glib-single-include.patch \
		"${FILESDIR}"/${P}-gtkextra.patch

		eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk gui) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use doc && dodoc doc/gpsim.pdf

	prune_libtool_files
}
