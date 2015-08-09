# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="an ARM embedded hardware simulator"
HOMEPAGE="http://www.skyeye.org/"
SRC_URI="http://download.gro.clinux.org/skyeye/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="sys-libs/ncurses
	media-libs/freetype
	x11-libs/gtk+:2
	dev-libs/glib:2
	x11-libs/pango"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	dobin binary/skyeye || die "skyeye"
	dodoc ChangeLog README
}
